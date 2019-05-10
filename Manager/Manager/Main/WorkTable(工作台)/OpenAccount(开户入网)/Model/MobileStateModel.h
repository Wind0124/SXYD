//
//  MobileStateModel.h
//  Manager
//
//  Created by vpclub on 2018/12/30.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobileStateModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * fee;// 预存费用（万分之一元）
@property (nonatomic, strong) NSString<Optional> * occupyDepartId;// 选占部门
@property (nonatomic, strong) NSString<Optional> * occupyStaffId;// 选占工号
@property (nonatomic, strong) NSString<Optional> * occupyTime;// 选占时间（yyyy-MM-dd HH:mm:ss）
@property (nonatomic, strong) NSString<Optional> * poolCode;// 归属群池编码
@property (nonatomic, strong) NSString<Optional> * simCardNo;// 绑定的sim卡卡号
@property (nonatomic, strong) NSString<Optional> * state;// 是否选占
@property (nonatomic, strong) NSString<Optional> * validTime;// 有效时间（yyyy-MM-dd HH:mm:ss）

@end

NS_ASSUME_NONNULL_END
