//
//  AuthTipView.h
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthTipView : UIView

@property (nonatomic, strong) UIViewController *fatherVC;

- (id)initWithNib;
- (void)showAgain;
@end

NS_ASSUME_NONNULL_END
