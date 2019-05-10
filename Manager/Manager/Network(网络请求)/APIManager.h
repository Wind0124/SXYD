//
//  APIManager.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHTTPService.h"

#define VPAPI [APIManager shareApiManager]

@interface APIManager : NSObject

@property (nonatomic, strong) CCHTTPService * _Nullable httpService;
@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;

+ (APIManager *_Nullable)shareApiManager;

#pragma mark - 系统相关
// 获取最新APP版本
/**
 * 返回值 @block 成功或失败
 */
- (void)getAPPVersionBlock:(ModelResultBlock _Nullable)block;

// 获取最新APP版本
/**
 *
 */
- (void)getSystemParameterList;

#pragma mark - 用户体系
// 手机号 密码登录
/**
 * 参数 @parameters 字段1：deviceId 字段2：deviceModel 字段3：forceLogin 字段4：mobile 字段5：pwd
 * 返回值 @block 成功或失败
 */
- (void)loginWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 手机号 验证码登录
/**
 * 参数 @parameters 字段1：deviceId 字段2：deviceModel 字段3：smsCode 字段4：mobile
 * 返回值 @block 成功或失败
 */
- (void)smsLoginWithDic:(NSDictionary * _Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 获取4A认证 验证码
/**
 * 参数 @parameters 字段1：account 字段：password
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)getCertificateSMSCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 4A 账号认证
/**
 * 参数 @parameters 字段1：account 字段2：mobile 字段3：pwd 字段4：smsCode
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)auth4AWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 4A 授权列表
/**
 * 返回值 @block 数组：AuthDetailModel
 */
- (void)getAuthListWithBlock:(ModelArrayResultBlock _Nullable)block;

// 4A 授权
/**
 * 参数 @parameters 字段1：name 字段2：mobile 字段3：smsCode 字段4：employeeNumber
 * 返回值 @block 成功或失败
 */
- (void)authorizeUserWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 4A 授权信息修改
/**
 * 参数 @parameters 字段1：id 字段2：name
 * 返回值 @block 成功或失败
 */
- (void)authorizeModifyWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 4A解绑v
/**
 * 参数 @parameters 字段1：id
 * 返回值 @block 成功或失败
 */
- (void)authorizeUnbindWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 发送验证码
/**
 * 参数 @parameters 字段1：mobile 字段2：type
 * 验证码type类别：1注册 2重置登录密码 3绑定手机号 4验证码登录 5支付验证码 6添加店员 7授权
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)getSmsCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 重置密码
/**
 * 参数 @parameters 字段1：mobile 字段2：pwd 字段3：smsCode
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)resetPasswordWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 修改密码
/**
 * 参数 @parameters 字段1：oldPwd 字段2：newPwd
 * 返回值 @block 成功或失败
 */
- (void)modifyPasswordWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 查询用户的工号列表
/**
 * 返回值 @block 数组：EmployeeModel
 */
- (NSURLSessionDataTask * _Nullable)getListEmployeeNumber:(ModelArrayResultBlock _Nullable)block;

// 设置工号
/**
 * 参数 @parameters 字段1：employeeNumber 字段2：workbenchCode
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)setEmployeeNumberWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 手势认证
/**
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)handAuth:(BooleanResultBlock _Nullable)block;

// 用户信息
/**
 * 返回值 @block 成功或失败
 */
- (NSURLSessionDataTask * _Nullable)getUserInfo:(BooleanResultBlock _Nullable)block;

// 修改用户头像
/**
 * 参数 @parameters 字段1：str(头像地址)
 * 返回值 @block 成功或失败
 */
- (void)modifyUserAvatarWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 注册千店万员
/**
 * 参数 @parameters 字段1：channelCode 字段2：cityCode 字段3：name 字段4：smsCode
 * 返回值 @block 成功或失败
 */
- (void)registerClerkWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 查询实名认证手机号码
/**
 * 参数 无
 * 返回值 @block 字典 字段1：acceptOrderPhoneNumber（接受工单短信号码） 字段2：crmPhoneNumber（实名认证APP登录手机号码）
 */
- (void)QueryAcceptOrderMobileWithBlock:(DictionaryResultBlock _Nullable)block;

// 保存接受工单短信号码
/**
 * 参数 @parameters 字段1：str（新手机号）
 * 返回值 @block 字典 字段1：acceptOrderPhoneNumber（接受工单短信号码） 字段2：crmPhoneNumber（实名认证APP登录手机号码）
 */
- (void)saveAcceptOrderMobileWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 设置默认渠道
/**
 * 参数 @parameters 字段1：str（渠道id）
 * 返回值 @block 成功或失败
 */
- (void)setDefaultChannelWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

#pragma mark - 首页
// 按广告类型查询列表接口
/**
 * 参数 @parameters 字段1：containsTotalCount 字段2：pageIndex 字段3：pageSize 字段4：query
 * query为字典@{@"type": @""}
 * 返回值 @block 数组：AdvertInfoModel
 */
- (NSURLSessionDataTask * _Nullable)getAdvertInfoWithDic:(NSDictionary *_Nullable)parameters block:(ModelAndArrayResultBlock _Nullable)block;

// 查询公告信息列表
/**
 * 参数 @parameters 字段1：containsTotalCount 字段2：pageIndex 字段3：pageSize 字段4：query
 * query为字典@{@"dictionaryDisplayPositionCode": @""}
 * 返回值 @block 字典：PageModel  包含datas数组：NoticeModel
 */
- (NSURLSessionDataTask * _Nullable)getMessageNoticeWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 首页专题列表
/**
 * 参数 @parameters 字段1：dictionaryOneLevleTypeCode
 * 返回值 @block 数组：ActivityModel
 */
- (NSURLSessionDataTask * _Nullable)getActivityInfoWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block;

// 获取店铺信息
/**
 * 返回值 @block ShopInfoModel
 */
- (void)getShopInfoBlock:(ModelResultBlock _Nullable)block;

// 编辑店铺信息
/**
 * 参数 @parameters     "allowContact","businessAddress","city","coverUrl"","description","district","id","latitude","longitude","name","pictureUrl","province"
 * 返回值 @block 成功或失败
 */
- (void)modifyShopWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 上传图片
/**
 * 参数 @img 图片
 * 返回值 @block 图片地址
 */
- (void)uploadImage:(UIImage *_Nullable)img block:(StringResultBlock _Nullable)block;

// 分享
/**
 * 参数 @type 0 二维码/ 1 海报/ 2 分享微信(对应三个不同接口）
 * 参数 @parameters   字段1：shareType(值为1）
 * 返回值 @block ShareModel
 */
- (void)getShareMessageWithType:(NSInteger)type para:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

#pragma mark - 工作台
// 工作台 本日本月业务量
/**
 * 参数 @parameters 字段1：channelCode 字段2：statisticsType（统计类型(1.小时，2.天, 3.月)）
 * 返回值 @block AllStatisticsModel
 */
- (NSURLSessionDataTask * _Nullable)getTodayOrMonthWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 查询所有业务分类
/**
 * 参数 @parameters 字段1：containsTotalCount 字段2：pageIndex 字段3：pageSize 字段4：query
 * query为字典@{@"type": @"DataDictionaryCode"}
 * 返回值 @block 数组@[AdvertInfoModel]
 */
- (void)getAllAdvertBusinessWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block;

// 用户鉴权验证码
/**
 * 参数 @parameters 字段1：mobile 字段2：graderId（值为579510467530067997)
 * 返回值 @block 成功或失败
 */
- (void)getUserAuthSmsCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 用户鉴权
/**
 * 参数 @parameters 字段1：mobile 字段2：graderId（值为579510467530067997) 字段3：verificationCode
 * 返回值 @block 成功或失败
 */
- (void)UserAuth:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 鉴权用户余额、流量、话费等
/**
 * 参数 @parameters 字段1：mobile
 * 返回值 @block AuthUserInfoModel
 */
- (void)getAuthUserInfo:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

#pragma mark - 我的
// 本月本日酬金、业务量
/**
 * 返回值 @block WeekMonthRewardModel
 */
- (void)getWeekMonthRewardBlcok:(ModelResultBlock _Nullable)block;

@end
