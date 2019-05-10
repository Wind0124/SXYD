//
//  GoodsView2.h
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 纵向展示商品图片、标题、价格
@interface GoodsView2 : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *imgView;
// 显示数据
@property (nonatomic, strong) ActivityBusinessModel *model;

@end

NS_ASSUME_NONNULL_END
