<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameVendors extends BaseController
{
    // 获取游戏厂商
    public function get_vendors()
    {
        Log::info('=== GameVendors::get_vendors 开始获取游戏厂商数据 ===');
        Log::info('get_vendors - 时间戳: ' . date('Y-m-d H:i:s'));

        try {
            // 第一步：调用API获取数据
            $data = [];
            $r = sendApiRequest('/game/vendors', $data, 'POST');
            
            // 检查API请求是否成功
            if (!$r['success'] || $r['http_code'] !== 200) {
                Log::error('get_vendors - API请求失败');
                Log::error('get_vendors - API响应: ' . json_encode($r));
                Log::error('get_vendors - TraceId: ' . ($r['trace_id'] ?? 'null'));
                
                return json([
                    'success' => false,
                    'message' => 'API请求失败',
                    'error' => $r['error'] ?? 'Unknown error',
                    'http_code' => $r['http_code'] ?? 0
                ]);
            }

            // 检查返回数据格式 - 数据在 data.data 中
            if (!isset($r['data']['data']) || !is_array($r['data']['data'])) {
                Log::error('get_vendors - API返回数据格式错误');
                Log::error('get_vendors - 是否有data: ' . (isset($r['data']) ? '是' : '否'));
                Log::error('get_vendors - data类型: ' . gettype($r['data'] ?? null));
                Log::error('get_vendors - 是否有data.data: ' . (isset($r['data']['data']) ? '是' : '否'));
                Log::error('get_vendors - data.data类型: ' . gettype($r['data']['data'] ?? null));
                Log::error('get_vendors - TraceId: ' . ($r['trace_id'] ?? 'null'));
                
                return json([
                    'success' => false,
                    'message' => 'API返回数据格式错误'
                ]);
            }

            // 真正的厂商数据在 data.data 中
            $apiData = $r['data']['data'];
            $totalCount = count($apiData);
            
            Log::info('get_vendors - API数据获取成功');
            Log::info('get_vendors - 总记录数: ' . $totalCount);
            Log::info('get_vendors - TraceId: ' . $r['trace_id']);

            // 开始数据库事务
            Db::startTrans();

            try {
                // 第二步：清空数据表
                Db::execute('TRUNCATE TABLE ntp_api_v2_supplier');
                
                Log::info('get_vendors - 数据表清空成功');
                Log::info('get_vendors - 表名: ntp_api_v2_supplier');

                // 第三步：准备插入数据
                if ($totalCount > 0) {
                    $insertData = [];
                    $currentDate = date('Y-m-d');
                    $successCount = 0;
                    $errorCount = 0;

                    foreach ($apiData as $index => $vendor) {
                        try {
                            // 记录原始数据用于调试
                            Log::debug('get_vendors - 处理厂商数据');
                            Log::debug('get_vendors - 索引: ' . $index);
                            Log::debug('get_vendors - 厂商数据: ' . json_encode($vendor));
                            Log::debug('get_vendors - 厂商字段: ' . implode(', ', array_keys($vendor ?? [])));

                            // 验证必要字段
                            if (!isset($vendor['name']) || !isset($vendor['code'])) {
                                Log::warning('get_vendors - 厂商数据缺少必要字段');
                                Log::warning('get_vendors - 索引: ' . $index);
                                Log::warning('get_vendors - 厂商数据: ' . json_encode($vendor));
                                Log::warning('get_vendors - 缺少name: ' . (!isset($vendor['name']) ? '是' : '否'));
                                Log::warning('get_vendors - 缺少code: ' . (!isset($vendor['code']) ? '是' : '否'));
                                Log::warning('get_vendors - 可用字段: ' . implode(', ', array_keys($vendor ?? [])));
                                $errorCount++;
                                continue;
                            }

                            // 准备插入数据，处理字段长度限制
                            $insertRecord = [
                                'create_at' => $currentDate,
                                'name' => mb_substr($vendor['name'] ?? '', 0, 200),
                                'code' => mb_substr($vendor['code'] ?? '', 0, 200),
                                'currency_code' => mb_substr($vendor['currencyCode'] ?? '', 0, 200),
                                'category_code' => mb_substr($vendor['categoryCode'] ?? '', 0, 600)
                            ];

                            $insertData[] = $insertRecord;
                            $successCount++;

                        } catch (\Exception $e) {
                            Log::error('get_vendors - 处理单条厂商数据时发生错误');
                            Log::error('get_vendors - 索引: ' . $index);
                            Log::error('get_vendors - 厂商数据: ' . json_encode($vendor));
                            Log::error('get_vendors - 错误信息: ' . $e->getMessage());
                            $errorCount++;
                        }
                    }

                    // 第四步：批量插入数据
                    if (!empty($insertData)) {
                        $insertResult = Db::name('ntp_api_v2_supplier')->insertAll($insertData);
                        
                        Log::info('get_vendors - 数据批量插入完成');
                        Log::info('get_vendors - 插入数量: ' . count($insertData));
                        Log::info('get_vendors - 插入结果: ' . $insertResult);
                        Log::info('get_vendors - 成功数量: ' . $successCount);
                        Log::info('get_vendors - 错误数量: ' . $errorCount);
                    }
                } else {
                    Log::warning('get_vendors - API返回数据为空');
                }

                // 提交事务
                Db::commit();

                Log::info('get_vendors - 游戏厂商数据同步完成');
                Log::info('get_vendors - API总记录数: ' . $totalCount);
                Log::info('get_vendors - 成功记录数: ' . ($successCount ?? 0));
                Log::info('get_vendors - 错误记录数: ' . ($errorCount ?? 0));
                Log::info('get_vendors - TraceId: ' . $r['trace_id']);

                return json([
                    'success' => true,
                    'message' => '游戏厂商数据同步完成',
                    'data' => [
                        'total_api_records' => $totalCount,
                        'success_records' => $successCount ?? 0,
                        'error_records' => $errorCount ?? 0,
                        'trace_id' => $r['trace_id']
                    ]
                ]);

            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                
                Log::error('get_vendors - 数据库操作失败，事务已回滚');
                Log::error('get_vendors - 错误信息: ' . $e->getMessage());
                Log::error('get_vendors - 错误文件: ' . $e->getFile());
                Log::error('get_vendors - 错误行号: ' . $e->getLine());

                return json([
                    'success' => false,
                    'message' => '数据库操作失败',
                    'error' => $e->getMessage()
                ]);
            }

        } catch (\Exception $e) {
            Log::error('get_vendors - 函数执行异常');
            Log::error('get_vendors - 错误信息: ' . $e->getMessage());
            Log::error('get_vendors - 错误文件: ' . $e->getFile());
            Log::error('get_vendors - 错误行号: ' . $e->getLine());
            Log::error('get_vendors - 错误堆栈: ' . $e->getTraceAsString());

            return json([
                'success' => false,
                'message' => '系统异常',
                'error' => $e->getMessage()
            ]);
        }
    }
}