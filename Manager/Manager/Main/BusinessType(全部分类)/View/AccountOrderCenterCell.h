//
//  AccountOrderCenterCell.h
//  Manager
//
//  Created by vpclub on 2019/2/18.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountOrderCenterCell : UITableViewCell

// -1跳转详情 0待激活 1待支付
@property (nonatomic, copy) void(^ClickBlock)(NSInteger status);

@property (nonatomic, assign) NSInteger type;// 0待激活 1待支付 2已完成 3已取消
@property (nonatomic, strong) OrderCenterModel *model;
@end

NS_ASSUME_NONNULL_END
