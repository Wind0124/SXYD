//
//  APIDefine.h
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#ifndef APIDefine_h
#define APIDefine_h

#define APIVERSION @"2.1.0"


#define ShowResponseData 0 // 1 显示接口返回数据 0 不显示数据

#define ENVIRONMENT  0 // 0:开发环境  1:测试环境  2:线上环境
#if ENVIRONMENT == 0
#define BASEURL @"http://apidev.central.vpclub.cn/"
#define APPKEY @"vphonorshanxicmcc_portableHall_3"
#define APPSECRET @"9f80459b377dd3356732852571cd3d42"
#define BASEIMAGEURL @"http://imgdev.central.vpclub.cn/"
#elif ENVIRONMENT == 1
#define BASEURL @"http://apitest.central.vpclub.cn/"
#define APPKEY @"vphonorshanxicmcc_portableHall_3"
#define APPSECRET @"9f80459b377dd3356732852571cd3d42"
#define BASEIMAGEURL @"http://imgtest.central.vpclub.cn/"
#elif ENVIRONMENT == 2
#define BASEURL @"https://sn.ac.10086.cn/mall/vpclub/vp/"
#define APPKEY @"vphonorshanxicmcc_portableHall_3"
#define APPSECRET @"9f80459b377dd3356732852571cd3d42"
#define BASEIMAGEURL @"http://sn.ac.10086.cn/mall/vpclub/img/"
#endif

#pragma mark - 系统相关
// 查询app版本
//#define APPVersion @"mall/api/auth/sysmgt/clientVersionCfg/queryClientVersion"
#define APPVersion @"mall/api/pass/sysmgt/clientVersionCfg/queryClientVersion"
// 查询系统参数配置列表
#define SystemParameterList @"mall/api/pass/sysmgt/systemParameterCfg/listApi"

#pragma mark - 用户体系
// 手机号密码登录
#define Login @"cmcc/api/pass/user/cmccUser/login"
// 手机号 验证码登录
#define SmsCodeLogin @"cmcc/api/pass/user/cmccUser/smsCodeLogin"
// 4A认证验证码
#define GetCerSMSCode @"cmcc/api/pass/user/cmccUser/sendAuthCode"
// 4A认证
//#define Auth4A @"cmcc/api/pass/user/cmccUser/cmccAuth"
#define Auth4A @"cmcc/api/auth/user/cmccUser/cmccAuth2"
// 4A授权列表
#define AuthorizeList @"cmcc/api/auth/user/cmccUser/authorizeList"
// 4A授权
#define AuthorizeUser @"cmcc/api/auth/user/cmccUser/authorize"
// 授权信息修改
#define AuthorizeModify  @"cmcc/api/auth/user/cmccUser/authorizeModify"
// 4A解绑
#define AuthorizeUnbind @"cmcc/api/auth/user/cmccUser/authorizeUnbind"
// 发送验证码 1注册 2重置登录密码 3绑定手机号 4验证码登录 5支付验证码 6添加店员
#define SendSmsCode @"mall/api/pass/user/user/sendSmsCode"
// 重置密码
#define ResetLoginPwd   @"mall/api/pass/user/user/resetLoginPwd"
// 修改密码
#define ModifyLoginPwd  @"mall/api/auth/user/user/modifyLoginPwd"
// 查询用户工号列表
#define ListEmployeeNumber @"cmcc/api/auth/user/cmccUser/listEmployeeNumber"
// 设置工号
#define SetEmployeeNumber @"cmcc/api/auth/user/cmccUser/setEmployeeNumber"
// 手势认证
#define HandAuth @"cmcc/api/auth/user/cmccUser/handAuth"
// 用户信息
#define UserInfo    @"cmcc/api/auth/user/cmccUser/userInfo"
// 修改用户头像
#define ModifyUserAvatar    @"cmcc/api/auth/user/cmccUser/modifyAvatar"
// 注册千店万员
#define RegisterClerk   @"cmcc/api/auth/user/cmccUser/registerClerk"
// 查询实名认证手机号码
#define QueryAcceptOrderMobile @"cmcc/api/auth/user/cmccUser/queryAcceptOrderMobile"
// 保存接受工单短信号码
#define SaveAcceptOrderMobile @"cmcc/api/auth/user/cmccUser/saveAcceptOrderMobile"
// 设置默认渠道
#define setDefaultChannel @"cmcc/api/auth/user/cmccUser/setDefaultChannel"

