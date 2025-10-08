<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\facade\Route;

// 测试路由
Route::get('think', function () {
    return 'hello,ThinkPHP6!';
});

Route::get('hello/:name', 'index/hello');


// 游戏采集
Route::rule('caiji/auth', 'caiji.GameAuth/get_auth');                           // 测试权限
Route::rule('caiji/vendors', 'caiji.GameVendors/get_vendors');                  // 获取厂商列表 更新的时候用一次
Route::rule('caiji/list', 'caiji.GameList/get_list');                           // 厂商 游戏列表 更新的时候用一次
Route::rule('caiji/url', 'caiji.GameUrl/get_url');                              // 获取游戏列表 需要配合 用户余额执行 厂商会回调用户余额 暂时所有参数都是 url 传参
Route::rule('caiji/down', 'caiji.GameDownload/get_down');                       // 从游戏接口下载图片
Route::rule('caiji/transfer', 'caiji.GameTransfer/get_transfer');               // 游戏从采集转移到游戏表中

