<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameUrl extends BaseController
{
    // 获取游戏地址
    public function get_url()
    {
        Log::info('=== GameUrl::get_url 开始获取游戏访问URL ===');
        Log::info('get_url - 时间戳: ' . date('Y-m-d H:i:s'));
        Log::info('get_url - 请求参数: ' . json_encode($this->request->param()));

        try {
            // 获取GET参数
            $username = $this->request->param('username', '');
            $gameCode = $this->request->param('gameCode', '');
            $language = $this->request->param('language', 'en');
            $platform = $this->request->param('platform', 'web');
            $currency = $this->request->param('currency', '');
            $lobbyUrl = $this->request->param('lobbyUrl', '');
            $ipAddress = $this->request->param('ipAddress', '');

            Log::debug('get_url - 请求参数解析完成');
            Log::debug('get_url - 用户名: ' . $username);
            Log::debug('get_url - 游戏代码: ' . $gameCode);
            Log::debug('get_url - 语言: ' . $language);
            Log::debug('get_url - 平台: ' . $platform);
            Log::debug('get_url - 货币: ' . $currency);
            Log::debug('get_url - 大厅URL: ' . $lobbyUrl);
            Log::debug('get_url - IP地址: ' . $ipAddress);

            // 验证必需参数
            $requiredParams = [
                'username' => $username,
                'gameCode' => $gameCode,
                'currency' => $currency,
                'lobbyUrl' => $lobbyUrl,
                'ipAddress' => $ipAddress
            ];

            $missingParams = [];
            foreach ($requiredParams as $paramName => $paramValue) {
                if (empty($paramValue)) {
                    $missingParams[] = $paramName;
                }
            }

            if (!empty($missingParams)) {
                Log::warning('get_url - 缺少必需参数');
                Log::warning('get_url - 缺少的参数: ' . implode(', ', $missingParams));
                Log::warning('get_url - 所有参数: ' . json_encode($requiredParams));

                return json([
                    'success' => false,
                    'message' => '缺少必需参数',
                    'missing_params' => $missingParams,
                    'required_params' => array_keys($requiredParams)
                ]);
            }

            // 验证平台参数
            $validPlatforms = ['web', 'H5'];
            if (!in_array($platform, $validPlatforms)) {
                Log::warning('get_url - 平台参数无效');
                Log::warning('get_url - 当前平台: ' . $platform);
                Log::warning('get_url - 有效平台: ' . implode(', ', $validPlatforms));

                return json([
                    'success' => false,
                    'message' => '平台参数无效',
                    'platform' => $platform,
                    'valid_platforms' => $validPlatforms
                ]);
            }

            // 验证IP地址格式
            if (!filter_var($ipAddress, FILTER_VALIDATE_IP)) {
                Log::warning('get_url - IP地址格式无效');
                Log::warning('get_url - IP地址: ' . $ipAddress);

                return json([
                    'success' => false,
                    'message' => 'IP地址格式无效',
                    'ipAddress' => $ipAddress
                ]);
            }

            // 验证URL格式
            if (!filter_var($lobbyUrl, FILTER_VALIDATE_URL)) {
                Log::warning('get_url - lobbyUrl格式无效');
                Log::warning('get_url - lobbyUrl: ' . $lobbyUrl);

                return json([
                    'success' => false,
                    'message' => 'lobbyUrl格式无效',
                    'lobbyUrl' => $lobbyUrl
                ]);
            }

            Log::info('get_url - 参数验证通过，准备调用API');
            Log::info('get_url - 用户名: ' . $username);
            Log::info('get_url - 游戏代码: ' . $gameCode);
            Log::info('get_url - 平台: ' . $platform);

            // 准备API请求数据
            $requestData = [
                'username' => $username,
                'gameCode' => $gameCode,
                'language' => $language,
                'platform' => $platform,
                'currency' => $currency,
                'lobbyUrl' => $lobbyUrl,
                'ipAddress' => $ipAddress
            ];

            // 调用API获取游戏URL
            $apiResponse = sendApiRequest('/game/url', $requestData, 'POST');

            Log::info('get_url - API请求完成');
            Log::info('get_url - 用户名: ' . $username);
            Log::info('get_url - 游戏代码: ' . $gameCode);
            Log::info('get_url - API成功: ' . ($apiResponse['success'] ? '是' : '否'));
            Log::info('get_url - HTTP状态码: ' . $apiResponse['http_code']);
            Log::info('get_url - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

            // 检查API请求是否成功
            if (!$apiResponse['success'] || $apiResponse['http_code'] !== 200) {
                Log::error('get_url - 获取游戏URL API请求失败');
                Log::error('get_url - 用户名: ' . $username);
                Log::error('get_url - 游戏代码: ' . $gameCode);
                Log::error('get_url - API响应: ' . json_encode($apiResponse));
                Log::error('get_url - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

                return json([
                    'success' => false,
                    'message' => 'API请求失败',
                    'error' => $apiResponse['error'] ?? 'Unknown error',
                    'http_code' => $apiResponse['http_code'] ?? 0,
                    'trace_id' => $apiResponse['trace_id'] ?? null
                ]);
            }

            // 检查返回数据格式
            if (!isset($apiResponse['data']) || !is_array($apiResponse['data'])) {
                Log::error('get_url - API返回数据格式错误');
                Log::error('get_url - 用户名: ' . $username);
                Log::error('get_url - 游戏代码: ' . $gameCode);
                Log::error('get_url - 是否有data: ' . (isset($apiResponse['data']) ? '是' : '否'));
                Log::error('get_url - data类型: ' . gettype($apiResponse['data'] ?? null));
                Log::error('get_url - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

                return json([
                    'success' => false,
                    'message' => 'API返回数据格式错误',
                    'trace_id' => $apiResponse['trace_id'] ?? null
                ]);
            }

            $responseData = $apiResponse['data'];

            // 检查是否包含游戏URL - API返回的数据结构是嵌套的
            // 实际结构：responseData.data.gameUrl
            $gameUrl = null;
            $token = null;
            
            if (isset($responseData['data']['gameUrl'])) {
                $gameUrl = $responseData['data']['gameUrl'];
                $token = $responseData['data']['token'] ?? null;
            } elseif (isset($responseData['gameUrl'])) {
                // 备用检查直接在responseData中的情况
                $gameUrl = $responseData['gameUrl'];
                $token = $responseData['token'] ?? null;
            }
            
            if (empty($gameUrl)) {
                Log::warning('get_url - API响应中未找到游戏URL');
                Log::warning('get_url - 用户名: ' . $username);
                Log::warning('get_url - 游戏代码: ' . $gameCode);
                Log::warning('get_url - 响应数据: ' . json_encode($responseData));
                Log::warning('get_url - 是否有data字段: ' . (isset($responseData['data']) ? '是' : '否'));
                Log::warning('get_url - 是否有直接gameUrl: ' . (isset($responseData['gameUrl']) ? '是' : '否'));
                Log::warning('get_url - 是否有嵌套gameUrl: ' . (isset($responseData['data']['gameUrl']) ? '是' : '否'));
                Log::warning('get_url - 响应键名: ' . implode(', ', array_keys($responseData)));
                Log::warning('get_url - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

                return json([
                    'success' => false,
                    'message' => '未获取到有效的游戏URL',
                    'response_data' => $responseData,
                    'trace_id' => $apiResponse['trace_id'] ?? null
                ]);
            }

            Log::info('get_url - 游戏URL获取成功');
            Log::info('get_url - 用户名: ' . $username);
            Log::info('get_url - 游戏代码: ' . $gameCode);
            Log::info('get_url - 游戏URL长度: ' . strlen($gameUrl));
            Log::info('get_url - 游戏URL域名: ' . (parse_url($gameUrl, PHP_URL_HOST) ?? 'unknown'));
            Log::info('get_url - 是否有token: ' . (!empty($token) ? '是' : '否'));
            Log::info('get_url - API状态: ' . ($responseData['status'] ?? 'unknown'));
            Log::info('get_url - API消息: ' . ($responseData['message'] ?? 'unknown'));
            Log::info('get_url - TraceId: ' . ($apiResponse['trace_id'] ?? 'null'));

            // 返回成功响应
            return json([
                'success' => true,
                'message' => '游戏URL获取成功',
                'data' => [
                    'gameUrl' => $gameUrl,
                    'token' => $token,
                    'gameCode' => $gameCode,
                    'username' => $username,
                    'platform' => $platform,
                    'language' => $language,
                    'currency' => $currency,
                    'api_status' => $responseData['status'] ?? null,
                    'api_message' => $responseData['message'] ?? null,
                    'trace_id' => $apiResponse['trace_id'] ?? null
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('get_url - 函数执行异常');
            Log::error('get_url - 错误信息: ' . $e->getMessage());
            Log::error('get_url - 错误文件: ' . $e->getFile());
            Log::error('get_url - 错误行号: ' . $e->getLine());
            Log::error('get_url - 错误堆栈: ' . $e->getTraceAsString());
            Log::error('get_url - 请求参数: ' . json_encode($this->request->param()));

            return json([
                'success' => false,
                'message' => '系统异常',
                'error' => $e->getMessage()
            ]);
        }
    }
}