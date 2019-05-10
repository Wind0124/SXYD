//
//  WUGestureUnlockViewController.m
//  WUGesturesToUnlock
//
//  Created by wuqh on 16/4/1.
//  Copyright © 2016年 wuqh. All rights reserved.
//

#import "WUGesturesUnlockViewController.h"
#import "WUGesturesUnlockView.h"
#import "WUGesturesUnlockIndicator.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import "EmployeeVC.h"
#import "MineSettingVC.h"
#import "Masonry.h"

#define GesturesPassword @"gesturespassword"


@interface WUGesturesUnlockViewController ()<WUGesturesUnlockViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet WUGesturesUnlockView *gesturesUnlockView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
 //重新绘制按钮
@property (weak, nonatomic) IBOutlet UIButton *otherAcountLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *resetGesturesPasswordButton;

@property (weak, nonatomic) IBOutlet UIImageView *headIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headIconHeightConstraint;

@property (nonatomic) WUUnlockType unlockType;

//要创建的手势密码
@property (nonatomic, copy) NSString *lastGesturePassword;

/*欢迎回来*/
@property (nonatomic, strong)UIImageView *iconImgView;//头像icon
@property (nonatomic, strong)UILabel *welcomeLbl;//欢迎回来uilabel
@property (nonatomic, strong)UILabel *nameLbl;//欢迎回来uilabel

@end

@implementation WUGesturesUnlockViewController

#pragma mark - 类方法

+ (void)deleteGesturesPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturesPassword];
}

