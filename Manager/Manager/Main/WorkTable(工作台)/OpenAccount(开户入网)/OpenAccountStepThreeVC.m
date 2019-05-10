//
//  OpenAccountStepThreeVC.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountStepThreeVC.h"
#import "OpenAccountStepCell.h"
#import "StepThree_UserInfoView.h"
#import "PhoneFeeView.h"
#import "PreSaveFeeView.h"
#import "PayStyleView.h"
// 获取SIM卡界面
#import "StepThree_InputSIMVC.h"
// 支付界面
#import "OpenAccountPayVC.h"
// 办理完成
#import "OpenAccountSuccessVC.h"
#import "OpenAccountFailVC.h"

@interface OpenAccountStepThreeVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) OpenAccountStepCell *stepHeadView;

@property (nonatomic, strong) StepThree_UserInfoView *infoView;
@property (nonatomic, strong) UIButton *readSIMBtn;
@property (nonatomic, strong) PhoneFeeView *phoneFeeView;// 手机号费用View
@property (nonatomic, strong) PreSaveFeeView *preSaveFeeView;// 预存金额View
@property (nonatomic, strong) PayStyleView *payStyleView;// 支付方式View

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSString *phoneFee;// 手机号费用
@property (nonatomic, strong) NSString *preSaveFee;// 预存金额
@property (nonatomic, assign) BOOL isPay;// 是否完成支付

@end

@implementation OpenAccountStepThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"号卡绑定";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scrollView];
    
    // 步骤
    [self.scrollView addSubview:self.stepHeadView];
    // 信息
    [self.infoView updateInfoWithCombo:self.openAccountInfo.contractModel.contractConfigureName city:CurrentUser.crmCityName phone:self.openAccountInfo.mobileModel.mobile];
    [self.scrollView addSubview:self.infoView];
    // sim卡
    [self.scrollView addSubview:self.readSIMBtn];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.readSIMBtn.maxY + 20);
    
    [self.view addSubview:self.nextBtn];
    self.nextBtn.hidden = YES;
    
//    // 测试假数据
//    self.openAccountInfo.contractModel.minimumAmount = @"100";
}

#pragma mark - 按钮点击
- (void)readSIMAction {
//    // 测试假数据
//    [self.infoView updateSIMNumber:@"0B0261874588020"];
//    self.openAccountInfo.SIMString = @"0B0261874588020";
//    [self readSIMSuccess];
//    return;
    
    StepThree_InputSIMVC *inputSIMVC = [[StepThree_InputSIMVC alloc] init];
    inputSIMVC.openAccountInfo = [self.openAccountInfo copy];
    [self.navigationController pushViewController:inputSIMVC animated:YES];
    inputSIMVC.inputSIMBlock = ^(NSString * _Nonnull SIMString) {
        // 显示sim号码
        [self.infoView updateSIMNumber:SIMString];
        self.openAccountInfo.SIMString = SIMString;
        [self readSIMSuccess];
    };
}

- (void)readSIMSuccess {
    // 手机号费用
    [self.scrollView addSubview:self.phoneFeeView];
    if (self.openAccountInfo.mobileModel.fee.integerValue != 0) {
        self.phoneFee = self.openAccountInfo.mobileModel.fee;
        [self.phoneFeeView setFeeNumber:[NSString stringWithFormat:@"%.2f", self.openAccountInfo.mobileModel.fee.integerValue / 10000.0]];
    } else {
        self.phoneFee = @"0";
        self.phoneFeeView.viewHeight = 0;
        self.phoneFeeView.hidden = YES;
    }
    self.preSaveFeeView.frame = CGRectMake(0, self.phoneFeeView.maxY, SCREEN_WIDTH, 105);
//    NSLog(@"%@",NSStringFromCGRect(self.phoneFeeView.frame));
    
    // 预存金额
    [self.scrollView addSubview:self.preSaveFeeView];
    if (![self.openAccountInfo.contractModel.minimumAmount isEqualToString:@"0"]) {
        self.preSaveFeeView.fee = self.openAccountInfo.contractModel.minimumAmount;
    } else {
        self.preSaveFee = @"0";
        self.preSaveFeeView.viewHeight = 0;
        self.preSaveFeeView.hidden = YES;
    }
//    NSLog(@"%@",NSStringFromCGRect(self.preSaveFeeView.frame));
    // 支付方式
    [self.scrollView addSubview:self.payStyleView];
    self.payStyleView.frame = CGRectMake(0, self.preSaveFeeView.maxY, SCREEN_WIDTH, 85);
    if (self.phoneFeeView.hidden && self.preSaveFeeView.hidden) {
        // 没有手机费，没有预存费，隐藏支付
        self.payStyleView.viewHeight = 0;
        self.payStyleView.hidden = YES;
        self.isPay = YES;
        [self.nextBtn setTitle:@"激活" forState:UIControlStateNormal];
    }
    // 调整scrollView高度
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.payStyleView.maxY + 20);

    self.readSIMBtn.hidden = YES;
    self.nextBtn.hidden = NO;
}

