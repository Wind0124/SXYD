//
//  StepOne_ChoosePhoneCell.h
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepOne_ChoosePhoneCell : UITableViewCell

@property (nonatomic, strong) OpenAccountMobileModel *model;
@property (nonatomic, copy) void(^StepOne_ChoosePhoneAction)(void);
@end

NS_ASSUME_NONNULL_END
