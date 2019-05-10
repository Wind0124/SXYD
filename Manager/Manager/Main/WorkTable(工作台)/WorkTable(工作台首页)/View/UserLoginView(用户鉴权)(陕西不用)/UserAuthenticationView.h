//
//  UserAuthenticationView.h
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAuthenticationView : UIView

@property (nonatomic, copy) void(^UserAuthViewBlock)(NSString *phoneNumber);

@end

NS_ASSUME_NONNULL_END