#pragma mark - 首页
// 广告类型查询列表接口
#define AdvertInfo @"mall/api/pass/advert/advertInfo/pageApi"
// 所有业务类型
#define AdverBusiness @"mall/api/pass/advert/advertInfo/pageBusiness"
// 公告信息列表
#define MessageNoticePage @"mall/api/pass/message/messageNotice/page"
// 查询公告信息
#define MessageNoticeQuery  @"mall/api/pass/message/messageNotice/query"
// 首页专题列表Activity
#define ActivityInfo    @"mall/api/pass/activity/activityPrefectureInfo/pageApi"

// 获取店铺信息
#define ShopInfo     @"cmcc/api/auth/user/cmccUser/myShop"
// 编辑店铺信息
#define ModifyShop  @"cmcc/api/auth/user/cmccUser/modifyShop"
// 上传图片
#define UploadImg   @"mall/api/pass/file/image/upload"
// 分享二维码
#define ShareQRCode @"cmcc/api/auth/user/cmccUser/shareQrCode"
// 分享海报
#define SharePoster @"cmcc/api/auth/user/cmccUser/sharePoster"
// 分享微信
#define ShareWeChat @"cmcc/api/auth/user/cmccUser/shareWechat"

#pragma mark - 工作台
// 工作台 本月本日业务量
#define TodayAndMonthBusiness @"cmcc/api/auth/order/salespersonStatistics/getSelfAllStatisticsNumber"
// 用户鉴权验证码
#define AuthSendSmsCode @"cmcc/api/auth/business/adapter/common/sendCheckCode"
// 用户鉴权
#define AuthCheckOut    @"cmcc/api/auth/business/adapter/common/checkout"
// 获取鉴权用户信息余额 流量 话费
#define AuthUserInfo    @"cmcc/api/auth/business/adapter/common/queryUserInfo"

#pragma mark - 我的
// 本月本日酬金、业务办理数量
#define WeekMonthReward @"cmcc/api/auth/order/salespersonStatistics/getWeekMonthReward"

#pragma mark - 参数类型
// 广告类型
#define AdvertBottomMenu @"advertBottomMenu" // 底部菜单
#define HomePageBanner  @"homePageBanner" // 首页Banner
#define HotRecommended  @"hotRecommended"   // 热门推荐
#define DataDictionaryCode  @"dataDictionaryCode" // 业务分类数据字典
#define BusinessQuery   @"businessQuery" // 业务查询
#define BusinessHandl   @"businessHandl" // 业务办理
#define ComboHand   @"comboHand" // 套餐办理
#define FlowPackageHand @"flowPackageHand" // 流量包办理
#define PennyExperience @"pennyExperience"  // 一分钱体验
#define InternationalRoaming    @"internationalRoaming" // 国际漫游
#define ESOP    @"ESOP"     // ESOP
#define MessageDataDictionary   @"messageDataDictionary"    // 消息数据字典
#define WorkbenchBusiness   @"workbenchBusiness"    // 工作台业务
#define HomePageBusisnessAdvert @"homePageBusisnessAdvert"  // 首页移动业务广告
#define Chest   @"chest" // 百宝箱
#define SplashScreenPage    @"splashScreenPage" // 闪屏广告
// 公告类型
#define FineMessage @"findMessage" // 发现
#define HomePageMessage @"homePageMessage" // 首页公告
#define NoticeMessage   @"noticeMessage" // 通知
#define LifeMessage @"lifeMessage" // 生活公告
#define policyMessage   @"policyMessage" // 政策
#define SurveyMessage   @"surveyMessage" // 调查
#define MessageExam @"messageExam" // 考试




#endif /* APIDefine_h */
