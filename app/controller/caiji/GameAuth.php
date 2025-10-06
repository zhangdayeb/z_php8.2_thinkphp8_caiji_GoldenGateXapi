<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;
use think\facade\Cache;

class GameAuth extends BaseController
{
    /**
     * 获取权限地址（认证令牌）
     * 访问地址：/caiji/auth
     */
    public function get_auth()
    {
        try {
            Log::info('GameAuth.get_auth - 开始获取认证令牌');
            Log::info('GameAuth.get_auth - 请求时间: ' . date('Y-m-d H:i:s'));
            
            // 1. 先检查缓存中是否有有效的token
            $cachedToken = $this->getCachedToken();
            if ($cachedToken !== false) {
                Log::info('GameAuth.get_auth - 使用缓存的令牌');
                return $this->successResponse('使用缓存的令牌', $cachedToken);
            }
            
            // 2. 从环境变量获取配置
            $clientId = env('clientId');
            $clientSecret = env('clientSecret');
            $apiUrl = env('API_URL');
            
            Log::debug('GameAuth.get_auth - 配置信息');
            Log::debug('GameAuth.get_auth - API_URL: ' . $apiUrl);
            Log::debug('GameAuth.get_auth - clientId: ' . $clientId);
            Log::debug('GameAuth.get_auth - clientSecret前缀: ' . substr($clientSecret, 0, 10) . '...');
            
            // 3. 验证配置是否完整
            if (empty($clientId) || empty($clientSecret) || empty($apiUrl)) {
                Log::error('GameAuth.get_auth - 配置信息不完整');
                Log::error('GameAuth.get_auth - clientId是否为空: ' . (empty($clientId) ? '是' : '否'));
                Log::error('GameAuth.get_auth - clientSecret是否为空: ' . (empty($clientSecret) ? '是' : '否'));
                Log::error('GameAuth.get_auth - apiUrl是否为空: ' . (empty($apiUrl) ? '是' : '否'));
                
                return $this->errorResponse('配置信息不完整，请检查env文件配置');
            }
            
            // 4. 构建请求参数
            $requestData = [
                'clientId' => $clientId,
                'clientSecret' => $clientSecret
            ];
            
            // 5. 构建完整的请求URL
            $url = rtrim($apiUrl, '/') . '/auth/createtoken';
            
            Log::info('GameAuth.get_auth - 准备调用API');
            Log::info('GameAuth.get_auth - URL: ' . $url);
            Log::info('GameAuth.get_auth - clientId: ' . $clientId);
            
            // 6. 发送HTTP请求（createtoken接口不需要签名）
            $result = $this->sendCreateTokenRequest($url, $requestData);
            
            // 7. 处理响应
            if ($result['success']) {
                $tokenData = $result['data'];
                
                // 验证响应数据
                if (empty($tokenData['token']) || empty($tokenData['expiration'])) {
                    Log::error('GameAuth.get_auth - 响应数据不完整');
                    Log::error('GameAuth.get_auth - 响应内容: ' . json_encode($tokenData));
                    return $this->errorResponse('API响应数据不完整');
                }
                
                // 计算过期时间
                $expirationTime = $tokenData['expiration'];
                $currentTime = time();
                $remainingSeconds = $expirationTime - $currentTime;
                
                // 缓存token（提前5分钟过期，避免边界情况）
                if ($remainingSeconds > 300) {
                    $cacheSeconds = $remainingSeconds - 300;
                    Cache::set('game_auth_token', $tokenData, $cacheSeconds);
                    
                    Log::info('GameAuth.get_auth - 令牌已缓存');
                    Log::info('GameAuth.get_auth - 缓存时长(秒): ' . $cacheSeconds);
                }
                
                // 格式化输出数据
                $responseData = [
                    'token' => $tokenData['token'],
                    'expiration' => $expirationTime,
                    'expiration_date' => date('Y-m-d H:i:s', $expirationTime),
                    'remaining_seconds' => $remainingSeconds,
                    'remaining_time' => $this->formatRemainingTime($remainingSeconds),
                    'request_time' => date('Y-m-d H:i:s'),
                    'cached' => false
                ];
                
                Log::info('GameAuth.get_auth - 获取令牌成功');
                Log::info('GameAuth.get_auth - Token前缀: ' . substr($tokenData['token'], 0, 20) . '...');
                Log::info('GameAuth.get_auth - 过期时间: ' . $responseData['expiration_date']);
                Log::info('GameAuth.get_auth - 剩余有效期: ' . $responseData['remaining_time']);
                
                return $this->successResponse('获取令牌成功', $responseData);
                
            } else {
                Log::error('GameAuth.get_auth - API调用失败');
                Log::error('GameAuth.get_auth - 错误信息: ' . ($result['error'] ?? 'Unknown error'));
                Log::error('GameAuth.get_auth - HTTP状态码: ' . ($result['http_code'] ?? 0));
                
                return $this->errorResponse(
                    'API调用失败: ' . ($result['error'] ?? 'Unknown error'),
                    [
                        'http_code' => $result['http_code'] ?? 0,
                        'trace_id' => $result['trace_id'] ?? null
                    ]
                );
            }
            
        } catch (\Exception $e) {
            Log::error('GameAuth.get_auth - 发生异常');
            Log::error('GameAuth.get_auth - 异常信息: ' . $e->getMessage());
            Log::error('GameAuth.get_auth - 异常文件: ' . $e->getFile());
            Log::error('GameAuth.get_auth - 异常行号: ' . $e->getLine());
            Log::error('GameAuth.get_auth - 异常堆栈: ' . $e->getTraceAsString());
            
            return $this->errorResponse('系统异常: ' . $e->getMessage());
        }
    }
    
