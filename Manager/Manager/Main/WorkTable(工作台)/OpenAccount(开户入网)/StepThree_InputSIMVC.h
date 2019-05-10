//
//  StepThree_InputSIMVC.h
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseVC.h"
#import "OpenAccountInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface StepThree_InputSIMVC : BaseVC

@property (nonatomic, strong) OpenAccountInfo *openAccountInfo;// 开户数据
@property (nonatomic, copy) void(^inputSIMBlock)(NSString *SIMString);

@end

NS_ASSUME_NONNULL_END
