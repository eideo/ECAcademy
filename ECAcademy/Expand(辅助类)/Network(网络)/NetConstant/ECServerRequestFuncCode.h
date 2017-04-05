//
//  ECServerRequestFuncCode.h
//  ECDoctor
//
//  Created by linsen on 15/8/19.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#ifndef ECDoctor_ECServerRequestFuncCode_h
#define ECDoctor_ECServerRequestFuncCode_h

static const NSString*  FUNC_ID_SYSTEM_UPGRADE			    = @"4";  //检测更新
static const NSString*  FUNC_ID_SYSTEM_SHOW_REFUSE			= @"12";  //检测更新
// 与诊所服务器通信
static const NSString*  KOALA_FUNC_ID_CLINIC_IP_PORT        = @"112";       // 获取诊所内ip和port
static const NSString*  KOALA_FUNC_ID_CLINIC_WEB            = @"113";       // 测试web服务器是否连通
// 用户
static const NSString*  FUNC_ID_USER_REGISTER = @"6102"; // 用户注册
static const NSString*  FUNC_ID_USER_LOGIN = @"102";    // 用户登录
static const NSString *FUNC_ID_CUSTOMER_LOGIN_DEFAULT = @"10021";//默认登录
static const NSString* FUNC_ID_DOC_LOGIN_USERNAME		= @"146";//@"6100";//"@"146";//医生app登录（通过用户名密码）
static const NSString*  FUNC_ID_OTHER_USER_LOGIN = @"134";  // 第三方用户登录
static const NSString*  FUNC_ID_USER_LOGIN_CODE = @"130";  // 请求登录码
static const NSString*  FUNC_ID_QCODE_USER_LOGIN = @"145";  // 扫描注册绑定登录
static const NSString*  FUNC_ID_USER_LOGOUT = @"103";   //退出登录
static const NSString*  FUNC_ID_USER_ALERT_PASSWORD = @"154";   //修改用户名密码 (@"105")
static const NSString*  FUNC_ID_USER_RESET_PASSWORD = @"6137";   //重置密码
static const NSString*  FUNC_ID_USER_GETINFO = @"6118";//@"106";    // 获取用户信息
static const NSString*  FUNC_ID_USER_ALERT_USERINFO = @"6119"; //@"107";   //修改用户信息
static const NSString*  FUNC_ID_USER_RELATIONSHIP_GET = @"109"; // 获取诊所的医生列表
static const NSString*  FUNC_ID_USER_SEARCH = @"111";   // 搜索用户信息
static const NSString*  FUNC_ID_USER_RELATIONSHIP_DEL = @"113"; // 删除用户关系
static const NSString*  FUNC_ID_USER_BINDCALL_GET = @"117"; // 绑定手机或邮箱申请
static const NSString*  FUNC_ID_USER_BINDCALL_SET = @"118"; // 绑定手机或邮箱提交
static const NSString*  FUNC_ID_USER_BIND_DATA = @"122";    // 绑定用户数据
static const NSString*  FUNC_ID_USER_REMOVE_BIND_DATA = @"123";    // 解除绑定用户数据
static const NSString*  FUNC_ID_USER_LOGIN_VISITOR = @"129";    // 注册游客账号

static const NSString*  FUNC_ID_USER_REMOVE_BIND_GET = @"132";  //解绑手机或邮箱申请
static const NSString*  FUNC_ID_USER_REMOVE_BIND_SET = @"133";  //解绑手机或邮箱提交

static const NSString* FUNC_ID_GET_VERIFY_CODE			= @"144";//获取短信验证码mobile|reqfuncid
static const NSString* FUNC_ID_DOC_LOGIN_WECHAT			= @"6101";//@"145";//医生app微信登录
static const NSString* FUNC_ID_DOC_LOGIN_USERID			= @"6103";//@"147";//医生app用户ID登录//静默登录
static const NSString* FUNC_ID_DOC_FORGET_PASSWORD		= @"6109";//忘记密码
static const NSString* FUNC_ID_DOC_LOGIN_VERIFYCODE		= @"148";//手机app短信验证码登录ƒ
static const NSString* FUNC_ID_DOC_LOGIN_QRCODE			= @"149";//医生app扫描二维登录


#endif
