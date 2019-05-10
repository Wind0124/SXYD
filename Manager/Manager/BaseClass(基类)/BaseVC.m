//
//  BaseVC.m
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseVC.h"
#import "ShopperRegisterVC.h"// 注册千店万员
#import "ManagerChannelVC.h" // 渠道管理
#import "WebViewController.h"// H5界面
#import "CertificateVC_SX.h"// 4A认证
@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.size = CGSizeMake(34, 34);
    [backBtn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = hexStringToColor(@"5C5C5C");

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   

#pragma mark - 跳H5之前判断
- (BOOL)checkChannelStatus {
    if (CurrentUser.channelStatus.integerValue == 0) {
        [self alertWithMessage:@"注册千店万员" complete:^{
            ShopperRegisterVC *registerVC = [[ShopperRegisterVC alloc] init];
            registerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registerVC animated:YES];
        }];
        return NO;
    } else if (CurrentUser.channelStatus.integerValue == -1) {
        [self alertWithMessage:@"绑定渠道" complete:^{
            ManagerChannelVC *channelVC = [[ManagerChannelVC alloc] init];
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }];
        return NO;
    } else if (!CurrentUser.defaultChannelId) {
        [self alertWithMessage:@"设置默认渠道" complete:^{
            ManagerChannelVC *channelVC = [[ManagerChannelVC alloc] init];
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }];
        return NO;
    }
    return YES;
}

#pragma mark - 跳H5
- (void)showAdvertWithModel:(AdvertInfoModel *)model Supplier:(ChannelModel *)supplierModel {
    NSLog(@"跳转业务：%@", model);
    if ([model.dictionaryAdvertTypeCode isEqualToString:@"shanxi_open_an_account_the_net"]) {
        if (CurrentUser.crmStatus.integerValue == 3) {
            [self alertWithMessage:@"去4A认证" complete:^{
                CertificateVC_SX *certificateVC = [[CertificateVC_SX alloc] init];
                certificateVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:certificateVC animated:YES];
            }];
            return;
        }
        // 开户业务
        WebViewController * web = [[WebViewController alloc]init];
        NSArray *array = [model.linkAddr componentsSeparatedByString:@"businessCode="];
        if (array.count >= 2) {
            web.businessCode = array[1];
        }
        if (!supplierModel) {
            supplierModel = [[ChannelModel alloc] init];
            supplierModel.supplierId = CurrentUser.defaultSupplierId;
            supplierModel.supplierName = CurrentUser.defaultSupplierName;
        }
        web.supplierModel = supplierModel;
        NSString *paraString = [NSString stringWithFormat:@"&supplierId=%@&cityCode=%@&businessType=1", CurrentUser.crmChannelOrgId, CurrentUser.crmCityCode];
        if ([model.linkAddr hasPrefix:@"http"]) {
            web.urlStr = [NSString stringWithFormat:@"%@%@", model.linkAddr, paraString];
        } else {
            web.urlStr = [NSString stringWithFormat:@"%@%@%@", CurrentUser.cmccH5Prefix, model.linkAddr, paraString];
        }
        web.title = model.name;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        return;
    }
    if ([model.dictionaryLinkTypeCode isEqualToString:@"advertExternalLink"]) {
        // 外部链接
        WebViewController * web = [[WebViewController alloc] init];
        web.urlStr = model.linkAddr;
        web.title = model.name;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        return;
    }
    // 其他链接
    NSString *supplierId = supplierModel ? supplierModel.supplierId : (CurrentUser.defaultSupplierId ?: @"");
    NSString *channelId = CurrentUser.defaultChannelId ?: @"";
    NSString *clerkId = CurrentUser.thousandClerkId ?: @"";
    NSString *userId= CurrentUser.userId ?: @"";
    NSString *baseURL;
    if ([model.linkAddr hasPrefix:@"http"]) {
        baseURL = model.linkAddr;
    } else {
        baseURL = [NSString stringWithFormat:@"%@%@", CurrentUser.cmccH5Prefix, model.linkAddr];
    }
    // 业务跳转全部都要拼接参数，先判断链接中是否有问号，运营人员配置时可能会缺少？号
    if ([baseURL containsString:@"?"]) {
        baseURL = [NSString stringWithFormat:@"%@&", baseURL];
    } else {
        baseURL = [NSString stringWithFormat:@"%@?", baseURL];
    }
    //  http://webmdev.central.vpclub.cn/
    //  /business/listTwo?businessCode=MEAL_FLOW_OPTIONAL_PACKAGE_2018_EDITION
    //  &supplierId=%@&supplierName=%@&channelId=%@&clerkId=%@&userId=%@
    NSString *urlString = [NSString stringWithFormat:@"%@supplierId=%@&channelId=%@&clerkId=%@&userId=%@", baseURL, supplierId, channelId, clerkId, userId];
    
    WebViewController * web = [[WebViewController alloc] init];
    web.urlStr = urlString;
    web.title = model.name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - message
- (void)alertWithMessage:(NSString *)message complete:(void (^)(void))block {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)alertWithMessage:(NSString *)message {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)showWithMessage:(NSString *)message {
    UIView* view = self.navigationController.view;
    if (!view) {
        view = self.view;
    }
    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    hud.detailsLabel.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0f];
}

- (void)dealloc {
    NSLog(@"%s, %s", object_getClassName(self), __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
