//
//  UpdateView.h
//  Manager
//
//  Created by vpclub on 2018/12/15.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateView : UIView

@property (nonatomic, strong) APPVersionModel *model;
- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
