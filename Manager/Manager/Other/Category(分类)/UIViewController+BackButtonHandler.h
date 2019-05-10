//
//  UIViewController+BackButtonHandler.h
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end


NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
