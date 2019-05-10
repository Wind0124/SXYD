//
//  BusinessTypeVC.m
//  Manager
//
//  Created by vpclub on 2018/12/13.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BusinessTypeVC.h"
#import "BusinessCCell.h"
#import "WebViewController.h"
//#import "BusinessTypeHeaderView.h"
#import "ShopperRegisterVC.h"// 注册千店万员
#import "ManagerChannelVC.h" // 渠道管理
#import "SelectCityView.h"// 切换机构、城市
#import "ChangeChannelView.h"// 切换默认渠道
#import "AccountOrderCenterVC.h"// 号卡订单中心

@interface BusinessTypeVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) BusinessTypeHeaderView *headerView;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) UICollectionView *mainCollView;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, assign) NSInteger selectedIndex;// 左侧选中

//@property (nonatomic, assign) NSInteger supplierSelectIndex;// 选中的机构
//@property (nonatomic, strong) NSMutableArray *supplierArray;// 机构列表

@property (nonatomic, strong) NSMutableArray *activityArray;// 工作台专区列表
@end

@implementation BusinessTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"业务分类";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.supplierSelectIndex = -1;
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.typeTableView];
    [self.scrollView addSubview:self.mainCollView];
//    [self.mainCollView reloadData];
//    [self getOrgData];
    [self getBusinessData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDefaultChannelAction) name:ChangeDefaultChannel object:nil];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getBusinessData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 网络请求
// 获取陕西机构列表
//- (void)getOrgData {
//    [VPAPI2 getShanXiOrgWithBlock:^(NSArray *objects, HeadModel *error) {
//        if (objects) {
//            [self.supplierArray removeAllObjects];
//            [self.supplierArray addObjectsFromArray:objects];
//        } else {
//            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
//        }
//    }];
//}

