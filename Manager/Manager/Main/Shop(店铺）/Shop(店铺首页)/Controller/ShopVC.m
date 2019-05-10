//
//  ShopVC.m
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "ShopVC.h"
#import "ShopVM.h"
// 店铺
#import "ShopNavigationView.h"
// Banner
#import "SDCycleScrollView.h"
// 分类
#import "BusinessAdvertCell.h"
// 头条
#import "HeadlineCell.h"
//// 父专区
//#import "ActivityHeadCell.h"
//// 子专区
//#import "ChildCell.h"
#import "ShopActivityCell.h"
// 商品
#import "BusinessCell.h"
// 跳转
#import "WebViewController.h"
// 我的店铺
#import "EditShopInfoVC.h"
// 分享
#import "YBPopupMenu.h"
// 分享-海报
#import "PosterVC.h"
// 分享-二维码
#import "StoreQrCodeVC.h"
// 分享
#import "ShareView.h"
// 4A+渠道管理
#import "AuthTipView.h"
// 店铺设置
#import "ShopSettingVC.h"

@interface ShopVC ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>
// 总体View
@property (nonatomic, strong) UITableView *shopTableView;
// 店铺导航view
@property (nonatomic, strong) ShopNavigationView *shopNavigationView;
// bannerView
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
// 数据加载和处理
@property (nonatomic, strong) ShopVM *shopVM;
// 认证和渠道 弹窗
@property (nonatomic, strong) AuthTipView *tipView;

@end

@implementation ShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"店铺";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    NSLog(@"创建店铺首页 %s, %s",object_getClassName(self), __func__);
    
    self.shopVM = [[ShopVM alloc] init];
    
    [self initUI];
    
    [self getUserData];
    [self getData];
    
    // 2019-02-27新需求，登录后不需要显示弹窗
    // 判断是否需要显示4A认证和渠道管理View
//    NSString *key = [NSString stringWithFormat:@"%@+%@", ShowAuthTipView, CurrentUser.mobile];
//    NSString *showAuthTip = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    BOOL noAuth = (CurrentUser.crmStatus.integerValue == 3);
//    BOOL noChannel = (CurrentUser.channelStatus.integerValue != 1);
//    if (![showAuthTip isEqualToString:@"NO"] && (noAuth || noChannel)) {
//        self.tipView = [[AuthTipView alloc] initWithNib];
//        self.tipView.fatherVC = self;
//        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [dele.window addSubview:self.tipView];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 更新导航栏信息
    [self.shopNavigationView updateShopInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"%@", self.tipView);
//    if (self.tipView) {
//        [self.tipView showAgain];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UI
- (void)initUI {
    [self.view addSubview:self.shopTableView];
    // 头部
    self.shopTableView.tableHeaderView = self.bannerScrollView;
    // 脚部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
//    footerView.backgroundColor = [UIColor greenColor];
    self.shopTableView.tableFooterView = footerView;
    // 店铺导航
    [self.view addSubview:self.shopNavigationView];
}

#pragma mark - 数据
- (void)getData {
    dispatch_group_t group = dispatch_group_create();

    //banner
    dispatch_group_enter(group);
    [self.shopVM requestBannerFinish:^(BOOL success) {
        dispatch_group_leave(group);
        if (success) {
//            [self.shopTableView.mj_header endRefreshing];
            self.bannerScrollView.imageURLStringsGroup = self.shopVM.imageArray;
            [self.shopTableView reloadData];
        }
    }];
    
    // 类目
    dispatch_group_enter(group);
    [self.shopVM requestCategoryFinish:^(BOOL success) {
        dispatch_group_leave(group);
        if (success) {
//            [self.shopTableView.mj_header endRefreshing];
            [self.shopTableView reloadData];
        }
    }];
    
    // 头条
    dispatch_group_enter(group);
    [self.shopVM requestHeadlineFinish:^(BOOL success) {
        dispatch_group_leave(group);
        if (success) {
//            [self.shopTableView.mj_header endRefreshing];
            [self.shopTableView reloadData];
        }
    }];
    
    // 专区
    dispatch_group_enter(group);
    [self.shopVM requestActivityFinish:^(BOOL success) {
        dispatch_group_leave(group);
        if (success) {
//            [self.shopTableView.mj_header endRefreshing];
            [self.shopTableView reloadData];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.shopTableView.mj_header endRefreshing];
    });
}

- (void)getUserData {
    [self.shopVM getUserData:^(BOOL success) {
        if (success) {
            // 更新头部用户店铺数据
            [self.shopNavigationView updateShopInfo];
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
//    view.backgroundColor = [UIColor redColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + self.shopVM.activityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { // 首页移动业务广告
        return ceil(self.shopVM.categoryArray.count / 4);
    }
    if (section == 1) { // 头条
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {// 首页移动业务广告
        NSInteger row = ceil(self.shopVM.categoryArray.count / 4.0);
        return row * 80;
    } else if (indexPath.section == 1) {// 头条
        return 50;
    } else {
        // section >= 2 用于显示专区
        return 150.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 首页移动业务广告
    if (indexPath.section == 0) {
        BusinessAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessAdvertCell"];
        if (!cell) {
            cell = [[BusinessAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessAdvertCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = self.shopVM.categoryArray;
        cell.block = ^(BaseModel * _Nonnull baseModel) {
            AdvertInfoModel *model = (AdvertInfoModel *)baseModel;
            NSLog(@"广告 跳转数据：%@",model);
            [self advertJumpH5:model];
        };
        return cell;
    }
    // 头条
    if (indexPath.section == 1) {
        HeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadlineCell"];
        if (!cell) {
            cell = [[HeadlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadlineCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModelArray:self.shopVM.headlineArray];
        cell.block = ^(NSInteger index) {
            NoticeModel *model = self.shopVM.headlineArray[index];
            [self noticeJumpH5:model];
        };
        return cell;
    }
    // 专区
    NSString *identifyString = NSStringFromClass([ShopActivityCell class]);
    ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
    }
    PrefectureModel *model = self.shopVM.activityArray[indexPath.section - 2];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= 2) {
        PrefectureModel *model = self.shopVM.activityArray[indexPath.section - 2];
        NSLog(@"专题跳转:%@",model);
        WebViewController * web = [[WebViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@%@?prefectureId=%@&supplierName=%@&channelId=%@&userShopId=%@&clerkId=%@&userId=%@",CurrentUser.cmccH5Prefix,  CurrentUser.businessListSubject, model.prefectureId, CurrentUser.defaultSupplierName, CurrentUser.defaultChannelId, CurrentUser.shopId, CurrentUser.thousandClerkId, CurrentUser.userId];
        web.urlStr = urlString;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.shopNavigationView.hidden = offsetY < -Status_Height;
    [self.shopNavigationView setViewShow:(offsetY >= 0)];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    // H5
    if (![self checkChannelStatus]) {
        return ;
    }
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    if (index == 0) {
        NSLog(@"二维码");
        StoreQrCodeVC *vc = [[StoreQrCodeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        NSLog(@"分享");
        ShareView *shareView = [[ShareView alloc] initWithNib];
        [shareView showInVC:self];
    } else if (index == 2) {
        NSLog(@"海报");
        PosterVC *posterVC = [[PosterVC alloc] init];
        posterVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:posterVC animated:YES];
    }
}

#pragma mark - 专区跳转
// 父专区
- (void)fatherJumpH5:(ActivityHeadModel *)model {
    NSLog(@"父专区跳转%@", model);
    [self alertWithMessage:@"敬请期待\n父专区跳转原生界面"];
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

// banner、广告
- (void)advertJumpH5:(AdvertInfoModel *)model {
//    if (![self checkChannelStatus]) {
//        NSLog(@"不能跳转");
//        return;
//    }
    [self showAdvertWithModel:model Supplier:nil];
}

// 头条、公告
- (void)noticeJumpH5:(NoticeModel *)model {
    NSLog(@"头条：%@",model);
    if (model.detailType.integerValue == 1) {
        // 文本内容
        WebViewController * web = [[WebViewController alloc]init];
        [web loadWebWithContentSring:model.textContent];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    } else if (model.detailType.integerValue == 2){
        WebViewController * web = [[WebViewController alloc]init];
        web.urlStr = model.url;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark - 懒加载
- (UITableView *)shopTableView {
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -Status_Height, SCREEN_WIDTH, SCREEN_HEIGHT - TabBar_Height + Status_Height) style:UITableViewStyleGrouped];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 刷新
        _shopTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
//            [self.shopTableView.mj_footer resetNoMoreData];
        }];
        _shopTableView.mj_header.automaticallyChangeAlpha = YES;
//        _shopTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self.shopTableView.mj_footer endRefreshingWithNoMoreData];
//        }];
    }
    return _shopTableView;
}

- (ShopNavigationView *)shopNavigationView {
    if (!_shopNavigationView) {
        _shopNavigationView = [[ShopNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Nav_Height)];
        __weak typeof(self) weakSelf = self;
        _shopNavigationView.enterStoreAction = ^{
            NSLog(@"进入店铺");
            EditShopInfoVC *editShopVC = [[EditShopInfoVC alloc] init];
            editShopVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:editShopVC animated:YES];
        };
        _shopNavigationView.shopNavEditAction = ^{
            NSLog(@"店铺套餐设置");
            // H5
            if (![weakSelf checkChannelStatus]) {
                return ;
            }
            WebViewController * web = [[WebViewController alloc] init];
            // 参数： shopId 店铺ID， supplierId 机构ID supplierName机构名称
//            web.urlStr = @"http://webmdev.central.vpclub.cn/#/codeshop/setting?shopId=562433097140846594&supplierId=029&supplierName=西安";
            NSString *shopId = CurrentUser.shopId?: @"没有店铺id";
            NSString *supplierId = CurrentUser.defaultSupplierId?: @"没有机构id";
            NSString *supplierName = CurrentUser.defaultSupplierName?: @"没有机构名";
            NSString *urlString = [NSString stringWithFormat:@"%@%@?shopId=%@&supplierId=%@&supplierName=%@", CurrentUser.cmccH5Prefix, CurrentUser.codeShopSettingUrl, shopId, supplierId, supplierName];
            web.urlStr = urlString;
            web.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
        _shopNavigationView.shopNavMoreAction = ^(UIButton * _Nonnull sender) {
            NSLog(@"更多");
            [YBPopupMenu showRelyOnView:sender titles:@[@"二维码", @"分享", @"海报"] icons:@[@"shop_share_qrCode", @"shop_share_share", @"shop_share_haibao"] menuWidth:120 delegate:weakSelf];
        };
    }
    return _shopNavigationView;
}

- (SDCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 750 * 450)];
        _bannerScrollView.autoScroll = true;
        _bannerScrollView.autoScrollTimeInterval = 5.0;
        _bannerScrollView.backgroundColor = UIColor.whiteColor;
        //    _bannerScrollView.delegate = self;
        //    _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //    _bannerScrollView.currentPageDotColor = [UIColor grayColor];
        //    _bannerScrollView.pageDotColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _bannerScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"下标：%zd", currentIndex);
            AdvertInfoModel *model = weakSelf.shopVM.bannerArray[currentIndex];
            NSLog(@"banner跳转数据：%@",model);
            [weakSelf advertJumpH5:model];
        };
    }
    return _bannerScrollView;
}

#pragma mark - 管理控制器
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
