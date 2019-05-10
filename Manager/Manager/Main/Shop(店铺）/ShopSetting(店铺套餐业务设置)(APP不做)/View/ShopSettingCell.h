//
//  ShopSettingCell.h
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopSettingCell : UITableViewCell

@property (nonatomic, copy) void(^switchStatusBlock)(void);

@end

NS_ASSUME_NONNULL_END
