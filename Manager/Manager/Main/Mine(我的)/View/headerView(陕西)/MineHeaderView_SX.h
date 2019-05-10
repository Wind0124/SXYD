//
//  MineHeaderView_SX.h
//  Manager
//
//  Created by vpclub on 2018/12/24.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView_SX : UIView

@property (nonatomic, copy) void(^mineSettingBlock)(void);
@property (nonatomic, copy) void(^mineAvatarBlock)(void);

// 更新用户信息
- (void)updateUserInfo;

@end

NS_ASSUME_NONNULL_END
