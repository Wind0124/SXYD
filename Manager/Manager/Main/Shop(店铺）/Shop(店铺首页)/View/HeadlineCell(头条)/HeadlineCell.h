//
//  HeadlineCell.h
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HeadlineCellBlock)(NSInteger index);

@interface HeadlineCell : UITableViewCell

@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) HeadlineCellBlock block;

@end

NS_ASSUME_NONNULL_END