    /**
     * 发送创建令牌的HTTP请求
     * @param string $url 请求URL
     * @param array $data 请求数据
     * @return array 响应结果
     */
    private function sendCreateTokenRequest($url, $data)
    {
        Log::debug('sendCreateTokenRequest - 开始发送请求');
        Log::debug('sendCreateTokenRequest - URL: ' . $url);
        
        try {
            // 初始化cURL
            $ch = curl_init();
            
            // 准备请求体
            $jsonData = json_encode($data);
            
            Log::debug('sendCreateTokenRequest - 请求体: ' . $jsonData);
            
            // 设置cURL选项
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => $jsonData,
                CURLOPT_HTTPHEADER => [
                    'Content-Type: application/json',
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
            
            Log::info('sendCreateTokenRequest - 请求完成');
            Log::info('sendCreateTokenRequest - HTTP状态码: ' . $httpCode);
            Log::info('sendCreateTokenRequest - 耗时(毫秒): ' . $duration);
            Log::info('sendCreateTokenRequest - 响应长度: ' . strlen($response));
            
            // 检查cURL错误
            if ($error) {
                Log::error('sendCreateTokenRequest - cURL错误: ' . $error);
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
                Log::error('sendCreateTokenRequest - JSON解析失败: ' . json_last_error_msg());
                Log::error('sendCreateTokenRequest - 原始响应: ' . $response);
                
                return [
                    'success' => false,
                    'error' => 'JSON解析失败: ' . json_last_error_msg(),
                    'http_code' => $httpCode,
                    'raw_response' => $response,
                    'duration_ms' => $duration
                ];
            }
            
            // 检查HTTP状态码
            if ($httpCode !== 200) {
                Log::warning('sendCreateTokenRequest - HTTP状态码非200');
                Log::warning('sendCreateTokenRequest - 响应内容: ' . json_encode($responseData));
                
                return [
                    'success' => false,
                    'error' => 'HTTP状态码: ' . $httpCode,
                    'http_code' => $httpCode,
                    'data' => $responseData,
                    'duration_ms' => $duration
                ];
            }
            
            Log::debug('sendCreateTokenRequest - 响应解析成功');
            Log::debug('sendCreateTokenRequest - 响应数据键: ' . implode(', ', array_keys($responseData)));
            
            return [
                'success' => true,
                'http_code' => $httpCode,
                'data' => $responseData,
                'duration_ms' => $duration
            ];
            
        } catch (\Exception $e) {
            Log::error('sendCreateTokenRequest - 发生异常: ' . $e->getMessage());
            
            return [
                'success' => false,
                'error' => 'Exception: ' . $e->getMessage(),
                'http_code' => 0
            ];
        }
    }
    
    /**
     * 从缓存获取令牌
     * @return mixed 令牌数据或false
     */
    private function getCachedToken()
    {
        $cachedData = Cache::get('game_auth_token');
        
        if ($cachedData && !empty($cachedData['token']) && !empty($cachedData['expiration'])) {
            $currentTime = time();
            $expirationTime = $cachedData['expiration'];
            
            // 检查是否还有至少1分钟的有效期
            if ($expirationTime - $currentTime > 60) {
                $remainingSeconds = $expirationTime - $currentTime;
                
                Log::info('getCachedToken - 找到有效的缓存令牌');
                Log::info('getCachedToken - 剩余有效期(秒): ' . $remainingSeconds);
                
                return [
                    'token' => $cachedData['token'],
                    'expiration' => $expirationTime,
                    'expiration_date' => date('Y-m-d H:i:s', $expirationTime),
                    'remaining_seconds' => $remainingSeconds,
                    'remaining_time' => $this->formatRemainingTime($remainingSeconds),
                    'request_time' => date('Y-m-d H:i:s'),
                    'cached' => true
                ];
            } else {
                Log::info('getCachedToken - 缓存令牌即将过期，需要刷新');
                Cache::delete('game_auth_token');
            }
        }
        
        return false;
    }
    
    /**
     * 格式化剩余时间
     * @param int $seconds 秒数
     * @return string 格式化的时间字符串
     */
    private function formatRemainingTime($seconds)
    {
        if ($seconds < 0) {
            return '已过期';
        }
        
        $hours = floor($seconds / 3600);
        $minutes = floor(($seconds % 3600) / 60);
        $secs = $seconds % 60;
        
        $parts = [];
        if ($hours > 0) {
            $parts[] = $hours . '小时';
        }
        if ($minutes > 0) {
            $parts[] = $minutes . '分钟';
        }
        if ($secs > 0 || empty($parts)) {
            $parts[] = $secs . '秒';
        }
        
        return implode('', $parts);
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