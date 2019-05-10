//
//  ModifyPictureCell.h
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModifyPictureCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, copy) void(^ModifyDelePicBlock)(NSInteger index);
@property (nonatomic, copy) void(^ModifyAddPicBlock)(void);

@end

NS_ASSUME_NONNULL_END
