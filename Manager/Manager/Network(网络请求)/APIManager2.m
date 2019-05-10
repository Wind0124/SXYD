//
//  APIManager2.m
//  Manager
//
//  Created by vpclub on 2018/12/24.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "APIManager2.h"

@implementation APIManager2

static APIManager2 *instance = nil;
+ (APIManager2 * _Nullable)shareApiManager {
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpService = [[CCHTTPService alloc] init];
    }
    return self;
}

- (AFNetworkReachabilityStatus)netStatus {
    _netStatus = _httpService.netStatus;
    return _netStatus;
}

#pragma mark - 渠道管理
// 已绑定渠道列表
/**
 * 返回值 @block 数组：ChannelModel
 */
- (void)getBindChannelListWithBlock:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ListBindChannel parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是数组
            NSArray *bodyArray = (NSArray *)responseModel.body;
            // 处理body数组中的字典数据成ChannelModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)bodyArray[i];
                ChannelModel *model = [[ChannelModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 获取陕西地市列表
/**
 * 返回值 @block 数组:ChannelModel
 */
- (void)getShanXiCityWithBlcok:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ListShanXiCity parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是数组
            NSArray *bodyArray = (NSArray *)responseModel.body;
            // 处理body数组中的字典数据成ChannelModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)bodyArray[i];
                ChannelModel *model = [[ChannelModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 根据城市和渠道编码 查询渠道列表
/**
 * 参数 @parameters 字段1：channelCode 字段2：cityCode
 * 返回值 @block 数组:ChannelModel
 */
- (void)getChannelListWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ListChannel parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是数组
            NSArray *bodyArray = (NSArray *)responseModel.body;
            // 处理body数组中的字典数据成ChannelModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)bodyArray[i];
                ChannelModel *model = [[ChannelModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 绑定渠道
/**
 * 参数 @parameters 字段1：channelCode 字段2：channelId 字段3：cityCode
 * 返回值 @block 成功或失败
 */
- (void)bindChannelWithDic:(NSDictionary *)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:BindChannel parameters:parameters completion:^(ResponseModel *responseModel) {
        [self handerBooleanWithResponse:responseModel Result:^(BOOL succeeded, HeadModel *error) {
            block(succeeded, error);
        }];
    }];
}

// 解绑渠道
/**
 * 参数 @parameters 字段1：channelCode 字段2：channelId 字段3：cityCode
 * 返回值 @block 成功或失败
 */
- (void)unbindChannelWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:UnbindChannel parameters:parameters completion:^(ResponseModel *responseModel) {
        
        [self handerBooleanWithResponse:responseModel Result:block];
    }];
}

// 获取陕西机构列表
/**
 * 参数 @parameters 无
 * 返回值 @block 数组：ChannelModel
 */
- (void)getShanXiOrgWithBlock:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ListShanXiOrg parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是数组
            NSArray *bodyArray = (NSArray *)responseModel.body;
            // 处理body数组中的字典数据成ChannelModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)bodyArray[i];
                ChannelModel *model = [[ChannelModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

#pragma mark - 开户
// 获取联档次或政策合约(开户)列表
/**
 * 参数 @parameters 字段1：businessCode 字段2：supplierId
 * 返回值 @block model:BusinessApiGradeModel
 */
- (void)getGradeListWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:GetGradeList parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            BusinessApiGradeModel *model = [[BusinessApiGradeModel alloc] initWithDictionary:(NSDictionary *)responseModel.body error:nil];
            block ? block(model, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 分页查询开户手机号
/**
 * 参数 @parameters 字段1：cityCode 字段2：mobilePrefix 字段3：businessId
 * 返回值 @block 数组：OpenAccountMobileModel
 */
- (void)getOpenAccountMobiles:(NSDictionary *_Nullable)parameters block:(ModelAndArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:OpenAccountPageMobiles parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 总数据 包含页数 总量
            PageModel *model = [[PageModel alloc] initWithDictionary:(NSDictionary *)responseModel.body error:nil];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < model.datas.count; i++) {
                NSDictionary *dic = model.datas[i];
                OpenAccountMobileModel *mobileModel = [[OpenAccountMobileModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:mobileModel];
            }
            block ? block(model, dataArray, nil) : nil;
        } else {
            block ? block(nil, nil, headModel) : nil;
        }
    }];
}

// 号码选占
/**
 * 参数 @parameters 字段1：mobile 字段2：addressCode
 * 返回值 @block 字符串："randomNo" : "string" 选占随机号
 */
- (void)openAccountOccupyPhoneNum:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:OccupyPhoneNum parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            BOOL isSuccess = [bodyDic[@"success"] boolValue];
            if (isSuccess) {
                NSString *randomNo = bodyDic[@"randomNo"];
                block ? block(randomNo, nil) : nil;
            } else {
                headModel.msg = bodyDic[@"msg"];
                block ? block(nil, headModel) : nil;
            }
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 下发采集验证工单（跳实名认证APP使用）
/**
 * 参数 @parameters 字段1:billId(办理业务的号码) 字段2:channelId(4A渠道id) 字段3:operCode(4A工号) 字段4:telephone(4A工号绑定手机号)
 * 返回值 @block 字典
 */
- (void)openAccountSendBillWithDic:(NSDictionary *_Nullable)parameters block:(DictionaryResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:OpenAccountSendBill parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *dic = (NSDictionary *)responseModel.body;
            block ? block(dic, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 查询实名认证信息
/**
 * 参数 @parameters 字段1：transactionId(下发工单时返回的数据)
 * 返回值 @block model:IDInfoModel
 */
- (void)queryRealnameBillWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:QueryRealnameBill parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *dic = (NSDictionary *)responseModel.body;
            IDInfoModel *model = [[IDInfoModel alloc] initWithDictionary:dic error:nil];
            block ? block(model, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 黑名单全国一证五号校验
/**
 * 参数 @parameters 字段1：idName 字段2：idNum 字段3：addressCode(10个常用 地州编码)
 * 返回值 @block (字符串：msg bool：pass)
 */
- (void)validateOneCerFiveNumberWithDic:(NSDictionary *_Nullable)parameters block:(StringAndBooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ValidateOneCerFiveNumber parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            BOOL isSuccess = [bodyDic[@"success"] boolValue];
            if (isSuccess) {
                block ? block(@"", YES, nil) : nil;
            } else {
                NSString *msg = bodyDic[@"msg"];
                block ? block(msg, NO, nil) : nil;
            }
        } else {
            block ? block(nil, NO, headModel) : nil;
        }
    }];
}

// SIM卡查询号码信息
/**state
 * 参数 @parameters 字段1：simCardNo 字段2：addressCode 字段3：mobile(开户手机号)
 * 返回值 @block (字符串：msg bool：pass)
 */
- (void)getSimCardInfoWithDic:(NSDictionary *_Nullable)parameters block:(StringAndBooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:GetSimCardInfo parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            BOOL isSuccess = [bodyDic[@"success"] boolValue];
            if (isSuccess) {
                block ? block(@"", YES, nil) : nil;
            } else {
                NSString *msg = bodyDic[@"msg"];
                block ? block(msg, NO, nil) : nil;
            }
        } else {
            block ? block(nil, NO, headModel) : nil;
        }
    }];
}

