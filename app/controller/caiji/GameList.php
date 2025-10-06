<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameList extends BaseController
{
    /**
     * 获取游戏列表
     * 访问地址：/caiji/list
     */
    public function get_list()
    {
        try {
            Log::info('GameList.get_list - 开始获取游戏列表');
            Log::info('GameList.get_list - 执行时间: ' . date('Y-m-d H:i:s'));
            
            // 1. 从环境变量获取配置
            $authorization = env('Authorization');
            $apiUrl = env('API_URL');
            
            Log::debug('GameList.get_list - 配置信息');
            Log::debug('GameList.get_list - API_URL: ' . $apiUrl);
            Log::debug('GameList.get_list - Authorization token前缀: ' . substr($authorization, 0, 50) . '...');
            
            // 2. 验证配置是否完整
            if (empty($authorization) || empty($apiUrl)) {
                Log::error('GameList.get_list - 配置信息不完整');
                Log::error('GameList.get_list - Authorization是否为空: ' . (empty($authorization) ? '是' : '否'));
                Log::error('GameList.get_list - apiUrl是否为空: ' . (empty($apiUrl) ? '是' : '否'));
                
                return $this->errorResponse('配置信息不完整，请检查env文件配置');
            }
            
            // 3. 查询所有厂商
            $suppliers = Db::table('ntp_api_goldengatex_supplier')->select();
            
            if (empty($suppliers)) {
                Log::warning('GameList.get_list - 厂商表为空');
                return $this->errorResponse('没有找到任何厂商数据，请先执行厂商获取');
            }
            
            Log::info('GameList.get_list - 查询到厂商数量: ' . count($suppliers));
            
            // 4. 清空游戏表
            Db::table('ntp_api_goldengatex_supplier_games')->delete(true);
            Log::info('GameList.get_list - 已清空游戏表');
            
            // 5. 统计数据
            $totalGames = 0;
            $successSuppliers = 0;
            $failedSuppliers = 0;
            $supplierResults = [];
            
            // 6. 遍历每个厂商获取游戏
            foreach ($suppliers as $supplier) {
                Log::info('GameList.get_list - 开始处理厂商: ' . $supplier['name'] . ' (code: ' . $supplier['code'] . ')');
                
                try {
                    // 调用API获取该厂商的游戏列表
                    $gamesResult = $this->fetchSupplierGames(
                        $apiUrl,
                        $authorization,
                        $supplier['code']
                    );
                    
                    if ($gamesResult['success']) {
                        $games = $gamesResult['data'];
                        
                        if (empty($games)) {
                            Log::warning('GameList.get_list - 厂商 ' . $supplier['name'] . ' 没有游戏');
                            $supplierResults[] = [
                                'supplier' => $supplier['name'],
                                'code' => $supplier['code'],
                                'status' => 'success',
                                'game_count' => 0,
                                'message' => '没有游戏'
                            ];
                            $successSuppliers++;
                            continue;
                        }
                        
                        // 批量插入游戏数据
                        $insertData = [];
                        foreach ($games as $game) {
                            $insertData[] = [
                                'supplier_id' => $supplier['id'],
                                'supplier_code' => $game['vendorCode'] ?? $supplier['code'],
                                'create_at' => date('Y-m-d H:i:s'),
                                'game_name' => $game['gameName'] ?? '',
                                'game_code' => $game['gameCode'] ?? '',
                                'game_type' => $game['gameType'] ?? null,
                                'game_img_url' => $game['thumbnail'] ?? '',
                                'game_language' => 'zh',
                                'game_support_devices' => 'H5,WEB',
                                'game_currency_code' => 'CNY'
                            ];
                        }
                        
                        // 批量插入
                        if (!empty($insertData)) {
                            Db::table('ntp_api_goldengatex_supplier_games')->insertAll($insertData);
                            
                            $gameCount = count($insertData);
                            $totalGames += $gameCount;
                            
                            Log::info('GameList.get_list - 厂商 ' . $supplier['name'] . ' 插入游戏数量: ' . $gameCount);
                            
                            $supplierResults[] = [
                                'supplier' => $supplier['name'],
                                'code' => $supplier['code'],
                                'status' => 'success',
                                'game_count' => $gameCount,
                                'message' => '成功'
                            ];
                        }
                        
                        $successSuppliers++;
                        
                    } else {
                        Log::error('GameList.get_list - 厂商 ' . $supplier['name'] . ' 获取游戏失败: ' . $gamesResult['error']);
                        
                        $supplierResults[] = [
                            'supplier' => $supplier['name'],
                            'code' => $supplier['code'],
                            'status' => 'failed',
                            'game_count' => 0,
                            'message' => $gamesResult['error']
                        ];
                        
                        $failedSuppliers++;
                    }
                    
                } catch (\Exception $e) {
                    Log::error('GameList.get_list - 处理厂商 ' . $supplier['name'] . ' 时发生异常: ' . $e->getMessage());
                    
                    $supplierResults[] = [
                        'supplier' => $supplier['name'],
                        'code' => $supplier['code'],
                        'status' => 'failed',
                        'game_count' => 0,
                        'message' => '异常: ' . $e->getMessage()
                    ];
                    
                    $failedSuppliers++;
                }
                
                // 避免请求过快，添加小延迟
                usleep(100000); // 0.1秒
            }
            
            // 7. 返回汇总结果
            $summary = [
                'total_suppliers' => count($suppliers),
                'success_suppliers' => $successSuppliers,
                'failed_suppliers' => $failedSuppliers,
                'total_games' => $totalGames,
                'execution_time' => date('Y-m-d H:i:s'),
                'details' => $supplierResults
            ];
            
            Log::info('GameList.get_list - 执行完成');
            Log::info('GameList.get_list - 总厂商数: ' . $summary['total_suppliers']);
            Log::info('GameList.get_list - 成功厂商数: ' . $summary['success_suppliers']);
            Log::info('GameList.get_list - 失败厂商数: ' . $summary['failed_suppliers']);
            Log::info('GameList.get_list - 总游戏数: ' . $summary['total_games']);
            
            return $this->successResponse('游戏列表获取完成', $summary);
            
        } catch (\Exception $e) {
            Log::error('GameList.get_list - 发生异常');
            Log::error('GameList.get_list - 异常信息: ' . $e->getMessage());
            Log::error('GameList.get_list - 异常文件: ' . $e->getFile());
            Log::error('GameList.get_list - 异常行号: ' . $e->getLine());
            Log::error('GameList.get_list - 异常堆栈: ' . $e->getTraceAsString());
            
            return $this->errorResponse('系统异常: ' . $e->getMessage());
        }
    }
    
    /**
     * 获取指定厂商的游戏列表
     * @param string $apiUrl API基础地址
     * @param string $authorization 授权token
     * @param string $vendorCode 厂商代码
     * @return array
     */
    private function fetchSupplierGames($apiUrl, $authorization, $vendorCode)
    {
        Log::debug('fetchSupplierGames - 开始获取厂商游戏');
        Log::debug('fetchSupplierGames - vendorCode: ' . $vendorCode);
        
        try {
            // 构建完整的请求URL
            $url = rtrim($apiUrl, '/') . '/games/list';
            
            // 准备请求数据
            $requestData = [
                'vendorCode' => $vendorCode,
                'language' => 'zh'  // 默认使用中文
            ];
            
            $jsonData = json_encode($requestData);
            
            Log::debug('fetchSupplierGames - URL: ' . $url);
            Log::debug('fetchSupplierGames - 请求体: ' . $jsonData);
            
            // 初始化cURL
            $ch = curl_init();
            
            // 设置cURL选项
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => $jsonData,
                CURLOPT_HTTPHEADER => [
                    'Content-Type: application/json',
                    'Authorization: Bearer ' . $authorization,
                    'Accept: */*'
                ],
                CURLOPT_TIMEOUT => 30,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_SSL_VERIFYHOST => false,
            ]);
            
            // 记录开始时间
            $startTime = microtime(true);
            
            // 执行请求
            $response = curl_exec($ch);
            
            // 记录结束时间
            $endTime = microtime(true);
            $duration = round(($endTime - $startTime) * 1000, 2);
            
            // 获取HTTP状态码
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            
            curl_close($ch);
            
            Log::info('fetchSupplierGames - 请求完成');
            Log::info('fetchSupplierGames - HTTP状态码: ' . $httpCode);
            Log::info('fetchSupplierGames - 耗时(毫秒): ' . $duration);
            
            // 检查cURL错误
            if ($error) {
                Log::error('fetchSupplierGames - cURL错误: ' . $error);
                return [
                    'success' => false,
                    'error' => 'cURL Error: ' . $error
                ];
            }
            
            // 解析响应
            $responseData = json_decode($response, true);
            
            if (json_last_error() !== JSON_ERROR_NONE) {
                Log::error('fetchSupplierGames - JSON解析失败: ' . json_last_error_msg());
                Log::error('fetchSupplierGames - 原始响应: ' . substr($response, 0, 500));
                
                return [
                    'success' => false,
                    'error' => 'JSON解析失败: ' . json_last_error_msg()
                ];
            }
            
            // 检查API响应状态
            if (!isset($responseData['success']) || !$responseData['success']) {
                $errorMsg = $responseData['message'] ?? 'API返回失败';
                $errorCode = $responseData['errorCode'] ?? 'Unknown';
                
                Log::error('fetchSupplierGames - API返回失败');
                Log::error('fetchSupplierGames - 错误信息: ' . $errorMsg);
                Log::error('fetchSupplierGames - 错误代码: ' . $errorCode);
                
                return [
                    'success' => false,
                    'error' => $errorMsg . ' (Code: ' . $errorCode . ')'
                ];
            }
            
            // 获取游戏列表
            $games = $responseData['message'] ?? [];
            
            Log::info('fetchSupplierGames - 获取游戏数量: ' . count($games));
            
            return [
                'success' => true,
                'data' => $games
            ];
            
        } catch (\Exception $e) {
            Log::error('fetchSupplierGames - 发生异常: ' . $e->getMessage());
            
            return [
                'success' => false,
                'error' => 'Exception: ' . $e->getMessage()
            ];
        }
    }
    
    /**
     * 返回成功响应
     * @param string $message 消息
     * @param mixed $data 数据
     * @return \think\response\Json
     */
    private function successResponse($message, $data = null)
    {
        $response = [
            'code' => 200,
            'success' => true,
            'message' => $message,
            'timestamp' => time(),
            'datetime' => date('Y-m-d H:i:s')
        ];
        
        if ($data !== null) {
            $response['data'] = $data;
        }
        
        return json($response);
    }
    
    /**
     * 返回错误响应
     * @param string $message 错误消息
     * @param mixed $data 额外数据
     * @return \think\response\Json
     */
    private function errorResponse($message, $data = null)
    {
        $response = [
            'code' => 500,
            'success' => false,
            'message' => $message,
            'timestamp' => time(),
            'datetime' => date('Y-m-d H:i:s')
        ];
        
        if ($data !== null) {
            $response['data'] = $data;
        }
        
        return json($response);
    }
}