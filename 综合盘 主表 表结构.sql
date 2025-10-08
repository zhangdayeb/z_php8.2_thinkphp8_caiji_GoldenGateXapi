-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2025-10-06 19:09:16
-- 服务器版本： 5.7.44-log
-- PHP 版本： 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `ntp_zonghe`
--

-- --------------------------------------------------------

--
-- 表的结构 `ntp_admin_login_log`
--

CREATE TABLE `ntp_admin_login_log` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `admin_id` int(11) NOT NULL COMMENT '管理员ID',
  `admin_name` varchar(200) NOT NULL COMMENT '管理员账号',
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `login_ip` varchar(45) DEFAULT NULL COMMENT '登录IP地址',
  `login_time` datetime DEFAULT NULL COMMENT '登录时间',
  `user_agent` text COMMENT '用户代理信息',
  `login_status` tinyint(1) DEFAULT '1' COMMENT '登录状态 1成功 0失败',
  `fail_reason` varchar(500) DEFAULT NULL COMMENT '失败原因',
  `session_id` varchar(100) DEFAULT NULL COMMENT '会话ID',
  `login_device` varchar(100) DEFAULT NULL COMMENT '登录设备类型',
  `browser_info` varchar(200) DEFAULT NULL COMMENT '浏览器信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员登录日志表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_agent_login_log`
--

CREATE TABLE `ntp_agent_login_log` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `agent_id` int(11) NOT NULL COMMENT '代理ID',
  `agent_name` varchar(200) NOT NULL COMMENT '代理账号',
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `login_ip` varchar(45) DEFAULT NULL COMMENT '登录IP地址',
  `login_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `user_agent` text COMMENT '用户代理信息',
  `login_status` tinyint(1) DEFAULT '1' COMMENT '登录状态 1成功 0失败',
  `fail_reason` varchar(500) DEFAULT NULL COMMENT '失败原因',
  `session_id` varchar(100) DEFAULT NULL COMMENT '会话ID',
  `login_device` varchar(100) DEFAULT NULL COMMENT '登录设备类型',
  `browser_info` varchar(200) DEFAULT NULL COMMENT '浏览器信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代理登录日志表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_code_set`
--

