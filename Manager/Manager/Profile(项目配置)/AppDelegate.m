//
//  AppDelegate.m
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "WUGesturesUnlockViewController.h"
#import "VPTabbarVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import "UpdateView.h"
#import "GuideVC.h"
#import "LoginVC_SX.h"
#import "HUDImageView.h"

@interface AppDelegate ()<BMKLocationAuthDelegate>

@property (nonatomic, strong) VPTabbarVC *tabbarVC;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AppDelegate
// MarthFive
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置UserAgent，wkWebView打开H5判断当前是iOS app
    [self setUserAgent];
    
    // 解档历史用户数据
    [CurrentUser unarchive];

    // 查询系统参数配置列表
    [VPAPI getSystemParameterList];
    
    // 进入主界面之前
    [self enterGuideVC];
    
    // 添加通知
    [self addNotification];
    
    // SDK 初始化
    [ShareManger connectShareSDK];
    
    // baidu地图
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"RlHQtCdSZN9Gew8xLbEGGnYtgNUGUBDY" authDelegate:self];
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"RlHQtCdSZN9Gew8xLbEGGnYtgNUGUBDY" generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图manager start failed!");
    } else {
        NSLog(@"百度地图start成功");
    }
    return YES;
}

#pragma mark - 通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrGesture) name:LoginOrGesture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:Logout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomePageBanner) name:GetHomePageBanner object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudShow) name:SHOW_HUD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHud) name:HIDE_HUD object:nil];
}

#pragma mark - 进入主界面之前
- (void)enterGuideVC {
    // 提前创建tabbar获取数据
    self.tabbarVC = [[VPTabbarVC alloc] init];
    
    GuideVC * guideVC = [[GuideVC alloc] init];
    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:guideVC];
    self.window.rootViewController = nav;
}

#pragma mark - 登录
- (void)loginOrGesture {
    // APP升级
    [self performSelector:@selector(checkUpdate) withObject:nil afterDelay:2];

    if (CurrentUser.token) {
        // 是否已设置手势
//        BOOL hasGesture = CurrentUser.gesturesPassword ? YES : NO;
//        [self welcomeVCWithGesture:hasGesture];
        // 直接进入主界面(陕西)
        [self getHomePageBanner];
    } else {
        [self login];
    }
}

- (void)login {
    // 进入登录页面
//        LoginVC * loginVC = [[LoginVC alloc] init];
    LoginVC_SX *loginVC = [[LoginVC_SX alloc] init];
    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
}

// 进入首页
- (void)getHomePageBanner {
    if (!self.tabbarVC) {
        self.tabbarVC = [[VPTabbarVC alloc] init];
    }
    self.window.rootViewController = self.tabbarVC;
}

// 退出登录
- (void)logout {
    // 新的主界面
    if (self.tabbarVC) {
        self.tabbarVC = [[VPTabbarVC alloc] init];
    }
    [self login];
}

// 进入手势页面
- (void)welcomeVCWithGesture:(BOOL)hasGesture {
    NSInteger GestureType;
    if (hasGesture) {// 有手势，进入验证手势界面
        GestureType = WUUnlockTypeValidatePwd;
    } else {// 无手势，进入创建手势界面
        GestureType = WUUnlockTypeCreatePwd;
    }
    WUGesturesUnlockViewController * root = [[WUGesturesUnlockViewController alloc] initWithUnlockType:GestureType];
    BaseNav * nav = [[BaseNav alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
}

#pragma mark - update
- (void)checkUpdate {
    [VPAPI getAPPVersionBlock:^(BaseModel *object, HeadModel *error) {
        if (object) {
            NSLog(@"%@",object);
            APPVersionModel *model = (APPVersionModel *)object;
            NSInteger status = [model.status integerValue];
            NSInteger isUpgrade = [model.isUpgrade integerValue];
            if (status == 1 && (isUpgrade == 1 || isUpgrade == 2)) {
                UpdateView *updateView = [[UpdateView alloc] initWithNib];
                updateView.model = model;
                [self.window addSubview:updateView];
            }
        }
    }];
}

#pragma mark - webview隐藏H5头部
- (void)setUserAgent {
    // 获取默认User-Agent
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    // 给User-Agent添加额外的信息
    NSString *newAgent = [NSString stringWithFormat:@"%@;%@", oldAgent, @"cmccios"];
    NSLog(@"newAgent:%@",newAgent);
    // 设置global User-Agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

#pragma mark - HUD
-(void)hudShow {
    [self show:@"" view:self.window];
    //自动隐藏处理
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf hiddenHud];
    });
}

-(void)hiddenHud {
    if (![self.hud isHidden]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
        });
    }
}

- (void)show:(NSString *)text view:(UIView *)view {
    if (_hud) {
        [_hud hideAnimated:YES];
        [_hud removeFromSuperview];
        _hud = nil;
    }
    [self.hud showAnimated:YES];
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.window];
        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.bezelView.backgroundColor = [UIColor clearColor];
        _hud.mode = MBProgressHUDModeCustomView;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:gifData];
        HUDImageView *imageView = [[HUDImageView alloc] init];
        if (SCREEN_WIDTH == 320) {
            imageView.frame = CGRectMake(0, 0, 80, 80);
        } else {
            imageView.frame = CGRectMake(0, 0, 120, 120);
        }
        imageView.image =image;
        _hud.customView = imageView;
        [self.window addSubview:_hud];
    }
    return _hud;
}

#pragma mark - 其他application
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@",url);
    NSData *jsonData = [url.host dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:SMRZResult object:nil];
        return NO;
    }
    //字典dic中包含了返回的信息大致如下 /*
    //    "address" : "",
    //    "signer" : "",
    //    "period" : "",
    //    "id" : "",
    //    "result" : "",
    //    "birthday" : "",
    //    "resultCode" : 0,
    //    "sex" : "",
    //    "name" : ""
    //    */
    //resultCode等于@0表示身份证未读取 反之表示读取成功。
    //result等于@“1”表示本次校验成功，反之则表示不成功
    NSLog(@"SMRZ APP回调数据%@",dic);
//    if ([[dic objectForKey:@"result"] isEqual:@"1"]) {
//        //验证成功
//        NSLog(@"验证成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:SMRZResult object:dic];
//    } else {
//        //验证失败
//        NSLog(@"验证失败");
//        [[NSNotificationCenter defaultCenter] postNotificationName:SMRZResult object:nil];
//    }
    return YES;
}

@end
