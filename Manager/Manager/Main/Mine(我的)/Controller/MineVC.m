//
//  MineVC.m
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView_SX.h"
#import "BusinessAdvertCell.h"
#import "MineSettingVC.h"
#import "WebViewController.h"
// 4A+渠道管理 提醒
#import "AuthTipView.h"
// 4A管理
#import "Manager4AVC.h"
#import "CertificateVC_SX.h"
// 千店万员注册
#import "ShopperRegisterVC.h"
// 渠道管理
#import "ManagerChannelVC.h"
// 认证管理-手机号
#import "ManagerAuthPhoneVC.h"
// 切换渠道
#import "ChangeChannelView.h"
@interface MineVC ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 总体View
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) MineHeaderView_SX *headerView;
// 百宝箱数据
@property (nonatomic, strong) NSMutableArray *chestArray;
// 认证和渠道 弹窗
@property (nonatomic, strong) AuthTipView *tipView;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    NSLog(@"%@, %s",self, __func__);
    // 更新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:UpdateUserInfo object:nil];
    [self.view addSubview:self.mineTableView];
    [self initTableViewHeaderView];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.headerView updateUserInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@", self.tipView);
    if (self.tipView) {
        [self.tipView showAgain];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UI
- (void)initTableViewHeaderView {
    // 头部(WindWarning高度180-220之间，iPhone X下拉刷新后，cell点击不了，需滑动一下。未解决的bug）
    CGFloat height = 140+Nav_Height;
    self.headerView = [[MineHeaderView_SX alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    __weak typeof(self) weakSelf = self;
    self.headerView.mineSettingBlock = ^{
        // 跳转setting
        MineSettingVC *settingVC = [[MineSettingVC alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    self.headerView.mineAvatarBlock = ^{
        // 更改头像
        [weakSelf addLocalPic];
    };
    self.mineTableView.tableHeaderView = self.headerView;
    
    // 脚部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
//    footerView.backgroundColor = [UIColor greenColor];
    self.mineTableView.tableFooterView = footerView;
}

- (void)showAuthTipView {
    // 判断是否需要显示4A认证和渠道管理View
    NSString *key = [NSString stringWithFormat:@"%@+%@", ShowAuthTipView, CurrentUser.mobile];
    NSString *showAuthTip = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    BOOL noAuth = (CurrentUser.crmStatus.integerValue == 3);
    BOOL noChannel = (CurrentUser.channelStatus.integerValue != 1);
    if (![showAuthTip isEqualToString:@"NO"] && (noAuth || noChannel)) {
        self.tipView = [[AuthTipView alloc] initWithNib];
        self.tipView.fatherVC = self;
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [dele.window addSubview:self.tipView];
    }
}

#pragma mark - 数据
- (void)getData {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    
    dispatch_group_t group = dispatch_group_create();
    // 用户数据
    dispatch_group_enter(group);
    [VPAPI getUserInfo:^(BOOL succeeded, HeadModel *error) {
        dispatch_group_leave(group);
        if (succeeded) {
            [self.headerView updateUserInfo];
            [self showAuthTipView];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
    // 百宝箱数据
    dispatch_group_enter(group);
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": Chest},
                           };
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        dispatch_group_leave(group);
        if (object) {
            [self.chestArray removeAllObjects];
            [self.chestArray addObjectsFromArray:array];
            AdvertInfoModel *model = [[AdvertInfoModel alloc] init];
            model.name = @"跳SMRZ";
            [self.chestArray addObject:model];
            [self.mineTableView reloadData];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
    });
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.chestArray.count > 0) {
        return 50;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.chestArray.count > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 25)];
        label.text = @"百宝箱";
        label.textColor = [UIColor lightGrayColor];
        [view addSubview:label];
        
        CGFloat btnWidth = 80;
        UIButton *changeChannelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - btnWidth, 15, btnWidth, 26)];
        [changeChannelBtn setTitle:@"切换渠道" forState:UIControlStateNormal];
        [changeChannelBtn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        changeChannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        changeChannelBtn.backgroundColor = UIColor.whiteColor;
        changeChannelBtn.layer.borderWidth = 1;
        changeChannelBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        changeChannelBtn.layer.cornerRadius = 4;
        changeChannelBtn.layer.masksToBounds = YES;
        [changeChannelBtn addTarget:self action:@selector(changeDefaultChannel) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:changeChannelBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 50 - 1, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = hexStringToColor(COLOR_Background);
        [view addSubview:lineView];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view.backgroundColor = hexStringToColor(COLOR_Background);
        return view;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
////    view.backgroundColor = hexStringToColor(COLOR_Background);
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger row = ceil(self.chestArray.count / 4.0);
        return row * 80;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessAdvertCell"];
    if (!cell) {
        cell = [[BusinessAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessAdvertCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataArray = self.chestArray;
    cell.block = ^(BaseModel * _Nonnull baseModel) {
        AdvertInfoModel *model = (AdvertInfoModel *)baseModel;
        NSLog(@"广告 跳转数据");
        [self advertJumpH5:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了%zd %zd", indexPath.section, indexPath.row);
}

#pragma mark - 跳转
// 广告
- (void)advertJumpH5:(AdvertInfoModel *)model {
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
    if ([model.name isEqualToString:@"4A管理"]) {
        if (CurrentUser.crmStatus.integerValue == 3) {// 未认证
            CertificateVC_SX *certificateVC = [[CertificateVC_SX alloc] init];
            certificateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:certificateVC animated:YES];
        } else {
            Manager4AVC *manager4AVC = [[Manager4AVC alloc] init];
            manager4AVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:manager4AVC animated:YES];
        }
        return YES;
    }
    if ([model.name isEqualToString:@"渠道管理"]) {
        if (CurrentUser.channelStatus.integerValue == 0) {
            // 未注册千店万员
            ShopperRegisterVC *registerVC = [[ShopperRegisterVC alloc] init];
            registerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registerVC animated:YES];
        } else {
            ManagerChannelVC *managerChannelVC = [[ManagerChannelVC alloc] init];
            managerChannelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerChannelVC animated:YES];
        }
        return YES;
    }
    if ([model.name isEqualToString:@"认证管理"]) {
        if (CurrentUser.crmStatus.integerValue == 3) {
            [self alertWithMessage:@"去4A认证" complete:^{
                CertificateVC_SX *certificateVC = [[CertificateVC_SX alloc] init];
                certificateVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:certificateVC animated:YES];
            }];
            return YES;
        }
        ManagerAuthPhoneVC *authPhoneVC = [[ManagerAuthPhoneVC alloc] init];
        authPhoneVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authPhoneVC animated:YES];
        return YES;
    }
    if ([model.name isEqualToString:@"跳SMRZ"]) {
//        NSDictionary *para = @{@"billId": @"15129228901",
//                               @"businessCode": @"k9999",
//                               };
//        [VPAPI2 realnameAuthSignWithDic:para block:^(BaseModel *object, HeadModel *error) {
//            if (object) {
//                [self jumpSMRZ:(SMRZParametersModel *)object];
//            } else {
//                [self alertWithMessage:error.msg];
//            }
//        }];
        [self jumpSMRZ:nil];
        return YES;
    }
    return NO;
}

- (void)jumpSMRZ:(SMRZParametersModel *)model {
//    NSDictionary *dicData = @{ @"transactionID": model.transactionId,
//                               @"billId": model.billId,
//                               @"account": model.account,
//                               @"channelCode": model.channelCode,
//                               @"provinceCode": model.provinceCode,
//                               @"signature": model.signature,
//                               @"mode":@"3"
//                               };
    
    NSDictionary *dicData = @{ @"transactionID": @"29000120190418103834000699",
                               @"billId": @"15129228901",
                               @"account": @"J0_guolei",
                               @"channelCode": @"J0J00060",
                               @"provinceCode": @"290",
                               @"signature": @"bjw+jyo0439pjL8S4FlbV+si9SdziD/dysNMUynQreeGQEA6dz2xNiWoLvSkpa1SwyXklB/+DRiutGSGoFZe9u6M5TW3lQyKCujBGwBpYxxgincDGZ/vl+op2xdmt6HaE3Thyf/ckodnWeI+QURT93/TiZFYL0MvKdZqiFDZaueHyGbJ3/VDuLVUmDFpySPpQn/Z4PtCFGy0L3Uo+AhfqqhdVd8f65C+8qrroDBhY9gKUDy596G7kQwJvNDl/KP1HTHgDP5k4K+BrzlQlcl9fFTARwkWK/OtRGaMeJH+HVxeAQww1+AQBvYHmvxejaLNACyY7h0cL0XyZu9d0oNqsw==",
                               @"mode":@"3"
                               };
    NSLog(@"唤起实名认证APP传参：%@", dicData);
    //NSDictionary转换为jsonStrong
    NSData *jsonDataa = [NSJSONSerialization dataWithJSONObject:dicData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonDataa encoding:NSUTF8StringEncoding];
    jsonString = [self URLEncodedString:jsonString]; //URLEncoded，⻅下⽅
    NSString *scheme = @"IDENTITYAUTHENTICATION://"; //构建调⽤用⽤用插件的URL scheme
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",scheme ,jsonString]];
    NSLog(@"唤起实名认证APP 完整URL\n%@", url);
    [[UIApplication sharedApplication] openURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelSMRZResult:) name:SMRZResult object:nil];

}

- (void)handelSMRZResult:(NSNotification *)notification {
    NSLog(@"实名认证结果:%@", [notification object]);
    // 认证结果保存到服务器
    
    // 通知H5认证结果 0失败 1成功
//    NSString *methodString = @"SMRZResult('0')";
//    [self.webView evaluateJavaScript:methodString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        NSLog(@"value: %@ error: %@", response, error);
//    }];
    
}
- (NSString *)URLEncodedString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

#pragma makr - 点击事件
- (void)changeDefaultChannel {
    NSLog(@"切换默认渠道");
    ChangeChannelView *channelView = [[ChangeChannelView alloc] init];
    AppDelegate *globalDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [globalDelegate.window addSubview:channelView];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)addLocalPic {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self alertWithMessage:@"不支持本地相册"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = image.size;
    CGFloat scale = 1;
    if (imageSize.width > 300) {
        scale = 300 / imageSize.width;
    }
    imageSize.height = imageSize.height*scale;
    imageSize.width = imageSize.width*scale;
    image = [self imageWithImage:image scaledToSize:imageSize];
    
    [self uploadImage:image];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)uploadImage:(UIImage *)image {
    // 上传图片
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI uploadImage:image block:^(NSString *string, HeadModel *error) {
        if (string) {
            [self modifyUserAvatar:string];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            //                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

- (void)modifyUserAvatar:(NSString *)imgString {
    NSDictionary *para = @{@"str": imgString,};
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI modifyUserAvatarWithDic:para block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            NSLog(@"更新成功");
            CurrentUser.faceUrl = imgString;
            [self.headerView updateUserInfo];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            //                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - 懒加载
- (UITableView *)mineTableView {
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -Status_Height, SCREEN_WIDTH, SCREEN_HEIGHT - TabBar_Height + Status_Height) style:UITableViewStyleGrouped];
        _mineTableView.delegate = self;
        _mineTableView.dataSource = self;
        _mineTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 刷新
        _mineTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
            [self.mineTableView.mj_header endRefreshing];
        }];
    }
    return _mineTableView;
}

- (NSMutableArray *)chestArray {
    if (!_chestArray) {
        _chestArray = [NSMutableArray array];
    }
    return _chestArray;
}

#pragma mark - 管理器相关
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
