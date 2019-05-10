//
//  OpenAccountPayVC.h
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseVC.h"
#import "OpenAccountInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenAccountPayVC : BaseVC

@property (nonatomic, strong) OpenAccountInfo *openAccountInfo;// 开户数据
@property (nonatomic, assign) float totalFee;// 总费用

@property (nonatomic, copy) void(^openAccountPaySuccessBlock)(void);// 支付成功回调

@end

NS_ASSUME_NONNULL_END
