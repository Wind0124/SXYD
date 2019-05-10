//
//  AddChannelView.h
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddChannelView : UIView

@property (nonatomic, copy) void(^selectCityBlock)(void);
@property (nonatomic, copy) void(^searchBlock)(NSString *channelCode);

@property (nonatomic, assign) NSInteger citySelectIndex;
@property (nonatomic, strong) NSString *selectCityName;
- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
