//
//  OpenAccountStepTwoVC.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountStepTwoVC.h"
#import "OpenAccountStepCell.h"
#import "StepTwo_UserInfoView.h"
#import "OpenAccountStepThreeVC.h"
#import "StepTwo_DownloadTipView.h"

@interface OpenAccountStepTwoVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) OpenAccountStepCell *stepHeadView;

@property (nonatomic, strong) UIButton *readIDBtn;
@property (nonatomic, strong) UIButton *checkIDBtn;

@property (nonatomic, strong) StepTwo_UserInfoView *infoView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSString *transactionId;// 下发工单返回的id

@end

@implementation OpenAccountStepTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"资料录入";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.stepHeadView];
    [self.scrollView addSubview:self.readIDBtn];
    [self.scrollView addSubview:self.checkIDBtn];
    [self.scrollView addSubview:self.infoView];
    self.infoView.hidden = YES;
    [self.scrollView addSubview:self.nextBtn];
    self.nextBtn.hidden = YES;
    self.stepHeadView.step = 2;
    self.transactionId = @"";
}

#pragma mark - 按钮点击
- (void)beforeReadIDAction {
//    // 测试假数据 直接跳过下发采集认证工单
//    [self jmup10085APP];
//    return;
    
    // 下发采集认证工单
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSDictionary *para = [[NSDictionary alloc] init];
    [VPAPI2 openAccountSendBillWithDic:para block:^(NSDictionary *dic, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (dic) {
            BOOL isSuccess = [dic[@"success"] boolValue];
            if (isSuccess) {
                self.transactionId = dic[@"transactionId"];
                [self jmup10085APP];
            } else {
                [self alertWithMessage:@"下发采集认证工单失败"];
            }
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 提示打开APP进行认证
- (void)jmup10085APP {
    NSString *scheme = @"IDENTITYAUTHENTICATION://"; //构建调用插件的URL scheme
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
        // 提示下载APP
        StepTwo_DownloadTipView *tipView = [[StepTwo_DownloadTipView alloc] initWithNib];
        tipView.downloadConfirmBlock = ^{
            self.readIDBtn.hidden = YES;
            self.checkIDBtn.hidden = NO;
        };
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [dele.window addSubview:tipView];
        return;
    } else {
        [self alertWithMessage:@"请手动打开实名认证APP进行身份认证" complete:^{
            self.readIDBtn.hidden = YES;
            self.checkIDBtn.hidden = NO;
        }];
    }
}

// 检测验证状态
- (void)checkIDAction {
    // 测试假数据 直接获取身份证成功
//    NSDictionary *idDic = @{@"custCertAddr" : @"广东省普宁市大坝镇大坝圩",
//                            @"birthday" : @"1990-01-24",
//                            @"certExpDate": @"2036-09-18",
//                            @"certValidDate": @"2016-09-18",
//                            @"psptId" : @"445281199001243714",
//                            @"custName" : @"蔡东阳",
//                            @"nation" : @"汉",
//                            @"gender" : @"1",
//                            @"issuingAuthority" : @"普宁市公安局",
//                            };
//    self.openAccountInfo.idModel = [[IDInfoModel alloc] initWithDictionary:idDic error:nil];
//    [self getIDInfoSuccess];
//    return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.transactionId, @"transactionId",
                          nil];
//    NSDictionary *para = @{@"transactionId": self.transactionId};
    [VPAPI2 queryRealnameBillWithDic:para block:^(BaseModel *object, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (object) {
            self.openAccountInfo.idModel = (IDInfoModel *)object;
            [self getIDInfoSuccess];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 得到实名认证返回的身份证数据
- (void)getIDInfoSuccess{
    NSString *name = self.openAccountInfo.idModel.custName;
    NSString *gender = self.openAccountInfo.idModel.gender;
    NSString *idNum = self.openAccountInfo.idModel.psptId;
    NSString *address = self.openAccountInfo.idModel.custCertAddr;
    [self.infoView updateInfoWithName:name gender:gender idNum:idNum address:address];

    self.readIDBtn.hidden = YES;
    self.checkIDBtn.hidden = YES;
    self.infoView.hidden = NO;
    self.nextBtn.hidden = NO;
}

- (void)nextAction {
    [self checkOneCerFiveNumber];
}

#pragma mark - 网络请求
// 检测全国一证五号
- (void)checkOneCerFiveNumber {
//    OpenAccountStepThreeVC *stepThreeVC = [[OpenAccountStepThreeVC alloc] init];
//    stepThreeVC.openAccountInfo = [self.openAccountInfo copy];
//    [self.navigationController pushViewController:stepThreeVC animated:YES];
//    return;
    
    //    NSDictionary *para = @{@"addressCode": CurrentUser.crmCityCode,
    //                           @"idName": self.openAccountInfo.idModel.custName,
    //                           @"idNum": self.openAccountInfo.idModel.psptId,
    //                           @"transactionId": self.transactionId,
    //                           };
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          CurrentUser.crmCityCode, @"addressCode",
                          self.openAccountInfo.idModel.custName, @"idName",
                          self.openAccountInfo.idModel.psptId, @"idNum",
                          self.transactionId, @"transactionId",
                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 validateOneCerFiveNumberWithDic:para block:^(NSString *string, BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            OpenAccountStepThreeVC *stepThreeVC = [[OpenAccountStepThreeVC alloc] init];
            stepThreeVC.openAccountInfo = [self.openAccountInfo copy];
            [self.navigationController pushViewController:stepThreeVC animated:YES];
        } else {
            if (string) {
                [self alertWithMessage:string];
            } else {
                [self alertWithMessage:[NSString stringWithFormat:@"%@%@",error.code, error.msg]];
            }
        }
    }];
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
        _stepHeadView.step = 2;
    }
    return _stepHeadView;
}

- (UIButton *)readIDBtn {
    if (!_readIDBtn) {
        _readIDBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.stepHeadView.maxY + 50, SCREEN_WIDTH - 30, 40)];
        _readIDBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_readIDBtn setTitle:@"读取身份证（10085认证）" forState:UIControlStateNormal];
        [_readIDBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _readIDBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _readIDBtn.layer.cornerRadius = 4;
        _readIDBtn.layer.masksToBounds = YES;
        [_readIDBtn addTarget:self action:@selector(beforeReadIDAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readIDBtn;
}

- (UIButton *)checkIDBtn {
    if (!_checkIDBtn) {
        _checkIDBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.stepHeadView.maxY + 50, SCREEN_WIDTH - 30, 40)];
        _checkIDBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_checkIDBtn setTitle:@"查询认证状态" forState:UIControlStateNormal];
        [_checkIDBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _checkIDBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _checkIDBtn.layer.cornerRadius = 4;
        _checkIDBtn.layer.masksToBounds = YES;
        [_checkIDBtn addTarget:self action:@selector(checkIDAction) forControlEvents:UIControlEventTouchUpInside];
        _checkIDBtn.hidden = YES;
    }
    return _checkIDBtn;
}

- (StepTwo_UserInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[StepTwo_UserInfoView alloc] initWithNib];
        _infoView.frame = CGRectMake(0, self.stepHeadView.maxY + 10, SCREEN_WIDTH, 280);
    }
    return _infoView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.infoView.maxY + 50, SCREEN_WIDTH - 30, 40)];
        _nextBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
@end
