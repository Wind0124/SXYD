//
//  AuthTipView.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "AuthTipView.h"
#import "CertificateVC_SX.h"
#import "ManagerChannelVC.h"
#import "ShopperRegisterVC.h"

@interface AuthTipView()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *channelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelHeightConstraint;

@end

@implementation AuthTipView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + IPHONEX_BOTTOM_SPACE);
        self.registerBtn.layer.cornerRadius = 4;
        self.registerBtn.layer.borderWidth = 1;
        self.registerBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.registerBtn.layer.masksToBounds = YES;
        self.channelBtn.layer.cornerRadius = 4;
        self.channelBtn.layer.borderWidth = 1;
        self.channelBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.channelBtn.layer.masksToBounds = YES;
        [self checkStatus];
    } else {
        self = [super init];
    }
    return self;
}

// 检测4A认证，千店万员、渠道绑定
- (BOOL)checkStatus {
    // 再次判断是否需要显示弹窗
    BOOL needShowAgain = NO;
    NSInteger authStatus = CurrentUser.crmStatus.integerValue;
    if (authStatus == 1 || authStatus == 2) {
        // 已4A认证或授权
        self.authHeightConstraint.constant = 0;
        self.authBtn.hidden = YES;
    } else {
        self.authHeightConstraint.constant = 40;
        self.authBtn.hidden = NO;
        needShowAgain = YES;
    }
    NSInteger channelStatus = CurrentUser.channelStatus.integerValue;
    if (channelStatus == 0 ) {
        // 不是千店万员 显示注册按钮、隐藏渠道按钮
        self.registerHeightConstraint.constant = 40;
        self.registerBtn.hidden = NO;
        self.channelHeightConstraint.constant = 0;
        self.channelBtn.hidden = YES;
        needShowAgain = YES;
    }
    if (channelStatus == -1) {
        // 无渠道 隐藏注册按钮、显示渠道按钮
        self.registerHeightConstraint.constant = 0;
        self.registerBtn.hidden = YES;
        self.channelHeightConstraint.constant = 40;
        self.channelBtn.hidden = NO;
        needShowAgain = YES;
    }
    if (channelStatus == 1) {
        // 有渠道 隐藏注册按钮、隐藏渠道按钮
        self.registerHeightConstraint.constant = 0;
        self.registerBtn.hidden = YES;
        self.channelHeightConstraint.constant = 0;
        self.channelBtn.hidden = YES;
        needShowAgain = YES;
    }
    return needShowAgain;
}

- (void)showAgain {
    // 判断4A和渠道
    if ([self checkStatus]) {
        self.hidden = NO;
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - 点击事件
- (IBAction)hideAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *key = [NSString stringWithFormat:@"%@+%@", ShowAuthTipView, CurrentUser.mobile];
    if (sender.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:key];
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)manager4AAction:(UIButton *)sender {
    NSLog(@"跳转4A认证");
    self.hidden = YES;
    CertificateVC_SX *certificateVC = [[CertificateVC_SX alloc] init];
    certificateVC.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@",self.fatherVC);
    [self.fatherVC.navigationController pushViewController:certificateVC animated:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    NSLog(@"跳转注册千店万员");
    self.hidden = YES;
    ShopperRegisterVC *registerVC = [[ShopperRegisterVC alloc] init];
    registerVC.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@", self.fatherVC);
    [self.fatherVC.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)managerChannelAction:(UIButton *)sender {
    NSLog(@"跳转渠道管理");
    self.hidden = YES;
    ManagerChannelVC *managerChannelVC = [[ManagerChannelVC alloc] init];
    managerChannelVC.hidesBottomBarWhenPushed = YES;
    [self.fatherVC.navigationController pushViewController:managerChannelVC animated:YES];
}

@end
