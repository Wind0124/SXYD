//
//  Manager4AVC.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Manager4AVC.h"
#import "AutherCell.h"
// 切换工号
#import "SwitchEmployeeView.h"
// 4A认证
#import "CertificateVC_SX.h"
// 4A授权
#import "Auth4AVC.h"
// 授权详情
#import "AuthDetailVC.h"
@interface Manager4AVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;

@property (nonatomic, strong) NSMutableArray *authArray;

@end

@implementation Manager4AVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"4A管理";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    self.switchBtn.layer.borderWidth = 1;
    self.switchBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.switchBtn.layer.masksToBounds = YES;
    self.certificateBtn.layer.borderWidth = 1;
    self.certificateBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.certificateBtn.layer.masksToBounds = YES;
    if (CurrentUser.crmStatus.integerValue == 2) {
        [self.certificateBtn setTitle:@"认证店长" forState:UIControlStateNormal];
    }
    NSString *employeeString = CurrentUser.employeeNumber ? : @"";
    self.employeeLabel.text = [NSString stringWithFormat:@"4A工号：%@", employeeString];
    
    self.tableView.backgroundColor = hexStringToColor(COLOR_Background);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 没有多工号，隐藏切换按钮
    if (CurrentUser.crmYD) {
        NSArray *employeeArray = [CurrentUser.crmYD componentsSeparatedByString:@","];
        if (employeeArray.count < 2) {
            self.switchBtn.hidden = YES;
        }
    } else {
        self.switchBtn.hidden = YES;
    }
    // 被授权账号，隐藏授权按钮
    if (CurrentUser.crmStatus.integerValue == 2) {
        self.authBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAuthList];
}

#pragma mark - 网络请求
// 授权列表
- (void)getAuthList {
    [VPAPI getAuthListWithBlock:^(NSArray *objects, HeadModel *error) {
        if (objects) {
            [self.authArray removeAllObjects];
            [self.authArray addObjectsFromArray:objects];
            [self.tableView reloadData];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutherCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AutherCell" owner:nil options:nil].firstObject;
    }
    AuthDetailModel *model = self.authArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.mobile;
    // 日期只显示前部分
    NSArray *dateArray = [model.date componentsSeparatedByString:@" "];
    if (dateArray.count >= 2) {
        cell.dateLabel.text = dateArray[0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // indexPath.row
    AuthDetailVC *detailVC = [[AuthDetailVC alloc] init];
    AuthDetailModel *model = self.authArray[indexPath.row];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 按钮点击
// 切换工号
- (IBAction)switchEmployeeAction:(UIButton *)sender {
    SwitchEmployeeView *view = [[SwitchEmployeeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (CurrentUser.crmYD) {
        NSArray *employeeArray = [CurrentUser.crmYD componentsSeparatedByString:@","];
        view.dataArray = [NSMutableArray arrayWithArray:employeeArray];
    }
    view.switchEmployeeBlock = ^(NSString * _Nonnull employeeString) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
        [VPAPI setEmployeeNumberWithDic:@{@"employeeNumber": employeeString} block:^(BOOL successed, HeadModel *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            if (successed) {
                CurrentUser.employeeNumber = employeeString;
                self.employeeLabel.text = [NSString stringWithFormat:@"4A工号：%@", employeeString];
            } else {
                [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
            }
        }];
    };
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [dele.window addSubview:view];
}

// 再次认证
- (IBAction)certificateAction:(UIButton *)sender {
    CertificateVC_SX *certificateVC = [[CertificateVC_SX alloc] init];
    [self.navigationController pushViewController:certificateVC animated:YES];
}

// 授权
- (IBAction)authAction:(UIButton *)sender {
    Auth4AVC *authVC = [[Auth4AVC alloc] init];
    [self.navigationController pushViewController:authVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)authArray {
    if (!_authArray) {
        _authArray = [NSMutableArray array];
    }
    return _authArray;
}

@end
