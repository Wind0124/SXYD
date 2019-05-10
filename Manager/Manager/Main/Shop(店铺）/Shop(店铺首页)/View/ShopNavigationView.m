//
//  ShopNavigationView.m
//  Manager
//
//  Created by vpclub on 2018/12/8.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopNavigationView.h"

@interface ShopNavigationView()


@property (nonatomic, strong) UIButton *storeBtn;//店铺icon
@property (nonatomic, strong) UIButton *storeNameBtn;//店铺名称
@property (nonatomic, strong) UILabel *supplierNameLabel;// 默认渠道地市
@property (nonatomic, strong) UIButton *moreBtn;//更多
@property (nonatomic, strong) UIButton *editBtn;// 编辑
@property (nonatomic, strong) UIView *titleLine;
@property (nonatomic, strong) UIImageView *backgroundImgV;

@end

@implementation ShopNavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundImgV];
        [self addSubview:self.titleLine];
        [self addSubview:self.storeBtn];
        [self addSubview:self.storeNameBtn];
        [self addSubview:self.supplierNameLabel];
        [self addSubview:self.editBtn];
        [self addSubview:self.moreBtn];
    }
    return self;
}

- (void)setViewShow:(BOOL)showBackground {
    if (showBackground) {
        self.backgroundColor = UIColor.whiteColor;
        self.backgroundImgV.hidden = YES;
        self.storeBtn.selected = YES;
        [_storeNameBtn setTitleColor:hexStringToColor(@"414141") forState:UIControlStateNormal];
        self.supplierNameLabel.textColor = hexStringToColor(@"414141");
        self.moreBtn.selected = YES;
        self.editBtn.selected = YES;
        self.titleLine.alpha = 1;
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundImgV.hidden = NO;
        self.storeBtn.selected = NO;
        [_storeNameBtn setTitleColor:hexStringToColor(@"FFFFFF") forState:UIControlStateNormal];
        self.supplierNameLabel.textColor = hexStringToColor(@"FFFFFF");
        self.moreBtn.selected = NO;
        self.editBtn.selected = NO;
        self.titleLine.alpha = 0;
    }
}

- (void)updateShopInfo {
    [self.storeNameBtn setTitle:CurrentUser.shopName?:@"我的店铺" forState:UIControlStateNormal];
    if (CurrentUser.defaultSupplierName) {
        self.supplierNameLabel.hidden = NO;
        self.supplierNameLabel.text = [NSString stringWithFormat:@"地市：%@", CurrentUser.defaultSupplierName];
    } else {
        self.supplierNameLabel.hidden = YES;
    }
}

#pragma mark - 内部事件
-(void)enterShopInfoAction{
    if (self.enterStoreAction) {
        self.enterStoreAction();
    }
}

- (void)editAction:(UIButton *)sender {
    self.shopNavEditAction ? self.shopNavEditAction() : nil;
}

- (void)moreAction:(UIButton *)sender {
    if (self.shopNavMoreAction) {
        self.shopNavMoreAction(sender);
    }
}

#pragma mark - 懒加载
- (UIImageView *)backgroundImgV {
    if (!_backgroundImgV) {
        _backgroundImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        [_backgroundImgV setImage:[UIImage imageNamed:@"shop_nav_bg"]];
    }
    return _backgroundImgV;
}

- (UIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [[UIButton alloc] init];
        _storeBtn.frame = CGRectMake(10, 20+IPHONEX_TOP_SPACE, 35, 35);
        [_storeBtn setImage:[UIImage imageNamed:@"shop_store_white"] forState:UIControlStateNormal];
        [_storeBtn setImage:[UIImage imageNamed:@"shop_store_black"] forState:UIControlStateSelected];
        [_storeBtn addTarget:self action:@selector(enterShopInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBtn;
}

-(UIButton *)storeNameBtn{
    if (!_storeNameBtn) {
        _storeNameBtn = [[UIButton alloc] init];
        _storeNameBtn.frame = CGRectMake(CGRectGetMaxX(_storeBtn.frame), CGRectGetMinY(_storeBtn.frame), 100, 35);
        [_storeNameBtn setTitleColor:hexStringToColor(@"FFFFFF") forState:UIControlStateNormal];
//        [_storeNameBtn setTitleColor:hexStringToColor(@"414141") forState:UIControlStateSelected];
        _storeNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_storeNameBtn setAdjustsImageWhenHighlighted:NO];
//        _storeNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _storeNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_storeNameBtn setTitle:CurrentUser.shopName?:@"我的店铺" forState:UIControlStateNormal];
        [_storeNameBtn addTarget:self action:@selector(enterShopInfoAction) forControlEvents:UIControlEventTouchUpInside];
        _storeNameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _storeNameBtn;
}

- (UILabel *)supplierNameLabel {
    if (!_supplierNameLabel) {
        _supplierNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_storeNameBtn.frame) + 5, CGRectGetMinY(_storeNameBtn.frame), 80, 35)];
        _supplierNameLabel.font = [UIFont systemFontOfSize:14];
        _supplierNameLabel.textColor = UIColor.whiteColor;
        _supplierNameLabel.text = @"地市：";
    }
    return _supplierNameLabel;
}

// 编辑
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - 40, 20+IPHONEX_TOP_SPACE, 40, 35);
        [_editBtn setImage:[UIImage imageNamed:@"shop_edit_white"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"shop_edit_black"] forState:UIControlStateSelected];
        [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
//        _editBtn.backgroundColor = [UIColor greenColor];
    }
    return _editBtn;
}

// 更多
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 10, 20+IPHONEX_TOP_SPACE, 40, 35);
        _moreBtn.tag = 101;
        [_moreBtn setImage:[UIImage imageNamed:@"shop_more_white"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"shop_more_black"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
//        _moreBtn.backgroundColor = UIColor.redColor;
    }
    return _moreBtn;
}


- (UIView *)titleLine {
    if (!_titleLine) {
        _titleLine = [[UIView alloc] init];
        _titleLine.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 0.5, SCREEN_WIDTH, 0.5);
        _titleLine.backgroundColor = hexStringToColor(@"D8D8D8");
    }
    return _titleLine;
}

@end
