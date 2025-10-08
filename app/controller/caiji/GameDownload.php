<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameDownload extends BaseController
{
    // 本地存储基础路径
    private $localBasePath;
    
    // 批处理大小
    private $batchSize = 100;
    
    // 下载超时时间（秒）
    private $downloadTimeout = 5;

    // 起步id
    private $startId = 0;

    public function __construct(\think\App $app)
    {
        parent::__construct($app);
        // 本地存储路径：/www/wwwroot/cj.ampj998.top/public/uploads/ggkj/
        $this->localBasePath = $app->getRootPath() . 'public/uploads/ggkj/';
    }

    /**
     * 主入口方法 - 图片本地化处理
     */
    public function get_down()
    {
        // 从request param里面获取起步ID参数
        $this->startId = $this->request->param('start_id', 0, 'intval');
        
        // 设置脚本执行时间限制
        set_time_limit(0);
        ini_set('memory_limit', '256M');
        
        Log::info('=== GameDownload::get_down 开始图片本地化处理 ===');
        Log::info('get_down - 时间戳: ' . date('Y-m-d H:i:s'));
        Log::info('get_down - 起步ID: ' . $this->startId);
        Log::info('get_down - 批处理大小: ' . $this->batchSize);
        Log::info('get_down - 本地基础路径: ' . $this->localBasePath);

        try {
            // 获取需要处理的记录
            $records = $this->getUnprocessedRecords();
            
            if (empty($records)) {
                Log::info('get_down - 所有图片已完成本地化处理');
                
                return json([
                    'success' => true,
                    'message' => '🎉 所有图片已完成本地化处理！',
                    'data' => [
                        'is_complete' => true,
                        'processed_count' => 0,
                        'total_remaining' => 0,
                        'need_refresh' => false
                    ]
                ]);
            }

            // 获取统计信息
            $totalUnprocessed = $this->getTotalUnprocessedCount();
            $processedCount = 0;
            $successCount = 0;
            $failedCount = 0;
            $alreadyExistsCount = 0;
            
            Log::info('get_down - 开始处理当前批次');
            Log::info('get_down - 当前批次记录数: ' . count($records));
            Log::info('get_down - 总待处理记录数: ' . $totalUnprocessed);

            // 处理每条记录
            foreach ($records as $index => $record) {
                $processedCount++;
                
                Log::info("get_down - 处理记录 [{$processedCount}/{$this->batchSize}] ID:{$record['id']}");
                Log::info("get_down - 游戏信息: {$record['supplier_code']}/{$record['game_code']}/{$record['game_name']}");
                Log::info("get_down - 当前图片URL: {$record['game_img_url']}");

                try {
                    $result = $this->processRecord($record);
                    
                    if ($result['success']) {
                        if ($result['action'] === 'already_exists') {
                            $alreadyExistsCount++;
                            Log::info("get_down - ID:{$record['id']} 文件已存在，直接标记");
                        } else {
                            $successCount++;
                            Log::info("get_down - ID:{$record['id']} 下载成功");
                        }
                    } else {
                        $failedCount++;
                        Log::warning("get_down - ID:{$record['id']} 处理失败: {$result['error']}");
                    }

                } catch (\Exception $e) {
                    $failedCount++;
                    Log::error("get_down - ID:{$record['id']} 处理异常: {$e->getMessage()}");
                }

                // 添加短暂延迟，避免请求过于频繁
                usleep(100000); // 0.1秒
            }

            // 获取更新后的统计
            $remainingCount = $this->getTotalUnprocessedCount();
            $needRefresh = $remainingCount > 0;

            $responseData = [
                'is_complete' => !$needRefresh,
                'batch_info' => [
                    'processed_count' => $processedCount,
                    'success_count' => $successCount,
                    'failed_count' => $failedCount,
                    'already_exists_count' => $alreadyExistsCount,
                    'start_id' => $records[0]['id'],
                    'end_id' => $records[count($records) - 1]['id']
                ],
                'progress_info' => [
                    'total_remaining' => $remainingCount,
                    'progress_percent' => $totalUnprocessed > 0 ? 
                        round((($totalUnprocessed - $remainingCount) / $totalUnprocessed) * 100, 2) : 100
                ],
                'need_refresh' => $needRefresh,
                'message_detail' => "处理了 {$processedCount} 条记录，成功 {$successCount} 个，已存在 {$alreadyExistsCount} 个，失败 {$failedCount} 个"
            ];

            $message = $needRefresh ? 
                "批次处理完成，还有 {$remainingCount} 条记录待处理，请刷新继续..." : 
                "🎉 所有图片本地化处理完成！";

            Log::info('get_down - 当前批次处理完成');
            Log::info('get_down - 处理结果: ' . json_encode($responseData['batch_info']));
            Log::info('get_down - 是否需要刷新: ' . ($needRefresh ? '是' : '否'));

            return json([
                'success' => true,
                'message' => $message,
                'data' => $responseData
            ]);

        } catch (\Exception $e) {
            Log::error('get_down - 函数执行异常');
            Log::error('get_down - 错误信息: ' . $e->getMessage());
            Log::error('get_down - 错误文件: ' . $e->getFile());
            Log::error('get_down - 错误行号: ' . $e->getLine());
            Log::error('get_down - 错误堆栈: ' . $e->getTraceAsString());

            return json([
                'success' => false,
                'message' => '系统异常: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * 获取未处理的记录
     * @return array
     */
    private function getUnprocessedRecords()
    {
        $query = Db::name('ntp_api_games')
            ->field('id,supplier_code,game_code,game_name,game_img_url')
            ->where('api_code_set', 'GGKJ')
            ->where('game_img_url_down', 0)
            ->where('game_img_url', '<>', '');

        // 如果指定了起步ID，则从该ID开始
        if ($this->startId > 0) {
            $query->where('id', '>=', $this->startId);
        }

        return $query->limit($this->batchSize)
            ->order('id', 'asc')
            ->select()
            ->toArray();
    }

    /**
     * 获取未处理记录总数
     * @return int
     */
    private function getTotalUnprocessedCount()
    {
        $query = Db::name('ntp_api_games')
            ->where('api_code_set', 'GGKJ')
            ->where('game_img_url_down', 0)
            ->where('game_img_url', '<>', '');

        // 如果指定了起步ID，则从该ID开始统计
        if ($this->startId > 0) {
            $query->where('id', '>=', $this->startId);
        }

        return $query->count();
    }

    /**
     * 处理单条记录
     * @param array $record
     * @return array
     */
    private function processRecord($record)
    {
        $gameId = $record['id'];
        $gameImgUrl = $record['game_img_url'];
        
        // 构建本地文件路径
        $localFilePath = $this->buildLocalFilePath($gameImgUrl);
        $fullLocalPath = $this->localBasePath . $localFilePath;
        
        Log::debug("processRecord - ID:{$gameId} 构建本地路径: {$fullLocalPath}");

        // 检查本地文件是否已存在
        if (file_exists($fullLocalPath)) {
            // 文件已存在，直接标记为已处理并更新路径
            $webPath = '/uploads/ggkj/' . $localFilePath;
            $this->markAsProcessed($gameId, $webPath);

            Log::info("processRecord - ID:{$gameId} 本地文件已存在，直接标记完成");
            Log::info("processRecord - ID:{$gameId} 更新路径为: {$webPath}");

            return [
                'success' => true,
                'action' => 'already_exists',
                'local_path' => $fullLocalPath,
                'web_path' => $webPath
            ];
        }

        // 文件不存在，需要下载
        $remoteUrl = $this->buildRemoteUrl($gameImgUrl);
        
        Log::info("processRecord - ID:{$gameId} 开始从远程下载");
        Log::info("processRecord - ID:{$gameId} 远程地址: {$remoteUrl}");
        Log::info("processRecord - ID:{$gameId} 本地路径: {$fullLocalPath}");

        // 创建目录
        $localDir = dirname($fullLocalPath);
        if (!$this->createDirectoryIfNotExists($localDir)) {
            return [
                'success' => false,
                'error' => '无法创建本地目录: ' . $localDir
            ];
        }

        // 下载文件
        $downloadResult = $this->downloadFile($remoteUrl, $fullLocalPath);
        
        Log::info("processRecord - ID:{$gameId} 下载结果: " . json_encode($downloadResult));

        if ($downloadResult['success']) {
            // 下载成功，标记为已处理并更新路径
            $webPath = '/uploads/ggkj/' . $localFilePath;
            $this->markAsProcessed($gameId, $webPath);

            Log::info("processRecord - ID:{$gameId} 下载成功并标记完成");
            Log::info("processRecord - ID:{$gameId} 文件大小: {$downloadResult['file_size']} 字节");
            Log::info("processRecord - ID:{$gameId} 更新路径为: {$webPath}");

            return [
                'success' => true,
                'action' => 'downloaded',
                'remote_url' => $remoteUrl,
                'local_path' => $fullLocalPath,
                'web_path' => $webPath,
                'file_size' => $downloadResult['file_size']
            ];
        } else {
            Log::warning("processRecord - ID:{$gameId} 下载失败: {$downloadResult['error']}");
            
            return [
                'success' => false,
                'error' => $downloadResult['error'],
                'remote_url' => $remoteUrl,
                'local_path' => $fullLocalPath
            ];
        }
    }

    /**
     * 构建本地文件路径
     * @param string $gameImgUrl
     * @return string
     */
    private function buildLocalFilePath($gameImgUrl)
    {
        // 示例输入: https://example.com/images/zombie-outbrk.png
        // 需要提取: images/zombie-outbrk.png（去掉域名，保留完整路径）

        $parsedUrl = parse_url($gameImgUrl);
        $path = $parsedUrl['path'] ?? '';

        // 去掉开头的斜杠
        $localPath = ltrim($path, '/');

        Log::debug("buildLocalFilePath - 原始URL: {$gameImgUrl}");
        Log::debug("buildLocalFilePath - 解析路径: {$path}");
        Log::debug("buildLocalFilePath - 本地路径: {$localPath}");

        return $localPath;
    }

    /**
     * 构建远程下载URL
     * @param string $gameImgUrl
     * @return string
     */
    private function buildRemoteUrl($gameImgUrl)
    {
        // 直接使用数据库中的URL，不需要转换
        // 输入: https://example.com/images/zombie-outbrk.png
        // 输出: https://example.com/images/zombie-outbrk.png

        Log::debug("buildRemoteUrl - 原始URL: {$gameImgUrl}");
        Log::debug("buildRemoteUrl - 远程URL: {$gameImgUrl}");

        return $gameImgUrl;
    }

    /**
     * 创建目录（如果不存在）
     * @param string $dir
     * @return bool
     */
    private function createDirectoryIfNotExists($dir)
    {
        if (is_dir($dir)) {
            return true;
        }

        try {
            return mkdir($dir, 0755, true);
        } catch (\Exception $e) {
            Log::error("createDirectoryIfNotExists - 创建目录失败: {$dir} - {$e->getMessage()}");
            return false;
        }
    }

    /**
     * 下载文件
     * @param string $remoteUrl
     * @param string $localPath
     * @return array
     */
    private function downloadFile($remoteUrl, $localPath)
    {
        $result = [
            'success' => false,
            'error' => null,
            'file_size' => 0,
            'http_code' => 0,
            'download_time' => 0
        ];

        $startTime = microtime(true);

        try {
            $ch = curl_init();
            
            curl_setopt_array($ch, [
                CURLOPT_URL => $remoteUrl,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_TIMEOUT => $this->downloadTimeout,
                CURLOPT_CONNECTTIMEOUT => 3,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_SSL_VERIFYHOST => false,
                CURLOPT_USERAGENT => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                CURLOPT_REFERER => 'https://trendytreasures.art/',
                CURLOPT_LOW_SPEED_LIMIT => 1024, // 如果速度低于1KB/s
                CURLOPT_LOW_SPEED_TIME => 3,     // 持续3秒，则超时
            ]);

            $imageData = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            $downloadTime = curl_getinfo($ch, CURLINFO_TOTAL_TIME);
            
            curl_close($ch);

            $endTime = microtime(true);
            $result['download_time'] = round(($endTime - $startTime) * 1000, 2); // 毫秒
            $result['http_code'] = $httpCode;

            if ($error) {
                $result['error'] = 'cURL错误: ' . $error;
                return $result;
            }

            if ($httpCode !== 200) {
                $result['error'] = 'HTTP状态码错误: ' . $httpCode;
                return $result;
            }

            if ($imageData === false || empty($imageData)) {
                $result['error'] = '下载的图片数据为空';
                return $result;
            }

            $dataSize = strlen($imageData);
            if ($dataSize < 100) {
                $result['error'] = '图片数据过小，可能不是有效图片 (大小: ' . $dataSize . ' 字节)';
                return $result;
            }

            // 保存文件
            $bytesWritten = file_put_contents($localPath, $imageData);
            
            if ($bytesWritten === false) {
                $result['error'] = '文件写入失败';
                return $result;
            }

            $result['success'] = true;
            $result['file_size'] = $bytesWritten;
            
            Log::info("downloadFile - 下载成功: {$remoteUrl}");
            Log::info("downloadFile - 文件大小: {$bytesWritten} 字节");
            Log::info("downloadFile - 下载耗时: {$result['download_time']} 毫秒");

            return $result;

        } catch (\Exception $e) {
            $result['error'] = '下载异常: ' . $e->getMessage();
            Log::error("downloadFile - 下载异常: {$remoteUrl} - {$e->getMessage()}");
            return $result;
        }
    }

    /**
     * 标记记录为已处理并更新图片路径
     * @param int $gameId
     * @param string $webPath
     * @return bool
     */
    private function markAsProcessed($gameId, $webPath)
    {
        try {
            $result = Db::name('ntp_api_games')
                ->where('id', $gameId)
                ->update([
                    'game_img_url_down' => 1,
                    'game_img_url' => $webPath
                ]);

            if ($result !== false) {
                Log::debug("markAsProcessed - 成功标记 ID:{$gameId} 为已处理");
                Log::debug("markAsProcessed - 成功更新路径: {$webPath}");
                return true;
            } else {
                Log::warning("markAsProcessed - 标记失败 ID:{$gameId}");
                return false;
            }
        } catch (\Exception $e) {
            Log::error("markAsProcessed - 标记异常 ID:{$gameId} - {$e->getMessage()}");
            return false;
        }
    }
}