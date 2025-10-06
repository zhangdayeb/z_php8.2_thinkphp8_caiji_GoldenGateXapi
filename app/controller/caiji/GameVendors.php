<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Log;
use think\facade\Db;

class GameVendors extends BaseController
{
    /**
     * 获取游戏厂商列表并同步到数据库
     * 访问地址：/caiji/vendors
     */
    public function get_vendors()
    {
        try {
            Log::info('GameVendors.get_vendors - 开始获取厂商列表');
            
            // 从env获取配置
            $apiUrl = env('API_URL');
            $token = env('Authorization');
            
            if (empty($apiUrl) || empty($token)) {
                Log::error('GameVendors.get_vendors - 配置缺失');
                return json([
                    'code' => 500,
                    'success' => false,
                    'message' => '配置信息不完整'
                ]);
            }
            
            // 构建请求URL
            $url = rtrim($apiUrl, '/') . '/vendors/list';
            
            // 发送请求
            $ch = curl_init();
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_HTTPHEADER => [
                    'Authorization: Bearer ' . $token,
                    'Content-Type: application/json'
                ],
                CURLOPT_TIMEOUT => 30,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_SSL_VERIFYHOST => false,
            ]);
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);
            
            if ($error) {
                Log::error('GameVendors.get_vendors - CURL错误: ' . $error);
                return json([
                    'code' => 500,
                    'success' => false,
                    'message' => '请求失败: ' . $error
                ]);
            }
            
            // 解析响应
            $data = json_decode($response, true);
            
            if ($httpCode !== 200 || !$data['success']) {
                Log::error('GameVendors.get_vendors - API返回错误');
                return json([
                    'code' => $httpCode,
                    'success' => false,
                    'message' => $data['message'] ?? '获取厂商列表失败'
                ]);
            }
            
            // 开启事务
            Db::startTrans();
            try {
                // 清空表
                Db::table('ntp_api_goldengatex_supplier')->delete(true);
                Log::info('GameVendors.get_vendors - 已清空厂商表');
                
                // 准备插入数据
                $insertData = [];
                $currentDate = date('Y-m-d');
                
                foreach ($data['message'] as $vendor) {
                    $insertData[] = [
                        'create_at' => $currentDate,
                        'name' => $vendor['name'],
                        'currency_code' => 'CNY',
                        'code' => $vendor['vendorCode'],
                        'category_code' => $this->getTypeName($vendor['type'])
                    ];
                }
                
                // 批量插入
                if (!empty($insertData)) {
                    Db::table('ntp_api_goldengatex_supplier')->insertAll($insertData);
                    Log::info('GameVendors.get_vendors - 成功插入 ' . count($insertData) . ' 条厂商数据');
                }
                
                // 提交事务
                Db::commit();
                
                // 返回成功结果
                return json([
                    'code' => 200,
                    'success' => true,
                    'message' => '厂商数据同步成功',
                    'data' => [
                        'total' => count($insertData),
                        'vendors' => $insertData
                    ]
                ]);
                
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                Log::error('GameVendors.get_vendors - 数据库操作失败: ' . $e->getMessage());
                return json([
                    'code' => 500,
                    'success' => false,
                    'message' => '数据库操作失败: ' . $e->getMessage()
                ]);
            }
            
        } catch (\Exception $e) {
            Log::error('GameVendors.get_vendors - 系统异常: ' . $e->getMessage());
            return json([
                'code' => 500,
                'success' => false,
                'message' => '系统异常: ' . $e->getMessage()
            ]);
        }
    }
    
    /**
     * 获取游戏类型名称
     */
    private function getTypeName($type)
    {
        $types = [
            1 => '真人娱乐场',
            2 => '老虎机',
            3 => '迷你游戏'
        ];
        return $types[$type] ?? '未知类型';
    }
}