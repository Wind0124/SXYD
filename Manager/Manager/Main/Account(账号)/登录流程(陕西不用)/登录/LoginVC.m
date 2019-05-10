//
//  LoginVC.m
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "LoginVC.h"
#import "InputBoxView.h"
#import "ForgotPwdVC.h"
#import "CertificateVC.h"
#import "EmployeeVC.h"
#import "WUGesturesUnlockViewController.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet InputBoxView *phoneView;
@property (weak, nonatomic) IBOutlet InputBoxView *passwordView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, assign) BOOL isForceLogin;// 是否要强制登录

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.phoneView.inputTF.placeholder = @"手机号";
    self.phoneView.titleLabel.text = @"手机";
    self.phoneView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneView.inputTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.phoneView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordView.inputTF.placeholder = @"登录密码";
    self.passwordView.titleLabel.text = @"密码";
    self.passwordView.inputTF.secureTextEntry = YES;
    self.passwordView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    self.passwordView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;

//#if ENVIRONMENT == 0
//    self.phoneView.inputTF.text = @"18800000002";
//    self.passwordView.inputTF.text = @"123456";
//    self.loginBtn.backgroundColor = hexStringToColor(@"0084CF");
//    self.loginBtn.enabled = YES;
//#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 监听输入框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeCheck) name:UITextFieldTextDidChangeNotification object:nil];
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneView.inputTF resignFirstResponder];
    [self.passwordView.inputTF resignFirstResponder];
    self.editing = NO;
}

#pragma mark - 监听键盘
- (void)keyboardShow:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"键盘高度：%.2f", frame.size.height);
    if (CGRectGetMaxY(self.passwordView.frame) > frame.origin.y) {
        CGRect viewFrame = self.view.frame;
        self.view.frame = CGRectMake(0, (-frame.size.height + 50), viewFrame.size.width, viewFrame.size.height);
    }
}

- (void)keyboardHide:(NSNotification *)notification {
    //    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewFrame = self.view.frame;
    self.view.frame = CGRectMake(viewFrame.origin.x, 0, viewFrame.size.width, viewFrame.size.height);
}

#pragma mark - 内部方法

- (IBAction)gestureLoginAction:(UIButton *)sender {
    NSLog(@"手势登录");
    if (self.isFromGestureController) {
        // dismiss控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self alertWithMessage:@"请先登录，首次登录成功后可先设置手势密码"];
//        WUGesturesUnlockViewController *gestureVC = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
//        [self.navigationController pushViewController:gestureVC animated:YES];
    }
}

- (IBAction)forgetPassword:(UIButton *)sender {
    NSLog(@"忘记密码");
    ForgotPwdVC *forgetVC = [[ForgotPwdVC alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    NSLog(@"开始登录");
    NSString *phoneString = self.phoneView.inputTF.text;
    NSString *passwordString = self.passwordView.inputTF.text;
    if ([self checkPhoneNumber:phoneString passwrod:passwordString]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:phoneString forKey:@"mobile"];
        [parameters setValue:[[MyMD5 md5:passwordString] lowercaseString] forKey:@"pwd"];
        if (self.isForceLogin) {
            [parameters setValue:@"true" forKey:@"forceLogin"];
        }
        NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [parameters setValue:deviceId forKey:@"deviceId"];
        NSString *deviceModel = [NSString deviceModel];
        [parameters setValue:deviceModel forKey:@"deviceModel"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
        [VPAPI loginWithDic:parameters block:^(BaseModel *object, HeadModel *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            if (error) {
                NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
                [self alertWithMessage:message];
            } else {
                CurrentUser.mobile = self.phoneView.inputTF.text;
                CurrentUser.passwordString = self.passwordView.inputTF.text;
                [CurrentUser archive];
                NSLog(@"用户数据：%@",CurrentUser);
                [self verificat4A];
                return ;
                // 有登录过
                if ([CurrentUser.isLogged isEqualToString:@"true"]) {
                    NSString *message = [NSString stringWithFormat:@"您的账号在%@设备登录，是否强制退出", CurrentUser.deviceModel];
                    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"退出提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertCtl addAction:cancelAction];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        self.isForceLogin = YES;
                        [self loginAction:self.loginBtn];
                    }];
                    [alertCtl addAction:confirmAction];
                    [self presentViewController:alertCtl animated:YES completion:nil];
                } else {
                    [self verificat4A];
                }
            }
        }];
    }
}

// 是否4A认证
- (void)verificat4A {
    // 未4A认证
    if ([CurrentUser.isCertified isEqualToString:@"false"]) {
        CertificateVC *certificateVC = [[CertificateVC alloc] init];
        [self.navigationController pushViewController:certificateVC animated:YES];
    } else {
        // 创建手势
        WUGesturesUnlockViewController *gestureVC = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
        [self.navigationController pushViewController:gestureVC animated:YES];
    }
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber passwrod:(NSString *)password {
    if (!phoneNumber.isMobile) {
        NSLog(@"错误手机号");
        [self alertWithMessage:@"请输入正确手机号"];
        return NO;
    }
    if (!password.isPassWord) {
        NSLog(@"错误密码格式");
        [self alertWithMessage:@"密码格式不正确"];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField
- (void)textChangeCheck {
    if (self.phoneView.inputTF.text.length > 0 && self.passwordView.inputTF.text.length > 0) {
        self.loginBtn.backgroundColor = hexStringToColor(@"0084CF");
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.loginBtn.enabled = NO;
    }
}

#pragma mark - 控制器管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
