//
//  BusinessTypeHeaderView.h
//  Manager
//
//  Created by vpclub on 2018/12/31.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessTypeHeaderView : UIView

@property (nonatomic, copy) void(^changeSupplierBlock)(void);
@property (nonatomic, copy) void(^changeDefaultChannelBlock)(void);

- (void)updateSupplierName:(NSString *)supplierName;

@end

NS_ASSUME_NONNULL_END
