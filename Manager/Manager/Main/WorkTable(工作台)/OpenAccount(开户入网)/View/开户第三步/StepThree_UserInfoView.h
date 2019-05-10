//
//  StepThree_UserInfoView.h
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepThree_UserInfoView : UIView

- (id)initWithNib;
// 显示数据
- (void)updateInfoWithCombo:(NSString *)combo city:(NSString *)cityName phone:(NSString *)phoneNum;
// 显示SIM卡
- (void)updateSIMNumber:(NSString *)SIMNum;
@end

NS_ASSUME_NONNULL_END
