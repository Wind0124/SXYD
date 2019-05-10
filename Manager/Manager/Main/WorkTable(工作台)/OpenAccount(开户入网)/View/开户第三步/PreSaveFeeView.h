//
//  PreSaveFeeView.h
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreSaveFeeView : UIView

@property (nonatomic, strong) NSString *fee;
@property (nonatomic, copy) void(^selectFeeBlock)(NSString *fee);

- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
