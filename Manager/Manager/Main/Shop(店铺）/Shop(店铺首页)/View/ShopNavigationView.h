//
//  ShopNavigationView.h
//  Manager
//
//  Created by vpclub on 2018/12/8.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopNavigationView : UIView

@property (nonatomic, copy) void(^enterStoreAction)(void);
@property (nonatomic, copy) void(^shopNavEditAction)(void);
@property (nonatomic, copy) void(^shopNavMoreAction)(UIButton *sender);
// 切换头部颜色
- (void)setViewShow:(BOOL)showBackground;
// 更新店铺名
- (void)updateShopInfo;

@end

NS_ASSUME_NONNULL_END
