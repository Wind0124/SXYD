//
//  Auth4AVC.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Auth4AVC.h"

@interface Auth4AVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation Auth4AVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"增加授权";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    
    self.phoneTF.delegate = self;
    
    self.smsCodeBtn.layer.cornerRadius = self.smsCodeBtn.viewHeight/2;
    self.smsCodeBtn.layer.borderWidth = 1;
    self.smsCodeBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.smsCodeBtn.layer.masksToBounds = YES;
//#if ENVIRONMENT == 0
//    self.nameTF.text = @"Feng";
//    self.phoneTF.text = @"13888888888";
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
- (IBAction)smsCodeAction:(UIButton *)sender {
    NSLog(@"发送验证码");
    NSString *phoneString = self.phoneTF.text;
    [sender setTitle:@"60s后重发" forState:UIControlStateNormal];
    sender.enabled = NO;
    self.num = 60;
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    // 获取验证码请求
    NSDictionary *para = @{@"mobile": phoneString,
                           @"type": @"7",
                           };
    [VPAPI getSmsCodeWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
                [self alertWithMessage:@"验证码发送成功"];
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
    NSLog(@"确认授权");
    NSLog(@"调接口");
    NSString *nameString = self.nameTF.text;
    NSString *phoneString = self.phoneTF.text;
    NSString *smsCodeString = self.smsCodeTF.text;
    if (nameString.length == 0) {
        NSLog(@"没用户名");
        [self alertWithMessage:@"请输入用户名"];
        return;
    }
    if (!phoneString.isMobile) {
        NSLog(@"错误手机号");
        [self alertWithMessage:@"请输入正确手机号"];
        return;
    }
//    if (!smsCodeString.isMessCode) {
//        NSLog(@"错误验证码格式");
//        [self alertWithMessage:@"验证码格式不正确"];
//        return;
//    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:nameString forKey:@"name"];
    [parameters setValue:phoneString forKey:@"mobile"];
    [parameters setValue:smsCodeString forKey:@"smsCode"];
    [parameters setValue:CurrentUser.employeeNumber forKey:@"employeeNumber"];
    [VPAPI authorizeUserWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            [self alertWithMessage:@"授权成功" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 0;
    if (textField == self.phoneTF) {
        maxLength = 11;
    } else {
        return YES;
    }
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger caninputlen = maxLength - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

#pragma mark - 监听
- (void)textChangeCheck {
    if (self.nameTF.text.length > 0 && self.phoneTF.text.length > 0 && self.smsCodeTF.text.length > 0) {
        self.confirmBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.confirmBtn.enabled = NO;
    }
}


@end