// 生成订单
/**
 * 参数 @parameters
 * 必填 字段1：addressCode(城市编码) 字段2：birthday(生日yyyy-MM-dd) 字段3：busiAreaCode(落频业务区) 字段4：businessGraderId(业务档次id) 字段5：businessId(业务id) 字段6：certExpDate(身份证失效日期) 字段7：certValidDate(身份证生效日期) 字段8：channelCode(落频渠道编码) 字段9：channelId(渠道id) 字段10：contractId(合约档id) 字段11：custCertAddr(证件地址) 字段12：custName(客户名称) 字段13：gender(性别0代表女，1代表男) 字段14：issuingAuthority(签证机关) 字段15：mobile(开户手机号码) 字段16：nation(民族) 字段17：payMoney(支付金额万分之一元) 字段18：psptId(证件号码) 字段19：randomNo(选占随机号) 字段20：saleDepartId(促销员渠道编码) 字段21：saleStaffId(促销员编码) 字段22：shopDepartId(归属渠道) 字段23：shopStaffId(店员编码) 字段24：simCardNo(Sim卡号)
 * 可选：字段1：gyType(副卡/子卡版本协议) 字段2：mainCardSn(主卡号码) 字段3：productId(产品编码) 字段4：productName(产品名称) 字段5：xhkOpenFlag(小号卡标识)
 * 返回值 @block 字符串：订单号
 */
