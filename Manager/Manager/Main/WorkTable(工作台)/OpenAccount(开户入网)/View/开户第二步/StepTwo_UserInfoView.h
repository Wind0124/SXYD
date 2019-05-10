//
//  StepTwo_UserInfo.h
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepTwo_UserInfoView : UIView

- (id)initWithNib;

- (void)updateInfoWithName:(NSString *)name gender:(NSString *)gender idNum:(NSString *)idNum address:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
