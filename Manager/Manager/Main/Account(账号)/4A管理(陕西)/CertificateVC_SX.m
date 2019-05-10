//
//  CertificateVC_SX.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "CertificateVC_SX.h"

@interface CertificateVC_SX ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation CertificateVC_SX

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"4A认证";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    self.smsCodeBtn.layer.cornerRadius = self.smsCodeBtn.viewHeight/2;
    self.smsCodeBtn.layer.borderWidth = 1;
    self.smsCodeBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.smsCodeBtn.layer.masksToBounds = YES;
    
//#if ENVIRONMENT == 0
//    self.accountTF.text = @"abcdefg";
//    self.passwordTF.text = @"123456";
//    self.smsCodeTF.text = @"1234";
//    self.confirmBtn.backgroundColor = hexStringToColor(@"0084CF");
//    self.confirmBtn.enabled = YES;
//#endif

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self.view endEditing:YES];
}

#pragma mark - 按钮
- (IBAction)pictureAction:(UIButton *)sender {
    NSLog(@"获取图片验证码");
    
}

- (IBAction)smsCodeAction:(UIButton *)sender {
    NSLog(@"发送验证码");
    NSString *accountString = self.accountTF.text;
    NSString *passwordString = self.passwordTF.text;
    if (accountString.length == 0 ) {
        NSLog(@"没账号");
        [self alertWithMessage:@"请输入账号"];
        return;
    }
    if (passwordString.length == 0) {
        NSLog(@"错误密码格式");
        [self alertWithMessage:@"请输入4A密码"];
        return;
    }
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
        if (successed) {
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
        [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.smsCodeBtn.enabled = YES;
    } else {
        self.num -= 1;
        [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"%lds后重发", self.num] forState:UIControlStateNormal];
    }
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSLog(@"确认认证");
    NSString *accountString = self.accountTF.text;
    NSString *phoneString = CurrentUser.mobile;
    NSString *passwordString = self.passwordTF.text;
    NSString *smsString = self.smsCodeTF.text;
    if (accountString.length == 0) {
        NSLog(@"没账号");
        [self alertWithMessage:@"请输入账号"];
        return;
    }
    if (passwordString.length == 0) {
        NSLog(@"错误密码格式");
        [self alertWithMessage:@"请输入4A密码"];
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
    // 4A认证请求
    [VPAPI auth4AWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            CurrentUser.authAccountNameString = self.accountTF.text;
            CurrentUser.passwordString = self.passwordTF.text;
            CurrentUser.crmStatus = @1;
            [CurrentUser archive];
            [self alertWithMessage:@"认证成功" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - 监听
- (void)textChangeCheck {
    if (self.accountTF.text.length > 0 && self.passwordTF.text.length > 0 && self.smsCodeTF.text.length > 0) {
        self.confirmBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.confirmBtn.enabled = NO;
    }
}

@end
