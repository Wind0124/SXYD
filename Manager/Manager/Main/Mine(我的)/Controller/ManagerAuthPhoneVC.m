//
//  ManagerAuthPhoneVC.m
//  Manager
//
//  Created by vpclub on 2019/3/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "ManagerAuthPhoneVC.h"

@interface ManagerAuthPhoneVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *auth4APhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiveMsgPhoneTF;

@property (nonatomic, strong) NSString *oldReceiveMsgPhone;
@end

@implementation ManagerAuthPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"认证管理";
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = hexStringToColor(@"D4D4D4").CGColor;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;
    
    self.receiveMsgPhoneTF.delegate = self;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.size = CGSizeMake(20, 20);
    [btn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self getPhoneData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 点击事件
- (void)finish {
    NSLog(@"修改接收短信号码");
    [self.view endEditing:YES];
    if (self.receiveMsgPhoneTF.text.length != 11) {
        [self alertWithMessage:@"请输入正确手机号"];
        return;
    }
    if ([self.receiveMsgPhoneTF.text isEqualToString:self.oldReceiveMsgPhone]) {
        [self alertWithMessage:@"请输入不一样的接收工单短信手机号"];
        return;
    }
    // 调设置手机号接口
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSDictionary *para = @{@"str": self.receiveMsgPhoneTF.text};
    [VPAPI saveAcceptOrderMobileWithDic:para block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            [self alertWithMessage:@"保存成功"];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - 网络请求
// 获取两个手机号
- (void)getPhoneData {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI QueryAcceptOrderMobileWithBlock:^(NSDictionary *dic, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (dic) {
            self.auth4APhoneLabel.text = [dic objectForKey:@"crmPhoneNumber"];
            self.receiveMsgPhoneTF.text = [dic objectForKey:@"acceptOrderPhoneNumber"];
            self.oldReceiveMsgPhone = [dic objectForKey:@"acceptOrderPhoneNumber"];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 0;
    if (textField == self.receiveMsgPhoneTF) {
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

@end
