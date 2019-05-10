//
//  OpenAccountChoosePhoneVC.h
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenAccountChoosePhoneVC : BaseVC

@property (nonatomic, strong) NSString *businessId;// 开户业务id
@property (nonatomic, copy) void(^choosePhoneBlock)(OpenAccountMobileModel *mobile);

@end

NS_ASSUME_NONNULL_END
