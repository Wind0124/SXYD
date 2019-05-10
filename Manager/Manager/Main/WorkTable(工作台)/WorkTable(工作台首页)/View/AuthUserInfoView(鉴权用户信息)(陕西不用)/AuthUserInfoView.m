//
//  AuthUserInfoView.m
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "AuthUserInfoView.h"
#import "StopWatchView.h"

@interface AuthUserInfoView()

@property (nonatomic, strong) UIImageView *bgView;//背景图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
// 流量、通话扇形图
@property (weak, nonatomic) IBOutlet StopWatchView *stopWatchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stopWatchViewHeightConstraint;

@end

@implementation AuthUserInfoView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self stopWatchAction];
    } else {
        self = [super init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - 加载数据
- (void)setModel:(AuthUserInfoModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.userName, model.linkPhone];
    self.statusLabel.text = model.userStatus;
    self.packageLabel.text = model.packageName;
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", [model.latestBalance integerValue] / 10000.0];
    self.scoreLabel.text = model.totalScore;
    self.costLabel.text = [NSString stringWithFormat:@"%.2f", [model.realtimeCallCharge integerValue] / 10000.0];
    
    self.stopWatchView.model = self.model;
}

#pragma mark - 事件
- (void)stopWatchAction {
    self.stopWatchView.clickHideBlock = ^(CGFloat floatValue) {
        NSLog(@"扇形图高度%.2f", floatValue);
        if (floatValue > 150) {
            self.viewHeight = 350;
        } else {
            self.viewHeight = 250;
        }
        self.AuthUserUpdateUIBlock ? self.AuthUserUpdateUIBlock() : nil;
    };
    
    self.stopWatchView.clickDetailBlock = ^{
        NSLog(@"点击详细");
        self.AuthUserClickDetailBlock ? self.AuthUserClickDetailBlock() : nil;
    };
}

- (IBAction)recommendAction:(UIButton *)sender {
    NSLog(@"业务推荐");
    self.AuthUserRecommedBlock ? self.AuthUserRecommedBlock() : nil;
}

- (IBAction)changeUserAction:(UIButton *)sender {
    NSLog(@"切换用户");
    self.AuthUserChangeBlock ? self.AuthUserChangeBlock() : nil;
}

- (IBAction)checkBalanceAction:(UITapGestureRecognizer *)sender {
    NSLog(@"查询余额");
    self.AuthUserCheckBalanceBlock ? self.AuthUserCheckBalanceBlock() : nil;
}

- (IBAction)checkScoreAction:(UITapGestureRecognizer *)sender {
    NSLog(@"查询积分");
    self.AuthUserCheckScoreBlock ? self.AuthUserCheckScoreBlock() : nil;
}

- (IBAction)checkCostAction:(UITapGestureRecognizer *)sender {
    NSLog(@"查询实时话费");
    self.AuthUserCheckCostBlock ? self.AuthUserCheckCostBlock() : nil;
}

@end
