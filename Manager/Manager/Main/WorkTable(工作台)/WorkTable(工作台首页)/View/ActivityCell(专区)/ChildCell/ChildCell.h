//
//  ChildCell.h
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChildCell : UITableViewCell

typedef void (^ChildPictureActionBlock)(ActivityChildModel *model);

@property (nonatomic, strong) NSArray *childArray;
@property (nonatomic, copy) ChildPictureActionBlock pictureActionBlock;

@end

NS_ASSUME_NONNULL_END
