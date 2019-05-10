//
//  MineSettingVC.m
//  Manager
//
//  Created by vpclub on 2018/12/6.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "MineSettingVC.h"
#import "WUGesturesUnlockViewController.h"
//#import "LoginVC.h"
#import "LoginVC_SX.h"
#import "ModifyPwdVC.h"
#import "AboutVC.h"

@interface MineSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation MineSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.dataArray = @[@"修改密码", @"修改登录手势", @"版本信息", @"推荐下载", @"清理缓存", @"帮助中心", @"功能反馈", ];
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = hexStringToColor(COLOR_Background);
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.logoutBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)logoutAction {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:cancelAction];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];
    [alertCtl addAction:confirmAction];

    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)logout {
    // 登陆失效 跳回登陆页面
    [CurrentUser logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
    //进入登录界面
//    LoginVC_SX * loginVC = [[LoginVC_SX alloc] init];
//    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
//    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 50;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ModifyPwdVC *modifyVC = [[ModifyPwdVC alloc] init];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 1:
        {
            // 修改登录手势 1.先验证手势解锁; 2.设置新手势密码;
            WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeModifyPwd];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            AboutVC *aboutVC = [[AboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 3:
        {
            [self alertWithMessage:@"敬请期待"];
        }
            break;
        case 4:
        {
            [self alertWithMessage:@"敬请期待"];
        }
            break;
        case 5:
        {
            [self alertWithMessage:@"敬请期待"];
        }
            break;
        case 6:
        {
            [self alertWithMessage:@"敬请期待"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(15, SCREEN_HEIGHT - 90, SCREEN_WIDTH - 30, 45);
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setBackgroundColor:hexStringToColor(COLOR_Btn)];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.layer.cornerRadius = 4;
        _logoutBtn.layer.masksToBounds = YES;
        [_logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}
@end
