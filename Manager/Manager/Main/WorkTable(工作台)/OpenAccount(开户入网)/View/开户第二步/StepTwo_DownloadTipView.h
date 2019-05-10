//
//  StepTwo_DownloadTipView.h
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepTwo_DownloadTipView : UIView

@property (nonatomic, strong) void(^downloadConfirmBlock)(void);

- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