// 获取所有业务数据
- (void)getBusinessData {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": DataDictionaryCode},
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI getAllAdvertBusinessWithDic:para block:^(NSArray *objects, HeadModel *error) {
        [self.scrollView.mj_header endRefreshing];
        if (objects) {
            // 左侧数据
            [self.leftArray removeAllObjects];
            [self.leftArray addObjectsFromArray:objects];
            [self.typeTableView reloadData];
            // 右侧数据
            AdvertInfoModel *typeModel = (AdvertInfoModel *)objects[self.selectedIndex];
            [self.rightArray removeAllObjects];
            [self.rightArray addObjectsFromArray:typeModel.businessContents];
            // 获取工作台专区列表
            [self getWorkTableActivityData];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

// 获取工作台专区
// 自营厅专区加到直营厅终端，O2O专区加到O2O终端
- (void)getWorkTableActivityData {
    NSDictionary *para = @{@"dictionaryOneLevleTypeCode": @"workbenchPrefecture",
                           };
    [VPAPI getActivityInfoWithDic:para block:^(NSArray *objects, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (objects) {
            [self.activityArray removeAllObjects];
            [self.activityArray addObjectsFromArray:objects];
            [self addActivityToRightArray];
            [self.mainCollView reloadData];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - 内部事件
- (void)changeDefaultChannelAction {
//    self.supplierSelectIndex = -1;
//    [self.headerView updateSupplierName:CurrentUser.defaultSupplierName];
}

// 业务跳转
- (void)advertJumpH5:(AdvertInfoModel *)model {
    NSString *code = model.dictionaryAdvertTypeCode;
    // dictionaryAdvertTypeCode 是comboHand（4G套餐）、trafficManagement(4G流量)、marketingActivities(营销活动）、Preferential（优惠体验）
    if ([code isEqualToString:@"comboHand"] || [code isEqualToString:@"trafficManagement"] || [code isEqualToString:@"marketingActivities"] || [code isEqualToString:@"Preferential"]) {
        if (![self checkChannelStatus]) {
            NSLog(@"不能跳转");
            return;
        }
    }
    if ([model.name isEqualToString:@"号卡订单中心"]) {
        NSLog(@"跳转号卡订单中心");
        AccountOrderCenterVC *orderVC = [[AccountOrderCenterVC alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        return;
    }
//    if (self.supplierSelectIndex < 0) {
        [self showAdvertWithModel:model Supplier:nil];
//    } else {
//        ChannelModel *supplierModel = (ChannelModel *)self.supplierArray[self.supplierSelectIndex];
//        [self showAdvertWithModel:model Supplier:supplierModel];
//    }
}

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
    
    WebViewController * web = [[WebViewController alloc] init];
    web.urlStr = urlString;
    web.title = model.name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - tabviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTypeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessTypeCell"];
//        cell.contentView.backgroundColor = hexStringToColor(COLOR_Background);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.typeTableView.viewWidth, 60)];
//        nameLabel.center = cell.contentView.center;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.tag = 100;
        [cell.contentView addSubview:nameLabel];
    }
    AdvertInfoModel *model = (AdvertInfoModel *)self.leftArray[indexPath.row];
//    cell.textLabel.text = model.name;
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
    UILabel *nameLabel = [cell.contentView viewWithTag:100];
    nameLabel.text = model.name;
    if (self.selectedIndex == indexPath.row) {
        cell.backgroundColor = hexStringToColor(COLOR_Btn);
    } else {
        cell.backgroundColor = hexStringToColor(COLOR_Background);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self.typeTableView reloadData];
    
    AdvertInfoModel *typeModel = self.leftArray[indexPath.row];
    [self.rightArray removeAllObjects];
    [self.rightArray addObjectsFromArray:typeModel.businessContents];
    [self addActivityToRightArray];
    [self.mainCollView reloadData];
}

// 自营厅专区加到直营厅终端，O2O专区加到O2O终端
- (void)addActivityToRightArray {
    AdvertInfoModel *typeModel = self.leftArray[self.selectedIndex];
    if ([typeModel.dictionaryAdvertTypeCode isEqualToString:@"distributionSales"]) {
        for (int i = 0; i < self.activityArray.count; i++) {
            ActivityModel *aModel = (ActivityModel *)self.activityArray[i];
            if ([aModel.dictionaryTwoLevelTypeCode isEqualToString:@"directSalesOfficeSalesZone"] || [aModel.dictionaryTwoLevelTypeCode isEqualToString:@"directSalesHallZone"]) {
                [self.rightArray addObject:aModel];
            }
        }
    } else if ([typeModel.dictionaryAdvertTypeCode isEqualToString:@"o2oTerminal"]) {
        for (int i = 0; i < self.activityArray.count; i++) {
            ActivityModel *aModel = (ActivityModel *)self.activityArray[i];
            if ([aModel.dictionaryTwoLevelTypeCode isEqualToString:@"o2oZone"]) {
                [self.rightArray addObject:aModel];
            }
        }
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){(SCREEN_WIDTH - self.typeTableView.viewWidth) / 3, 100};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return (CGSize){SCREEN_WIDTH, 44};
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return (CGSize){SCREEN_WIDTH, 22};
//}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rightArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"BusinessCCell";
    BusinessCCell *cCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    if (indexPath.item < self.rightArray.count) {
        id model = self.rightArray[indexPath.item];
        if ([model isKindOfClass:[AdvertInfoModel class]]) {
            AdvertInfoModel *infoModel = (AdvertInfoModel *)self.rightArray[indexPath.item];
            // 处理图片地址
            NSString *fullImgString = [NSString getFullImageUrlString:infoModel.image server:CurrentUser.imgServerPrefix];
            [cCell.imgView sd_setImageWithURL:[NSURL URLWithString:fullImgString] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
            cCell.nameLabel.text = infoModel.name;
        } else {
            // 专区
            ActivityModel *infoModel = (ActivityModel *)self.rightArray[indexPath.item];
            UIImage *image = [UIImage imageNamed:infoModel.dictionaryTwoLevelTypeCode];
            if (image) {
                [cCell.imgView setImage:image];
            } else {
                [cCell.imgView setImage:[UIImage imageNamed:@"placeHolder"]];
            }
            cCell.nameLabel.text = infoModel.activityHead.name;
        }
        // 文字吸顶 方法一
        CGRect frame = cCell.nameLabel.frame;
        cCell.nameLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40);
        // 文字吸顶 方法二
//        [cCell.nameLabel sizeToFit];
    } else {
        cCell.backgroundColor = [UIColor clearColor];
        cCell.imgView.image = [UIImage imageNamed:@"tabbarIcon"];
    }
    // 布局查看
//    if (indexPath.item % 2 == 0) {
//        cCell.backgroundColor = [UIColor greenColor];
//    } else {
//        cCell.backgroundColor = [UIColor yellowColor];
//    }
    return cCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.rightArray[indexPath.item];
    if ([model isKindOfClass:[AdvertInfoModel class]]) {
        AdvertInfoModel *infoModel = (AdvertInfoModel *)self.rightArray[indexPath.item];
        [self advertJumpH5:infoModel];
    } else {
        // 专区跳转
        ActivityModel *infoModel = (ActivityModel *)self.rightArray[indexPath.item];
        [self fatherJumpH5:infoModel.activityHead prefecture:infoModel];
    }
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollView;
}

//- (BusinessTypeHeaderView *)headerView {
//    if (!_headerView) {
//        _headerView = [[BusinessTypeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//        __weak typeof(self) weakSelf = self;
//        _headerView.changeSupplierBlock = ^{
//            if (weakSelf.supplierArray.count == 0) {
//                [weakSelf getOrgData];
//            }
//            NSLog(@"切换机构");
//            SelectCityView *cityView = [[SelectCityView alloc] initWithNib];
//            cityView.cityArray = weakSelf.supplierArray;
//            cityView.isForSupplierSelected = YES;
//            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            cityView.selectCityBlock = ^(NSInteger index) {
//                NSLog(@"选中了第%zd个机构", index);
//                weakSelf.supplierSelectIndex = index;
//                ChannelModel *model = weakSelf.supplierArray[index];
//                [weakSelf.headerView updateSupplierName:model.supplierName];
//            };
//            [dele.window addSubview:cityView];
//        };
//        if (CurrentUser.defaultSupplierName) {
//            [_headerView updateSupplierName:CurrentUser.defaultSupplierName];
//        }
//        _headerView.changeDefaultChannelBlock = ^{
//            NSLog(@"切换默认渠道");
//            ChangeChannelView *channelView = [[ChangeChannelView alloc] init];
//            AppDelegate *globalDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [globalDelegate.window addSubview:channelView];
//        };
//    }
//    return _headerView;
//}

- (UITableView *)typeTableView {
    if (!_typeTableView) {
//        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.viewHeight, 120, SCREEN_HEIGHT-self.headerView.viewHeight-Nav_Height-TabBar_Height) style:UITableViewStylePlain];
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, SCREEN_HEIGHT-Nav_Height-TabBar_Height) style:UITableViewStylePlain];
        _typeTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        _typeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _typeTableView;
}

- (UICollectionView *)mainCollView {
    if (!_mainCollView) {
        UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init];
//        customLayout.itemSize = CGSizeMake(50, 50);
//        _mainCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.typeTableView.viewWidth, self.headerView.viewHeight, SCREEN_WIDTH - self.typeTableView.viewWidth, SCREEN_HEIGHT-self.headerView.viewHeight-Nav_Height-TabBar_Height) collectionViewLayout:customLayout];
        _mainCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.typeTableView.viewWidth, 0, SCREEN_WIDTH - self.typeTableView.viewWidth, SCREEN_HEIGHT-Nav_Height-TabBar_Height) collectionViewLayout:customLayout];
        _mainCollView.delegate = self;
        _mainCollView.dataSource = self;
        _mainCollView.backgroundColor = [UIColor whiteColor];
        _mainCollView.showsVerticalScrollIndicator = NO;
        _mainCollView.showsHorizontalScrollIndicator = NO;
//        _mainCollView.pagingEnabled = YES;
        [_mainCollView registerClass:[BusinessCCell class] forCellWithReuseIdentifier:@"BusinessCCell"];
    }
    return _mainCollView;
}

- (NSMutableArray *)leftArray {
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}

- (NSMutableArray *)rightArray {
    if (!_rightArray) {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
}

//- (NSMutableArray *)supplierArray {
//    if (!_supplierArray) {
//        _supplierArray = [NSMutableArray array];
//    }
//    return _supplierArray;
//}

- (NSMutableArray *)activityArray {
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
    }
    return _activityArray;
}
@end
