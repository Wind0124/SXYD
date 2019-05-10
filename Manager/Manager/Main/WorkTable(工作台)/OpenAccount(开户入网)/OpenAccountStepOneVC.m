//
//  OpenAccountStepOneVC.m
//  Manager
//
//  Created by vpclub on 2018/12/27.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountStepOneVC.h"
#import "OpenAccountStepTwoVC.h"
#import "OpenAccountStepCell.h"
#import "StepOne_ChooseBusinessCell.h"
#import "StepOne_AmountCell.h"
#import "StepOne_ChoosePhoneCell.h"
#import "StepOne_BusinessDetailCell.h"
#import "OpenAccountChoosePhoneVC.h"

@interface OpenAccountStepOneVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) BusinessApiGradeModel *model;// 业务数据
@property (nonatomic, strong) NSMutableArray *contractArray;// 合约列表
@property (nonatomic, strong) BusinessContractModel *selectContractModel;// 选中的档次
@property (nonatomic, assign) BOOL hasAmount;// 是否有预存金额
@property (nonatomic, strong) OpenAccountMobileModel *selectMobileModel;

@end

@implementation OpenAccountStepOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择套餐和号码";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirmBtn];
    [self getContractList];
//    // 测试假数据 咸阳0910 西安0029 榆林0912
//    CurrentUser.crmCityCode = @"0910";
//    CurrentUser.crmCityName = @"咸阳";
}

#pragma mark - 按钮事件
- (void)nextStep {
    if (!self.selectContractModel) {
        [self alertWithMessage:@"请选择政策合约"];
        return;
    }
    if (!self.selectMobileModel) {
        [self alertWithMessage:@"请选择手机号码"];
        return;
    }
    // 下一步
    OpenAccountStepTwoVC *stepTwoVC = [[OpenAccountStepTwoVC alloc] init];
    stepTwoVC.openAccountInfo = [[OpenAccountInfo alloc] init];
    stepTwoVC.openAccountInfo.model = self.model;
    stepTwoVC.openAccountInfo.contractModel = self.selectContractModel;
    stepTwoVC.openAccountInfo.mobileModel = self.selectMobileModel;
    NSLog(@"选中合约id：%@, 选中手机号：%@", self.selectContractModel.info_id, self.selectMobileModel.mobile);
    [self.navigationController pushViewController:stepTwoVC animated:YES];
}

#pragma mark - 请求数据
- (void)getContractList {
    // businessCode有：schoolZone stormAction sharedSubCard largeFlowPackage mobileCard flyingPackage
//    NSDictionary *para = @{@"businessCode": self.businessCode,
//                           @"supplierId": self.supplierModel.supplierId,
//                           };
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.businessCode, @"businessCode",
                          self.supplierModel.supplierId, @"supplierId",
                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 getGradeListWithDic:para block:^(BaseModel *object, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (object) {
            NSLog(@"业务数据%@",object);
            self.model = (BusinessApiGradeModel *)object;
            [self.contractArray removeAllObjects];
            [self.contractArray addObjectsFromArray:self.model.contractList];
            NSLog(@"有%ld个档次", self.contractArray.count);
            if (self.contractArray.count > 0) {
                self.selectContractModel = (BusinessContractModel *)self.contractArray[0];
                if (![self.selectContractModel.minimumAmount isEqualToString:@"0"]) {
                    self.hasAmount = YES;
                } else {
                    self.hasAmount = NO;
                }
            }
            [self.tableView reloadData];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {// 步骤
        return 67;
    }
    if (indexPath.section == 1) {// 合约
        return 130;
    }
    if (indexPath.section == 2) {// 预存金额
        if (self.hasAmount) {
            return 50;
        }
        return 0.01;
    }
    if (indexPath.section == 3) {// 手机
        return 50;
    }
    if (indexPath.section == 4) {// 档次详情
        return 300;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {// 预存金额
        if (self.hasAmount) {
            return 10;
        }
        return 0.01;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 显示步骤
    if (indexPath.section == 0) {
        NSString *identifyString = NSStringFromClass([OpenAccountStepCell class]);
        OpenAccountStepCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        cell.step = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // 选择合约
    if (indexPath.section == 1) {
        NSString *identifyString = NSStringFromClass([StepOne_ChooseBusinessCell class]);
        StepOne_ChooseBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        cell.contractArray = self.contractArray;
        cell.selectBusinessBlock = ^(NSInteger index) {
            NSLog(@"选择了第%zd个档次", index);
            self.selectContractModel = (BusinessContractModel *)self.contractArray[index];
            if (![self.selectContractModel.minimumAmount isEqualToString:@"0"]) {
                self.hasAmount = YES;
            } else {
                self.hasAmount = NO;
            }
            [self.tableView reloadData];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // 预存金额
    if (indexPath.section == 2) {
        NSString *identifyString = NSStringFromClass([StepOne_AmountCell class]);
        StepOne_AmountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        cell.model = self.selectContractModel;
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // 选择号码
    if (indexPath.section == 3) {
        NSString *identifyString = NSStringFromClass([StepOne_ChoosePhoneCell class]);
        StepOne_ChoosePhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        if (self.selectMobileModel) {
            cell.model = self.selectMobileModel;
        }
        cell.StepOne_ChoosePhoneAction = ^{
            if (!self.model) {
                [self alertWithMessage:@"业务不存在"];
                return ;
            }
            OpenAccountChoosePhoneVC *choosePhoneVC = [[OpenAccountChoosePhoneVC alloc] init];
            choosePhoneVC.businessId = self.model.info_id;
            choosePhoneVC.choosePhoneBlock = ^(OpenAccountMobileModel * _Nonnull mobile) {
                self.selectMobileModel = mobile;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:choosePhoneVC animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // 显示档次详情
    if (indexPath.section == 4) {
        NSString *identifyString = NSStringFromClass([StepOne_BusinessDetailCell class]);
        StepOne_BusinessDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        if (self.selectContractModel) {
            cell.descString = self.selectContractModel.info_description;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // indexPath.row
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = hexStringToColor(COLOR_Background);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        [_confirmBtn setTitle:@"提交工单" forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_confirmBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (NSMutableArray *)contractArray {
    if (!_contractArray) {
        _contractArray = [NSMutableArray array];
    }
    return _contractArray;
}
@end
