//
//  ScanVC.h
//  Manager
//
//  Created by vpclub on 2018/12/26.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanVC : BaseVC

@property (nonatomic, copy) void(^ScanResultBlock)(NSString *string);

@end

NS_ASSUME_NONNULL_END