- (void)nextAction {
//    // 测试假数据
//    // 无支付金额 603664305879027712 603679721733001216
//    // 有支付金额0.01元 603738043316211712  603755752703692800
//    self.openAccountInfo.orderId = @"603755752703692800";
//    [self payAction];
//    return;
    
    NSLog(@"生成订单");
    if (!self.preSaveFee) {
        [self alertWithMessage:@"请选择预存金额"];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:CurrentUser.crmCityCode forKey:@"addressCode"];// 地市编码
    [para setValue:self.openAccountInfo.idModel.birthday forKey:@"birthday"];// 生日
    [para setValue:self.openAccountInfo.model.info_id forKey:@"businessId"];// 业务id
    [para setValue:self.openAccountInfo.idModel.certExpDate forKey:@"certExpDate"];// 身份证失效日期
    [para setValue:self.openAccountInfo.idModel.certValidDate forKey:@"certValidDate"];// 身份证生效日期
    [para setValue:self.openAccountInfo.contractModel.info_id forKey:@"contractId"];// 合约档id
    [para setValue:self.openAccountInfo.idModel.custCertAddr forKey:@"custCertAddr"];// 证件地址
    [para setValue:self.openAccountInfo.idModel.custName forKey:@"custName"];// 客户名称
    [para setValue:self.openAccountInfo.idModel.gender forKey:@"gender"];// 性别
    [para setValue:self.openAccountInfo.idModel.issuingAuthority forKey:@"issuingAuthority"];// 签证机关
    [para setValue:self.openAccountInfo.mobileModel.mobile forKey:@"mobile"];// 开户手机号码
    [para setValue:self.openAccountInfo.idModel.nation forKey:@"nation"];// 民族
    [para setValue:self.openAccountInfo.idModel.psptId forKey:@"psptId"];// 证件号码
    [para setValue:self.openAccountInfo.mobileModel.randomNo forKey:@"randomNo"];// 选占随机号
    [para setValue:self.openAccountInfo.SIMString forKey:@"simCardNo"];// Sim卡号
    float phoneFee = self.phoneFee.floatValue;
    float preSaveFee = self.preSaveFee.floatValue;
    float totalFee = phoneFee + preSaveFee;
    [para setValue:[NSNumber numberWithFloat:totalFee] forKey:@"payMoney"];// 支付金额
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 createOrderWithDic:para block:^(NSString *string, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (string) {
            self.openAccountInfo.orderId = string;
            NSLog(@"订单号：%@",string);
            if (self.isPay) {
                [self submitOrderSuccess];
            } else {
                [self payAction];
            }
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

- (void)payAction {
    NSLog(@"开始支付");
    OpenAccountPayVC *payVC = [[OpenAccountPayVC alloc] init];
    float phoneFee = self.phoneFee.floatValue / 10000.0;
    float preSaveFee = self.preSaveFee.floatValue / 10000.0;
    payVC.totalFee = phoneFee + preSaveFee;
    payVC.openAccountInfo = [self.openAccountInfo copy];
    payVC.openAccountPaySuccessBlock = ^{
        self.isPay = YES;
        // 隐藏支付相关内容
        self.phoneFeeView.hidden = YES;
        self.preSaveFeeView.hidden = YES;
        self.payStyleView.hidden = YES;
        
        [self.nextBtn removeTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.nextBtn addTarget:self action:@selector(submitOrderSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self.nextBtn setTitle:@"激活" forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)submitOrderSuccess {
    NSLog(@"提交订单成功");
    OpenAccountSuccessVC *successVC = [[OpenAccountSuccessVC alloc] init];
    successVC.openAccountInfo = [self.openAccountInfo copy];
    [self.navigationController pushViewController:successVC animated:YES];
    
//    OpenAccountFailVC *failVC = [[OpenAccountFailVC alloc] init];
//    [self.navigationController pushViewController:failVC animated:YES];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _scrollView;
}

- (OpenAccountStepCell *)stepHeadView {
    if (!_stepHeadView) {
        _stepHeadView = [[NSBundle mainBundle] loadNibNamed:@"OpenAccountStepCell" owner:nil options:nil].firstObject;
        _stepHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 67);
        _stepHeadView.step = 3;
    }
    return _stepHeadView;
}

- (StepThree_UserInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[StepThree_UserInfoView alloc] initWithNib];
        _infoView.frame = CGRectMake(0, self.stepHeadView.maxY + 20, SCREEN_WIDTH, 260);
    }
    return _infoView;
}

- (PhoneFeeView *)phoneFeeView {
    if (!_phoneFeeView) {
        _phoneFeeView = [[PhoneFeeView alloc] initWithNib];
        _phoneFeeView.frame = CGRectMake(0, self.infoView.maxY + 15, SCREEN_WIDTH, 105);
    }
    return _phoneFeeView;
}

- (PreSaveFeeView *)preSaveFeeView {
    if (!_preSaveFeeView) {
        _preSaveFeeView = [[PreSaveFeeView alloc] initWithNib];
        _preSaveFeeView.frame = CGRectMake(0, self.phoneFeeView.maxY, SCREEN_WIDTH, 105);
        __weak typeof(self) weakSelf = self;
        _preSaveFeeView.selectFeeBlock = ^(NSString * _Nonnull fee) {
            NSLog(@"要预存的金额是%@",fee);
            weakSelf.preSaveFee = fee;
        };
    }
    return _preSaveFeeView;
}

- (PayStyleView *)payStyleView {
    if (!_payStyleView) {
        _payStyleView = [[PayStyleView alloc] initWithNib];
        _payStyleView.frame = CGRectMake(0, self.preSaveFeeView.maxX, SCREEN_WIDTH, 85);
    }
    return _payStyleView;
}

- (UIButton *)readSIMBtn {
    if (!_readSIMBtn) {
        _readSIMBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.infoView.maxY + 50, SCREEN_WIDTH - 30, 40)];
        _readSIMBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_readSIMBtn setTitle:@"输入15位ICCID号码" forState:UIControlStateNormal];
        [_readSIMBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _readSIMBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _readSIMBtn.layer.cornerRadius = 4;
        _readSIMBtn.layer.masksToBounds = YES;
        [_readSIMBtn addTarget:self action:@selector(readSIMAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readSIMBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _nextBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

@end
