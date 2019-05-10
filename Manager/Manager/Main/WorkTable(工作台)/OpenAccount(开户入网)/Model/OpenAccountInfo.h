//
//  OpenAccountInfo.h
//  Manager
//
//  Created by vpclub on 2019/1/9.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NSCopying
- (id)copyWithZone:(NSZone*)zone;
@end

@interface OpenAccountInfo : NSObject

@property (nonatomic, strong) BusinessApiGradeModel *model;// 业务数据
@property (nonatomic, strong) BusinessContractModel *contractModel;// 合约数据
@property (nonatomic, strong) OpenAccountMobileModel *mobileModel;// 选择手机号
@property (nonatomic, strong) IDInfoModel *idModel;// 身份证信息
@property (nonatomic, strong) NSString *SIMString; // SIM号
@property (nonatomic, strong) NSString *orderId;// 订单号
@end

NS_ASSUME_NONNULL_END
