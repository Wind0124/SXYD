//
//  CertificateVC.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "CertificateVC.h"
#import "InputBoxView.h"
#import "EmployeeVC.h"

@interface CertificateVC ()

@property (weak, nonatomic) IBOutlet InputBoxView *accountView;

@property (weak, nonatomic) IBOutlet InputBoxView *passwordView;
@property (weak, nonatomic) IBOutlet InputBoxView *smsCodeView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation CertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"4A认证";
    self.accountView.inputTF.placeholder = @"4A账号";
    self.accountView.titleLabel.text = @"账号";
    [self.accountView.inputTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.accountView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordView.inputTF.placeholder = @"登录密码";
    self.passwordView.titleLabel.text = @"密码";
    self.passwordView.inputTF.secureTextEntry = YES;
    self.passwordView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.smsCodeView.inputTF.placeholder = @"验证码";
    self.smsCodeView.titleLabel.text = @"验证码";
    self.smsCodeView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    [self.smsCodeView bringSubviewToFront:self.sendBtn];
    
//#if ENVIRONMENT == 0
//    self.accountView.inputTF.text = @"yanwenfeng";
//    self.passwordView.inputTF.text = @"ywf_1001";
//    self.smsCodeView.inputTF.text = @"1234";
//    self.confirmBtn.backgroundColor = hexStringToColor(@"0084CF");
//    self.confirmBtn.enabled = YES;
//#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 监听输入框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeCheck) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountView.inputTF resignFirstResponder];
    [self.passwordView.inputTF resignFirstResponder];
    [self.smsCodeView.inputTF resignFirstResponder];
    self.editing = NO;
}

#pragma mark - 内部按钮方法

- (IBAction)sendSMSCodeAction:(UIButton *)sender {
    NSString *accountString = self.accountView.inputTF.text;
//    NSString *phoneString = self.phoneView.inputTF.text;
    NSString *passwordString = self.passwordView.inputTF.text;
    if (accountString.length == 0 ) {
        NSLog(@"没账号");
        [self alertWithMessage:@"请输入账号"];
        return;
    }
//    if (!phoneString.isMobile) {
//        NSLog(@"错误手机号");
//        [self alertWithMessage:@"请输入正确手机号"];
//        return;
//    }
    if (passwordString.length == 0) {
        NSLog(@"错误密码格式");
        [self alertWithMessage:@"请输入密码"];
        return;
    }
    NSLog(@"发送验证码");
    [sender setTitle:@"60s后重发" forState:UIControlStateNormal];
    sender.enabled = NO;
    self.num = 60;
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    // 获取4A认证 验证码
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:accountString forKey:@"account"];
    [parameters setValue:passwordString forKey:@"password"];
    [VPAPI getCertificateSMSCodeWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        if (YES) {
            [self alertWithMessage:@"发送验证码成功"];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
            self.num = -1;
        }
    }];
}

- (void)countDown {
    if (self.num <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendBtn.enabled = YES;
    } else {
        self.num -= 1;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%lds后重发", self.num] forState:UIControlStateNormal];
    }
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSLog(@"发送4A认证");
    NSString *accountString = self.accountView.inputTF.text;
    NSString *phoneString = CurrentUser.mobile;
    NSString *passwordString = self.passwordView.inputTF.text;
    NSString *smsString = self.smsCodeView.inputTF.text;
    if (accountString.length == 0) {
        NSLog(@"没账号");
        [self alertWithMessage:@"请输入账号"];
        return;
    }
    if (!phoneString.isMobile) {
        NSLog(@"错误手机号");
        [self alertWithMessage:@"请输入正确手机号"];
        return;
    }
    if (passwordString.length == 0) {
        NSLog(@"错误密码格式");
        [self alertWithMessage:@"请输入密码"];
        return;
    }
//    if (!smsString.isMessCode) {
//        NSLog(@"错误验证码");
//        [self alertWithMessage:@"验证码格式不正确"];
//        return;
//    }
    NSDictionary *para = @{@"account": accountString,
                           @"mobile" : phoneString,
                           @"pwd": passwordString,
                           @"smsCode" : smsString,
                           };
//     4A认证请求
    [VPAPI auth4AWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            CurrentUser.authAccountNameString = self.accountView.inputTF.text;
            CurrentUser.passwordString = self.passwordView.inputTF.text;
            [CurrentUser archive];
//            [self alertWithMessage:@"认证成功"];
            // 选择工号
            EmployeeVC *employeeVC = [[EmployeeVC alloc] init];
            [self.navigationController pushViewController:employeeVC animated:YES];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITextField
- (void)textChangeCheck {
    if (self.accountView.inputTF.text.length > 0 && self.passwordView.inputTF.text.length && self.smsCodeView.inputTF.text.length > 0) {
        self.confirmBtn.backgroundColor = hexStringToColor(@"0084CF");
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.confirmBtn.enabled = NO;
    }
}

#pragma mark - 控制器管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
