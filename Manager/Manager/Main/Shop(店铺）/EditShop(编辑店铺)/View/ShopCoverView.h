//
//  ShopCoverView.h
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCoverView : UIView

@property (nonatomic, strong) ShopInfoModel *model;
@property (nonatomic, copy) void(^ShopCoverViewEditBlock)(void);
// 初始化
- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
