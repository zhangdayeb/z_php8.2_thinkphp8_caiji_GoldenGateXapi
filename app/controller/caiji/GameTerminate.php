<?php
namespace app\controller\caiji;

use app\BaseController;
use think\facade\Db;
use think\facade\Log;

class GameTerminate extends BaseController
{
    // 终止用户会话
    public function get_terminate()
    {
        return 'it work!';
    }
}