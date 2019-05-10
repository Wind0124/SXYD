//
//  UserAuthenticationView.m
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "UserAuthenticationView.h"
#import "InputBoxView.h"

@interface UserAuthenticationView()

@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *whiteView;
@property (nonatomic, strong) UILabel  *titleLbl;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) InputBoxView *phoneView;
@property (nonatomic, strong) InputBoxView *smsCodeView;

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@end

@implementation UserAuthenticationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgView];
        [self addSubview:self.whiteView];
        [self.whiteView addSubview:self.titleLbl];
        [self.whiteView addSubview:self.closeBtn];
        [self.whiteView addSubview:self.lineView];
        [self.whiteView addSubview:self.phoneView];
        [self.whiteView addSubview:self.smsCodeView];
        [self.whiteView addSubview:self.sendBtn];
        [self.whiteView addSubview:self.loginBtn];
        
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
//        self.loginBlock = loginBlock;
//        self.closeBlock = closeBlock;
//        self.changeBlock = changeBlock;
//#if ENVIRONMENT == 0
//        self.phoneView.inputTF.text = @"13909574917";
//        self.smsCodeView.inputTF.text = @"1234";
//#endif
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - 监听键盘
- (void)keyboardShow:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"键盘高度：%.2f", frame.size.height);
    CGRect whiteFrame = self.whiteView.frame;
    self.whiteView.frame = CGRectMake(whiteFrame.origin.x, (SCREEN_HEIGHT - frame.size.height - whiteFrame.size.height), whiteFrame.size.width, whiteFrame.size.height);
}

- (void)keyboardHide:(NSNotification *)notification {
//    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect whiteFrame = self.whiteView.frame;
    self.whiteView.frame = CGRectMake(whiteFrame.origin.x, (SCREEN_HEIGHT - whiteFrame.size.height), whiteFrame.size.width, whiteFrame.size.height);
}

#pragma mark - 内部事件
//关闭鉴权
-(void)closeViewAction{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self removeFromSuperview];
}

- (void)sendSMSCodeAction:(UIButton *)sender {
    if (!self.phoneView.inputTF.text.isMobile) {
        [self.phoneView.inputTF becomeFirstResponder];
        NSLog(@"手机号错误");
        [self showWithMessage:@"请输入正确手机号"];
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
                           @"graderId": @"579510467530067997",
                           };
    [VPAPI getUserAuthSmsCodeWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self showWithMessage:message];
            self.num = -1;
//            [self alertWithMessage:message];
        } else {
            if (successed) {
//            [self alertWithMessage:@"验证码发送成功"];
                [self showWithMessage:@"验证码发送成功"];
            } else {
                [self showWithMessage:@"验证码发送失败"];
                self.num = -1;
            }
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

//用户鉴权登录
-(void)loginActionInUserAuthenticationView{
    if (!self.phoneView.inputTF.text.isMobile) {
        [self.phoneView.inputTF becomeFirstResponder];
        NSLog(@"手机号错误");
        [self showWithMessage:@"请输入正确手机号"];
        return;
    }
    if (self.smsCodeView.inputTF.text.length == 0) {
        [self.smsCodeView.inputTF becomeFirstResponder];
        NSLog(@"验证码错误");
        [self showWithMessage:@"请输入验证码"];
        return;
    }
    // 登录
    NSDictionary *para = @{@"mobile": self.phoneView.inputTF.text,
                           @"graderId": @"579510467530067997",
                           @"verificationCode": self.smsCodeView.inputTF.text,
                           };
    [VPAPI UserAuth:para block:^(BOOL successed, HeadModel *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self showWithMessage:message];
//            [self alertWithMessage:message];
        } else {
            if (successed) {
                // 登录成功
                if (self.UserAuthViewBlock) {
                    self.UserAuthViewBlock(self.phoneView.inputTF.text);
                }
                [self closeViewAction];
            } else {
                [self showWithMessage:@"用户登录失败"];
            }
        }
    }];
}

#pragma mark - 懒加载
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.7;
    }
    return _bgView;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 230, SCREEN_WIDTH, 230)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _titleLbl.font = [UIFont systemFontOfSize:17];
        _titleLbl.text = @"用户鉴权";
        _titleLbl.textColor = hexStringToColor(@"414141");
        _titleLbl.textAlignment = 1;
    }
    return _titleLbl;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40)];
        [_closeBtn setImage:[UIImage imageNamed:@"WorkTable_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleLbl.frame), SCREEN_HEIGHT, 1)];
        _lineView.backgroundColor = hexStringToColor(@"DFDFDF");
    }
    return _lineView;
}

- (InputBoxView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[InputBoxView alloc] initWithFrame:CGRectMake(-20, CGRectGetMaxY(self.titleLbl.frame), SCREEN_WIDTH + 40, 50)];
        _phoneView.inputTF.placeholder = @"请输入办理号码";
        _phoneView.titleLabel.text = @"手机号";
        _phoneView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneView;
}

- (InputBoxView *)smsCodeView {
    if (!_smsCodeView) {
        _smsCodeView = [[InputBoxView alloc] initWithFrame:CGRectMake(-20, CGRectGetMaxY(self.phoneView.frame) + 10, SCREEN_WIDTH + 40, 50)];
        _smsCodeView.inputTF.placeholder = @"请输入验证码";
        _smsCodeView.titleLabel.text = @"验证码";
        _smsCodeView.inputTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _smsCodeView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(SCREEN_WIDTH - 130, self.smsCodeView.frame.origin.y + 10, 100, 30);
        [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendBtn.layer.cornerRadius = _sendBtn.frame.size.height / 2;
        _sendBtn.layer.borderWidth = 1;
        _sendBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendSMSCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(UIButton*)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.smsCodeView.frame) + 20, SCREEN_WIDTH - 30, 44)];
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.backgroundColor = hexStringToColor(@"#0084CF");
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_loginBtn setTitle:@"登录" forState:0];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_loginBtn addTarget:self action:@selector(loginActionInUserAuthenticationView) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)showWithMessage:(NSString *)message {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    hud.detailsLabel.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0f];
}
@end
