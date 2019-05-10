//
//  APIManager2.h
//  Manager
//
//  Created by vpclub on 2018/12/24.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHTTPService.h"

#define VPAPI2 [APIManager2 shareApiManager]

NS_ASSUME_NONNULL_BEGIN

@interface APIManager2 : NSObject

@property (nonatomic, strong) CCHTTPService * _Nullable httpService;
@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;

+ (APIManager2 *_Nullable)shareApiManager;

#pragma mark - 渠道管理
// 已绑定渠道列表
/**
 * 返回值 @block 数组：ChannelModel
 */
- (void)getBindChannelListWithBlock:(ModelArrayResultBlock _Nullable)block;

// 获取陕西地市列表
/**
 * 返回值 @block 数组:ChannelModel
 */
- (void)getShanXiCityWithBlcok:(ModelArrayResultBlock _Nullable)block;

// 根据城市和渠道编码 查询渠道列表
/**
 * 参数 @parameters 字段1：channelCode 字段2：cityCode
 * 返回值 @block 数组:ChannelModel
 */
- (void)getChannelListWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block;

// 绑定渠道
/**
 * 参数 @parameters 字段1：channelCode 字段2：channelId 字段3：cityCode
 * 返回值 @block 成功或失败
 */
- (void)bindChannelWithDic:(NSDictionary *)parameters block:(BooleanResultBlock _Nullable)block;

// 解绑渠道
/**
 * 参数 @parameters 字段1：channelCode 字段2：channelId 字段3：cityCode
 * 返回值 @block 成功或失败
 */
- (void)unbindChannelWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;


// 获取陕西机构列表
/**
 * 参数 @parameters 无
 * 返回值 @block 数组：ChannelModel
 */
- (void)getShanXiOrgWithBlock:(ModelArrayResultBlock _Nullable)block;

#pragma mark - 开户
// 获取联档次或政策合约(开户)列表
/**
 * 参数 @parameters 字段1：businessCode 字段2：supplierId
 * 返回值 @block model:BusinessApiGradeModel
 */
- (void)getGradeListWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 分页查询开户手机号
/**
 * 参数 @parameters 字段1：cityCode 字段2：mobilePrefix 字段3：businessId
 * 返回值 @block 数组：OpenAccountMobileModel
 */
- (void)getOpenAccountMobiles:(NSDictionary *_Nullable)parameters block:(ModelAndArrayResultBlock _Nullable)block;

// 号码选占
/**
 * 参数 @parameters 字段1：mobile 字段2：addressCode
 * 返回值 @block 字符串："randomNo" : "string" 选占随机号
 */
- (void)openAccountOccupyPhoneNum:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block;

// 下发采集验证工单（跳实名认证APP使用）
/**
 * 参数 @parameters 字段1:billId(办理业务的号码) 字段2:channelId(4A渠道id) 字段3:operCode(4A工号) 字段4:telephone(4A工号绑定手机号)
 * 返回值 @block 字典
 */
- (void)openAccountSendBillWithDic:(NSDictionary *_Nullable)parameters block:(DictionaryResultBlock _Nullable)block;

// 查询实名认证信息
/**
 * 参数 @parameters 字段1：transactionId(下发工单时返回的数据)
 * 返回值 @block model:IDInfoModel
 */
- (void)queryRealnameBillWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

// 黑名单全国一证五号校验
/**
 * 参数 @parameters 字段1：idName 字段2：idNum 字段3：addressCode(10个常用 地州编码)
 * 返回值 @block (字符串：msg bool：pass)
 */
- (void)validateOneCerFiveNumberWithDic:(NSDictionary *_Nullable)parameters block:(StringAndBooleanResultBlock _Nullable)block;

// SIM卡查询号码信息
/**state
 * 参数 @parameters 字段1：simCardNo 字段2：addressCode 字段3：mobile(开户手机号)
 * 返回值 @block (字符串：msg bool：pass)
 */
- (void)getSimCardInfoWithDic:(NSDictionary *_Nullable)parameters block:(StringAndBooleanResultBlock _Nullable)block;

// 生成订单
/**
 * 参数 @parameters
 * 必填 字段1：addressCode(城市编码) 字段2：birthday(生日yyyy-MM-dd) 字段3：certExpDate(身份证失效日期) 字段4：certValidDate(身份证生效日期) 字段5：contractId(合约档id) 字段6：custCertAddr(证件地址) 字段7：custName(客户名称) 字段8：gender(性别0代表女，1代表男) 字段9：issuingAuthority(签证机关) 字段10：mobile(开户手机号码) 字段11：nation(民族) 字段12：payMoney(支付金额万分之一元) 字段13：psptId(证件号码) 字段14：randomNo(选占随机号) 字段15：simCardNo(Sim卡号)
 * 可选：字段1：gyType(副卡/子卡版本协议) 字段2：mainCardSn(主卡号码) 字段3：productId(产品编码) 字段4：productName(产品名称) 字段5：xhkOpenFlag(小号卡标识)
 * 返回值 @block 字符串：订单号
 */
- (void)createOrderWithDic:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block;

// 订单支付(返回支付二维码字符串)
/**
 * 参数 @parameters 字段1：orderId(主订单id)
 * 字段2：payCode（支付产品编码（5001 支付宝扫码,5012 微信扫码支付 ,2001 支付宝手机网站,2002 微信H5支付（微信外部）,微信公众号支付3002）
 * 字段3：frontUrl（前端回调地址）
 * 返回值 @block 字符串：data
 */
- (void)payOrderWithDic:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block;

// 查询订单支付状态
/**
 * 参数 @parameters 字段1：orderId
 * 返回值 @block NSNumber payStatus：1待支付2支付成功
 */
- (void)queryPayStatusWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block;

// 号卡订单中心列表
/**
 * 参数 @parameters 字段1：orderStatus（订单状态（waitActivite：待激活 waitPay：待支付 finished：已支付 canceled：已取消）
 字段2：userMobile（手机号码）
 * 返回值 @block 数组：OrderCenterModel
 */
- (void)queryOrderCenterWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block;

// 获取唤起实名认证APP的参数
/**
 * 参数 @parameters 字段1：billId （开户号码） 字段2：businessCode（业务编码）
 * 返回值 @block 数组：SMRZParametersModel
 */
- (void)realnameAuthSignWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block;

#pragma mark - 专题
// 获取店铺的已上架的专题列表
/**
 * 参数 @parameters 字段1：dictionaryOneLevleTypeCode 字段2：supplierId 字段3：supplierName 字段4：userShopId
 * 返回值 @block 数组：
 */
- (void)getShopPrefectureWith:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block;

@end

NS_ASSUME_NONNULL_END
