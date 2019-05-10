//
//  MineHeaderView.m
//  智汇随身厅
//
//  Created by BiuBiu on 2018/1/17.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "MineHeaderView.h"
#import "MineHeaderItemView.h"
#import "Masonry.h"

@interface MineHeaderView ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIButton *settingBtn; //设置
@property (nonatomic, strong) UIButton *imageBtn;   //头像
@property (nonatomic, strong) UILabel *nameLbl;     //显示店铺名

@property (nonatomic, strong) MineHeaderItemView *businessItemView;    //业务办理
@property (nonatomic, strong) MineHeaderItemView *orderItemView;   //商品订单
@property (nonatomic, strong) MineHeaderItemView *customerItemView; //常客

@property (nonatomic, strong) UILabel *statisticsLabel;// 酬金预估
@property (nonatomic, strong) MineHeaderItemView *todayRewardItemView;    // 本日酬金
@property (nonatomic, strong) UIView *lineView;// 分割线
@property (nonatomic, strong) MineHeaderItemView *monthRewardItemView;    // 本月酬金
@end

@implementation MineHeaderView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = hexStringToColor(@"FFFFFF");
        [self addSubview:self.bgImgView];
        [self addSubview:self.settingBtn];
        [self addSubview:self.imageBtn];
        [self addSubview:self.nameLbl];
        [self addSubview:self.businessItemView];
        [self addSubview:self.orderItemView];
        [self addSubview:self.customerItemView];
        [self addSubview:self.statisticsLabel];
        
        [self addSubview:self.todayRewardItemView];
        [self addSubview:self.lineView];
        [self addSubview:self.monthRewardItemView];
        [self addConstraint];
    }
    return self;
}

// 更新用户信息
- (void)updateUserInfo {
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:CurrentUser.faceUrl server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
//    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:CurrentUser.faceUrl server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
    self.nameLbl.text = [NSString stringWithFormat:@"%@ %@" ,CurrentUser.employeeNumber, CurrentUser.nickName];
}

#pragma mark - setter
- (void)setModel:(WeekMonthRewardModel *)model {
    _model = model;
    self.businessItemView.countLbl.text = model.businessCount;
    self.customerItemView.countLbl.text = CurrentUser.frequenterCount ? : @"0";

    self.todayRewardItemView.countLbl.text = [NSString stringWithFormat:@"%.2f", [model.dayCommission floatValue] / 10000.0];
    self.monthRewardItemView.countLbl.text = [NSString stringWithFormat:@"%.2f", [model.monthCommission floatValue] / 10000.0];
}

