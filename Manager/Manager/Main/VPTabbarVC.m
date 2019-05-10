//
//  VPTabbarVC.m
//  Manager
//
//  Created by vpclub on 2018/12/27.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "VPTabbarVC.h"
#import "MarketHomeVC.h"
#import "ShopVC.h"
#import "WorkTableVC.h"
#import "MineVC.h"
#import "MessageVC.h"
#import "GuideVC.h"
#import "BusinessTypeVC.h"

@interface VPTabbarVC ()<UITabBarControllerDelegate>

@property (nonatomic ,strong) NSArray *recordsArr;//网络请求的tab数据

@end

@implementation VPTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self removeSystemBarbtn];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbarController:) name:ShowTabbarController object:nil];
//    for (UIView *btn in self.tabBar.subviews) {
//        NSLog(@"%@",btn);
//    }
}

//移除系统tabbar上面的按钮(UITabBarButton类型)
- (void)removeSystemBarbtn{
    Class class =  NSClassFromString(@"UITabBarButton");
    for (UIView *view in self.tabBar.subviews) {
        //如果view是由UITabBarButton类创建的对象,则将其移除
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - 网络请求
- (void)loadData {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": AdvertBottomMenu},
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (object) {
            PageModel *pageModel = (PageModel *)object;
            NSArray *dataArray = pageModel.datas;
            // 保存主页tabbar数据
            [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:TABBARDATA];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self analyseData:dataArray];
        } else {
            NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:TABBARDATA];
            if (dataArray) {
                [self analyseData:dataArray];
            } else {
                if ([error.code isEqualToString:@"100019"]) {
                    // 服务器时间错误
                    [self loadData];
                } else {
                    NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
                    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    dele.window.rootViewController = self;
                    [self alertWithMessage:message];
                }
            }
        }
    }];
}

- (void)analyseData:(NSArray *)dataArray {
    NSMutableArray *bannerArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dic = dataArray[i];
        AdvertInfoModel *infoModel = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
        NSLog(@"底部菜单栏:%@", infoModel.name);
        [bannerArray addObject:infoModel];
    }
    [self setRecordsArr:bannerArray];
}

- (void)setRecordsArr:(NSArray *)recordsArr {
    _recordsArr = recordsArr;
    
    for (int i = 0; i < self.recordsArr.count; i++) {
        AdvertInfoModel *model = self.recordsArr[i];
//        NSLog(@"%@", model);
        // 创建控制器
        BaseVC *childController = [self tabbarViewController:model.linkAddr];
//        childController.title = model.name;
        // 创建TabbarButton
        [self createTabbarItem:model index:i];
        
        // 加导航
        BaseNav *nav = [[BaseNav alloc] initWithRootViewController:childController];
        [self addChildViewController:nav];
    }
    // 菜单栏是否要透明
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.selectedIndex = 0;
    
//    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    dele.window.rootViewController = self;    
}

// 创建控制器
- (id)tabbarViewController:(NSString *)linkAddr{
    id childController;
    if ([linkAddr isEqualToString:@"cmccShop"]) {
        ShopVC *shop = [[ShopVC alloc] init];
        childController = shop;
    } else if ([linkAddr isEqualToString:@"cmccMarking"]) {
        MarketHomeVC *mkHomeVC = [[MarketHomeVC alloc] init];
        childController = mkHomeVC;
    } else if ([linkAddr isEqualToString:@"cmccWorkbench"]) {
        WorkTableVC *work = [[WorkTableVC alloc] init];
        childController = work;
    } else if ([linkAddr isEqualToString:@"cmccPersonal"]) {
        MineVC *mine = [[MineVC alloc] init];
        childController = mine;
    } else if ([linkAddr isEqualToString:@"cmccMessage"]) {
        MessageVC *message = [[MessageVC alloc] init];
        childController = message;
    } else if ([linkAddr isEqualToString:@"cmccBusiness"]) {
        BusinessTypeVC *businessType = [[BusinessTypeVC alloc] init];
        childController = businessType;
    }
    return childController;
}

