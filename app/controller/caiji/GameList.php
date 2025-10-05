<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameList extends BaseController
{
    // 获取游戏列表
    public function get_list()
    {
        // 设置脚本执行时间限制和内存限制
        set_time_limit(0);              // 0 = 无时间限制
        ini_set('memory_limit', '512M'); // 设置内存限制为512MB
        ignore_user_abort(true);         // 即使用户断开连接也继续执行
        
        Log::info('=== GameList::get_list 开始获取游戏列表数据 ===');
        Log::info('get_list - 时间戳: ' . date('Y-m-d H:i:s'));
        Log::info('get_list - 时间限制: ' . ini_get('max_execution_time'));
        Log::info('get_list - 内存限制: ' . ini_get('memory_limit'));

        try {
            // 第一步：获取所有厂商
            $vendors = Db::name('ntp_api_v2_supplier')->field('id,code,name')->select()->toArray();
            
            if (empty($vendors)) {
                Log::warning('get_list - 未找到厂商数据');
                
                return json([
                    'success' => false,
                    'message' => '未找到厂商数据，请先执行厂商数据同步'
                ]);
            }

            $totalVendors = count($vendors);
            Log::info('get_list - 获取厂商列表成功');
            Log::info('get_list - 厂商总数: ' . $totalVendors);

            // 统计变量
            $overallStats = [
                'total_vendors' => $totalVendors,
                'success_vendors' => 0,
                'failed_vendors' => 0,
                'total_games_processed' => 0,
                'total_games_inserted' => 0,
                'total_games_duplicated' => 0,
                'vendor_results' => []
            ];

            // 第二步：遍历每个厂商获取游戏列表
            foreach ($vendors as $vendorIndex => $vendor) {
                $vendorStartTime = microtime(true);
                
                Log::info('get_list - 开始处理厂商');
                Log::info('get_list - 厂商索引: ' . ($vendorIndex + 1) . '/' . $totalVendors);
                Log::info('get_list - 厂商ID: ' . $vendor['id']);
                Log::info('get_list - 厂商代码: ' . $vendor['code']);
                Log::info('get_list - 厂商名称: ' . $vendor['name']);

                try {
                    $vendorResult = $this->processVendorGames($vendor);
                    $overallStats['vendor_results'][] = $vendorResult;
                    
                    if ($vendorResult['success']) {
                        $overallStats['success_vendors']++;
                        $overallStats['total_games_processed'] += $vendorResult['total_games'];
                        $overallStats['total_games_inserted'] += $vendorResult['inserted_games'];
                        $overallStats['total_games_duplicated'] += $vendorResult['duplicated_games'];
                    } else {
                        $overallStats['failed_vendors']++;
                    }

                } catch (\Exception $e) {
                    $overallStats['failed_vendors']++;
                    
                    Log::error('get_list - 处理厂商时发生异常');
                    Log::error('get_list - 厂商ID: ' . $vendor['id']);
                    Log::error('get_list - 厂商代码: ' . $vendor['code']);
                    Log::error('get_list - 错误信息: ' . $e->getMessage());
                    Log::error('get_list - 错误文件: ' . $e->getFile());
                    Log::error('get_list - 错误行号: ' . $e->getLine());

                    $overallStats['vendor_results'][] = [
                        'vendor_id' => $vendor['id'],
                        'vendor_code' => $vendor['code'],
                        'vendor_name' => $vendor['name'],
                        'success' => false,
                        'error' => $e->getMessage(),
                        'total_games' => 0,
                        'inserted_games' => 0,
                        'duplicated_games' => 0
                    ];
                }

                $vendorEndTime = microtime(true);
                $vendorDuration = round(($vendorEndTime - $vendorStartTime) * 1000, 2);
                
                Log::info('get_list - 厂商处理完成');
                Log::info('get_list - 厂商索引: ' . ($vendorIndex + 1));
                Log::info('get_list - 厂商代码: ' . $vendor['code']);
                Log::info('get_list - 处理耗时(毫秒): ' . $vendorDuration);
                Log::info('get_list - 当前进度: ' . round(($vendorIndex + 1) / $totalVendors * 100, 2) . '%');

                // 添加短暂延迟，避免API请求过于频繁
                usleep(100000); // 0.1秒
            }

            Log::info('get_list - 游戏列表数据同步完成');
            Log::info('get_list - 总体统计: ' . json_encode($overallStats));

            return json([
                'success' => true,
                'message' => '游戏列表数据同步完成',
                'data' => $overallStats
            ]);

        } catch (\Exception $e) {
            Log::error('get_list - 函数执行异常');
            Log::error('get_list - 错误信息: ' . $e->getMessage());
            Log::error('get_list - 错误文件: ' . $e->getFile());
            Log::error('get_list - 错误行号: ' . $e->getLine());
            Log::error('get_list - 错误堆栈: ' . $e->getTraceAsString());

            return json([
                'success' => false,
                'message' => '系统异常',
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * 处理单个厂商的游戏数据
     * @param array $vendor 厂商信息
     * @return array 处理结果
     */
    private function processVendorGames($vendor)
    {
        $vendorId = $vendor['id'];
        $vendorCode = $vendor['code'];
        $vendorName = $vendor['name'];
        
        Log::info('processVendorGames - 开始获取厂商游戏数据');
        Log::info('processVendorGames - 厂商ID: ' . $vendorId);
        Log::info('processVendorGames - 厂商代码: ' . $vendorCode);

        $stats = [
            'vendor_id' => $vendorId,
            'vendor_code' => $vendorCode,
            'vendor_name' => $vendorName,
            'success' => false,
            'total_games' => 0,
            'inserted_games' => 0,
            'duplicated_games' => 0,
            'total_pages' => 0,
            'processed_pages' => 0,
            'error' => null
        ];

        try {
            $pageNo = 1;
            $pageSize = 100;
            $totalPages = 1; // 初始值，会在第一次请求后更新
            $allGames = [];

            // 分页获取所有游戏数据
            do {
                Log::debug('processVendorGames - 请求厂商游戏列表');
                Log::debug('processVendorGames - 厂商代码: ' . $vendorCode);
                Log::debug('processVendorGames - 页码: ' . $pageNo);
                Log::debug('processVendorGames - 页大小: ' . $pageSize);

                // 准备API请求参数
                $requestData = [
                    'vendorCode' => $vendorCode,
                    'pageNo' => $pageNo,
                    'displayLanguage' => 'zh',
                    'pageSize' => $pageSize
                ];

                // 调用API
                $apiResponse = sendApiRequest('/game/list', $requestData, 'POST');

                if (!$apiResponse['success'] || $apiResponse['http_code'] !== 200) {
                    Log::error('processVendorGames - 获取厂商游戏列表API请求失败');
                    Log::error('processVendorGames - 厂商代码: ' . $vendorCode);
                    Log::error('processVendorGames - 页码: ' . $pageNo);
                    Log::error('processVendorGames - API响应: ' . json_encode($apiResponse));
                    Log::error('processVendorGames - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

                    $stats['error'] = $apiResponse['error'] ?? 'API请求失败';
                    return $stats;
                }

                // 检查响应数据结构
                if (!isset($apiResponse['data']['data']) || !is_array($apiResponse['data']['data'])) {
                    Log::error('processVendorGames - API返回数据格式错误');
                    Log::error('processVendorGames - 厂商代码: ' . $vendorCode);
                    Log::error('processVendorGames - 页码: ' . $pageNo);
                    Log::error('processVendorGames - 是否有data: ' . (isset($apiResponse['data']) ? '是' : '否'));
                    Log::error('processVendorGames - data类型: ' . gettype($apiResponse['data'] ?? null));
                    Log::error('processVendorGames - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

                    $stats['error'] = 'API返回数据格式错误';
                    return $stats;
                }

                $responseData = $apiResponse['data']['data'];
                
                // 第一次请求时获取总页数
                if ($pageNo === 1) {
                    $totalPages = $responseData['totalPages'] ?? 1;
                    $stats['total_pages'] = $totalPages;
                    
                    Log::info('processVendorGames - 获取厂商游戏总页数');
                    Log::info('processVendorGames - 厂商代码: ' . $vendorCode);
                    Log::info('processVendorGames - 总页数: ' . $totalPages);
                    Log::info('processVendorGames - 总记录数: ' . ($responseData['totalItems'] ?? 0));
                }

                // 获取游戏数据和字段映射
                $games = $responseData['games'] ?? [];
                $headers = $responseData['headers'] ?? [];
                
                if (!empty($games) && !empty($headers)) {
                    // 处理当前页的游戏数据
                    $processedGames = $this->processGamesData($games, $headers, $vendorId, $vendorCode);
                    $allGames = array_merge($allGames, $processedGames);
                    
                    Log::debug('processVendorGames - 当前页游戏数据处理完成');
                    Log::debug('processVendorGames - 厂商代码: ' . $vendorCode);
                    Log::debug('processVendorGames - 页码: ' . $pageNo);
                    Log::debug('processVendorGames - 原始游戏数量: ' . count($games));
                    Log::debug('processVendorGames - 处理后游戏数量: ' . count($processedGames));
                }

                $stats['processed_pages'] = $pageNo;
                $pageNo++;

            } while ($pageNo <= $totalPages);

            $stats['total_games'] = count($allGames);
            
            Log::info('processVendorGames - 厂商所有游戏数据获取完成');
            Log::info('processVendorGames - 厂商代码: ' . $vendorCode);
            Log::info('processVendorGames - 总页数: ' . $totalPages);
            Log::info('processVendorGames - 总游戏数: ' . count($allGames));

            // 批量插入游戏数据
            if (!empty($allGames)) {
                $insertResult = $this->batchInsertGames($allGames, $vendorCode);
                $stats['inserted_games'] = $insertResult['inserted'];
                $stats['duplicated_games'] = $insertResult['duplicated'];
            }

            $stats['success'] = true;
            return $stats;

        } catch (\Exception $e) {
            Log::error('processVendorGames - 处理厂商游戏数据时发生异常');
            Log::error('processVendorGames - 厂商代码: ' . $vendorCode);
            Log::error('processVendorGames - 错误信息: ' . $e->getMessage());
            Log::error('processVendorGames - 错误文件: ' . $e->getFile());
            Log::error('processVendorGames - 错误行号: ' . $e->getLine());

            $stats['error'] = $e->getMessage();
            return $stats;
        }
    }

    /**
     * 处理游戏数据，转换为数据库格式
     * @param array $games 游戏数据数组
     * @param array $headers 字段映射
     * @param int $vendorId 厂商ID
     * @param string $vendorCode 厂商代码
     * @return array 处理后的游戏数据
     */
    private function processGamesData($games, $headers, $vendorId, $vendorCode)
    {
        $processedGames = [];
        $currentDate = date('Y-m-d H:i:s');

        Log::debug('processGamesData - 开始处理游戏数据');
        Log::debug('processGamesData - 厂商代码: ' . $vendorCode);
        Log::debug('processGamesData - 游戏数量: ' . count($games));
        Log::debug('processGamesData - 字段映射: ' . json_encode($headers));

        foreach ($games as $index => $gameArray) {
            try {
                if (!is_array($gameArray) || count($gameArray) < 8) {
                    Log::warning('processGamesData - 游戏数据格式错误或字段不完整');
                    Log::warning('processGamesData - 厂商代码: ' . $vendorCode);
                    Log::warning('processGamesData - 游戏索引: ' . $index);
                    Log::warning('processGamesData - 游戏数据类型: ' . gettype($gameArray));
                    Log::warning('processGamesData - 游戏数据数量: ' . (is_array($gameArray) ? count($gameArray) : 0));
                    Log::warning('processGamesData - 游戏数据: ' . json_encode($gameArray));
                    continue;
                }

                // 直接使用数组索引提取字段数据
                $gameCode = $gameArray[0] ?? '';        // 游戏代码
                $gameName = $gameArray[1] ?? '';        // 游戏名称  
                $categoryCode = $gameArray[2] ?? '';    // 游戏类型
                $imageSquare = $gameArray[3] ?? '';     // 方形图片
                $imageLandscape = $gameArray[4] ?? '';  // 横向图片
                $languageCode = $gameArray[5] ?? '';    // 支持语言
                $platformCode = $gameArray[6] ?? '';    // 支持平台
                $currencyCode = $gameArray[7] ?? '';    // 货币代码

                // 验证必要字段
                if (empty($gameCode) || empty($gameName)) {
                    Log::warning('processGamesData - 游戏数据缺少必要字段');
                    Log::warning('processGamesData - 厂商代码: ' . $vendorCode);
                    Log::warning('processGamesData - 游戏索引: ' . $index);
                    Log::warning('processGamesData - 游戏代码: ' . $gameCode);
                    Log::warning('processGamesData - 游戏名称: ' . $gameName);
                    Log::warning('processGamesData - 游戏数组: ' . json_encode($gameArray));
                    continue;
                }

                // 准备数据库记录 - 匹配表结构
                $gameRecord = [
                    'supplier_id' => $vendorId,
                    'supplier_code' => mb_substr($vendorCode, 0, 200),
                    'create_at' => $currentDate,
                    'game_name' => mb_substr($gameName, 0, 200),
                    'game_code' => mb_substr($gameCode, 0, 600), // 实际存储游戏代码，虽然字段注释是"游戏描述"
                    'game_type' => mb_substr($categoryCode, 0, 200),
                    'game_img_url' => mb_substr($imageSquare ?: $imageLandscape, 0, 200), // 优先使用方形图片
                    'game_language' => mb_substr($languageCode, 0, 200),
                    'game_support_devices' => mb_substr($platformCode, 0, 200),
                    'game_currency_code' => mb_substr($currencyCode, 0, 600)
                ];

                $processedGames[] = $gameRecord;

                // 记录成功处理的游戏
                Log::debug('processGamesData - 游戏数据处理成功');
                Log::debug('processGamesData - 厂商代码: ' . $vendorCode);
                Log::debug('processGamesData - 游戏索引: ' . $index);
                Log::debug('processGamesData - 游戏代码: ' . $gameCode);
                Log::debug('processGamesData - 游戏名称: ' . $gameName);
                Log::debug('processGamesData - 游戏类型: ' . $categoryCode);

            } catch (\Exception $e) {
                Log::error('processGamesData - 处理单个游戏数据时发生错误');
                Log::error('processGamesData - 厂商代码: ' . $vendorCode);
                Log::error('processGamesData - 游戏索引: ' . $index);
                Log::error('processGamesData - 游戏数据: ' . json_encode($gameArray));
                Log::error('processGamesData - 错误信息: ' . $e->getMessage());
            }
        }

        Log::debug('processGamesData - 游戏数据处理完成');
        Log::debug('processGamesData - 厂商代码: ' . $vendorCode);
        Log::debug('processGamesData - 输入游戏数: ' . count($games));
        Log::debug('processGamesData - 输出游戏数: ' . count($processedGames));

        return $processedGames;
    }

    /**
     * 批量插入游戏数据，处理重复数据
     * @param array $games 游戏数据
     * @param string $vendorCode 厂商代码
     * @return array 插入结果统计
     */
    private function batchInsertGames($games, $vendorCode)
    {
        Log::info('batchInsertGames - 开始批量插入游戏数据');
        Log::info('batchInsertGames - 厂商代码: ' . $vendorCode);
        Log::info('batchInsertGames - 游戏数量: ' . count($games));

        $stats = [
            'inserted' => 0,
            'duplicated' => 0
        ];

        try {
            // 开始事务
            Db::startTrans();

            // 获取已存在的游戏记录（基于supplier_code + game_code）
            $existingGames = [];
            if (!empty($games)) {
                $gameCodes = array_column($games, 'game_code');
                $existing = Db::name('ntp_api_v2_supplier_games')
                    ->where('supplier_code', $vendorCode)
                    ->whereIn('game_code', $gameCodes)
                    ->column('game_code');
                
                $existingGames = array_flip($existing);
                
                Log::debug('batchInsertGames - 查询已存在游戏');
                Log::debug('batchInsertGames - 厂商代码: ' . $vendorCode);
                Log::debug('batchInsertGames - 已存在数量: ' . count($existingGames));
            }

            // 筛选出需要插入的新游戏
            $newGames = [];
            foreach ($games as $game) {
                $gameCode = $game['game_code'];
                if (!isset($existingGames[$gameCode])) {
                    $newGames[] = $game;
                } else {
                    $stats['duplicated']++;
                }
            }

            // 批量插入新游戏
            if (!empty($newGames)) {
                $insertResult = Db::name('ntp_api_v2_supplier_games')->insertAll($newGames);
                $stats['inserted'] = count($newGames);
                
                Log::info('batchInsertGames - 游戏数据批量插入完成');
                Log::info('batchInsertGames - 厂商代码: ' . $vendorCode);
                Log::info('batchInsertGames - 插入数量: ' . $stats['inserted']);
                Log::info('batchInsertGames - 插入结果: ' . $insertResult);
            } else {
                Log::info('batchInsertGames - 无新游戏需要插入');
                Log::info('batchInsertGames - 厂商代码: ' . $vendorCode);
            }

            // 提交事务
            Db::commit();

            Log::info('batchInsertGames - 游戏数据插入事务完成');
            Log::info('batchInsertGames - 厂商代码: ' . $vendorCode);
            Log::info('batchInsertGames - 统计结果: ' . json_encode($stats));

            return $stats;

        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            
            Log::error('batchInsertGames - 游戏数据插入失败，事务已回滚');
            Log::error('batchInsertGames - 厂商代码: ' . $vendorCode);
            Log::error('batchInsertGames - 错误信息: ' . $e->getMessage());
            Log::error('batchInsertGames - 错误文件: ' . $e->getFile());
            Log::error('batchInsertGames - 错误行号: ' . $e->getLine());

            throw $e;
        }
    }
}