#pragma mark - button click event
- (void)settingBtnAction {
    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (void)imageBtnAction {
    if (self.avatarBlock) {
        self.avatarBlock();
    }
}

- (void)busiItemAction {
    if (self.actionBlock) {
        self.actionBlock(0);
    }
}

- (void)orderItemAction {
    if (self.actionBlock) {
        self.actionBlock(1);
    }
}

- (void)customersItemAction {
    if (self.actionBlock) {
        self.actionBlock(2);
    }
}

- (void)todayItemAction {
    self.actionBlock ? self.actionBlock(3) : nil;
}

- (void)monthItemAction {
    self.actionBlock ? self.actionBlock(4) : nil;
}

#pragma mark - add constraint
- (void)addConstraint {
    // 第一部分
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImgView).mas_offset(60);
        make.right.mas_equalTo(self.bgImgView).mas_offset(-15);
        make.width.height.mas_equalTo(30);
    }];
    
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImgView.mas_top).offset(60);
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(75);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageBtn.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.imageBtn.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    
    // 第二部分
    [_businessItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImgView.mas_bottom);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self.orderItemView.mas_width);
        make.width.mas_equalTo(self.customerItemView.mas_width);
        make.height.mas_equalTo(80);
    }];
    
    [_orderItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.businessItemView.mas_top);
        make.left.mas_equalTo(self.businessItemView.mas_right);
        make.right.mas_equalTo(self.customerItemView.mas_left);
        make.height.mas_equalTo(80);
    }];

    [_customerItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.businessItemView.mas_top);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(80);
    }];
    
    // 第三部分
    [_statisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.businessItemView.mas_bottom).offset(0);
        make.left.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_todayRewardItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statisticsLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.todayRewardItemView.mas_top);
        make.bottom.mas_equalTo(self.todayRewardItemView.mas_bottom);
        make.left.mas_equalTo(self.todayRewardItemView.mas_right);
        make.width.offset(1);
    }];
    
    [_monthRewardItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top);
        make.left.mas_equalTo(self.lineView.mas_right);
        make.bottom.mas_equalTo(self.lineView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma mark - 懒加载
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _bgImgView.image = [UIImage imageNamed:@"WorkTable_bg_head"];
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
        _imageBtn.layer.cornerRadius = 75 / 2.0;
        _imageBtn.layer.masksToBounds = YES;
        NSURL *imgUrl = [NSURL URLWithString:[NSString getFullImageUrlString:CurrentUser.faceUrl server:CurrentUser.imgServerPrefix]];
        [_imageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_mine"]];
        [_imageBtn addTarget:self action:@selector(imageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = hexStringToColor(@"ffffff");
        _nameLbl.font = [UIFont systemFontOfSize:16];
        _nameLbl.text = [NSString stringWithFormat:@"%@ %@", CurrentUser.employeeNumber, CurrentUser.nickName];
    }
    return _nameLbl;
}

- (MineHeaderItemView *)businessItemView {
    if(!_businessItemView) {
        _businessItemView = [[MineHeaderItemView alloc] init];
        _businessItemView.titleLbl.text = @"业务订单";
        _businessItemView.countLbl.text = @"--";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(busiItemAction)];
        [_businessItemView addGestureRecognizer:tap];
    }
    return _businessItemView;
}

- (MineHeaderItemView *)orderItemView {
    if(!_orderItemView) {
        _orderItemView = [[MineHeaderItemView alloc] init];
        _orderItemView.titleLbl.text = @"商品订单";
        _orderItemView.countLbl.text = @"--";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderItemAction)];
        [_orderItemView addGestureRecognizer:tap];
    }
    return _orderItemView;
}

- (MineHeaderItemView *)customerItemView {
    if(!_customerItemView) {
        _customerItemView = [[MineHeaderItemView alloc] init];
        _customerItemView.titleLbl.text = @"我的常客";
        _customerItemView.countLbl.text = @"--";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customersItemAction)];
        [_customerItemView addGestureRecognizer:tap];
    }
    return _customerItemView;
}

- (UILabel *)statisticsLabel {
    if (!_statisticsLabel) {
        _statisticsLabel = [[UILabel alloc] init];
        _statisticsLabel.textColor = [UIColor blackColor];
        _statisticsLabel.font = [UIFont systemFontOfSize:16];
        _statisticsLabel.text = @"酬金预估";
//        _statisticsLabel.backgroundColor = [UIColor greenColor];
    }
    return _statisticsLabel;
}

- (MineHeaderItemView *)todayRewardItemView {
    if(!_todayRewardItemView) {
        _todayRewardItemView = [[MineHeaderItemView alloc] init];
        _todayRewardItemView.titleLbl.text = @"今日酬金（元）";
        _todayRewardItemView.countLbl.text = @"--";
//        CGRect frame = _todayRewardItemView.countLbl.frame;
//        frame.size.height = 50;
//        _todayRewardItemView.countLbl.frame = frame;
//        _todayRewardItemView.countLbl.backgroundColor = [UIColor greenColor];
        _todayRewardItemView.countLbl.font = [UIFont systemFontOfSize:22];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayItemAction)];
        [_todayRewardItemView addGestureRecognizer:tap];
//        _todayRewardItemView.backgroundColor = [UIColor blueColor];
    }
    return _todayRewardItemView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (MineHeaderItemView *)monthRewardItemView {
    if(!_monthRewardItemView) {
        _monthRewardItemView = [[MineHeaderItemView alloc] init];
        _monthRewardItemView.titleLbl.text = @"本月酬金（元）";
        _monthRewardItemView.countLbl.text = @"--";
        _monthRewardItemView.countLbl.font = [UIFont systemFontOfSize:22];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthItemAction)];
        [_monthRewardItemView addGestureRecognizer:tap];
    }
    return _monthRewardItemView;
}
@end
