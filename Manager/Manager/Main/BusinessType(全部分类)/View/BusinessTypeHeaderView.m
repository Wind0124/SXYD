//
//  BusinessTypeHeaderView.m
//  Manager
//
//  Created by vpclub on 2018/12/31.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BusinessTypeHeaderView.h"

@interface BusinessTypeHeaderView()

//@property (nonatomic, strong) UILabel *supplyLabel;
@property (nonatomic, strong) UIImageView *supplyImgView;
@property (nonatomic, strong) UIButton *supplyBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIButton *changeChannelBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation BusinessTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.supplyImgView];
        [self addSubview:self.supplyBtn];
        [self addSubview:self.arrowImgView];
        [self addSubview:self.changeChannelBtn];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)updateSupplierName:(NSString *)supplierName {
    supplierName = supplierName ?: @"机构";
    [self.supplyBtn setTitle:supplierName forState:UIControlStateNormal];
}

#pragma mark - 按钮点击
- (void)changeSupplier {
    self.changeSupplierBlock ? self.changeSupplierBlock() : nil;
}

- (void)changeDefaultChannel {
    self.changeDefaultChannelBlock ? self.changeDefaultChannelBlock() :nil;
}
#pragma mark - 懒加载
- (UIImageView *)supplyImgView {
    if (!_supplyImgView) {
        _supplyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 15, 15)];
        _supplyImgView.image = [UIImage imageNamed:@"channel_city"];
    }
    return _supplyImgView;
}

- (UIButton *)supplyBtn {
    if (!_supplyBtn) {
        _supplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.supplyImgView.maxX + 5, 12, 45, 30)];
        [_supplyBtn setTitle:@"机构" forState:UIControlStateNormal];
        [_supplyBtn setTitleColor:hexStringToColor(@"333333") forState:UIControlStateNormal];
        _supplyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_supplyBtn addTarget:self action:@selector(changeSupplier) forControlEvents:UIControlEventTouchUpInside];
    }
    return _supplyBtn;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.supplyBtn.maxX, 21, 12, 12)];
        _arrowImgView.image = [UIImage imageNamed:@"arrow_right_gray"];
    }
    return _arrowImgView;
}

- (UIButton *)changeChannelBtn {
    if (!_changeChannelBtn) {
        CGFloat btnWidth = 80;
        _changeChannelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth - 15 - btnWidth, 12, btnWidth, 26)];
        [_changeChannelBtn setTitle:@"切换渠道" forState:UIControlStateNormal];
        [_changeChannelBtn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        _changeChannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _changeChannelBtn.backgroundColor = UIColor.whiteColor;
        _changeChannelBtn.layer.borderWidth = 1;
        _changeChannelBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        _changeChannelBtn.layer.cornerRadius = 4;
        _changeChannelBtn.layer.masksToBounds = YES;
        [_changeChannelBtn addTarget:self action:@selector(changeDefaultChannel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeChannelBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 1, self.viewWidth, 1)];
        _lineView.backgroundColor = hexStringToColor(COLOR_Background);
    }
    return _lineView;
}

@end
