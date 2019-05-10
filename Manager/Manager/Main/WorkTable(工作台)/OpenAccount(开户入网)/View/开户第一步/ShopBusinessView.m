//
//  ShopBusinessView.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopBusinessView.h"

@interface ShopBusinessView()

@property (nonatomic, strong) UIImageView *cornerImgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation ShopBusinessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self addSubview:self.cornerImgView];
        [self addSubview:self.imgView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.nameLabel.textColor = hexStringToColor(COLOR_Btn);
        self.cornerImgView.hidden = NO;
    } else {
        self.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
        self.nameLabel.textColor = hexStringToColor(@"333333");
        self.cornerImgView.hidden = YES;
    }
}

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    self.nameLabel.text = nameString;
}

#pragma mark - 懒加载
- (UIImageView *)cornerImgView {
    if (!_cornerImgView) {
        _cornerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [_cornerImgView setImage:[UIImage imageNamed:@"shop_business_check"]];
        _cornerImgView.hidden = YES;
    }
    return _cornerImgView;
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 24, 24)];
        [_imgView setImage:[UIImage imageNamed:@"shop_business"]];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10, 0, 80, self.viewHeight)];
        _nameLabel.textColor = hexStringToColor(@"333333");
        _nameLabel.text = @"4G飞享套餐18元";
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}
@end
