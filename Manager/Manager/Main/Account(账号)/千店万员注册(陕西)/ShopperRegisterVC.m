//
//  ShopperRegisterVC.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopperRegisterVC.h"
#import "SelectCityView.h"

@interface ShopperRegisterVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSMutableArray *cityArray;// 城市列表
@property (nonatomic, assign) NSInteger citySelectIndex;// 选中的城市
@property (nonatomic, strong) ChannelModel *channelModel;// 要绑定的渠道
@end

@implementation ShopperRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"千店万员注册";
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.smsCodeBtn.layer.cornerRadius = self.smsCodeBtn.viewHeight/2;
    self.smsCodeBtn.layer.borderWidth = 1;
    self.smsCodeBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.smsCodeBtn.layer.masksToBounds = YES;

    self.citySelectIndex = -1;
    self.phoneLabel.text = CurrentUser.mobile;
    // 先隐藏渠道view
    self.channelViewHeightConstraint.constant = 0;
    [self getCityList];
    
//#if ENVIRONMENT == 0
//    self.nameTF.text = @"测试员";
//    self.smsCodeTF.text = @"1234";
//#endif
}

- (void)endEdit {
    [self.view endEditing:YES];
}

#pragma mark - 网路请求
// 获取城市列表
- (void)getCityList {
    [VPAPI2 getShanXiCityWithBlcok:^(NSArray *objects, HeadModel *error) {
        if (objects) {
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:objects];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

#pragma mark - 按钮点击
// 获取验证码
- (IBAction)smsCodeAction:(UIButton *)sender {
    NSLog(@"发送验证码");
    [sender setTitle:@"60s后重发" forState:UIControlStateNormal];
    sender.enabled = NO;
    self.num = 60;
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    // 获取验证码请求
    NSDictionary *para = @{@"mobile": self.phoneLabel.text,
                           @"type": @"1",
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

// 倒计时
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

// 选择城市
- (IBAction)selectCityAction:(UIButton *)sender {
    [self.view endEditing:YES];
    SelectCityView *cityView = [[SelectCityView alloc] initWithNib];
    cityView.cityArray = self.cityArray;
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    cityView.selectCityBlock = ^(NSInteger index) {
        NSLog(@"选中了第%zd个城市", index);
        self.citySelectIndex = index;
        ChannelModel *model = self.cityArray[index];
        [self.cityBtn setTitle:model.cityName forState:UIControlStateNormal];
    };
    [dele.window addSubview:cityView];
}

- (IBAction)searchAction:(UIButton *)sender {
    if (self.citySelectIndex < 0) {
        [self showWithMessage:@"请选择城市"];
        return;
    }
    if (self.searchTF.text.length == 0) {
        [self showWithMessage:@"请输入渠道编码"];
        return;
    }
    ChannelModel *cityModel = self.cityArray[self.citySelectIndex];
    NSDictionary *para = @{@"channelCode" : self.searchTF.text,
                           @"cityCode" : cityModel.cityCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 getChannelListWithDic:para block:^(NSArray *objects, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (objects) {
            if (objects.count >= 1) {
                self.channelModel = (ChannelModel *)objects[0];
                self.channelViewHeightConstraint.constant = 50;
                self.channelLabel.text = [NSString stringWithFormat:@"【%@】【%@】%@",self.channelModel.channelCode, self.channelModel.channelId, self.channelModel.channelName];
            } else {
                [self alertWithMessage:@"未搜索到渠道"];
            }
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

- (IBAction)confirmAction:(UIButton *)sender {
    if (self.nameTF.text.length == 0 || self.smsCodeTF.text == 0) {
        [self showWithMessage:@"请填写完整信息"];
        return;
    }
    if (!self.channelModel) {
        [self showWithMessage:@"请搜索要绑定的渠道"];
        return;
    }
    NSLog(@"开始注册");
    ChannelModel *cityModel = self.cityArray[self.citySelectIndex];
    NSDictionary *para = @{@"channelCode" : self.channelModel.channelCode,
                           @"cityCode" : cityModel.cityCode,
                           @"name": self.nameTF.text,
                           @"smsCode": self.smsCodeTF.text,
                           };
    [VPAPI registerClerkWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            CurrentUser.channelStatus = @1;
            [CurrentUser archive];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
@end
