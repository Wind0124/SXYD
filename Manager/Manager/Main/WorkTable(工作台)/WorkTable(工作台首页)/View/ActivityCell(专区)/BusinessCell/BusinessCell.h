//
//  BusinessCell.h
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessCell : UITableViewCell

typedef void (^BusinessActionBlock)(ActivityBusinessModel *model);

@property (nonatomic, strong) NSArray *businessArray;
@property (nonatomic, copy) BusinessActionBlock actionBlock;

@end

NS_ASSUME_NONNULL_END