// 创建按钮
- (UIButton *)createTabbarItem:(AdvertInfoModel *)model index:(NSInteger)index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/self.recordsArr.count * index, 0, SCREEN_WIDTH/self.recordsArr.count, 49);
    [btn setTitle:model.name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateSelected];
    btn.tag = index + 100;
    if (index == 0) {
        btn.selected = YES;
    }
    // 处理图片地址
    NSString *fullImgString = [NSString getFullImageUrlString:model.image server:CurrentUser.imgServerPrefix];
    NSLog(@"图片地址%@",fullImgString);
    [btn sd_setImageWithURL:[NSURL URLWithString:fullImgString] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *scalImage = [self OriginImage:image scaleToSize:CGSizeMake(20, 20)];
        [btn setImage:scalImage forState:UIControlStateNormal];
    }];
    NSString *fullReverseImgString = [NSString getFullImageUrlString:model.reserveImage server:CurrentUser.imgServerPrefix];
    NSLog(@"选中图片地址%@",fullReverseImgString);
    [btn sd_setImageWithURL:[NSURL URLWithString:fullReverseImgString] forState:UIControlStateSelected completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *scalImage = [self OriginImage:image scaleToSize:CGSizeMake(20, 20)];
        [btn setImage:scalImage forState:UIControlStateSelected];
    }];
    
    // 调整位置 (top,left,bottom,right)
    CGSize titleSize = btn.titleLabel.intrinsicContentSize;
//    CGSize imageSize = button.currentImage.size;// 网络图片未加载没有size
    CGSize imageSize = CGSizeMake(20, 20);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height, 0, 0, -titleSize.width)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + 10, -imageSize.width, 0, 0)];
    
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btn];
    return btn;
}

- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)btnAction:(UIButton *)sender {
    NSLog(@"点击 %ld", sender.tag - 100);
    UIButton *oldSelectBtn = [self.tabBar viewWithTag:self.selectedIndex + 100];
    oldSelectBtn.selected = NO;
    sender.selected = YES;
    self.selectedIndex = sender.tag - 100;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    for (int i = 0; i < self.recordsArr.count; i++) {
        UIButton *btn = [self.tabBar viewWithTag:100 + i];
        if (self.selectedIndex == i) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    //    NSLog(@"%@",viewController);
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        NSLog(@"%@", nav.topViewController);
    }
}

#pragma mark - H5切换
- (void)showTabbarController:(NSNotification *)notification {
    NSString *flagString = [notification object];
    NSLog(@"传参数%@", flagString);
    if ([flagString isEqualToString:@"100"]) {
        for (int i = 0; i < self.viewControllers.count; i++) {
            BaseNav *childNav = self.viewControllers[i];
            BaseVC *childVC = childNav.viewControllers.firstObject;
            if ([childVC isKindOfClass:[ShopVC class]]) {
                self.selectedIndex = i;
                break;
            }
        }
    } else if ([flagString isEqualToString:@"101"]) {
        for (int i = 0; i < self.viewControllers.count; i++) {
            BaseNav *childNav = self.viewControllers[i];
            BaseVC *childVC = childNav.viewControllers.firstObject;
            if ([childVC isKindOfClass:[MarketHomeVC class]]) {
                self.selectedIndex = i;
                break;
            }
        }
    } else if ([flagString isEqualToString:@"102"]) {
        for (int i = 0; i < self.viewControllers.count; i++) {
            BaseNav *childNav = self.viewControllers[i];
            BaseVC *childVC = childNav.viewControllers.firstObject;
            if ([childVC isKindOfClass:[WorkTableVC class]]) {
                self.selectedIndex = i;
                break;
            }
        }
    } else if ([flagString isEqualToString:@"103"]) {
        for (int i = 0; i < self.viewControllers.count; i++) {
            BaseNav *childNav = self.viewControllers[i];
            BaseVC *childVC = childNav.viewControllers.firstObject;
            if ([childVC isKindOfClass:[MineVC class]]) {
                self.selectedIndex = i;
                break;
            }
        }
    }
}

#pragma mark -
- (void)alertWithMessage:(NSString *)message {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

@end
