//
//  ModifyShopIntroAndCoverView.h
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditShopInfoVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifyShopIntroAndCoverView : UIView

@property (nonatomic, strong) ShopInfoModel *model;
@property (nonatomic, strong) EditShopInfoVC *fatherVC;
- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
