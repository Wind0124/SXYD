//
//  LoginVC_SX.m
//  Manager
//
//  Created by vpclub on 2018/12/19.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "LoginVC_SX.h"

@interface LoginVC_SX ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation LoginVC_SX

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneTF.delegate = self;
    
    self.smsBtn.layer.cornerRadius = self.smsBtn.viewHeight/2;
    self.smsBtn.layer.borderWidth = 1;
    self.smsBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.smsBtn.layer.masksToBounds = YES;
    
//#if ENVIRONMENT == 0
//    self.phoneTF.text = @"18292492625";// 18291452416
//    self.smsCodeTF.text = @"1234";
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
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTF resignFirstResponder];
    [self.smsCodeTF resignFirstResponder];
    self.editing = NO;
}

#pragma mark - 内部点击
- (IBAction)getSmsCodeAction:(UIButton *)sender {
    NSString *phoneString = self.phoneTF.text;
    if (phoneString.length == 0 ) {
        NSLog(@"没手机号");
        [self alertWithMessage:@"请输入手机号"];
        return;
    }
    if (!phoneString.isMobile) {
        NSLog(@"错误手机号");
        [self alertWithMessage:@"请输入正确手机号"];
        return;
    }
    NSLog(@"发送验证码");
    [sender setTitle:@"60s后重发" forState:UIControlStateNormal];
    sender.enabled = NO;
    self.num = 60;
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    // 获取验证码请求
    NSDictionary *para = @{@"mobile": self.phoneTF.text,
                           @"type": @"4",
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
        [self.smsBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.smsBtn.enabled = YES;
    } else {
        self.num -= 1;
        [self.smsBtn setTitle:[NSString stringWithFormat:@"%lds后重发", self.num] forState:UIControlStateNormal];
    }
}

- (IBAction)loginAction:(UIButton *)sender {
    NSLog(@"开始登录");
    NSString *phoneString = self.phoneTF.text;
    NSString *smsCodeString = self.smsCodeTF.text;
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
    [parameters setValue:phoneString forKey:@"mobile"];
    [parameters setValue:smsCodeString forKey:@"smsCode"];
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [parameters setValue:deviceId forKey:@"deviceId"];
    NSString *deviceModel = [NSString deviceModel];
    [parameters setValue:deviceModel forKey:@"deviceModel"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI smsLoginWithDic:parameters block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            // 保存数据
            CurrentUser.mobile = phoneString;
            [CurrentUser archive];
            NSLog(@"%@", CurrentUser);
            // 获取用户信息
            [self getUserInfo];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

- (void)getUserInfo {
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI getUserInfo:^(BOOL succeeded, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GetHomePageBanner object:nil];
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

#pragma mark - UITextField
- (void)textChangeCheck {
    if (self.phoneTF.text.length > 0 && self.smsCodeTF.text.length > 0) {
        self.loginBtn.backgroundColor = hexStringToColor(@"0084CF");
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.loginBtn.enabled = NO;
    }
}

#pragma mark - 监听键盘
- (void)keyboardShow:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"键盘高度：%.2f", frame.size.height);
    if (CGRectGetMaxY(self.loginBtn.frame) > frame.origin.y) {
        CGRect viewFrame = self.view.frame;
        // 上移距离 = 键盘高度-（页面高度 - 按钮底部）
        CGFloat gap = frame.size.height - (self.view.viewHeight - CGRectGetMaxY(self.loginBtn.frame));
        self.view.frame = CGRectMake(0, (-gap), viewFrame.size.width, viewFrame.size.height);
    }
}

- (void)keyboardHide:(NSNotification *)notification {
    //    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewFrame = self.view.frame;
    self.view.frame = CGRectMake(viewFrame.origin.x, 0, viewFrame.size.width, viewFrame.size.height);
}

@end