#pragma mark - inint
- (instancetype)initWithUnlockType:(WUUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gesturesUnlockView.delegate = self;
    
    self.resetGesturesPasswordButton.hidden = YES;
    switch (_unlockType) {
            // 创建手势密码
        case WUUnlockTypeCreatePwd: {
//            self.gesturesUnlockIndicator.hidden = NO;
            self.otherAcountLoginButton.hidden = YES;
//            self.headIconImageView.hidden = NO;
            self.statusLabel.text = @"首次登录成功 请设置手势密码";
            if (IS_IPHONE_5) {
                self.headIconHeightConstraint.constant = 100;
            }
        }
            break;
            // 验证密码
        case WUUnlockTypeValidatePwd:
        {
//            self.gesturesUnlockIndicator.hidden = YES;
            
            //状态label
            self.statusLabel.hidden = YES;
//            float h = SCREEN_HEIGHT;
//            if (h == 736.0) {
//                //为iphone7P 6P 8P
//                self.statusLblTopConstraint.constant = (50)*layoutBy6();
//            }
            
            //欢迎回来 工号 头像
            [self.view addSubview:self.welcomeLbl];
            [self.view addSubview:self.nameLbl];
            [self.view addSubview:self.iconImgView];
            
            //隐藏之前的logo
            self.headIconHeightConstraint.constant = 100;
            self.headIconImageView.hidden = YES;
            
            [self.otherAcountLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
            [self.otherAcountLoginButton setTitleColor:hexStringToColor(@"0084CF") forState:UIControlStateNormal];
        }
            break;
            // 修改手势密码
        case WUUnlockTypeModifyPwd:
        {
            self.navigationItem.title = @"修改登录手势";
//            self.gesturesUnlockIndicator.hidden = YES;
            self.otherAcountLoginButton.hidden = YES;
            self.headIconHeightConstraint.constant = 60;
            self.headIconImageView.hidden = YES;
            self.statusLabel.text = @"请输入原密码";
        }
            break;
            // 创建新手势密码
        case WUUnlockTypeCreatePwdForModify:
        {
            self.navigationItem.title = @"修改登录手势";
//            self.gesturesUnlockIndicator.hidden = NO;
            self.otherAcountLoginButton.hidden = YES;
            self.headIconHeightConstraint.constant = 60;
            self.headIconImageView.hidden = YES;
            self.statusLabel.text = @"请绘制新手势密码";
        }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_unlockType == WUUnlockTypeModifyPwd || _unlockType == WUUnlockTypeCreatePwdForModify) {
        // 修改手势密码
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - private
//创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPassword {
    // 手势是否有效
    if (self.lastGesturePassword.length == 0) {
        if (gesturesPassword.length < 4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        
        if (self.resetGesturesPasswordButton.hidden == YES) {
            self.resetGesturesPasswordButton.hidden = NO;
        }
        
        self.lastGesturePassword = gesturesPassword;
//        [self.gesturesUnlockIndicator setGesturesPassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制手势密码";
        return;
    }
    // 手势是否一致
    BOOL isSameGesture = [self.lastGesturePassword isEqualToString:gesturesPassword];
    if (!isSameGesture) {
        self.statusLabel.text = @"与上一次绘制不一致，请重新绘制";
        [self shakeAnimationForView:self.statusLabel];
        return;
    }
    //绘制成功
    if (self.unlockType == WUUnlockTypeCreatePwd) {
        // 从登录进入主页面 创建手势成功 保存
        CurrentUser.gesturesPassword = gesturesPassword;
        [CurrentUser archive];
        // 进入选工号界面
        // 选择工号
        EmployeeVC *employeeVC = [[EmployeeVC alloc] init];
        [self.navigationController pushViewController:employeeVC animated:YES];

    } else if (self.unlockType == WUUnlockTypeCreatePwdForModify){
        // 修改手势密码成功 保存
        CurrentUser.gesturesPassword = gesturesPassword;
        [CurrentUser archive];
        // 返回到设置页面
        for (BaseVC *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MineSettingVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

//验证手势密码
- (void)validateGesturesPassword:(NSMutableString *)gesturesPassword {
    // 最多可错5次
    static NSInteger errorCount = 5;
    // 验证密码
    if (self.unlockType == WUUnlockTypeValidatePwd) {
        if ([gesturesPassword isEqualToString:CurrentUser.gesturesPassword]) {
            // 欢迎回来 验证完手势之后进入主页面
            NSLog(@"登录 直接验证密码成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
            [VPAPI handAuth:^(BOOL succeeded, HeadModel *error) {
                if (succeeded) {
                    // 进入主界面
                    NSLog(@"进入主界面");
//                    [self alertWithMessage:@"进入主界面"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GetHomePageBanner object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
                    NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
                    [self alertWithMessage:message];
                }
            }];
        } else {
            if (errorCount <= 1) {//你已经输错五次了！ 退出登陆！
                errorCount = 5;
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"手势密码已失效" message:@"请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [CurrentUser logout];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
                    //进入登录界面
//                    LoginVC * loginVC = [[LoginVC alloc] init];
//                    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
//                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            self.statusLabel.hidden = NO;
            self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
            [self shakeAnimationForView:self.statusLabel];
        }
    }
    // 修改手势密码
    if (self.unlockType == WUUnlockTypeModifyPwd) {
        // 修改手势密码
        if ([gesturesPassword isEqualToString:CurrentUser.gesturesPassword]) {
            // 设置手势解锁
            WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwdForModify];
            [self.navigationController pushViewController:vc animated:YES];
            errorCount = 5;
        } else {
            if (errorCount <= 1) {//你已经输错五次了！ 退出登陆！
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"手势密码已失效" message:@"请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [CurrentUser logout];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
                    //进入登录界面
//                    LoginVC * loginVC = [[LoginVC alloc] init];
//                    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
//                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                errorCount = 5;
                return;
            }
            self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
            [self shakeAnimationForView:self.statusLabel];
        }
    }
}

//抖动动画
- (void)shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark 绑定事件 跳转登录页面
//点击其他账号登陆按钮
- (IBAction)enterLoginPage:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    LoginVC * loginVC = [[LoginVC alloc] init];
    //是否来自手势密码登录
    loginVC.isFromGestureController = YES;
    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//点击重新绘制按钮
- (IBAction)resetGesturePassword:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    self.lastGesturePassword = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetGesturesPasswordButton.hidden = YES;
//    [self.gesturesUnlockIndicator setGesturesPassword:@""];
}

#pragma mark - WUGesturesUnlockViewDelegate
- (void)gesturesUnlockView:(WUGesturesUnlockView *)unlockView drawRectFinished:(NSMutableString *)gesturePassword {
    
    switch (_unlockType) {
        case WUUnlockTypeCreatePwd://创建手势密码
        case WUUnlockTypeCreatePwdForModify://修改手势密码:创建手势密码
        {
            [self createGesturesPassword:gesturePassword];
        }
            break;
            
        case WUUnlockTypeValidatePwd://校验手势密码
        case WUUnlockTypeModifyPwd://修改手势密码: 校验手势密码
        {
            [self validateGesturesPassword:gesturePassword];
        }
            break;

        default:
            break;
    }
}

#pragma mark - 懒加载
- (UILabel *)welcomeLbl{
    if (!_welcomeLbl) {
        _welcomeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 35)];
        _welcomeLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
        _welcomeLbl.textColor = hexStringToColor(@"0084CF");
        _welcomeLbl.text = @"欢迎回来";
        _welcomeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _welcomeLbl;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.welcomeLbl.frame), SCREEN_WIDTH, 20)];
        _nameLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLbl.textColor = hexStringToColor(@"0084CF");
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        NSString *nameString = CurrentUser.employeeNumber ? : @"还没有绑定工号";
        _nameLbl.text = nameString;
    }
    return _nameLbl;
}

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, CGRectGetMaxY(_nameLbl.frame), 80, 80)];
        _iconImgView.backgroundColor = [UIColor grayColor];
        _iconImgView.layer.cornerRadius = 40;
        _iconImgView.layer.masksToBounds = YES;
        NSString *headerImgUrl = CurrentUser.avatar;
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:headerImgUrl] placeholderImage:[UIImage imageNamed:@"icon_common"]];
    }
    return _iconImgView;
}


@end
