//
//  ModifyPwdVC.m
//  Manager
//
//  Created by vpclub on 2018/12/17.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ModifyPwdVC.h"

@interface ModifyPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *modifyPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *modifyPwdTF2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation ModifyPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 监听输入框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeCheck) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.oldPwdTF resignFirstResponder];
    [self.modifyPwdTF resignFirstResponder];
    [self.modifyPwdTF2 resignFirstResponder];
    self.editing = NO;
}


- (IBAction)submitAction:(UIButton *)sender {
    NSLog(@"发送忘记密码");
    if (![self.modifyPwdTF.text isEqualToString:self.modifyPwdTF2.text]) {
        [self alertWithMessage:@"密码不一致"];
        return;
    }
    NSDictionary *para = @{@"oldPwd": [[MyMD5 md5:self.oldPwdTF.text] lowercaseString],
                           @"newPwd": [[MyMD5 md5:self.modifyPwdTF.text] lowercaseString],
                           };
    [VPAPI modifyPasswordWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showWithMessage:@"修改密码成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

- (void)textChangeCheck {
    if (self.oldPwdTF.text.length > 0 && self.modifyPwdTF.text.length > 0 && self.modifyPwdTF2.text.length > 0) {
        self.submitBtn.backgroundColor = hexStringToColor(@"0084CF");
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.backgroundColor = hexStringToColor(@"DFDFDF");
        self.submitBtn.enabled = NO;
    }
}
@end
