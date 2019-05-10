//
//  ForgotPwdVC.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "ForgotPwdVC.h"
#import "InputBoxView.h"

@interface ForgotPwdVC ()
@property (weak, nonatomic) IBOutlet InputBoxView *phoneView;
@property (weak, nonatomic) IBOutlet InputBoxView *smsCodeView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet InputBoxView *passwordView;
@property (weak, nonatomic) IBOutlet InputBoxView *passwordView2;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation ForgotPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    
    self.phoneView.inputTF.placeholder = @"手机号";
    self.phoneView.titleLabel.text = @"账号";
    self.phoneView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneView.inputTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.phoneView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.smsCodeView.inputTF.placeholder = @"验证码";
    self.smsCodeView.titleLabel.text = @"验证码";
    self.smsCodeView.inputTF.keyboardType = UIKeyboardTypePhonePad;
//    self.smsCodeView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.smsCodeView bringSubviewToFront:self.sendBtn];
    
    self.passwordView.inputTF.placeholder = @"请输入新密码";
    self.passwordView.titleLabel.text = @"新密码";
    self.passwordView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    self.passwordView.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordView2.inputTF.placeholder = @"请再次输入新密码";
    self.passwordView2.titleLabel.text = @"新密码";
    self.passwordView2.inputTF.keyboardType = UIKeyboardTypePhonePad;
    self.passwordView2.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
//#if ENVIRONMENT == 0
//    self.phoneView.inputTF.text = @"13691912998";
//    self.smsCodeView.inputTF.text = @"1234";
//    self.passwordView.inputTF.text = @"123456";
//    self.passwordView2.inputTF.text = @"123456";
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneView.inputTF resignFirstResponder];
    [self.smsCodeView.inputTF resignFirstResponder];
    self.editing = NO;
}

#pragma mark - 内部按钮方法

- (IBAction)sendSMSCodeAction:(UIButton *)sender {
    if (!self.phoneView.inputTF.text.isMobile) {
        [self.phoneView.inputTF becomeFirstResponder];
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
    NSDictionary *para = @{@"mobile": self.phoneView.inputTF.text,
                           @"type": @"2",
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
        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendBtn.enabled = YES;
    } else {
        self.num -= 1;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%lds后重发", self.num] forState:UIControlStateNormal];
    }
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSLog(@"发送忘记密码");
    if (![self.passwordView.inputTF.text isEqualToString:self.passwordView2.inputTF.text]) {
        [self alertWithMessage:@"密码不一致"];
        return;
    }
    NSDictionary *para = @{@"mobile": self.phoneView.inputTF.text,
                           @"pwd": [[MyMD5 md5:self.passwordView2.inputTF.text] lowercaseString],
                           @"smsCode" : self.smsCodeView.inputTF.text,
                           };
    [VPAPI resetPasswordWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            [self alertWithMessage:@"重置密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITextField
- (void)textChangeCheck {
    if (self.phoneView.inputTF.text.length > 0 && self.smsCodeView.inputTF.text.length > 0 && self.passwordView.inputTF.text.length > 0 && self.passwordView2.inputTF.text.length > 0) {
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
