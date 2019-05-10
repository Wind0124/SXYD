//
//  BusinessContractModel.h
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessContractModel : BaseModel

@property (nonatomic, strong) NSArray<Optional> * activityIds;//
@property (nonatomic, strong) NSArray<Optional> * activityList;// 专区隔离
@property (nonatomic, strong) NSNumber<Optional> * businessType;// 业务类型(1:终端销售,2:号卡开户)
@property (nonatomic, strong) NSNumber<Optional> * contractConfigureAttribute;// 合约档属性(1:自动办理,2:手动办理)
@property (nonatomic, strong) NSString<Optional> * contractConfigureCode;// 合约档编码
@property (nonatomic, strong) NSString<Optional> * contractConfigureName;// 合约档名称
@property (nonatomic, strong) NSNumber<Optional> * contractConfigureType;// 合约档类型(1:单卡合约,2:成本合约,3:产品优惠,4:94合约)
@property (nonatomic, strong) NSArray<Optional> * contractInfoList;// 合约明细（类型包含1:营销包,2:产品,3:流量套餐,4:优惠包)
@property (nonatomic, strong) NSString<Optional> * downOnlineTime;// 下线时间
@property (nonatomic, strong) NSNumber<Optional> * goodsPackageJobNumber;// 产品套餐办理工号类型(1:渠道工号,2:电商工号)
@property (nonatomic, strong) NSString<Optional> * info_id;// 主键id
@property (nonatomic, strong) NSNumber<Optional> * isFixedMarketingCheck;// 是否用固定营销包校验(1:是,2:否)
@property (nonatomic, strong) NSNumber<Optional> * isImportCheck;// 是否和动力导入校验(1:是,2:否)
@property (nonatomic, strong) NSArray<Optional> * localMarketIds;//
@property (nonatomic, strong) NSArray<Optional> * localMarketList;// 地市隔離
@property (nonatomic, strong) NSNumber<Optional> * marketingJobNumber;// 营销包办理工号类型(1:渠道工号,2:电商工号)
@property (nonatomic, strong) NSNumber<Optional> * state;// 状态(1:启用中,2:已禁用)
@property (nonatomic, strong) NSArray<Optional> * supplierIds;//
@property (nonatomic, strong) NSArray<Optional> * supplierList;// 供应商隔离
@property (nonatomic, strong) NSNumber<Optional> * targetUserInfoId;// 目标用户
@property (nonatomic, strong) NSString<Optional> * upOnlineTime;// 上线时间 
@property (nonatomic, strong) NSString<Optional> * info_description;// 业务说明
@property (nonatomic, strong) NSString<Optional> *minimumAmount;// 预存金额，多个用“，”隔开

@end

NS_ASSUME_NONNULL_END
