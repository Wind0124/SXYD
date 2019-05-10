//
//  ChannelCell.h
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    ChannelCellTypeUnbind,
    ChannelCellTypeAdd,
    ChannelCellTypeHasBind,
} ChannelCellType;
@interface ChannelCell : UITableViewCell

@property (nonatomic, assign) NSInteger type; // 0解绑 1添加 2已添加
@property (nonatomic, copy) void (^unBindBlock)(ChannelModel *model);// 解绑
@property (nonatomic, copy) void (^bindBlock)(ChannelModel *model);// 添加
@property (nonatomic, assign) BOOL isDefaultChannel;
@property (nonatomic, strong) ChannelModel * _Nullable model;

@end

NS_ASSUME_NONNULL_END
