//
//  SelectCityView.h
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCityView : UIView

@property (nonatomic, copy) void(^selectCityBlock)(NSInteger index);
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, assign) BOOL isForSupplierSelected;// 该View也可用于选择机构

- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
