//
//  ActivityHeadCell.h
//  Manager
//
//  Created by vpclub on 2018/12/1.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ActivityHeadCell : UITableViewCell

typedef void (^MoreActionBlock)(ActivityHeadModel *model);
typedef void (^PictureActionBlock)(ActivityHeadModel *model);

@property (nonatomic, strong) NSString *styleCode;
@property (nonatomic, strong) ActivityHeadModel *model;
@property (nonatomic, copy) MoreActionBlock moreActionBlock;
@property (nonatomic, copy) PictureActionBlock pictureActionBlock;

@end

NS_ASSUME_NONNULL_END
