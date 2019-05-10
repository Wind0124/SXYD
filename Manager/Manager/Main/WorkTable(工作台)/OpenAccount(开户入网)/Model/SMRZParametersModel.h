//
//  SMRZParametersModel.h
//  Manager
//
//  Created by vpclub on 2019/4/11.
//  Copyright © 2019 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRZParametersModel : BaseModel

@property (nonatomic, strong) NSString *account; // 操作员工号
@property (nonatomic, strong) NSString *billId; // 开户号码
@property (nonatomic, strong) NSString *channelCode; // 渠道编码
@property (nonatomic, strong) NSString *provinceCode; // 请求源
@property (nonatomic, strong) NSString *signature; // 签名
@property (nonatomic, strong) NSString *transactionId; // 全局唯一流水号

@end

NS_ASSUME_NONNULL_END
