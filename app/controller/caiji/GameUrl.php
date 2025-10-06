<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameUrl extends BaseController
{
    /**
     * 获取游戏启动URL
     * 访问地址：/caiji/url?vendorCode=xxx&gameCode=xxx&userCode=xxx&lobbyUrl=xxx
     */
    public function get_url()
    {
        try {
            Log::info('GameUrl.get_url - 开始获取游戏URL');
            Log::info('GameUrl.get_url - 请求时间: ' . date('Y-m-d H:i:s'));
            
            // 1. 接收GET参数
            $vendorCode = $this->request->get('vendorCode', '');
            $gameCode = $this->request->get('gameCode', '');
            $userCode = $this->request->get('userCode', '');
            $lobbyUrl = $this->request->get('lobbyUrl', '');
            $language = $this->request->get('language', 'zh'); // 默认中文
            
            Log::info('GameUrl.get_url - 接收参数');
            Log::info('GameUrl.get_url - vendorCode: ' . $vendorCode);
            Log::info('GameUrl.get_url - gameCode: ' . $gameCode);
            Log::info('GameUrl.get_url - userCode: ' . $userCode);
            Log::info('GameUrl.get_url - lobbyUrl: ' . $lobbyUrl);
            Log::info('GameUrl.get_url - language: ' . $language);
            
            // 2. 验证必需参数
            if (empty($vendorCode)) {
                Log::error('GameUrl.get_url - vendorCode参数缺失');
                return $this->errorResponse('vendorCode参数不能为空');
            }
            
            if (empty($gameCode)) {
                Log::error('GameUrl.get_url - gameCode参数缺失');
                return $this->errorResponse('gameCode参数不能为空');
            }
            
            if (empty($userCode)) {
                Log::error('GameUrl.get_url - userCode参数缺失');
                return $this->errorResponse('userCode参数不能为空');
            }
            
            // 3. 从环境变量获取配置
            $authorization = env('Authorization');
            $apiUrl = env('API_URL');
            
            Log::debug('GameUrl.get_url - 配置信息');
            Log::debug('GameUrl.get_url - API_URL: ' . $apiUrl);
            Log::debug('GameUrl.get_url - Authorization token前缀: ' . substr($authorization, 0, 50) . '...');
            
            // 4. 验证配置是否完整
            if (empty($authorization) || empty($apiUrl)) {
                Log::error('GameUrl.get_url - 配置信息不完整');
                Log::error('GameUrl.get_url - Authorization是否为空: ' . (empty($authorization) ? '是' : '否'));
                Log::error('GameUrl.get_url - apiUrl是否为空: ' . (empty($apiUrl) ? '是' : '否'));
                
                return $this->errorResponse('配置信息不完整，请检查env文件配置');
            }
            
            // 5. 构建请求参数
            $requestData = [
                'vendorCode' => $vendorCode,
                'gameCode' => $gameCode,
                'userCode' => $userCode,
                'language' => $language
            ];
            
            // 如果有lobbyUrl，则添加
            if (!empty($lobbyUrl)) {
                $requestData['lobbyUrl'] = $lobbyUrl;
            }
            
            // 6. 构建完整的请求URL
            $url = rtrim($apiUrl, '/') . '/game/launch-url';
            
            Log::info('GameUrl.get_url - 准备调用API');
            Log::info('GameUrl.get_url - URL: ' . $url);
            Log::info('GameUrl.get_url - 请求参数: ' . json_encode($requestData));
            
            // 7. 发送HTTP请求获取游戏URL
            $result = $this->sendLaunchUrlRequest($url, $authorization, $requestData);
            
            // 8. 处理响应
            if ($result['success']) {
                $launchUrl = $result['data']['message'] ?? '';
                
                if (empty($launchUrl)) {
                    Log::error('GameUrl.get_url - API返回的URL为空');
                    return $this->errorResponse('获取游戏URL失败，返回数据为空');
                }
                
                // 记录到数据库（可选）
                $this->logGameAccess($vendorCode, $gameCode, $userCode, $launchUrl);
                
                // 返回成功响应
                $responseData = [
                    'launch_url' => $launchUrl,
                    'vendor_code' => $vendorCode,
                    'game_code' => $gameCode,
                    'user_code' => $userCode,
                    'request_time' => date('Y-m-d H:i:s')
                ];
                
                Log::info('GameUrl.get_url - 获取游戏URL成功');
                Log::info('GameUrl.get_url - Launch URL: ' . $launchUrl);
                
                return $this->successResponse('获取游戏URL成功', $responseData);
                
            } else {
                Log::error('GameUrl.get_url - API调用失败');
                Log::error('GameUrl.get_url - 错误信息: ' . ($result['error'] ?? 'Unknown error'));
                
                return $this->errorResponse(
                    'API调用失败: ' . ($result['error'] ?? 'Unknown error'),
                    [
                        'vendor_code' => $vendorCode,
                        'game_code' => $gameCode,
                        'error_detail' => $result['data'] ?? null
                    ]
                );
            }
            
        } catch (\Exception $e) {
            Log::error('GameUrl.get_url - 发生异常');
            Log::error('GameUrl.get_url - 异常信息: ' . $e->getMessage());
            Log::error('GameUrl.get_url - 异常文件: ' . $e->getFile());
            Log::error('GameUrl.get_url - 异常行号: ' . $e->getLine());
            Log::error('GameUrl.get_url - 异常堆栈: ' . $e->getTraceAsString());
            
            return $this->errorResponse('系统异常: ' . $e->getMessage());
        }
    }
    
    /**
     * 发送获取启动URL的HTTP请求
     * @param string $url 请求URL
     * @param string $authorization 授权token
     * @param array $data 请求数据
     * @return array 响应结果
     */
    private function sendLaunchUrlRequest($url, $authorization, $data)
    {
        Log::debug('sendLaunchUrlRequest - 开始发送请求');
        Log::debug('sendLaunchUrlRequest - URL: ' . $url);
        
        try {
            // 准备请求体
            $jsonData = json_encode($data);
            
            Log::debug('sendLaunchUrlRequest - 请求体: ' . $jsonData);
            
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
            
            Log::info('sendLaunchUrlRequest - 请求完成');
            Log::info('sendLaunchUrlRequest - HTTP状态码: ' . $httpCode);
            Log::info('sendLaunchUrlRequest - 耗时(毫秒): ' . $duration);
            Log::info('sendLaunchUrlRequest - 响应长度: ' . strlen($response));
            
            // 检查cURL错误
            if ($error) {
                Log::error('sendLaunchUrlRequest - cURL错误: ' . $error);
                return [
                    'success' => false,
                    'error' => 'cURL Error: ' . $error,
                    'http_code' => 0,
                    'duration_ms' => $duration
                ];
            }
            
            // 解析响应
            $responseData = json_decode($response, true);
            
            if (json_last_error() !== JSON_ERROR_NONE) {
                Log::error('sendLaunchUrlRequest - JSON解析失败: ' . json_last_error_msg());
                Log::error('sendLaunchUrlRequest - 原始响应: ' . $response);
                
                return [
                    'success' => false,
                    'error' => 'JSON解析失败: ' . json_last_error_msg(),
                    'http_code' => $httpCode,
                    'raw_response' => $response,
                    'duration_ms' => $duration
                ];
            }
            
            // 检查API响应状态
            if (!isset($responseData['success']) || !$responseData['success']) {
                $errorMsg = $responseData['message'] ?? 'API返回失败';
                $errorCode = $responseData['errorCode'] ?? 'Unknown';
                
                Log::warning('sendLaunchUrlRequest - API返回失败');
                Log::warning('sendLaunchUrlRequest - 错误信息: ' . $errorMsg);
                Log::warning('sendLaunchUrlRequest - 错误代码: ' . $errorCode);
                
                return [
                    'success' => false,
                    'error' => $errorMsg . ' (Code: ' . $errorCode . ')',
                    'http_code' => $httpCode,
                    'data' => $responseData,
                    'duration_ms' => $duration
                ];
            }
            
            Log::debug('sendLaunchUrlRequest - 响应解析成功');
            Log::debug('sendLaunchUrlRequest - Launch URL: ' . ($responseData['message'] ?? 'N/A'));
            
            return [
                'success' => true,
                'http_code' => $httpCode,
                'data' => $responseData,
                'duration_ms' => $duration
            ];
            
        } catch (\Exception $e) {
            Log::error('sendLaunchUrlRequest - 发生异常: ' . $e->getMessage());
            
            return [
                'success' => false,
                'error' => 'Exception: ' . $e->getMessage(),
                'http_code' => 0
            ];
        }
    }
    
    /**
     * 记录游戏访问日志（可选功能）
     * @param string $vendorCode 厂商代码
     * @param string $gameCode 游戏代码
     * @param string $userCode 用户代码
     * @param string $launchUrl 启动URL
     */
    private function logGameAccess($vendorCode, $gameCode, $userCode, $launchUrl)
    {
        try {
            // 可以记录到专门的游戏访问日志表
            // 这里只是示例，您可以根据需要创建相应的表
            Log::info('GameAccess - 记录游戏访问');
            Log::info('GameAccess - Vendor: ' . $vendorCode);
            Log::info('GameAccess - Game: ' . $gameCode);
            Log::info('GameAccess - User: ' . $userCode);
            Log::info('GameAccess - URL: ' . substr($launchUrl, 0, 100) . '...');
            
            // 如果有游戏访问记录表，可以在这里插入数据
            // Db::table('ntp_game_access_log')->insert([
            //     'vendor_code' => $vendorCode,
            //     'game_code' => $gameCode,
            //     'user_code' => $userCode,
            //     'launch_url' => $launchUrl,
            //     'access_time' => date('Y-m-d H:i:s'),
            //     'ip' => $this->request->ip()
            // ]);
            
        } catch (\Exception $e) {
            Log::error('logGameAccess - 记录失败: ' . $e->getMessage());
            // 记录失败不影响主流程
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