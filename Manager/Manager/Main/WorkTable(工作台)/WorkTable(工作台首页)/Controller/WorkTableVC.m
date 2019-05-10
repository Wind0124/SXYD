//
//  WorkTableVC.m
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "WorkTableVC.h"
#import "WorkTableVM.h"
#import "BusinessAdvertCell.h"
// 切换工号
#import "ChangeUserView.h"
// 用户鉴权登录
#import "UserAuthenticationView.h"
// 切换渠道
#import "ChangeChannelView.h"

// 工作台头部
#import "WorkTabHeaderView.h"
// 鉴权用户头部
#import "AuthUserInfoView.h"

// 业务类别
#import "BusinessTypeVC.h"

// 父专区
#import "ActivityHeadCell.h"
// 子专区
#import "ChildCell.h"
// 商品
#import "BusinessCell.h"

#import "WebViewController.h"

#import "OpenAccountStepOneVC.h"// 开户第一步

@interface WorkTableVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) UIBarButtonItem *changeEmployeeItem;
@property (nonatomic, strong) UIBarButtonItem *authUserLoginItem;
@property (nonatomic, strong) UIBarButtonItem *authUserLogoutItem;
@property (nonatomic, strong) WorkTabHeaderView *headerView;

@property (nonatomic, strong) ChangeUserView *changeUserView;
@property (nonatomic, strong) WorkTableVM *workTableVM;
// 鉴权用户的数据
@property (nonatomic, strong) AuthUserInfoModel *authUserInfoModel;
// 鉴权用户是否登录
@property (nonatomic, assign) BOOL isAuthUserLogin;
// 鉴权用户手机号
@property (nonatomic, strong) NSString *authUserPhoneNum;
// 鉴权用户的数据界面
@property (nonatomic, strong) AuthUserInfoView *authUserInfoView;

@end

@implementation WorkTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工作台";
    NSLog(@"%@, %s",self, __func__);

    self.workTableVM = [[WorkTableVM alloc] init];
    [self initUI];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UI
