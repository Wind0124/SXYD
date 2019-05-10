//
//  SwitchEmployeeView.h
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchEmployeeView : UIView

@property (nonatomic, copy) void(^switchEmployeeBlock)(NSString *employeeString);
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
