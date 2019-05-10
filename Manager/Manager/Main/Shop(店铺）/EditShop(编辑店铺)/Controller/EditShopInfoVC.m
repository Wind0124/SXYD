//
//  EditShopInfoVC.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "EditShopInfoVC.h"
#import "ShopCoverView.h"
#import "ShopInfoCell.h"
#import "ModifyPictureCell.h"
#import "ModifyShopIntroAndCoverView.h"
#import "ShopAddressVC.h"
// 分享
#import "YBPopupMenu.h"
// 分享-海报
#import "PosterVC.h"
// 分享-二维码
#import "StoreQrCodeVC.h"
// 分享
#import "ShareView.h"

@interface EditShopInfoVC ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView *mainTab;//主页面
@property (nonatomic, strong) ShopInfoModel *model; // 店铺数据
@property (nonatomic, strong) NSMutableArray *picArray; // 图片数据
@property (nonatomic, strong) ShopCoverView *coverView; // 店铺封面view
@property (nonatomic ,strong) UIBarButtonItem *rightItem;

@end

@implementation EditShopInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺信息";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    [self.view addSubview:self.mainTab];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.coverView = [[ShopCoverView alloc] initWithNib];
    __weak typeof(self) weakSelf = self;
    self.coverView.ShopCoverViewEditBlock = ^{
        // 编辑店铺描述、封面
//        [weakSelf alertWithMessage:@"编辑"];
        ModifyShopIntroAndCoverView *view = [[ModifyShopIntroAndCoverView alloc] initWithNib];
        view.model = weakSelf.model;
        view.fatherVC = weakSelf;
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [dele.window addSubview:view];
    };
    self.mainTab.tableHeaderView = self.coverView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getShopInfo];
}

#pragma mark - 网络请求
- (void)getShopInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI getShopInfoBlock:^(BaseModel *object, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (object) {
            NSLog(@"%@",object);
            self.model = (ShopInfoModel *)object;
            self.coverView.model = self.model;
            if (self.model.pictureUrl.length > 0) {
                NSArray *array = [self.model.pictureUrl componentsSeparatedByString:@","];
                self.picArray = [NSMutableArray arrayWithArray:array];
            }
            CurrentUser.shopName = self.model.name;
            [CurrentUser archive];
            [self.mainTab reloadData];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

- (void)uploadImage:(UIImage *)image {
    // 上传图片
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI uploadImage:image block:^(NSString *string, HeadModel *error) {
        if (string) {
            [self.picArray addObject:string];
            [self.mainTab reloadData];
            // 更新店铺信息
            NSString *picAllString = [self.picArray componentsJoinedByString:@","];
            [self updateShop:@{@"pictureUrl": picAllString, @"id": self.model.info_id,}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

- (void)updateShop:(NSDictionary *)parameters {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI modifyShopWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            NSLog(@"更新成功");
//            [self alertWithMessage:@"更新成功"];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    tmpView.backgroundColor = hexStringToColor(COLOR_Background);
    return tmpView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([self.model.isAgent isEqualToString:@"true"]) {
            return 60;
        } else {
            return 0;
        }
    }
    if (indexPath.row == 3) {
        return 100;
    }
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imgArray = @[@"myShop_img_0", @"myShop_img_1", @"myShop_img_2"];
    if (indexPath.row <= 2) {
        NSString *identifyString = @"ShopInfoCell";
        ShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        if (indexPath.row == 0) {// 是否代理商
            if ([self.model.isAgent isEqualToString:@"true"]) {
                cell.imgView.image = [UIImage imageNamed:imgArray[0]];
                cell.titleLabel.text = @"一级代理商";
                cell.lineView.hidden = NO;
            } else {
                cell.titleLabel.text = @"";
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {// 电话
            cell.imgView.image = [UIImage imageNamed:imgArray[1]];
            cell.titleLabel.text = self.model.mobile;
            cell.lineView.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 2) {// 地址
            cell.imgView.image = [UIImage imageNamed:imgArray[2]];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.model.province?:@"", self.model.city?:@"", self.model.district?:@"", self.model.businessAddress?:@""];
            cell.lineView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    if (indexPath.row == 3) {
        NSString *identifyString = @"ModifyPictureCell";
        ModifyPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].lastObject;
        }
        cell.picArray = self.picArray;
        cell.ModifyDelePicBlock = ^(NSInteger index) {
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除该图片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertCtl addAction:cancelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.picArray removeObjectAtIndex:index];
                [self.mainTab reloadData];
                NSString *picAllString = [self.picArray componentsJoinedByString:@","];
                [self updateShop:@{@"pictureUrl": picAllString, @"id": self.model.info_id,}];
            }];
            [alertCtl addAction:confirmAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        };
        cell.ModifyAddPicBlock = ^{
            [self addLocalPic];
        };
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
//        [self alertWithMessage:@"跳转地图"];
        ShopAddressVC *addressVC = [[ShopAddressVC alloc] init];
        addressVC.model = self.model;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
}

#pragma mark - 本地事件
- (void)addLocalPic {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(![UIImagePickerController isSourceTypeAvailable:sourceType]){
        [self alertWithMessage:@"不支持本地相册"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)shareAction:(UIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:@[@"二维码", @"分享", @"海报"] icons:@[@"shop_share_qrCode", @"shop_share_share", @"shop_share_haibao"] menuWidth:120 delegate:self];

}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    // H5
    if (![self checkChannelStatus]) {
        return ;
    }
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    //    [self alertWithMessage:@"敬请期待\n分享功能"];
    //    return;
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
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
//    NSString *strName = [NSString stringWithFormat:@"Iphone%@.jpg",[self getNameFromCurrentTime]];
//    _m_filePath = [NSString stringWithFormat:@"%@/%@",DocumentsPath,strName];
//
//    [UIImageJPEGRepresentation(image,1.0) writeToFile:_m_filePath atomically:YES];
//    [self uploadImageDataRequest];
    
    [self uploadImage:image];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 懒加载
-(UITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+IPHONEX_TOP_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT-64-IPHONEX_TOP_SPACE) style:UITableViewStyleGrouped];
        _mainTab.dataSource = self;
        _mainTab.delegate = self;
        _mainTab.backgroundColor = hexStringToColor(COLOR_Background);
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTab;
}

- (NSMutableArray *)picArray {
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

-(UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - 10, 20+IPHONEX_TOP_SPACE, 50, 35);
        [shareBtn setImage:[UIImage imageNamed:@"shop_more_black"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    }
    return _rightItem;
}

@end
