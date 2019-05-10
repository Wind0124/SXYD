//
//  EmployeeVC.m
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "EmployeeVC.h"
#import "EmployeeCell.h"

@interface EmployeeVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *employeeTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
// 选中工号的下表
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation EmployeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择工号";
    self.employeeTableView.delegate = self;
    self.employeeTableView.dataSource = self;
    self.employeeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.employeeTableView registerNib:[UINib nibWithNibName:@"EmployeeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"EmployeeCell"];
    self.selectIndex = -1;
    [self getEmployeeNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeCell"];
    EmployeeModel *model = self.dataArray[indexPath.row];
    cell.numberLabel.text = model.employeeNumber;
    if (self.selectIndex == indexPath.row) {
        [cell.imgView setImage:[UIImage imageNamed:@"login_choose_press"]];
    } else {
        [cell.imgView setImage:[UIImage imageNamed:@"login_choose_nor"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self.employeeTableView reloadData];
}

#pragma mark - 内部方法
// 获取工号列表
- (void)getEmployeeNumber {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI getListEmployeeNumber:^(NSArray *objects, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (error) {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        } else {
            if (objects.count > 0) {
                [self.dataArray addObjectsFromArray:objects];
                [self.employeeTableView reloadData];
            } else {
                [self alertWithMessage:@"工号列表为空"];
            }
        }
    }];
}

// 选择工号登录
- (IBAction)setNumberAction:(UIButton *)sender {
    if (self.selectIndex < 0) {
        [self alertWithMessage:@"未选择工号"];
        return;
    }
    EmployeeModel *model = self.dataArray[self.selectIndex];
    NSArray *workbenchArray = model.listWorkbench;
    NSString *workbenchCode;
    for (int i = 0; i < workbenchArray.count; i++) {
        NSDictionary *dic = workbenchArray[i];
        NSString *isDefault = [dic valueForKey:@"isDefault"];
        if ([isDefault isEqualToString:@"true"]) {
            workbenchCode = [dic valueForKey:@"code"];
            break;
        }
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:model.employeeNumber forKey:@"employeeNumber"];
    [parameters setValue:workbenchCode forKey:@"workbenchCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI setEmployeeNumberWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            NSLog(@"设置工号成功");
            CurrentUser.employeeNumber = model.employeeNumber;
            CurrentUser.workbenchCodeString = workbenchCode;
            [CurrentUser archive];
//            [self alertWithMessage:@"进入主界面"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetHomePageBanner object:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

// 取消
- (IBAction)cancelAction:(UIButton *)sender {
    [CurrentUser logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 管理控制器
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