- (void)createOrderWithDic:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:CreateOrder parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSString *dataString = [bodyDic objectForKey:@"orderId"];
            block ? block(dataString, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 订单支付(返回支付二维码字符串)
/**
 * 参数 @parameters 字段1：orderId(主订单id)
 * 字段2：payCode（支付产品编码（5001 支付宝扫码,5012 微信扫码支付 ,2001 支付宝手机网站,2002 微信H5支付（微信外部）,微信公众号支付3002）
 * 字段3：frontUrl（前端回调地址）
 * 返回值 @block 字符串：data
 */
- (void)payOrderWithDic:(NSDictionary *_Nullable)parameters block:(StringResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:PayOrder parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSString *dataString = [bodyDic objectForKey:@"data"];
            block ? block(dataString, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 查询订单支付状态
/**
 * 参数 @parameters 字段1：orderId
 * 返回值 @block NSNumber payStatus：1待支付2支付成功
 */
- (void)queryPayStatusWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:QueryPay parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSNumber *payStatus = [bodyDic objectForKey:@"payStatus"];
            NSLog(@"支付状态(1待支付，2支付)：%@", payStatus);
            BOOL isSuccess = (payStatus.integerValue == 2) ? YES : NO;
            block ? block(isSuccess, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 号卡订单中心列表
/**
 * 参数 @parameters 字段1：orderStatus（订单状态（waitActivite：待激活 waitPay：待支付 finished：已支付 canceled：已取消）
 字段2：userMobile（手机号码）
 * 返回值 @block 数组：OrderCenterModel
 */
- (void)queryOrderCenterWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:OrderCenter parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSArray *datas = bodyDic[@"datas"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < datas.count; i++) {
                NSDictionary *dic = datas[i];
                OrderCenterModel *model = [[OrderCenterModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 获取唤起实名认证APP的参数
/**
 * 参数 @parameters 字段1：billId （开户号码） 字段2：businessCode（业务编码）
 * 返回值 @block 数组：SMRZParametersModel
 */
- (void)realnameAuthSignWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:@"cmcc/api/auth/shanxi/openAccount/realnameAuthSign" parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            SMRZParametersModel *model = [[SMRZParametersModel alloc] initWithDictionary:bodyDic error:nil];
            block ? block(model, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}
#pragma mark - 专题
// 获取店铺的已上架的专题列表
/**
 * 参数 @parameters 字段1：dictionaryOneLevleTypeCode 字段2：supplierId 字段3：supplierName 字段4：userShopId
 * 返回值 @block 数组：
 */
- (void)getShopPrefectureWith:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:GetShopPrefectures parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSArray *prefectureList = (NSArray *)bodyDic[@"prefectureList"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < prefectureList.count; i++) {
                NSDictionary *dic = prefectureList[i];
                PrefectureModel *model = [[PrefectureModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            block ? block(dataArray, nil) : nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}











#pragma mark - 统一处理BoolleanResultBlock
- (void)handerBooleanWithResponse:(ResponseModel *)responseModel Result:(BooleanResultBlock _Nullable)block {
    HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
    if ([headModel.code isEqualToString:@"100000"]) {
        block ? block(YES, nil) : nil;
    } else {
        block ? block(nil, headModel) : nil;
    }
}
@end
