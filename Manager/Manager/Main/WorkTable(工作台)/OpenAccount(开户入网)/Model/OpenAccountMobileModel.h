//
//  OpenAccountMobileModel.h
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenAccountMobileModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * fee;// 预存费用（万分之一元）
@property (nonatomic, strong) NSString<Optional> * mobile ;// 手机号
@property (nonatomic, strong) NSString<Optional> * randomNo; // 选占随机号
@end

NS_ASSUME_NONNULL_END
