//
//  ChangeUserView.h
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeUserBlock)(NSDictionary *para);
@interface ChangeUserView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;//选中行

@property (nonatomic, copy) ChangeUserBlock changeUserBlock;

- (void)update;
@end

NS_ASSUME_NONNULL_END
