//
//  MineHeaderView_SX.m
//  Manager
//
//  Created by vpclub on 2018/12/24.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "MineHeaderView_SX.h"
#import "Masonry.h"

@interface MineHeaderView_SX ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIButton *settingBtn; //设置
@property (nonatomic, strong) UIButton *imageBtn;   //头像
@property (nonatomic, strong) UIImageView *authImgView; // 4A已授权
@property (nonatomic, strong) UILabel *phoneLabel; // 手机号
@property (nonatomic, strong) UILabel *channelNameLabel; // 渠道名
@property (nonatomic, strong) UILabel *channelCodeLabel; // 渠道编码
@property (nonatomic, strong) UILabel *channelIdLabel; // 渠道ID
@property (nonatomic, strong) UILabel *cityNameLabel; // 归属城市
@end

@implementation MineHeaderView_SX

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.bgImgView];
        [self addSubview:self.settingBtn];
        [self addSubview:self.imageBtn];
        [self addSubview:self.authImgView];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.channelNameLabel];
        [self addSubview:self.channelCodeLabel];
        [self addSubview:self.channelIdLabel];
        [self addSubview:self.cityNameLabel];
        [self addConstraint];
    }
    return self;
}

// 更新用户信息
- (void)updateUserInfo {
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:CurrentUser.faceUrl server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
    if (CurrentUser.mobile.length == 11) {
        NSString *mobileString = [CurrentUser.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneLabel.text = mobileString;
    }
    // 授权状态
    if (CurrentUser.crmStatus.integerValue != 3) {
        self.authImgView.hidden = NO;
    } else {
        self.authImgView.hidden = YES;
    }
    // 渠道名称
    if (!CurrentUser.crmChannelName || CurrentUser.crmChannelName.length == 0) {
        self.channelNameLabel.text = [NSString stringWithFormat:@"渠道名：%@", @"----"];
    } else {
        self.channelNameLabel.text = [NSString stringWithFormat:@"渠道名：%@", CurrentUser.crmChannelName];
    }
    // 渠道编码
    if (!CurrentUser.crmChannelCode || CurrentUser.crmChannelCode.length == 0) {
        self.channelCodeLabel.text = [NSString stringWithFormat:@"渠道编码：%@", @"----"];
    } else {
        self.channelCodeLabel.text = [NSString stringWithFormat:@"渠道编码：%@", CurrentUser.crmChannelCode];
    }
    // 渠道Id
    if (!CurrentUser.crmChannelId || CurrentUser.crmChannelId.length == 0) {
        self.channelIdLabel.text = [NSString stringWithFormat:@"渠道 ID：%@", @"----"];
    } else {
        self.channelIdLabel.text = [NSString stringWithFormat:@"渠道 ID：%@", CurrentUser.crmChannelId];
    }
    // 归属城市
    if (!CurrentUser.crmCityName || CurrentUser.crmCityName.length == 0) {
        self.cityNameLabel.text = [NSString stringWithFormat:@"归属城市：%@", @"----"];
    } else {
        self.cityNameLabel.text = [NSString stringWithFormat:@"归属城市：%@", CurrentUser.crmCityName];
    }
}

#pragma mark - button click event
- (void)settingBtnAction {
    self.mineSettingBlock ? self.mineSettingBlock() : nil;
}

- (void)imageBtnAction {
    self.mineAvatarBlock ? self.mineAvatarBlock() : nil;
}

#pragma mark - add constraint
- (void)addConstraint {
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(Status_Height + 10);
        make.right.mas_equalTo(self.bgImgView).mas_offset(-15);
        make.width.height.mas_equalTo(30);
    }];
    
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImgView.mas_top).offset(Nav_Height);
        make.left.mas_equalTo(self.mas_left).offset(15) ;
        make.width.height.mas_equalTo(60);
    }];
    [_authImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageBtn.mas_bottom).offset(-7);
        make.centerX.mas_equalTo(self.imageBtn.mas_centerX);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(13);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageBtn.mas_right).offset(15);
        make.top.mas_equalTo(self.imageBtn.mas_top).offset(5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
    
    [_channelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.phoneLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    
    [_channelCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.channelNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.channelNameLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    [_channelIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.channelCodeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.channelCodeLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    [_cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.channelIdLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.channelIdLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

#pragma mark - 懒加载
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"mine_bg"];
    }
    return _bgImgView;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.backgroundColor = [UIColor clearColor];
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:0];
        [_settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (UIButton *)imageBtn {
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.backgroundColor = [UIColor clearColor];
        _imageBtn.layer.cornerRadius = 60 / 2.0;
        _imageBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _imageBtn.layer.borderWidth = 1;
        _imageBtn.layer.masksToBounds = YES;
        NSURL *imgUrl = [NSURL URLWithString:[NSString getFullImageUrlString:CurrentUser.faceUrl server:CurrentUser.imgServerPrefix]];
        [_imageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_mine"]];
        [_imageBtn addTarget:self action:@selector(imageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}

- (UIImageView *)authImgView {
    if (!_authImgView) {
        _authImgView = [[UIImageView alloc] init];
        [_authImgView setImage:[UIImage imageNamed:@"mine_4A"]];
    }
    return _authImgView;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [self whiteLabelWithFont:18];
    }
    return _phoneLabel;
}

- (UILabel *)channelNameLabel {
    if (!_channelNameLabel) {
        _channelNameLabel = [self whiteLabelWithFont:11];
        _channelNameLabel.numberOfLines = 0;
    }
    return _channelNameLabel;
}

- (UILabel *)channelCodeLabel {
    if (!_channelCodeLabel) {
        _channelCodeLabel = [self whiteLabelWithFont:11];
    }
    return _channelCodeLabel;
}
- (UILabel *)channelIdLabel {
    if (!_channelIdLabel) {
        _channelIdLabel = [self whiteLabelWithFont:11];
    }
    return _channelIdLabel;
}
- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [self whiteLabelWithFont:11];
    }
    return _cityNameLabel;
}
- (UILabel *)whiteLabelWithFont:(CGFloat)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}
@end
