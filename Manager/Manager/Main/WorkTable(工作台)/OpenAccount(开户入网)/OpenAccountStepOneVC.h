//
//  OpenAccountStepOneVC.h
//  Manager
//
//  Created by vpclub on 2018/12/27.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenAccountStepOneVC : BaseVC

@property (nonatomic, strong) NSString *businessCode;// 开户业务code 例：flyingPackage
@property (nonatomic, strong) ChannelModel *supplierModel; // 开户业务机构数据

@end

NS_ASSUME_NONNULL_END