CREATE TABLE `ntp_api_code_set` (
  `id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `api_code_set` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接口代码',
  `code_name` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接口名称',
  `qianbao_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '对接对方的接口域名',
  `api_url` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接口地址',
  `api_key` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接口key',
  `api_secret` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密钥',
  `remark` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `handler_class` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理器类名',
  `is_enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `config_data` text COLLATE utf8mb4_unicode_ci COMMENT '额外配置数据(JSON格式)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='api对应的接口表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_games`
--

CREATE TABLE `ntp_api_games` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `api_code_set` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ZFKJ' COMMENT '接口代码',
  `is_hot` int(11) NOT NULL DEFAULT '1' COMMENT '是否热门 1 是 0 不是',
  `supplier_id` int(11) NOT NULL COMMENT '厂商ID',
  `supplier_code` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '厂商代码',
  `create_at` datetime NOT NULL COMMENT '创建时间',
  `game_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称',
  `game_name_more_language` text COLLATE utf8mb4_unicode_ci COMMENT '多语言翻译',
  `game_code` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏代码',
  `game_type` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏类型',
  `game_img_url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图片地址',
  `game_language` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支持语言',
  `game_support_devices` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支持设备',
  `game_currency_code` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '货币类型',
  `game_img_url_down` int(11) NOT NULL DEFAULT '0' COMMENT '图片本地化 0 没有 1 有',
  `sort_weight` int(11) NOT NULL DEFAULT '0' COMMENT '排序权重'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='厂商下属游戏列表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_games_temp`
--

CREATE TABLE `ntp_api_games_temp` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `api_code_set` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ZFKJ' COMMENT '接口代码',
  `is_hot` int(11) NOT NULL DEFAULT '1' COMMENT '是否热门 1 是 0 不是',
  `supplier_id` int(11) NOT NULL COMMENT '厂商ID',
  `supplier_code` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '厂商代码',
  `create_at` datetime NOT NULL COMMENT '创建时间',
  `game_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称',
  `game_name_more_language` text COLLATE utf8mb4_unicode_ci COMMENT '多语言翻译',
  `game_code` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏代码',
  `game_type` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏类型',
  `game_img_url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图片地址',
  `game_language` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支持语言',
  `game_support_devices` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支持设备',
  `game_currency_code` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '货币类型',
  `game_img_url_down` int(11) NOT NULL DEFAULT '0' COMMENT '图片本地化 0 没有 1 有',
  `sort_weight` int(11) NOT NULL DEFAULT '0' COMMENT '排序权重'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='厂商下属游戏列表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_game_transactions`
--

CREATE TABLE `ntp_api_game_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易ID（唯一标识）',
  `member_id` int(10) UNSIGNED NOT NULL COMMENT '会员ID',
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易类型：bet, bet_result, bet_credit, bet_debit, rollback, adjustment, etc.',
  `amount` decimal(16,2) NOT NULL COMMENT '交易金额',
  `status` enum('pending','completed','failed','cancelled','rolled_back') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '交易状态: pending, completed, failed, cancelled, rolled_back',
  `trace_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '追踪ID',
  `bet_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '下注ID',
  `external_transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '外部交易ID',
  `game_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏代码',
  `round_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏回合ID',
  `money_log_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT '关联的资金日志ID',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '备注信息',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏交易记录接口记录表防止重复计算的';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_game_types`
--

CREATE TABLE `ntp_api_game_types` (
  `id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `game_type` varchar(200) NOT NULL COMMENT '游戏类型',
  `icon_after` varchar(200) NOT NULL COMMENT '选中后的图标',
  `icon_before` varchar(200) NOT NULL COMMENT '选中前的图标',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `title_more_language` varchar(600) DEFAULT NULL COMMENT '多语言翻译',
  `sort_weight` int(11) NOT NULL DEFAULT '0' COMMENT '排序权重'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏分类表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_goldengatex_supplier`
--

CREATE TABLE `ntp_api_goldengatex_supplier` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `create_at` date NOT NULL COMMENT '创建时间',
  `name` varchar(200) NOT NULL COMMENT '厂商名字',
  `currency_code` varchar(200) NOT NULL COMMENT '支持货币类型',
  `code` varchar(200) NOT NULL COMMENT '厂商代码',
  `category_code` varchar(600) NOT NULL COMMENT '游戏分类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏供应商';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_goldengatex_supplier_games`
--

CREATE TABLE `ntp_api_goldengatex_supplier_games` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `supplier_id` int(11) NOT NULL COMMENT '厂商ID',
  `supplier_code` varchar(200) DEFAULT NULL COMMENT '厂商代码',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `game_name` varchar(200) NOT NULL COMMENT '游戏名称',
  `game_code` varchar(600) NOT NULL COMMENT '游戏代码',
  `game_type` varchar(200) DEFAULT NULL COMMENT '游戏类型',
  `game_img_url` varchar(200) NOT NULL COMMENT '封面图片地址',
  `game_language` varchar(200) NOT NULL DEFAULT 'zh' COMMENT '支持语言',
  `game_support_devices` varchar(200) NOT NULL DEFAULT 'H5,WEB' COMMENT '支持设备',
  `game_currency_code` varchar(600) NOT NULL DEFAULT 'CNY' COMMENT '货币类型'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='厂商下属游戏列表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_group_games`
--

CREATE TABLE `ntp_api_group_games` (
  `game_id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `show_group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '可以展示的集团 例如 DHYL,YHYL',
  `run_group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '可以运行的集团 例如 DHYL,YHYL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏展示及运行配置表 方便前端快速展示';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_supplier`
--

CREATE TABLE `ntp_api_supplier` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `show_status` int(11) NOT NULL DEFAULT '1' COMMENT '展示状态 0 不展示 1展示',
  `run_status` int(11) NOT NULL DEFAULT '1' COMMENT '运行状态 0 维护中 1正常运行',
  `img_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片',
  `create_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '厂商名字',
  `name_more_language` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '多语言自动翻译匹配',
  `currency_code` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '支持货币类型',
  `code` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '厂商代码',
  `category_code` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏分类',
  `sort_weight` int(11) NOT NULL DEFAULT '0' COMMENT '排序权重'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏供应商';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_v2_supplier`
--

CREATE TABLE `ntp_api_v2_supplier` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `create_at` date NOT NULL COMMENT '创建时间',
  `name` varchar(200) NOT NULL COMMENT '厂商名字',
  `currency_code` varchar(200) NOT NULL COMMENT '支持货币类型',
  `code` varchar(200) NOT NULL COMMENT '厂商代码',
  `category_code` varchar(600) NOT NULL COMMENT '游戏分类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏供应商';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_api_v2_supplier_games`
--

CREATE TABLE `ntp_api_v2_supplier_games` (
  `id` int(11) NOT NULL COMMENT 'ID 自增 序号',
  `supplier_id` int(11) NOT NULL COMMENT '厂商ID',
  `supplier_code` varchar(200) NOT NULL COMMENT '厂商代码',
  `create_at` datetime NOT NULL COMMENT '创建时间',
  `game_name` varchar(200) NOT NULL COMMENT '游戏名称',
  `game_code` varchar(600) NOT NULL COMMENT '游戏代码',
  `game_type` varchar(200) NOT NULL COMMENT '游戏类型',
  `game_img_url` varchar(200) NOT NULL COMMENT '封面图片地址',
  `game_language` varchar(200) NOT NULL COMMENT '支持语言',
  `game_support_devices` varchar(200) NOT NULL COMMENT '支持设备',
  `game_currency_code` varchar(600) NOT NULL COMMENT '货币类型'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='厂商下属游戏列表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_activity`
--

CREATE TABLE `ntp_common_activity` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `type` tinyint(1) DEFAULT NULL COMMENT '分类',
  `content` longtext COMMENT '内容',
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `thumb_url` text COMMENT '缩略图',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `author` varchar(200) DEFAULT NULL COMMENT '作者',
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_activity_type`
--

CREATE TABLE `ntp_common_activity_type` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `name` varchar(200) DEFAULT NULL COMMENT '分类名'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin`
--

CREATE TABLE `ntp_common_admin` (
  `id` int(10) NOT NULL,
  `user_name` varchar(200) DEFAULT NULL COMMENT '管理员账号',
  `pwd` varchar(200) DEFAULT NULL COMMENT '密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `role` int(2) DEFAULT '1' COMMENT '角色',
  `remarks` varchar(200) DEFAULT '0' COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台管理员表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_log`
--

CREATE TABLE `ntp_common_admin_log` (
  `id` int(10) NOT NULL,
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员id',
  `create_time` datetime DEFAULT NULL COMMENT '操作时间',
  `mark` varchar(200) DEFAULT NULL COMMENT '操作内容',
  `ip` varchar(200) DEFAULT NULL COMMENT 'ip',
  `city` varchar(200) DEFAULT NULL COMMENT '地区',
  `system` varchar(200) DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(200) DEFAULT NULL COMMENT '操作浏览器',
  `action` varchar(200) DEFAULT NULL COMMENT '操作'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台操作日志';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_menu`
--

CREATE TABLE `ntp_common_admin_menu` (
  `id` int(10) NOT NULL,
  `pid` int(10) DEFAULT '0' COMMENT '上级菜单,0为顶级菜单',
  `title` varchar(200) DEFAULT NULL COMMENT '菜单名',
  `status` tinyint(1) DEFAULT '1' COMMENT '菜单状态 1正常 0下架',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID，编辑者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `path` varchar(200) DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(200) DEFAULT NULL COMMENT '图标地址',
  `sort` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台菜单表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_power`
--

CREATE TABLE `ntp_common_admin_power` (
  `id` int(10) NOT NULL,
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `path` varchar(200) DEFAULT NULL COMMENT '路径',
  `type` varchar(200) DEFAULT NULL COMMENT '请求方式 get post put update detele'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_role`
--

CREATE TABLE `ntp_common_admin_role` (
  `id` int(10) NOT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '角色名',
  `status` int(10) DEFAULT NULL COMMENT '状态 1正常 0冻结',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_role_menu`
--

CREATE TABLE `ntp_common_admin_role_menu` (
  `id` int(10) NOT NULL,
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `auth_ids` varchar(200) DEFAULT NULL COMMENT '权限组'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_admin_role_power`
--

CREATE TABLE `ntp_common_admin_role_power` (
  `id` int(10) NOT NULL,
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `auth_ids` varchar(600) DEFAULT NULL COMMENT '权限集'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_agent_menu`
--

CREATE TABLE `ntp_common_agent_menu` (
  `id` int(10) NOT NULL,
  `pid` int(10) DEFAULT '0' COMMENT '上级菜单,0为顶级菜单',
  `title` varchar(200) DEFAULT NULL COMMENT '菜单名',
  `status` tinyint(1) DEFAULT '1' COMMENT '菜单状态 1正常 0下架',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID，编辑者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `path` varchar(200) DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(200) DEFAULT NULL COMMENT '图标地址',
  `sort` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代理菜单表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_article`
--

CREATE TABLE `ntp_common_article` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `type` tinyint(1) DEFAULT NULL COMMENT '分类',
  `content` longtext COMMENT '内容',
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `thumb_url` text COMMENT '缩略图',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `author` varchar(200) DEFAULT NULL COMMENT '作者',
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_article_type`
--

CREATE TABLE `ntp_common_article_type` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `name` varchar(200) DEFAULT NULL COMMENT '分类名'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_admin`
--

CREATE TABLE `ntp_common_group_admin` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `admin_name` varchar(200) DEFAULT NULL COMMENT '管理员账号',
  `admin_pwd` varchar(200) DEFAULT NULL COMMENT '密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `role` int(2) DEFAULT '1' COMMENT '角色',
  `remarks` varchar(200) DEFAULT '0' COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台管理员表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_agent`
--

CREATE TABLE `ntp_common_group_agent` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `agent_name` varchar(200) DEFAULT NULL COMMENT '代理账号',
  `agent_pwd` varchar(200) DEFAULT NULL COMMENT '代理密码',
  `agent_type` tinyint(10) DEFAULT '1' COMMENT '代理类型 1 3级代理 2无限级代理',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `money` decimal(20,2) DEFAULT '0.00' COMMENT '可用余额',
  `money_fanyong` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '代理所赚返佣',
  `money_total` decimal(20,2) DEFAULT '0.00' COMMENT '累计赚佣',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 1正常 0冻结',
  `fanyong_proportion` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '代理返佣比例',
  `agent_id_1` int(11) DEFAULT '0' COMMENT '一级代理 0 为公司直接代理',
  `agent_id_2` int(11) DEFAULT NULL COMMENT '二级代理',
  `agent_id_3` int(11) DEFAULT NULL COMMENT '三级代理',
  `agent_id` int(11) NOT NULL DEFAULT '0' COMMENT '暂时废弃了',
  `invitation_code` varchar(200) DEFAULT NULL COMMENT '邀请码',
  `tg_id` varchar(200) DEFAULT NULL COMMENT 'telegram ID',
  `tg_username` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_first_name` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_last_name` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_crowd_ids` varchar(200) DEFAULT NULL COMMENT 'telegram 所属群组'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代理表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_banner`
--

CREATE TABLE `ntp_common_group_banner` (
  `id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属集团',
  `web_url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '跳转网址',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `img_url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='广告表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_config`
--

CREATE TABLE `ntp_common_group_config` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `name` varchar(200) DEFAULT NULL COMMENT '配置中文名称',
  `value` varchar(200) DEFAULT NULL COMMENT '约束条件',
  `remark` text COMMENT '描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台配置表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_notice`
--

CREATE TABLE `ntp_common_group_notice` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `content` varchar(600) DEFAULT NULL COMMENT '公告内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `status` tinyint(1) DEFAULT NULL COMMENT '公告状态 1上架 0下架',
  `position` tinyint(2) DEFAULT NULL COMMENT '公告位置 xxx'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_notify`
--

CREATE TABLE `ntp_common_group_notify` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) NOT NULL COMMENT '所属集团前缀',
  `type` tinyint(1) DEFAULT NULL COMMENT '通知类型 1全体 2私人',
  `status` tinyint(1) DEFAULT NULL COMMENT '通知状态 1上架 0下架',
  `unique` text COMMENT '类型=2时 ，相关人员，以'',''分割',
  `create_time` datetime DEFAULT NULL COMMENT '通知时间',
  `mark` varchar(200) DEFAULT NULL COMMENT '通知内容'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_group_pay_accounts`
--

CREATE TABLE `ntp_common_group_pay_accounts` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `method_code` varchar(50) NOT NULL COMMENT '充值方式代码',
  `account_name` varchar(200) NOT NULL COMMENT '账户名称/收款人姓名',
  `account_number` varchar(200) DEFAULT NULL COMMENT '账户号码/银行卡号',
  `bank_name` varchar(200) DEFAULT NULL COMMENT '银行名称',
  `phone_number` varchar(50) DEFAULT NULL COMMENT '手机号码',
  `wallet_address` varchar(500) DEFAULT NULL COMMENT '钱包地址',
  `network_type` varchar(100) DEFAULT NULL COMMENT '网络类型(如TRC20)',
  `qr_code_url` varchar(500) DEFAULT NULL COMMENT '二维码图片URL',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否激活(0:禁用 1:启用)',
  `daily_limit` decimal(15,2) DEFAULT NULL COMMENT '日限额',
  `balance_limit` decimal(15,2) DEFAULT NULL COMMENT '余额限制',
  `usage_count` int(11) NOT NULL DEFAULT '0' COMMENT '使用次数',
  `last_used_at` timestamp NULL DEFAULT NULL COMMENT '最后使用时间',
  `remark` text COMMENT '备注信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公司充值账户信息表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_login_log`
--

CREATE TABLE `ntp_common_login_log` (
  `id` int(10) NOT NULL,
  `unique` int(10) DEFAULT NULL COMMENT '管理员、用户id',
  `login_type` tinyint(1) DEFAULT '1' COMMENT '类型 1后台管理员 2用户 3代理',
  `login_time` datetime DEFAULT NULL COMMENT '登陆时间',
  `login_ip` varchar(20) DEFAULT NULL COMMENT '登陆IP',
  `login_equipment` text COMMENT '登陆设备'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='登陆日志';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_market_level`
--

CREATE TABLE `ntp_common_market_level` (
  `id` int(11) NOT NULL COMMENT 'ID 序号 自增',
  `mkey` int(11) NOT NULL COMMENT 'key',
  `mvalue` varchar(200) NOT NULL COMMENT 'value',
  `morder` int(11) DEFAULT NULL COMMENT '排序'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='市场部等级表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_market_relation`
--

CREATE TABLE `ntp_common_market_relation` (
  `id` int(11) NOT NULL COMMENT 'ID 序号 自增',
  `aid` int(11) NOT NULL COMMENT '市场部ID',
  `a_level` int(11) NOT NULL COMMENT '市场部管理员',
  `pid` int(11) NOT NULL COMMENT '父级ID',
  `p_level` int(11) NOT NULL COMMENT '父级级别',
  `path` text NOT NULL COMMENT '用户来源路径'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='市场部关系表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_agent_withdraw`
--

CREATE TABLE `ntp_common_pay_agent_withdraw` (
  `id` int(10) NOT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '提现时间',
  `success_time` datetime DEFAULT NULL COMMENT '到账时间（审核时间）',
  `money` decimal(30,2) DEFAULT NULL COMMENT '提现金额',
  `money_balance` decimal(30,2) DEFAULT NULL COMMENT '用户余额',
  `money_fee` decimal(30,2) DEFAULT NULL COMMENT '手续费',
  `momey_actual` decimal(30,2) DEFAULT NULL COMMENT '实际到账金额',
  `msg` varchar(200) DEFAULT NULL COMMENT '备注',
  `agent_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_methods`
--

CREATE TABLE `ntp_common_pay_methods` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `method_code` varchar(50) NOT NULL COMMENT '充值方式代码(aba/huiwang/usdt)',
  `method_name` varchar(100) NOT NULL COMMENT '充值方式名称',
  `method_desc` varchar(200) DEFAULT NULL COMMENT '充值方式描述',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用(0:禁用 1:启用)',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序顺序',
  `min_amount` decimal(15,2) DEFAULT '0.00' COMMENT '最小充值金额',
  `max_amount` decimal(15,2) DEFAULT '999999.99' COMMENT '最大充值金额',
  `processing_time` varchar(100) DEFAULT NULL COMMENT '处理时间说明',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付方式配置表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_money_agent_log`
--

CREATE TABLE `ntp_common_pay_money_agent_log` (
  `id` int(10) NOT NULL COMMENT '主键ID',
  `create_time` datetime DEFAULT NULL COMMENT '变动时间',
  `type` tinyint(1) DEFAULT NULL COMMENT '类型 1收入 2支出 3后台修改金额 4返还',
  `status` int(3) DEFAULT NULL COMMENT '详细类型 101收入，201支出 301后台调整 401佣金收入 501用户返利 601下级代理返利',
  `money_before` decimal(30,2) DEFAULT '0.00' COMMENT '变化前金额',
  `money_end` decimal(30,2) DEFAULT '0.00' COMMENT '变化后金额',
  `money` decimal(30,2) DEFAULT NULL COMMENT '变化金额',
  `agent_id` int(10) DEFAULT NULL COMMENT '代理ID',
  `source_id` int(10) DEFAULT NULL COMMENT '源头ID（用户ID或其他代理ID）',
  `admin_uid` int(10) DEFAULT '0' COMMENT '操作管理员ID',
  `mark` varchar(200) DEFAULT NULL COMMENT '备注',
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代理资金流水表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_money_log`
--

CREATE TABLE `ntp_common_pay_money_log` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `type` tinyint(1) DEFAULT NULL COMMENT '类型 1收入 2支出 3后台修改金额 4提现退款',
  `status` int(3) DEFAULT NULL COMMENT '详细类型 101充值，201提现  301 积分  401套餐分销奖励 403充值分销奖励 501游戏 601代理返利',
  `money_before` decimal(30,2) DEFAULT '0.00' COMMENT '变化前金额',
  `money_end` decimal(30,2) DEFAULT '0.00' COMMENT '变化后金额',
  `money` decimal(30,2) DEFAULT NULL COMMENT '变化金额',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `source_id` int(10) DEFAULT NULL COMMENT '源头ID',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `mark` varchar(200) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资金流水表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_recharge`
--

CREATE TABLE `ntp_common_pay_recharge` (
  `id` int(10) NOT NULL COMMENT '主键ID',
  `group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属集团前缀',
  `cert_image` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传图片认证',
  `create_time` datetime DEFAULT NULL COMMENT '充值时间',
  `success_time` datetime DEFAULT NULL COMMENT '到账时间(审核时间)',
  `money` decimal(30,2) DEFAULT NULL COMMENT '充值金额',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态：0=待审核，1=已通过，2=已拒绝, 3=取消',
  `user_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `pay_account_id` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收款账号ID',
  `payment_method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付方式 huiwang/usdt/bank',
  `order_number` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '系统订单号',
  `user_ip` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户IP',
  `transaction_id` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户提交的交易单号',
  `verify_method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '验证方式 order_number/image/both	',
  `u_bank_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '打款银行名',
  `u_bank_user_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '打款用户名',
  `u_bank_card` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '打款银行卡号',
  `remark` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注信息',
  `tg_notification_sent` tinyint(1) DEFAULT '0' COMMENT '是否已发送群组通知：0=未发送 1=已发送',
  `tg_notification_time` datetime DEFAULT NULL COMMENT '群组通知发送时间',
  `tg_groups_sent_count` int(11) DEFAULT '0' COMMENT '发送到的群组数量',
  `tg_groups_success_count` int(11) DEFAULT '0' COMMENT '群组发送成功数量',
  `tg_sent_group_ids` json DEFAULT NULL COMMENT '已发送的群组ID列表(JSON数组)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='充值记录表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_pay_withdraw`
--

CREATE TABLE `ntp_common_pay_withdraw` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `create_time` datetime DEFAULT NULL COMMENT '提现时间',
  `success_time` datetime DEFAULT NULL COMMENT '到账时间（审核时间）',
  `money` decimal(30,2) DEFAULT NULL COMMENT '提现金额',
  `money_balance` decimal(30,2) DEFAULT NULL COMMENT '用户余额',
  `money_fee` decimal(30,2) DEFAULT NULL COMMENT '手续费',
  `momey_actual` decimal(30,2) DEFAULT NULL COMMENT '实际到账金额',
  `msg` varchar(200) DEFAULT NULL COMMENT '备注',
  `u_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `u_ip` varchar(200) DEFAULT NULL COMMENT '用户IP',
  `u_city` varchar(200) DEFAULT NULL COMMENT '用户地区',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态',
  `pay_type` varchar(200) DEFAULT NULL COMMENT '支付方式',
  `u_bank_name` varchar(200) DEFAULT NULL COMMENT '用户收款银行名',
  `u_back_card` varchar(200) DEFAULT NULL COMMENT '用户收款账号',
  `u_back_user_name` varchar(200) DEFAULT NULL COMMENT '用户收款名',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `order_number` varchar(200) DEFAULT NULL COMMENT '系统提现订单号',
  `withdraw_address` varchar(200) DEFAULT NULL COMMENT 'USDT提现地址',
  `withdraw_network` varchar(200) DEFAULT 'TRC20' COMMENT '网络类型',
  `verification_code` varchar(200) DEFAULT NULL COMMENT '验证码',
  `transaction_hash` varchar(200) DEFAULT NULL COMMENT '链上交易哈希',
  `tg_notification_sent` tinyint(1) DEFAULT '0' COMMENT '是否已发送群组通知：0=未发送 1=已发送',
  `tg_notification_time` datetime DEFAULT NULL COMMENT '群组通知发送时间',
  `tg_groups_sent_count` int(11) DEFAULT '0' COMMENT '发送到的群组数量',
  `tg_groups_success_count` int(11) DEFAULT '0' COMMENT '群组发送成功数量',
  `tg_sent_group_ids` json DEFAULT NULL COMMENT '已发送的群组ID列表(JSON数组)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_sys_config`
--

CREATE TABLE `ntp_common_sys_config` (
  `id` int(10) NOT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '配置中文名称',
  `value` varchar(200) DEFAULT NULL COMMENT '约束条件',
  `remark` text COMMENT '描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台配置表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_user`
--

CREATE TABLE `ntp_common_user` (
  `id` int(10) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `name` varchar(200) DEFAULT NULL COMMENT '账号',
  `phone` varchar(200) DEFAULT NULL COMMENT '手机号',
  `invitation_code` varchar(200) DEFAULT NULL COMMENT '邀请码',
  `pwd` varchar(200) DEFAULT 'MTIzNDU2' COMMENT '密码',
  `withdraw_pwd` varchar(200) NOT NULL DEFAULT 'aa123456' COMMENT '提现密码',
  `nick_name` varchar(200) DEFAULT NULL COMMENT '昵称',
  `vip_grade` int(10) DEFAULT '0' COMMENT '会员等级',
  `status` tinyint(1) DEFAULT '1' COMMENT '账号状态 1正常 0冻结',
  `state` tinyint(1) DEFAULT '0' COMMENT '是否在线 1在线 0下线',
  `fanshui_proportion` decimal(20,3) NOT NULL DEFAULT '0.000' COMMENT '会员默认返水比例 ',
  `fanyong_proportion` decimal(20,3) NOT NULL DEFAULT '0.000' COMMENT '会员默认返佣比例 ',
  `money` decimal(20,2) DEFAULT '0.00' COMMENT '可用余额',
  `money_rebate` decimal(20,3) DEFAULT '0.000' COMMENT '返水金额 相当于自己的洗码金额',
  `money_fanyong` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '用户返佣 如果这个人推荐了其他人 其他人消费的消费的返点 的累加',
  `money_total_recharge` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '累积充值',
  `money_total_withdraw` decimal(20,2) DEFAULT '0.00' COMMENT '累计提现',
  `is_real_name` tinyint(1) DEFAULT '1' COMMENT '是否实名 1已实名 0未实名',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `is_fictitious` tinyint(1) DEFAULT '0' COMMENT '是否虚拟账号 1是 0否',
  `is_trial_account` int(11) NOT NULL DEFAULT '0' COMMENT '是否试玩账号 1 是 0不是',
  `agent_id` int(10) NOT NULL DEFAULT '0' COMMENT '所属代理',
  `user_agent_id_1` int(11) DEFAULT NULL COMMENT '全民代理 一级',
  `user_agent_id_2` int(11) DEFAULT NULL COMMENT '全民代理 二级',
  `user_agent_id_3` int(11) DEFAULT NULL COMMENT '全民代理 三级',
  `currency` varchar(200) NOT NULL DEFAULT 'CNY' COMMENT '支持货币类型',
  `language_code` varchar(200) NOT NULL DEFAULT 'zh' COMMENT '用户选择的语言',
  `love_game_ids` varchar(600) DEFAULT NULL COMMENT '收藏的游戏IDs',
  `recent_game_ids` varchar(200) DEFAULT NULL COMMENT '最近的游戏',
  `remarks` text COMMENT '用户备注',
  `tg_id` varchar(200) DEFAULT NULL COMMENT 'telegram ID',
  `tg_username` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_first_name` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_last_name` varchar(200) DEFAULT NULL COMMENT 'telegram 用户名',
  `tg_crowd_ids` varchar(200) DEFAULT NULL COMMENT 'telegram 所属群组',
  `last_activity_at` datetime DEFAULT NULL COMMENT '最后活动时间',
  `withdraw_password_set` int(11) NOT NULL DEFAULT '1' COMMENT '是否设置提现密码 1是 0否',
  `auto_created` int(11) NOT NULL DEFAULT '0' COMMENT '是否自动创建 1是 0否',
  `telegram_bind_time` datetime DEFAULT NULL COMMENT 'Telegram绑定时间',
  `last_online_notify_time` datetime DEFAULT NULL COMMENT '最后上线通知时间',
  `game_rtp` int(11) NOT NULL DEFAULT '50' COMMENT '用户部分游戏胜利控制 30-99 之间是合规数字'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_user_accounts`
--

CREATE TABLE `ntp_common_user_accounts` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `account_type` enum('bank','huiwang','usdt') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账户类型：bank-银行，huiwang-汇旺，usdt-USDT钱包',
  `account_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账户姓名',
  `account_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '银行卡号/汇旺账号',
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号码',
  `bank_branch` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开户行',
  `id_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号码',
  `wallet_address` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'USDT钱包地址',
  `network_type` enum('TRC20','ERC20') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '网络类型：TRC20-波场，ERC20-以太坊',
  `remark_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注名称',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认账户：0-否，1-是',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户提现账户表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_user_real_name`
--

CREATE TABLE `ntp_common_user_real_name` (
  `id` int(10) NOT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '真实姓名',
  `card_id` varchar(200) DEFAULT NULL COMMENT '用户身份证号',
  `positive_url` varchar(255) DEFAULT NULL COMMENT '用户身份证正面图',
  `back_url` varchar(255) DEFAULT NULL COMMENT '用户身份证反面图',
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `u_id` int(10) DEFAULT NULL COMMENT '用户ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='身份证号';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_common_user_token`
--

CREATE TABLE `ntp_common_user_token` (
  `id` int(11) NOT NULL COMMENT 'ID 序号自增',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `token` varchar(200) DEFAULT NULL COMMENT 'token值',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建及更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户token表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_agent_money_fy_log`
--

CREATE TABLE `ntp_game_agent_money_fy_log` (
  `id` int(10) NOT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `money_before` decimal(30,2) DEFAULT '0.00' COMMENT '变化前金额',
  `money_end` decimal(30,2) DEFAULT '0.00' COMMENT '变化后金额',
  `money` decimal(30,2) DEFAULT NULL COMMENT '变化金额',
  `agent_id` int(10) DEFAULT NULL COMMENT '代理ID',
  `source_id` int(10) DEFAULT NULL COMMENT '源头ID',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `remark` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代理返佣资金表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_rebate_distribution`
--

CREATE TABLE `ntp_game_rebate_distribution` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `game_log_id` bigint(20) NOT NULL COMMENT '关联ntp_game_user_money_logs的ID',
  `bet_user_id` int(11) NOT NULL COMMENT '下注用户ID',
  `bet_amount` decimal(16,2) NOT NULL COMMENT '下注金额',
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `user_rebate_amount` decimal(16,2) DEFAULT '0.00' COMMENT '用户返水金额',
  `user_rebate_proportion` decimal(8,4) DEFAULT '0.0000' COMMENT '用户返水比例',
  `user_agent_total_amount` decimal(16,2) DEFAULT '0.00' COMMENT '会员代理返佣总金额',
  `user_agent_levels_count` int(11) DEFAULT '0' COMMENT '会员代理层级数量',
  `abnormal_levels_count` int(11) DEFAULT '0' COMMENT '异常层级数量',
  `total_abnormal_amount` decimal(16,2) DEFAULT '0.00' COMMENT '因异常而未分配的金额',
  `company_agent_id` int(11) DEFAULT '0' COMMENT '公司代理ID',
  `company_agent_amount` decimal(16,2) DEFAULT '0.00' COMMENT '公司代理返佣金额',
  `company_agent_proportion` decimal(8,4) DEFAULT '0.0000' COMMENT '公司代理返佣比例',
  `status` tinyint(1) DEFAULT '0' COMMENT '处理状态：0=待处理，1=已处理，2=处理失败',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  `error_message` text COMMENT '错误信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏记录返佣分配表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_user_money_apis`
--

CREATE TABLE `ntp_game_user_money_apis` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `api_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接口名称',
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台账号',
  `password` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台密码',
  `api_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '接口Token',
  `game_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '游戏token',
  `money` decimal(16,2) UNSIGNED NOT NULL DEFAULT '0.00' COMMENT '平台余额',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT '上次登录时间',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '描述',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_user_money_fs_log`
--

CREATE TABLE `ntp_game_user_money_fs_log` (
  `id` int(10) NOT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `money_before` decimal(30,2) DEFAULT '0.00' COMMENT '变化前金额',
  `money_end` decimal(30,2) DEFAULT '0.00' COMMENT '变化后金额',
  `money` decimal(30,2) DEFAULT NULL COMMENT '变化金额',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `source_id` int(10) DEFAULT NULL COMMENT '源头ID',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `remark` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户返水资金表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_user_money_fy_log`
--

CREATE TABLE `ntp_game_user_money_fy_log` (
  `id` int(10) NOT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `money_before` decimal(30,2) DEFAULT '0.00' COMMENT '变化前金额',
  `money_end` decimal(30,2) DEFAULT '0.00' COMMENT '变化后金额',
  `money` decimal(30,2) DEFAULT NULL COMMENT '变化金额',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `source_id` int(10) DEFAULT NULL COMMENT '源头ID',
  `market_uid` int(10) DEFAULT '0' COMMENT '业务员ID',
  `remark` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户返佣资金表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_game_user_money_logs`
--

CREATE TABLE `ntp_game_user_money_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` int(10) UNSIGNED NOT NULL COMMENT '会员ID',
  `money` decimal(16,2) UNSIGNED NOT NULL DEFAULT '0.00' COMMENT '操作金额',
  `money_before` decimal(16,2) UNSIGNED NOT NULL DEFAULT '0.00' COMMENT '操作前金额',
  `money_after` decimal(16,2) UNSIGNED NOT NULL DEFAULT '0.00' COMMENT '操作后金额',
  `money_type` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'money' COMMENT '金额类型',
  `number_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '数量类型，1加，-1减',
  `operate_type` tinyint(3) UNSIGNED NOT NULL COMMENT '金额变动类型',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员ID 有可能管理员自己补单',
  `model_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '关联模型',
  `model_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '模型ID',
  `game_code` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏厂商',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作描述',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '操作备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `fanyong_flag` int(11) DEFAULT '0' COMMENT '是否已经返水返佣 0 没有 1 完成了',
  `fanyong_remark` text COLLATE utf8mb4_unicode_ci COMMENT '返水返佣详细日志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户游戏资金记录表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_group_menu`
--

CREATE TABLE `ntp_group_menu` (
  `id` int(10) NOT NULL,
  `pid` int(10) DEFAULT '0' COMMENT '上级菜单,0为顶级菜单',
  `title` varchar(200) DEFAULT NULL COMMENT '菜单名',
  `status` tinyint(1) DEFAULT '1' COMMENT '菜单状态 1正常 0下架',
  `admin_uid` int(10) DEFAULT NULL COMMENT '管理员ID，编辑者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `path` varchar(200) DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(200) DEFAULT NULL COMMENT '图标地址',
  `sort` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公司菜单';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_group_set`
--

CREATE TABLE `ntp_group_set` (
  `id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属集团前缀',
  `group_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '集团名称',
  `site_name` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '前端显示名字',
  `site_wap_logo` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'logo地址',
  `site_description` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '集团描述',
  `customer_service_url` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客服地址',
  `web_url` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '前端地址',
  `admin_url` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '后端地址',
  `agent_url` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代理地址',
  `lobby_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '大厅地址',
  `promotion_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推广地址',
  `money` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态',
  `remarkt` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `ip_white` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP白名单',
  `ip_black` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_show_ids` text COLLATE utf8mb4_unicode_ci COMMENT '展示的供应商',
  `supplier_run_ids` text COLLATE utf8mb4_unicode_ci COMMENT '运行的供应商',
  `game_show_ids` text COLLATE utf8mb4_unicode_ci COMMENT '展示的游戏',
  `game_run_ids` text COLLATE utf8mb4_unicode_ci COMMENT '运行的游戏',
  `hot_show_ids` text COLLATE utf8mb4_unicode_ci COMMENT '热门展示ids',
  `hot_run_ids` text COLLATE utf8mb4_unicode_ci COMMENT '热门运行ids',
  `default_user_fanshui` decimal(20,3) NOT NULL DEFAULT '0.020' COMMENT '新注册用户默认返水',
  `default_user_fanyong` decimal(20,3) NOT NULL DEFAULT '0.050' COMMENT '新注册代理直属用户默认返佣',
  `default_agent_fanyong` decimal(20,3) NOT NULL DEFAULT '0.050' COMMENT '公司直属代理 默认 返佣比例',
  `main_style` int(11) NOT NULL DEFAULT '1' COMMENT '主页格式',
  `invitation_code_require` int(11) NOT NULL DEFAULT '0' COMMENT '是否必须输入邀请码 0 不需要 1 需要',
  `goldengatex_is_open` int(11) NOT NULL DEFAULT '0' COMMENT '金门科技 是否开启 默认不开启',
  `goldengatex_authorization` text COLLATE utf8mb4_unicode_ci COMMENT '金门科技的 认证码 ',
  `goldengatex_expiration_date` datetime DEFAULT NULL COMMENT '金门科技的 认证过期时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分公司管理';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_advertisements`
--

CREATE TABLE `ntp_tg_advertisements` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `title` varchar(200) NOT NULL COMMENT '广告标题',
  `content` text NOT NULL COMMENT '广告内容',
  `image_url` varchar(500) DEFAULT NULL COMMENT '图片地址',
  `send_mode` tinyint(1) NOT NULL DEFAULT '1' COMMENT '发送模式 1=一次性定时 2=每日定时 3=循环间隔',
  `send_time` datetime DEFAULT NULL COMMENT '指定发送时间（模式1使用）',
  `daily_times` varchar(200) DEFAULT NULL COMMENT '每日发送时间点，逗号分隔，如"01:00,02:00,03:00,08:00,23:00"（模式2使用）',
  `interval_minutes` int(11) DEFAULT NULL COMMENT '发送间隔分钟数（模式3使用）',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 0=禁用 1=启用 2=已完成',
  `is_sent` tinyint(1) DEFAULT '0' COMMENT '是否已发送过（模式1专用，防止重复发送）',
  `last_sent_time` datetime DEFAULT NULL COMMENT '最后发送时间',
  `next_send_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '下次发送时间（系统计算）',
  `total_sent_count` int(11) DEFAULT '0' COMMENT '总发送次数',
  `success_count` int(11) DEFAULT '0' COMMENT '成功发送次数',
  `failed_count` int(11) DEFAULT '0' COMMENT '失败发送次数',
  `start_date` date DEFAULT NULL COMMENT '开始生效日期',
  `end_date` date DEFAULT NULL COMMENT '结束生效日期',
  `created_by` int(10) DEFAULT NULL COMMENT '创建人ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_crowd` int(11) NOT NULL DEFAULT '1' COMMENT '是否群发',
  `is_all_member` int(11) NOT NULL DEFAULT '1' COMMENT '是否全体私发',
  `last_member_sent_time` datetime DEFAULT NULL COMMENT '最后私发时间',
  `next_member_send_time` datetime DEFAULT NULL COMMENT '下次私发时间（系统计算）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Telegram广告表（支持多种发送模式）';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_bot_config`
--

CREATE TABLE `ntp_tg_bot_config` (
  `id` int(11) NOT NULL COMMENT '序号 ID 自增',
  `group_prefix` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属集团前缀',
  `welcome` text COLLATE utf8mb4_unicode_ci,
  `button1_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '?开始在线游戏?',
  `button2_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '✅官方游戏入群✅',
  `button3_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '✅官方频道',
  `button4_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '✅选项卡1',
  `button5_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '✅选项卡2',
  `button6_name` varchar(600) COLLATE utf8mb4_unicode_ci DEFAULT '✅选项卡3',
  `button1_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button2_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button3_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button4_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button5_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button6_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tg_bot_id` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人ID',
  `tg_bot_token` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人token',
  `tg_bot_username` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人账号',
  `tg_bot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人名字',
  `tg_webhook_url` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://tgapi.oyim.top/webhook/telegram' COMMENT 'webhook地址',
  `tg_webhook_secret` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '7f8e9d0c1b2a34567890abcdef123456' COMMENT 'webhook密钥',
  `customer_service_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客服链接',
  `finance_service_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '财务链接',
  `agent_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属代理',
  `recharge_success_notify_img_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'https://xghb98.top/static/recharge_success.gif' COMMENT '充值动态图',
  `withdraw_success_notify_img_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'https://xghb98.top/static/withdraw_success.gif' COMMENT '提现动态图',
  `redpacket_finished_notify_img_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'https://xghb98.top/static/redpacket_header.png' COMMENT '红包动态图',
  `default_values_img_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'https://xghb98.top/static/default.png' COMMENT '默认动态图',
  `is_send_menu` int(11) NOT NULL DEFAULT '1' COMMENT '机器人是否定期发送联系方式到对应的群跟频道里面 1 发送 0 不发送',
  `send_menu_cycle_time_seconds` int(11) NOT NULL DEFAULT '14400' COMMENT '定时发送间隔 秒数 ',
  `last_send_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '联系我们信息最后的发送时间',
  `total_sent_count` int(11) NOT NULL DEFAULT '0' COMMENT '总发送次数',
  `success_count` int(11) NOT NULL DEFAULT '0' COMMENT '成功发送次数',
  `failed_count` int(11) NOT NULL DEFAULT '0' COMMENT '失败发送次数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='欢迎界面';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_crowd_list`
--

CREATE TABLE `ntp_tg_crowd_list` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `title` varchar(100) NOT NULL COMMENT '群名',
  `crowd_id` varchar(50) NOT NULL COMMENT '群ID',
  `first_name` varchar(100) NOT NULL COMMENT '机器人名称',
  `botname` varchar(100) DEFAULT NULL COMMENT '机器人用户名',
  `chat_type` varchar(200) DEFAULT 'group' COMMENT '聊天类型：private/group/supergroup/channel',
  `user_id` varchar(50) DEFAULT NULL COMMENT '拉机器人进群的用户ID',
  `username` varchar(255) DEFAULT NULL COMMENT '拉机器人进群的用户名称',
  `member_count` int(11) DEFAULT '0' COMMENT '群成员数量',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否活跃 1是 0否',
  `broadcast_enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用广播 1是 0否',
  `bot_status` varchar(20) DEFAULT 'member' COMMENT '机器人状态 member/administrator/left',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `del` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 0正常 1删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Telegram群组表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_messages`
--

CREATE TABLE `ntp_tg_messages` (
  `id` int(11) NOT NULL,
  `message_id` varchar(50) NOT NULL COMMENT 'Telegram消息ID',
  `chat_id` varchar(50) NOT NULL COMMENT '聊天ID',
  `user_id` int(10) DEFAULT NULL COMMENT '系统用户ID',
  `tg_user_id` varchar(50) DEFAULT NULL COMMENT 'Telegram用户ID',
  `message_type` varchar(20) DEFAULT 'text' COMMENT '消息类型：text/photo/document/sticker等',
  `message_content` text COMMENT '消息内容',
  `reply_to_message_id` varchar(50) DEFAULT NULL COMMENT '回复的消息ID',
  `file_id` varchar(200) DEFAULT NULL COMMENT '文件ID',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件路径',
  `direction` varchar(10) DEFAULT 'in' COMMENT '消息方向 in接收 out发送',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Telegram消息记录表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_message_logs`
--

CREATE TABLE `ntp_tg_message_logs` (
  `id` int(11) NOT NULL,
  `message_type` varchar(20) DEFAULT NULL COMMENT '消息类型：notification/advertisement/system/broadcast',
  `target_type` varchar(20) DEFAULT NULL COMMENT '目标类型：user/group/channel',
  `target_id` varchar(50) DEFAULT NULL COMMENT '目标用户/群组ID',
  `content` text COMMENT '发送内容',
  `send_status` tinyint(1) DEFAULT '0' COMMENT '发送状态 0发送中 1成功 2失败',
  `error_message` varchar(500) DEFAULT NULL COMMENT '错误信息',
  `telegram_message_id` varchar(50) DEFAULT NULL COMMENT 'Telegram返回的消息ID',
  `source_id` int(11) DEFAULT NULL COMMENT '源记录ID（广告ID/通知ID等）',
  `source_type` varchar(50) DEFAULT NULL COMMENT '源类型 recharge/withdraw/redpacket/advertisement',
  `sent_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Telegram消息发送日志表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_red_packets`
--

CREATE TABLE `ntp_tg_red_packets` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `packet_id` varchar(50) NOT NULL COMMENT '红包ID（唯一标识）',
  `title` varchar(200) DEFAULT '恭喜发财，大吉大利' COMMENT '红包标题/祝福语',
  `total_amount` decimal(10,2) NOT NULL COMMENT '红包总金额',
  `total_count` int(11) NOT NULL COMMENT '红包总个数',
  `remain_amount` decimal(10,2) NOT NULL COMMENT '剩余金额',
  `remain_count` int(11) NOT NULL COMMENT '剩余个数',
  `packet_type` tinyint(1) DEFAULT '1' COMMENT '红包类型 1拼手气 2平均分配',
  `sender_id` int(10) NOT NULL COMMENT '发送者用户ID',
  `sender_tg_id` varchar(50) NOT NULL COMMENT '发送者TG_ID',
  `chat_id` varchar(50) NOT NULL COMMENT '群组/聊天ID',
  `chat_type` varchar(20) DEFAULT 'group' COMMENT '聊天类型 group/supergroup/private',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 1正常 2已抢完 3已过期 4已撤回',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统红包 1是 0否',
  `telegram_sent_groups` json DEFAULT NULL COMMENT '已发送的群组列表',
  `telegram_sent_at` datetime DEFAULT NULL COMMENT 'Telegram发送时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `finished_at` datetime DEFAULT NULL COMMENT '完成时间（抢完或过期）',
  `tg_notification_sent` tinyint(1) DEFAULT '0' COMMENT '是否已发送群组通知：0=未发送 1=已发送',
  `tg_notification_time` datetime DEFAULT NULL COMMENT '群组通知发送时间',
  `tg_groups_sent_count` int(11) DEFAULT '0' COMMENT '发送到的群组数量',
  `tg_groups_success_count` int(11) DEFAULT '0' COMMENT '群组发送成功数量',
  `tg_sent_group_ids` json DEFAULT NULL COMMENT '已发送的群组ID列表(JSON数组)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='红包主表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_tg_red_packet_records`
--

CREATE TABLE `ntp_tg_red_packet_records` (
  `id` int(11) NOT NULL,
  `group_prefix` varchar(200) DEFAULT NULL COMMENT '所属集团前缀',
  `packet_id` varchar(50) NOT NULL COMMENT '红包ID',
  `user_id` int(10) NOT NULL COMMENT '领取者用户ID',
  `user_tg_id` varchar(50) NOT NULL COMMENT '领取者TG_ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户名',
  `username` varchar(200) DEFAULT NULL COMMENT '领取者用户名',
  `amount` decimal(10,2) NOT NULL COMMENT '领取金额',
  `is_best` tinyint(1) DEFAULT '0' COMMENT '是否手气最佳 1是 0否',
  `grab_order` int(11) NOT NULL COMMENT '领取顺序（第几个）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='红包领取记录表';

-- --------------------------------------------------------

--
-- 表的结构 `ntp_user_agent_rebate_detail`
--

CREATE TABLE `ntp_user_agent_rebate_detail` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `distribution_id` int(11) NOT NULL COMMENT '关联ntp_game_rebate_distribution的ID',
  `game_log_id` bigint(20) NOT NULL COMMENT '关联ntp_game_user_money_logs的ID',
  `bet_user_id` int(11) NOT NULL COMMENT '下注用户ID',
  `agent_user_id` int(11) NOT NULL COMMENT '获得返佣的会员代理ID',
  `agent_level` int(11) NOT NULL COMMENT '代理层级，1=直属上级',
  `agent_proportion` decimal(8,4) NOT NULL COMMENT '代理设定的返佣比例',
  `lower_level_proportion` decimal(8,4) DEFAULT '0.0000' COMMENT '下级的返佣比例',
  `actual_proportion` decimal(8,4) NOT NULL COMMENT '实际获得的返佣比例(上级%-下级%)',
  `rebate_amount` decimal(16,2) NOT NULL COMMENT '返佣金额',
  `is_abnormal` tinyint(1) DEFAULT '0' COMMENT '是否异常比例：0=正常，1=异常（上级比例<=下级比例）',
  `abnormal_reason` varchar(200) DEFAULT NULL COMMENT '异常原因描述',
  `status` tinyint(1) DEFAULT '0' COMMENT '处理状态：0=待处理，1=已处理，2=处理失败',
  `money_log_id` bigint(20) DEFAULT NULL COMMENT '关联的资金流水ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员代理返佣明细表';

-- --------------------------------------------------------

--
-- 表的结构 `upload_records`
--

CREATE TABLE `upload_records` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `original_name` varchar(255) NOT NULL COMMENT '原始文件名',
  `file_name` varchar(255) NOT NULL COMMENT '保存的文件名',
  `file_path` varchar(500) NOT NULL COMMENT '文件相对路径',
  `file_size` int(11) NOT NULL COMMENT '文件大小（字节）',
  `file_type` varchar(100) NOT NULL COMMENT '文件MIME类型',
  `file_url` varchar(500) NOT NULL COMMENT '完整访问URL',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件上传记录表';

--
-- 转储表的索引
--

--
-- 表的索引 `ntp_admin_login_log`
--
ALTER TABLE `ntp_admin_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin_id` (`admin_id`),
  ADD KEY `idx_admin_name` (`admin_name`),
  ADD KEY `idx_group_prefix` (`group_prefix`),
  ADD KEY `idx_login_time` (`login_time`),
  ADD KEY `idx_login_ip` (`login_ip`),
  ADD KEY `idx_login_status` (`login_status`),
  ADD KEY `idx_admin_group_time` (`admin_id`,`group_prefix`,`login_time`) COMMENT '管理员、集团、时间复合索引';

--
-- 表的索引 `ntp_agent_login_log`
--
ALTER TABLE `ntp_agent_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_agent_name` (`agent_name`),
  ADD KEY `idx_group_prefix` (`group_prefix`),
  ADD KEY `idx_login_time` (`login_time`),
  ADD KEY `idx_login_ip` (`login_ip`),
  ADD KEY `idx_login_status` (`login_status`),
  ADD KEY `idx_agent_group_time` (`agent_id`,`group_prefix`,`login_time`) COMMENT '代理、集团、时间复合索引';

--
-- 表的索引 `ntp_api_code_set`
--
ALTER TABLE `ntp_api_code_set`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_games`
--
ALTER TABLE `ntp_api_games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sort_weight_id` (`sort_weight`,`id`);

--
-- 表的索引 `ntp_api_games_temp`
--
ALTER TABLE `ntp_api_games_temp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sort_weight_id` (`sort_weight`,`id`);

--
-- 表的索引 `ntp_api_game_transactions`
--
ALTER TABLE `ntp_api_game_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_transactions_transaction_id_unique` (`transaction_id`),
  ADD KEY `game_transactions_member_id_index` (`member_id`),
  ADD KEY `game_transactions_trace_id_index` (`trace_id`),
  ADD KEY `game_transactions_game_code_index` (`game_code`),
  ADD KEY `game_transactions_round_id_index` (`round_id`),
  ADD KEY `game_transactions_created_at_index` (`created_at`);

--
-- 表的索引 `ntp_api_game_types`
--
ALTER TABLE `ntp_api_game_types`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_goldengatex_supplier`
--
ALTER TABLE `ntp_api_goldengatex_supplier`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_goldengatex_supplier_games`
--
ALTER TABLE `ntp_api_goldengatex_supplier_games`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_group_games`
--
ALTER TABLE `ntp_api_group_games`
  ADD PRIMARY KEY (`game_id`),
  ADD KEY `idx_show_group_prefix` (`show_group_prefix`(50)),
  ADD KEY `idx_game_show_run` (`game_id`,`show_group_prefix`(50),`run_group_prefix`(50));

--
-- 表的索引 `ntp_api_supplier`
--
ALTER TABLE `ntp_api_supplier`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_v2_supplier`
--
ALTER TABLE `ntp_api_v2_supplier`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_api_v2_supplier_games`
--
ALTER TABLE `ntp_api_v2_supplier_games`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_activity`
--
ALTER TABLE `ntp_common_activity`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_activity_type`
--
ALTER TABLE `ntp_common_activity_type`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin`
--
ALTER TABLE `ntp_common_admin`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_log`
--
ALTER TABLE `ntp_common_admin_log`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_menu`
--
ALTER TABLE `ntp_common_admin_menu`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_power`
--
ALTER TABLE `ntp_common_admin_power`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_role`
--
ALTER TABLE `ntp_common_admin_role`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_role_menu`
--
ALTER TABLE `ntp_common_admin_role_menu`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_admin_role_power`
--
ALTER TABLE `ntp_common_admin_role_power`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_agent_menu`
--
ALTER TABLE `ntp_common_agent_menu`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_article`
--
ALTER TABLE `ntp_common_article`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_article_type`
--
ALTER TABLE `ntp_common_article_type`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_admin`
--
ALTER TABLE `ntp_common_group_admin`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_agent`
--
ALTER TABLE `ntp_common_group_agent`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `agent_name` (`agent_name`,`invitation_code`),
  ADD KEY `idx_group_prefix_status` (`group_prefix`,`status`);

--
-- 表的索引 `ntp_common_group_banner`
--
ALTER TABLE `ntp_common_group_banner`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_config`
--
ALTER TABLE `ntp_common_group_config`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_notice`
--
ALTER TABLE `ntp_common_group_notice`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_notify`
--
ALTER TABLE `ntp_common_group_notify`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_group_pay_accounts`
--
ALTER TABLE `ntp_common_group_pay_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_method_active` (`method_code`,`is_active`),
  ADD KEY `idx_usage_count` (`usage_count`);

--
-- 表的索引 `ntp_common_login_log`
--
ALTER TABLE `ntp_common_login_log`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_market_level`
--
ALTER TABLE `ntp_common_market_level`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_market_relation`
--
ALTER TABLE `ntp_common_market_relation`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_pay_agent_withdraw`
--
ALTER TABLE `ntp_common_pay_agent_withdraw`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_pay_methods`
--
ALTER TABLE `ntp_common_pay_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_method_code` (`method_code`),
  ADD KEY `idx_enabled_sort` (`is_enabled`,`sort_order`);

--
-- 表的索引 `ntp_common_pay_money_agent_log`
--
ALTER TABLE `ntp_common_pay_money_agent_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `idx_type_status` (`type`,`status`),
  ADD KEY `idx_group_prefix` (`group_prefix`);

--
-- 表的索引 `ntp_common_pay_money_log`
--
ALTER TABLE `ntp_common_pay_money_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `create_time` (`create_time`,`type`,`status`,`money_before`,`money_end`,`money`,`uid`,`source_id`,`market_uid`);

--
-- 表的索引 `ntp_common_pay_recharge`
--
ALTER TABLE `ntp_common_pay_recharge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `idx_pay_account_id` (`pay_account_id`);

--
-- 表的索引 `ntp_common_pay_withdraw`
--
ALTER TABLE `ntp_common_pay_withdraw`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_sys_config`
--
ALTER TABLE `ntp_common_sys_config`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_user`
--
ALTER TABLE `ntp_common_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_name` (`name`) USING BTREE COMMENT '唯一名称',
  ADD UNIQUE KEY `invitation_code` (`invitation_code`),
  ADD KEY `idx_user_agent_id_1` (`user_agent_id_1`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_group_prefix_status` (`group_prefix`,`status`),
  ADD KEY `idx_group_status_agent` (`group_prefix`,`status`,`agent_id`) COMMENT '集团、状态、代理复合索引',
  ADD KEY `idx_tg_id` (`tg_id`) COMMENT 'Telegram ID索引';

--
-- 表的索引 `ntp_common_user_accounts`
--
ALTER TABLE `ntp_common_user_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_account_type` (`account_type`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `ntp_common_user_real_name`
--
ALTER TABLE `ntp_common_user_real_name`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_common_user_token`
--
ALTER TABLE `ntp_common_user_token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_token` (`token`) COMMENT 'Token唯一索引',
  ADD KEY `idx_user_id` (`user_id`) COMMENT '用户ID索引',
  ADD KEY `idx_update_time` (`update_time`) COMMENT '更新时间索引，用于过期检查',
  ADD KEY `idx_user_update` (`user_id`,`update_time`) COMMENT '用户ID和更新时间复合索引',
  ADD KEY `idx_expire_cleanup` (`update_time`,`user_id`) COMMENT '过期清理专用索引';

--
-- 表的索引 `ntp_game_agent_money_fy_log`
--
ALTER TABLE `ntp_game_agent_money_fy_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `create_time` (`create_time`,`money_before`,`money_end`,`money`,`agent_id`,`source_id`,`market_uid`);

--
-- 表的索引 `ntp_game_rebate_distribution`
--
ALTER TABLE `ntp_game_rebate_distribution`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_game_log_id` (`game_log_id`),
  ADD KEY `idx_bet_user_id` (`bet_user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_process_time` (`process_time`),
  ADD KEY `idx_group_prefix` (`group_prefix`);

--
-- 表的索引 `ntp_game_user_money_apis`
--
ALTER TABLE `ntp_game_user_money_apis`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_game_user_money_fs_log`
--
ALTER TABLE `ntp_game_user_money_fs_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `create_time` (`create_time`,`money_before`,`money_end`,`money`,`uid`,`source_id`,`market_uid`);

--
-- 表的索引 `ntp_game_user_money_fy_log`
--
ALTER TABLE `ntp_game_user_money_fy_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `create_time` (`create_time`,`money_before`,`money_end`,`money`,`uid`,`source_id`,`market_uid`);

--
-- 表的索引 `ntp_game_user_money_logs`
--
ALTER TABLE `ntp_game_user_money_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_fanyong_flag_number_type` (`fanyong_flag`,`number_type`),
  ADD KEY `idx_member_id_created_at` (`member_id`,`created_at`);

--
-- 表的索引 `ntp_group_menu`
--
ALTER TABLE `ntp_group_menu`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_group_set`
--
ALTER TABLE `ntp_group_set`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_prefix` (`group_prefix`);

--
-- 表的索引 `ntp_tg_advertisements`
--
ALTER TABLE `ntp_tg_advertisements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_send_mode` (`send_mode`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_next_send_time` (`next_send_time`),
  ADD KEY `idx_send_time` (`send_time`),
  ADD KEY `idx_date_range` (`start_date`,`end_date`);

--
-- 表的索引 `ntp_tg_bot_config`
--
ALTER TABLE `ntp_tg_bot_config`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ntp_tg_crowd_list`
--
ALTER TABLE `ntp_tg_crowd_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_crowd_id` (`crowd_id`),
  ADD KEY `idx_del` (`del`),
  ADD KEY `idx_active_broadcast` (`is_active`,`broadcast_enabled`);

--
-- 表的索引 `ntp_tg_messages`
--
ALTER TABLE `ntp_tg_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chat_id` (`chat_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_tg_user_id` (`tg_user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `ntp_tg_message_logs`
--
ALTER TABLE `ntp_tg_message_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_target` (`target_type`,`target_id`),
  ADD KEY `idx_status` (`send_status`),
  ADD KEY `idx_sent_at` (`sent_at`),
  ADD KEY `idx_source` (`source_type`,`source_id`);

--
-- 表的索引 `ntp_tg_red_packets`
--
ALTER TABLE `ntp_tg_red_packets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_packet_id` (`packet_id`),
  ADD KEY `idx_sender_id` (`sender_id`),
  ADD KEY `idx_chat_id` (`chat_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `ntp_tg_red_packet_records`
--
ALTER TABLE `ntp_tg_red_packet_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_packet_user` (`packet_id`,`user_tg_id`),
  ADD KEY `idx_packet_id` (`packet_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `ntp_user_agent_rebate_detail`
--
ALTER TABLE `ntp_user_agent_rebate_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_distribution_id` (`distribution_id`),
  ADD KEY `idx_agent_user_id` (`agent_user_id`),
  ADD KEY `idx_bet_user_id` (`bet_user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_game_log_id` (`game_log_id`),
  ADD KEY `idx_agent_level` (`agent_level`);

--
-- 表的索引 `upload_records`
--
ALTER TABLE `upload_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_upload_time` (`upload_time`),
  ADD KEY `idx_file_type` (`file_type`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `ntp_admin_login_log`
--
ALTER TABLE `ntp_admin_login_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_agent_login_log`
--
ALTER TABLE `ntp_agent_login_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_api_code_set`
--
ALTER TABLE `ntp_api_code_set`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_api_games`
--
ALTER TABLE `ntp_api_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_games_temp`
--
ALTER TABLE `ntp_api_games_temp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_game_transactions`
--
ALTER TABLE `ntp_api_game_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_api_game_types`
--
ALTER TABLE `ntp_api_game_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_api_goldengatex_supplier`
--
ALTER TABLE `ntp_api_goldengatex_supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_goldengatex_supplier_games`
--
ALTER TABLE `ntp_api_goldengatex_supplier_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_group_games`
--
ALTER TABLE `ntp_api_group_games`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_api_supplier`
--
ALTER TABLE `ntp_api_supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_v2_supplier`
--
ALTER TABLE `ntp_api_v2_supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_api_v2_supplier_games`
--
ALTER TABLE `ntp_api_v2_supplier_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 自增 序号';

--
-- 使用表AUTO_INCREMENT `ntp_common_activity`
--
ALTER TABLE `ntp_common_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_activity_type`
--
ALTER TABLE `ntp_common_activity_type`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin`
--
ALTER TABLE `ntp_common_admin`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_log`
--
ALTER TABLE `ntp_common_admin_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_menu`
--
ALTER TABLE `ntp_common_admin_menu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_power`
--
ALTER TABLE `ntp_common_admin_power`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_role`
--
ALTER TABLE `ntp_common_admin_role`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_role_menu`
--
ALTER TABLE `ntp_common_admin_role_menu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_admin_role_power`
--
ALTER TABLE `ntp_common_admin_role_power`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_agent_menu`
--
ALTER TABLE `ntp_common_agent_menu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_article`
--
ALTER TABLE `ntp_common_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_article_type`
--
ALTER TABLE `ntp_common_article_type`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_admin`
--
ALTER TABLE `ntp_common_group_admin`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_agent`
--
ALTER TABLE `ntp_common_group_agent`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_banner`
--
ALTER TABLE `ntp_common_group_banner`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_common_group_config`
--
ALTER TABLE `ntp_common_group_config`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_notice`
--
ALTER TABLE `ntp_common_group_notice`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_notify`
--
ALTER TABLE `ntp_common_group_notify`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_group_pay_accounts`
--
ALTER TABLE `ntp_common_group_pay_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_common_login_log`
--
ALTER TABLE `ntp_common_login_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_market_level`
--
ALTER TABLE `ntp_common_market_level`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 序号 自增';

--
-- 使用表AUTO_INCREMENT `ntp_common_market_relation`
--
ALTER TABLE `ntp_common_market_relation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 序号 自增';

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_agent_withdraw`
--
ALTER TABLE `ntp_common_pay_agent_withdraw`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_methods`
--
ALTER TABLE `ntp_common_pay_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_money_agent_log`
--
ALTER TABLE `ntp_common_pay_money_agent_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_money_log`
--
ALTER TABLE `ntp_common_pay_money_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_recharge`
--
ALTER TABLE `ntp_common_pay_recharge`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_common_pay_withdraw`
--
ALTER TABLE `ntp_common_pay_withdraw`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_sys_config`
--
ALTER TABLE `ntp_common_sys_config`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_user`
--
ALTER TABLE `ntp_common_user`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_user_accounts`
--
ALTER TABLE `ntp_common_user_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_common_user_real_name`
--
ALTER TABLE `ntp_common_user_real_name`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_common_user_token`
--
ALTER TABLE `ntp_common_user_token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 序号自增';

--
-- 使用表AUTO_INCREMENT `ntp_game_agent_money_fy_log`
--
ALTER TABLE `ntp_game_agent_money_fy_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_game_rebate_distribution`
--
ALTER TABLE `ntp_game_rebate_distribution`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `ntp_game_user_money_apis`
--
ALTER TABLE `ntp_game_user_money_apis`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_game_user_money_fs_log`
--
ALTER TABLE `ntp_game_user_money_fs_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_game_user_money_fy_log`
--
ALTER TABLE `ntp_game_user_money_fy_log`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_game_user_money_logs`
--
ALTER TABLE `ntp_game_user_money_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_group_menu`
--
ALTER TABLE `ntp_group_menu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_group_set`
--
ALTER TABLE `ntp_group_set`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_tg_advertisements`
--
ALTER TABLE `ntp_tg_advertisements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_tg_bot_config`
--
ALTER TABLE `ntp_tg_bot_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号 ID 自增';

--
-- 使用表AUTO_INCREMENT `ntp_tg_crowd_list`
--
ALTER TABLE `ntp_tg_crowd_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_tg_messages`
--
ALTER TABLE `ntp_tg_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_tg_message_logs`
--
ALTER TABLE `ntp_tg_message_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_tg_red_packets`
--
ALTER TABLE `ntp_tg_red_packets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_tg_red_packet_records`
--
ALTER TABLE `ntp_tg_red_packet_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `ntp_user_agent_rebate_detail`
--
ALTER TABLE `ntp_user_agent_rebate_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `upload_records`
--
ALTER TABLE `upload_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 限制导出的表
--

--
-- 限制表 `ntp_common_group_pay_accounts`
--
ALTER TABLE `ntp_common_group_pay_accounts`
  ADD CONSTRAINT `fk_ntp_dianji_deposit_accounts_method` FOREIGN KEY (`method_code`) REFERENCES `ntp_common_pay_methods` (`method_code`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