- (void)initUI {
    [self.view addSubview:self.myTable];
    // 头部
    self.myTable.tableHeaderView = self.headerView;
//    self.myTable.tableHeaderView = self.authUserInfoView; // test
    // 脚部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
//    footerView.backgroundColor = [UIColor greenColor];
    self.myTable.tableFooterView = footerView;

    self.changeUserView = [[ChangeUserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    // 用户切换item
    [self.navigationItem setLeftBarButtonItem:self.changeEmployeeItem];
    // 鉴权用户登录item
//    [self.navigationItem setRightBarButtonItem:self.authUserLoginItem];
    
    [self resetWorkTableView];
}

-(void)resetWorkTableView{
//    if ([CurrentUser.workbenchCodeString isEqualToString:@"workTypeClerk"]) {
//        self.navigationItem.title = @"营业员工作台";
//    } else if ([CurrentUser.workbenchCodeString isEqualToString:@"workTypeAgent"]) {
//        self.navigationItem.title = @"代理商工作台";
//    } else if ([CurrentUser.workbenchCodeString isEqualToString:@"workTypeManager"]) {
//        self.navigationItem.title = @"客户经理工作台";
//    } else {
//        self.navigationItem.title = @"工作台";
//    }
//    [self getData];
//    [self.myTable reloadData];
}

// 陕西不用切换工号，改切换渠道
- (void)changeEmployeeAction {
    NSLog(@"导航栏左按钮，切换工号");
    [self.workTableVM getEmployeeList:^(NSDictionary * _Nullable result) {
        // 显示工号选择页面
        self.changeUserView.dataArray = self.workTableVM.employeeArray;
        for (int i = 0; i < self.workTableVM.employeeArray.count; i++) {
            EmployeeModel *model = self.workTableVM.employeeArray[i];
            if ([model.employeeNumber isEqualToString:CurrentUser.employeeNumber]) {
                self.changeUserView.selectIndex = i;
                break;
            }
        }
        [self.changeUserView update];
        __weak typeof(self) weakSelf = self;
        self.changeUserView.changeUserBlock = ^(NSDictionary * _Nonnull para) {
            [weakSelf setEmployeeNumberWithDic:para];
        };
        AppDelegate *globalDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [globalDelegate.window addSubview:self.changeUserView];
    } failed:^(NSString * _Nullable errorMessage) {
        [self alertWithMessage:errorMessage];
    }];
}

- (void)changeChannelAction {
    ChangeChannelView *channelView = [[ChangeChannelView alloc] init];
    AppDelegate *globalDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [globalDelegate.window addSubview:channelView];
}

// 切换工号请求
- (void)setEmployeeNumberWithDic:(NSDictionary *)parameters {
    [VPAPI setEmployeeNumberWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            NSLog(@"设置工号成功");
            CurrentUser.employeeNumber = parameters[@"employeeNumber"];
            CurrentUser.workbenchCodeString = parameters[@"workbenchCode"];
            [CurrentUser archive];
            [self.changeUserView removeFromSuperview];
            [self resetWorkTableView];
            // ”我的“界面更新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfo object:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

- (void)authUserLoginAction {
    NSLog(@"导航栏右按钮，登录用户");
    UserAuthenticationView *userView = [[UserAuthenticationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    userView.UserAuthViewBlock = ^(NSString * _Nonnull phoneNumber) {
        // 获取鉴权用户的数据
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
        self.authUserPhoneNum = phoneNumber;
        [self getAuthUserInfo];
    };
    AppDelegate *globalDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [globalDelegate.window addSubview:userView];

//    [self.view addSubview:userView];
}

- (void)authUserLogoutAction {
    NSLog(@"导航栏右按钮，鉴权用户退出登录");
    NSString *message = @"\n当前已登录用户，是否要返回，返回后用户需重新登录";
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"返回提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isAuthUserLogin = NO;
            self.myTable.tableHeaderView = self.headerView;
            [self.navigationItem setLeftBarButtonItem:self.changeEmployeeItem];
            [self.navigationItem setRightBarButtonItem:self.authUserLoginItem];
            [self.myTable reloadData];
        });
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtl addAction:confirmAction];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - 请求数据
- (void)getData {
    if (self.isAuthUserLogin) {
        [self getAuthUserInfo];
    } else {
        // 本日业务量
        [self.workTableVM requestTodayAllStatisticsNumber:^(NSDictionary * _Nullable result) {
            self.headerView.todayModel = self.workTableVM.todayModel;
        } failed:nil];
        // 本月业务量
        [self.workTableVM requestMonthAllStatisticsNumber:^(NSDictionary * _Nullable result) {
            self.headerView.monthModel = self.workTableVM.monthModel;
        } failed:nil];
    }
    // 分类
    [self.workTableVM requestCategoryFinish:^(NSDictionary * _Nullable result) {
        [self.myTable.mj_header endRefreshing];
        [self.myTable reloadData];
    } failed:^(NSString * _Nullable errorMessage) {
    }];
    // 专区
    [self.workTableVM requestActivityFinish:^(BOOL success) {
        if (success) {
            [self.myTable.mj_header endRefreshing];
            [self.myTable reloadData];
        }
    }];
}

- (void)getAuthUserInfo {
    [VPAPI getAuthUserInfo:@{@"mobile": self.authUserPhoneNum} block:^(BaseModel *object, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (object) {
            self.authUserInfoModel = (AuthUserInfoModel *)object;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 加载数据
                if (self.authUserInfoModel.linkPhone.length == 0) {// 如果没返回手机号
                    self.authUserInfoModel.linkPhone = self.authUserPhoneNum;
                }
                self.authUserInfoView.model = self.authUserInfoModel;
                // 更新界面
                self.isAuthUserLogin = YES;
                self.myTable.tableHeaderView = self.authUserInfoView;
                [self.navigationItem setLeftBarButtonItem:nil];
                [self.navigationItem setRightBarButtonItem:self.authUserLogoutItem];
                [self.myTable reloadData];
            });
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            //                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    //    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.workTableVM.activityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 工作台移动业务广告
    if (section == 0) {
        return 1;
    }
    // 专区
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {// 工作台移动业务广告
        NSInteger row = ceil(self.workTableVM.categoryArray.count / 4.0);
        return row * 80;
    } else {
        // section >= 1 用于显示专区
        NSInteger activitySection = indexPath.section - 1;
        if (indexPath.row == 0) {
            float fatherHeight = [self.workTableVM.activityHeightArray[activitySection][0] floatValue];
            return fatherHeight;
        } else {
            float sonHeight = [self.workTableVM.activityHeightArray[activitySection][1] floatValue];
            return sonHeight;
//            return 150.0f;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {// 工作台移动业务广告
        BusinessAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessAdvertCell"];
        if (!cell) {
            cell = [[BusinessAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessAdvertCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = self.workTableVM.categoryArray;
        cell.block = ^(BaseModel * _Nonnull baseModel) {
            AdvertInfoModel *model = (AdvertInfoModel *)baseModel;
            [self advertJumpH5:model];
        };
        return cell;
    }
    // section >= 1 用于显示专区
    NSInteger activitySection = indexPath.section - 1;
    // 专区
    if (indexPath.row == 0) {
        // 父专区
        ActivityHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityHeadCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ActivityHeadCell" owner:nil options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ActivityModel *activityModel = self.workTableVM.activityArray[activitySection];
        cell.styleCode = activityModel.dictionaryStyleCode;
        cell.model = activityModel.activityHead;
        cell.moreActionBlock = ^(ActivityHeadModel * _Nonnull model) {
//            [self alertWithMessage:[NSString stringWithFormat:@"跳转更多H5：name-%@，urlKey-%@", model.name, model.url]];
        };
        cell.pictureActionBlock = ^(ActivityHeadModel * _Nonnull model) {
            [self fatherJumpH5:model prefecture:activityModel];
        };
        return cell;
    } else {
        ActivityModel *model = self.workTableVM.activityArray[activitySection];
        NSString *sonCellName = self.workTableVM.activityCellArray[activitySection];
        
        if (model.childSubject.integerValue == 1) { // 子专区
//            NSLog(@"子专区 section %ld 要使用cell %@", indexPath.section, sonCellName);
            ChildCell *cell = [tableView dequeueReusableCellWithIdentifier:sonCellName];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:sonCellName owner:nil options:nil].firstObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.childArray = model.activityChildList;
            cell.pictureActionBlock = ^(ActivityChildModel * _Nonnull model) {
                [self childJumpH5:model];
            };
            return cell;
        }
        else { // 商品
//            NSLog(@"商品区 section %ld 要使用cell %@", indexPath.section, sonCellName);
            BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:sonCellName];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:sonCellName owner:nil options:nil].firstObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.businessArray = model.activityBusinessList;
            cell.actionBlock = ^(ActivityBusinessModel * _Nonnull model) {
                [self businessJumpH5:model];
            };
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了%zd %zd", indexPath.section, indexPath.row);
}

#pragma mark - 专区跳转
// 父专区
- (void)fatherJumpH5:(ActivityHeadModel *)model prefecture:(ActivityModel *)activityModel {
    NSLog(@"父专区跳转%@", model);
    // 兼容后台配置了短链接
    NSString *baseURL;
    if ([model.url hasPrefix:@"http"]) {
        baseURL = model.url;
    } else {
        baseURL = [NSString stringWithFormat:@"%@%@", CurrentUser.cmccH5Prefix, model.url];
    }
    // 业务跳转全部都要拼接参数，先判断链接中是否有问号，运营人员配置时可能会缺少？号
    if ([baseURL containsString:@"?"]) {
        baseURL = [NSString stringWithFormat:@"%@&", baseURL];
    } else {
        baseURL = [NSString stringWithFormat:@"%@?", baseURL];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@prefectureId=%@&name=%@", baseURL, activityModel.info_id, model.name];

    // 直接使用接口返回的链接
//    NSString *urlString = [NSString stringWithFormat:@"%@&prefectureId=%@&name=%@", model.url, activityModel.info_id, model.name];
    
    WebViewController * web = [[WebViewController alloc] init];
    web.urlStr = urlString;
    web.title = model.name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

// 子专区
- (void)childJumpH5:(ActivityChildModel *)model {
    NSLog(@"子专区跳转数据：%@", model);
    [self alertWithMessage:[NSString stringWithFormat:@"敬请期待\n子专区跳转原生界面\n子专区id:%@", model.info_id]];
}

// 商品
- (void)businessJumpH5:(ActivityBusinessModel *)model {
    NSLog(@"商品跳转数据：%@", model);
    NSLog(@"%@",model.businessId);
    WebViewController * web = [[WebViewController alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@?id=%@", CurrentUser.productDetailUrl, model.businessId];
    web.urlStr = urlString;
    web.title = model.name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

// 广告
- (void)advertJumpH5:(AdvertInfoModel *)model {
    NSLog(@"%@", model);
    if ([self jumpOriginalPage:model]) {
        return;
    }
//    if (![self checkChannelStatus]) {
//        NSLog(@"不能跳转H5");
//        return;
//    }
    [self showAdvertWithModel:model Supplier:nil];
}

- (BOOL)jumpOriginalPage:(AdvertInfoModel *)model {
    if ([model.name isEqualToString:@"全部分类"]) {
        BusinessTypeVC *typeVC = [[BusinessTypeVC alloc] init];
        typeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:typeVC animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark - 懒加载
- (UITableView*)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBar_Height) style:UITableViewStyleGrouped];
        _myTable.backgroundColor = hexStringToColor(COLOR_Background);
        _myTable.showsVerticalScrollIndicator = YES;
        _myTable.separatorColor = [UIColor clearColor];
        _myTable.dataSource = self;
        _myTable.delegate = self;
        // 刷新
        _myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
            [self.myTable.mj_header endRefreshing];
//            [self.myTable.mj_footer resetNoMoreData];
        }];
        _myTable.mj_header.automaticallyChangeAlpha = YES;
//        _myTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self.myTable.mj_footer endRefreshingWithNoMoreData];
//        }];
    }
    return _myTable;
}

- (UIBarButtonItem *)changeEmployeeItem {
    if (!_changeEmployeeItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 33, 33);
        [btn setImage:[UIImage imageNamed:@"WorkTable_leftItem"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeChannelAction) forControlEvents:UIControlEventTouchUpInside];
        _changeEmployeeItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _changeEmployeeItem;
}

- (UIBarButtonItem *)authUserLoginItem {
    if (!_authUserLoginItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 33, 33);
        [btn setImage:[UIImage imageNamed:@"WorkTable_rightItem"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(authUserLoginAction) forControlEvents:UIControlEventTouchUpInside];
        _authUserLoginItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _authUserLoginItem;
}

- (UIBarButtonItem *)authUserLogoutItem {
    if (!_authUserLogoutItem) {
        [self.navigationItem setRightBarButtonItem:self.authUserLoginItem];
        // 退出item
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 33, 33);
        [btn1 setTitle:@"退出" forState:UIControlStateNormal];
        [btn1 setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(authUserLogoutAction) forControlEvents:UIControlEventTouchUpInside];
        _authUserLogoutItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    }
    return _authUserLogoutItem;
}
- (WorkTabHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WorkTabHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        __weak typeof(self) weakSelf = self;
        _headerView.HeaderCheckALLBusinessBlock = ^(BOOL isTody) {
//            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 所有业务量"];
        };
        _headerView.HeaderCheckSingleBusinessBlock = ^(BOOL isTody, StatisticsModel *model) {
//            [weakSelf alertWithMessage:[NSString stringWithFormat:@"敬请期待\n跳转H5\nname：%@,id：%@", model.dictionaryBusinessTypeName, model.handleUserId]];
        };
    }
    return _headerView;
}

- (AuthUserInfoView *)authUserInfoView {
    if (!_authUserInfoView) {
        _authUserInfoView = [[AuthUserInfoView alloc] initWithNib];
        __weak typeof(self) weakSelf = self;
        _authUserInfoView.AuthUserChangeBlock = ^{
            [weakSelf authUserLoginAction];
        };
        _authUserInfoView.AuthUserRecommedBlock = ^{
            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 推荐业务页面"];
        };
        _authUserInfoView.AuthUserCheckBalanceBlock = ^{
            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 查询余额"];
        };
        _authUserInfoView.AuthUserCheckScoreBlock = ^{
            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 查询积分"];
        };
        _authUserInfoView.AuthUserCheckCostBlock = ^{
            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 查询话费"];
        };
        _authUserInfoView.AuthUserUpdateUIBlock = ^{
            [weakSelf.myTable reloadData];
        };
        _authUserInfoView.AuthUserClickDetailBlock = ^{
            [weakSelf alertWithMessage:@"敬请期待\n跳转H5 流量和通话详情"];
        };
    }
    return _authUserInfoView;
}
@end
