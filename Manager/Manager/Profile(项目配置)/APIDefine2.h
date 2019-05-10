//
//  APIDefine2.h
//  Manager
//
//  Created by vpclub on 2018/12/25.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#ifndef APIDefine2_h
#define APIDefine2_h

#pragma mark - 渠道
// 已绑定渠道列表
#define ListBindChannel    @"cmcc/api/auth/user/cmccUser/listBindChannel"
// 获取地市列表
#define ListShanXiCity  @"cmcc/api/pass/user/cmccUser/listShanXiCity"
// 绑定渠道
#define BindChannel @"cmcc/api/auth/user/cmccUser/bindChannel"
// 解绑渠道
#define UnbindChannel    @"cmcc/api/auth/user/cmccUser/unbindChannel"
// 查询渠道列表
#define ListChannel @"cmcc/api/auth/user/cmccUser/listChannel"
// 获取陕西机构列表
#define ListShanXiOrg @"mall/api/pass/supplier/org/listShanXiOrg"

#pragma mark - 开户
// 获取联档次或政策合约(开户)列表
#define GetGradeList @"cmcc/api/auth/business/business/getGradeListByBusinessCode"
// 分页查询开户手机号
#define OpenAccountPageMobiles @"cmcc/api/auth/shanxi/openAccount/pageMobiles"
// 号码选占
#define OccupyPhoneNum @"cmcc/api/auth/shanxi/openAccount/occupyPhoneNum"
// 下发采集验证工单（跳实名认证APP使用）
#define OpenAccountSendBill @"cmcc/api/auth/shanxi/openAccount/sendBill"
// 校验实名认证状态
#define QueryRealnameBill @"cmcc/api/auth/shanxi/openAccount/queryRealnameBill"
// 黑名单全国一证五号校验
#define ValidateOneCerFiveNumber @"cmcc/api/auth/shanxi/openAccount/validateOneCertificateFiveNumber"
// SIM卡查询号码接口
#define GetSimCardInfo    @"cmcc/api/auth/shanxi/openAccount/getSimCardInfo"
// 生成订单
#define CreateOrder @"cmcc/api/auth/shanxi/openAccount/createOrder"
// 订单预支付(返回支付二维码字符串)
#define PayOrder @"cmcc/api/auth/order/order/payOrder"
// 查询支付状态
#define QueryPay @"cmcc/api/auth/order/order/queryPay"
// 订单中心列表
#define OrderCenter @"cmcc/api/auth/order/order/toOrderCenter"

#pragma mark - 专题
// 获取店铺的已上架的专题列表
#define GetShopPrefectures    @"cmcc/api/pass/user/cmccUserShop/getShopPrefectures"


#endif /* APIDefine2_h */
