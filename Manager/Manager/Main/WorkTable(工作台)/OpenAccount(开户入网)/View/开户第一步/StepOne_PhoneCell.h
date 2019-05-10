//
//  StepOne_PhoneCell.h
//  Manager
//
//  Created by vpclub on 2019/1/5.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepOne_PhoneCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) OpenAccountMobileModel *model;

@end

NS_ASSUME_NONNULL_END
