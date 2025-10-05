<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameTransfer extends BaseController
{
    /**
     * 主入口方法 - 数据同步处理
     */
    public function get_transfer()
    {
        // 设置脚本执行时间和内存限制
        set_time_limit(0);
        ini_set('memory_limit', '512M');
        ignore_user_abort(true);
        
        Log::info('=== GameTransfer::get_transfer 开始数据同步 ===');
        Log::info('get_transfer - 时间戳: ' . date('Y-m-d H:i:s'));
        
        return $this->performDataSync();
    }

    /**
     * 执行数据同步流程
     */
    private function performDataSync()
    {
        $startTime = microtime(true);
        
        try {
            // 第一步：获取所有数据
            Log::info('performDataSync - 开始获取数据');
            
            $sourceData = $this->getSourceData();      // v2表数据
            $backupData = $this->getBackupData();      // temp表数据
            $supplierData = $this->getSupplierData();  // 厂商表数据
            
            Log::info('performDataSync - 源数据: ' . count($sourceData) . ' 条');
            Log::info('performDataSync - 备份数据: ' . count($backupData) . ' 条');  
            Log::info('performDataSync - 厂商数据: ' . count($supplierData) . ' 条');

            if (empty($sourceData)) {
                return json([
                    'success' => false,
                    'message' => '源表中没有数据'
                ]);
            }

            // 第二步：处理数据同步
            Log::info('performDataSync - 开始处理数据同步');
            $syncResult = $this->syncData($sourceData, $backupData, $supplierData);
            
            $endTime = microtime(true);
            $duration = round(($endTime - $startTime) * 1000, 2);
            
            // 添加耗时到结果数据中
            $syncResult['duration_ms'] = $duration;

            Log::info('performDataSync - 数据同步完成，耗时: ' . $duration . 'ms');
            
            return json([
                'success' => true,
                'message' => $syncResult['message'],
                'data' => $syncResult
            ]);

        } catch (\Exception $e) {
            Log::error('performDataSync - 异常: ' . $e->getMessage());
            
            return json([
                'success' => false,
                'message' => '数据同步异常: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * 获取源数据（v2表）
     */
    private function getSourceData()
    {
        return Db::name('ntp_api_v2_supplier_games')
            ->field('id,supplier_id,supplier_code,create_at,game_name,game_code,game_type,game_img_url,game_language,game_support_devices,game_currency_code')
            ->where('game_name', '<>', '')
            ->where('game_code', '<>', '')
            ->where('supplier_code', '<>', '')
            ->order('id', 'asc')
            ->select()
            ->toArray();
    }

    /**
     * 获取备份数据（temp表）
     */
    private function getBackupData()
    {
        return Db::name('ntp_api_games_temp')
            ->field('id,supplier_id,supplier_code,game_name,game_name_more_language,game_code,game_type,game_img_url,game_language,game_support_devices,game_currency_code')
            ->where('game_name', '<>', '')
            ->where('game_code', '<>', '')
            ->where('supplier_code', '<>', '')
            ->select()
            ->toArray();
    }

    /**
     * 获取厂商数据
     */
    private function getSupplierData()
    {
        return Db::name('ntp_api_supplier')
            ->field('id,code,name')
            ->where('code', '<>', '')
            ->select()
            ->toArray();
    }

    /**
     * 同步数据处理
     */
    private function syncData($sourceData, $backupData, $supplierData)
    {
        $stats = [
            'source_records' => count($sourceData),
            'backup_records' => count($backupData),
            'supplier_records' => count($supplierData),
            'processed_records' => 0,
            'updated_records' => 0,
            'inserted_records' => 0,
            'supplier_id_updated' => 0,
            'skipped_duplicates' => 0,
            'start_time' => date('Y-m-d H:i:s')
        ];

        try {
            // 开始事务
            Db::startTrans();

            // 清空目标表
            Db::execute('TRUNCATE TABLE ntp_api_games');
            Log::info('syncData - 目标表已清空');

            // 构建索引
            $supplierIndex = $this->buildSupplierIndex($supplierData);
            $backupIndex = $this->buildBackupIndex($backupData);

            Log::info('syncData - 索引构建完成');

            // 处理源数据
            $finalData = [];
            $processedKeys = [];
            $currentDate = date('Y-m-d H:i:s');

            foreach ($sourceData as $index => $source) {
                try {
                    // 生成唯一键
                    $uniqueKey = $this->generateUniqueKey($source);
                    
                    // 跳过重复数据
                    if (isset($processedKeys[$uniqueKey])) {
                        $stats['skipped_duplicates']++;
                        continue;
                    }
                    $processedKeys[$uniqueKey] = true;

                    // 构建最终记录
                    $finalRecord = $this->buildFinalRecord(
                        $source, 
                        $backupIndex[$uniqueKey] ?? null, 
                        $supplierIndex, 
                        $currentDate,
                        $stats
                    );

                    if ($finalRecord) {
                        $finalData[] = $finalRecord;
                        
                        // 统计更新或新增
                        if (isset($backupIndex[$uniqueKey])) {
                            $stats['updated_records']++;
                        } else {
                            $stats['inserted_records']++;
                        }
                    }

                    $stats['processed_records']++;

                } catch (\Exception $e) {
                    Log::error('syncData - 处理记录异常: ' . $e->getMessage());
                }

                // 进度输出
                if (($index + 1) % 200 === 0 || ($index + 1) === count($sourceData)) {
                    $progress = round(($index + 1) / count($sourceData) * 100, 2);
                    Log::info('syncData - 处理进度: ' . ($index + 1) . '/' . count($sourceData) . ' (' . $progress . '%)');
                }
            }

            // 分批插入数据
            if (!empty($finalData)) {
                $this->batchInsertData($finalData);
            }

            // 提交事务
            Db::commit();

            // 验证结果
            $finalCount = Db::name('ntp_api_games')->count();
            $stats['end_time'] = date('Y-m-d H:i:s');
            $stats['final_target_count'] = $finalCount;

            // 构建响应消息
            $message = $this->buildResultMessage($stats);
            $stats['message'] = $message;

            return $stats;

        } catch (\Exception $e) {
            Db::rollback();
            Log::error('syncData - 事务回滚: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * 构建厂商索引
     */
    private function buildSupplierIndex($supplierData)
    {
        $index = [];
        foreach ($supplierData as $supplier) {
            $index[$supplier['code']] = $supplier['id'];
        }
        return $index;
    }

    /**
     * 构建备份数据索引
     */
    private function buildBackupIndex($backupData)
    {
        $index = [];
        foreach ($backupData as $backup) {
            $key = $this->generateUniqueKey($backup);
            if (!isset($index[$key])) {
                $index[$key] = $backup;
            }
        }
        return $index;
    }

    /**
     * 生成唯一键
     */
    private function generateUniqueKey($data)
    {
        return md5($data['game_code'] . '|' . $data['game_type'] . '|' . $data['supplier_code']);
    }

    /**
     * 构建最终记录
     */
    private function buildFinalRecord($source, $backup, $supplierIndex, $currentDate, &$stats)
    {
        try {
            // 核对厂商ID
            $supplierId = $source['supplier_id'];
            $supplierCode = $source['supplier_code'];
            
            if (isset($supplierIndex[$supplierCode])) {
                $newSupplierId = $supplierIndex[$supplierCode];
                if ($newSupplierId != $source['supplier_id']) {
                    $stats['supplier_id_updated']++;
                }
                $supplierId = $newSupplierId;
            } else {
                Log::warning('buildFinalRecord - 未找到厂商: ' . $supplierCode);
            }

            // 确定图片URL
            $imageUrl = '';
            if ($backup && !empty($backup['game_img_url'])) {
                $imageUrl = $backup['game_img_url'];
            } else {
                $imageUrl = $source['game_img_url'] ?? '';
            }

            // 确定多语言字段
            $moreLanguage = '';
            if ($backup && !empty($backup['game_name_more_language'])) {
                $moreLanguage = $backup['game_name_more_language'];
            }

            // 构建记录
            return [
                'api_code_set' => 'ZFKJ',
                'is_hot' => 1,
                'supplier_id' => $supplierId,
                'supplier_code' => mb_substr($supplierCode, 0, 200),
                'create_at' => $currentDate,
                'game_name' => mb_substr($source['game_name'], 0, 200),
                'game_name_more_language' => $moreLanguage,
                'game_code' => mb_substr($source['game_code'], 0, 600),
                'game_type' => mb_substr($source['game_type'], 0, 200),
                'game_img_url' => mb_substr($imageUrl, 0, 200),
                'game_language' => mb_substr($source['game_language'], 0, 200),
                'game_support_devices' => mb_substr($source['game_support_devices'], 0, 200),
                'game_currency_code' => mb_substr($source['game_currency_code'], 0, 600)
            ];

        } catch (\Exception $e) {
            Log::error('buildFinalRecord - 异常: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 分批插入数据
     */
    private function batchInsertData($finalData)
    {
        Log::info('batchInsertData - 开始分批插入 ' . count($finalData) . ' 条记录');
        
        $batchSize = 200;
        $totalBatches = ceil(count($finalData) / $batchSize);
        
        for ($i = 0; $i < $totalBatches; $i++) {
            $offset = $i * $batchSize;
            $batchData = array_slice($finalData, $offset, $batchSize);
            
            if (!empty($batchData)) {
                Db::name('ntp_api_games')->insertAll($batchData);
                
                if (($i + 1) % 10 === 0 || ($i + 1) === $totalBatches) {
                    $insertedCount = ($i + 1) * $batchSize;
                    if ($insertedCount > count($finalData)) {
                        $insertedCount = count($finalData);
                    }
                    Log::info('batchInsertData - 已插入: ' . $insertedCount . ' 条');
                }
            }
        }
        
        Log::info('batchInsertData - 插入完成');
    }

    /**
     * 构建结果消息
     */
    private function buildResultMessage($stats)
    {
        $message = "数据同步完成！\n";
        $message .= "📦 源数据记录: {$stats['source_records']} 条\n";
        $message .= "📋 备份数据记录: {$stats['backup_records']} 条\n";
        $message .= "🏭 厂商数据记录: {$stats['supplier_records']} 条\n";
        $message .= "✅ 处理记录数: {$stats['processed_records']} 条\n";
        $message .= "🔄 更新记录数: {$stats['updated_records']} 条\n";
        $message .= "➕ 新增记录数: {$stats['inserted_records']} 条\n";
        $message .= "🔧 厂商ID更新数: {$stats['supplier_id_updated']} 条\n";
        $message .= "⏭️ 跳过重复数: {$stats['skipped_duplicates']} 条\n";
        $message .= "🎯 最终目标表记录: {$stats['final_target_count']} 条";
        
        return $message;
    }
}