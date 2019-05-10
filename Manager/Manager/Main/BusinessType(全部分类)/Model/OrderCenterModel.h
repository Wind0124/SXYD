//
//  OrderCenterModel.h
//  Manager
//
//  Created by vpclub on 2019/3/6.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCenterModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * billCreateTime;// 工单创建时间
@property (nonatomic, strong) NSString<Optional> * businessGradeName;// 选择套餐
@property (nonatomic, strong) NSString<Optional> * cityName;// 号码归属地
@property (nonatomic, strong) NSString<Optional> * gradeName;// 套餐名称
@property (nonatomic, strong) NSString<Optional> * custName;// 用户姓名
@property (nonatomic, strong) NSNumber<Optional> * info_id;// 订单编号
@property (nonatomic, strong) NSString<Optional> * mobile;// 选择号码
@property (nonatomic, strong) NSString<Optional> * no;// 工单流水后6位
@property (nonatomic, strong) NSNumber<Optional> * orderAmount;// 支付金额
@property (nonatomic, strong) NSString<Optional> * orderPayTime;// 支付时间
// 支付方式（1：支付宝；2：微信；3：银行卡；4：超级付）
@property (nonatomic, strong) NSNumber<Optional> * payType;// 支付方式
@property (nonatomic, strong) NSString<Optional> * transactionId;// 工单流水号
@property (nonatomic, strong) NSString<Optional> * viceCardSimActivityName;// 活动名称


@end

NS_ASSUME_NONNULL_END
