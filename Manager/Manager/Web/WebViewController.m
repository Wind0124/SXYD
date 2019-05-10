

//
//  WebViewController.m
//  Guess
//
//  Created by inter on 16/11/21.
//  Copyright © 2016年 wankr. All rights reserved.
//

//https://blog.csdn.net/shaobo8910/article/details/80969972

#import "WebViewController.h"
#import "WKWebViewConfiguration+Console.h"
//#import "LoginVC.h"
#import "LoginVC_SX.h"
#import "OpenAccountStepOneVC.h"
// 分享
#import "YBPopupMenu.h"
// 分享
#import "ShareView.h"
// 扫描
#import "ScanVC.h"

@interface WebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, YBPopupMenuDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSURLRequest * request;

@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic, strong) NSDictionary *shareDetailDic;

@property (nonatomic, assign) NSInteger backBtnAction;// -1隐藏 0返回 1关闭
@end

@implementation WebViewController
- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = hexStringToColor(COLOR_Background);
        [self.view addSubview:self.webView];
//        [self showConsole];
        [self initBarItem];
     }
    return self;
}

// 重写 console.log, 打印js的log
- (void)showConsole {
    NSString *jsCode = @"console.log = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.log.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.log);";
    // injected the method when H5 starts to create the DOM tree
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    https://blog.csdn.net/huangyongf/article/details/52165952
//    self.navigationController.navigationBar.translucent = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self cleanWebView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(getHtmlContent)];
}

// 获取网页的html内容
- (void)getHtmlContent {
    NSString *doc = @"document.body.outerHTML";
    [self.webView evaluateJavaScript:doc completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"htmlStr==%@", htmlStr);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initProgressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    // 开启返回手势
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelSMRZResult:) name:SMRZResult object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeAllUserScripts];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.progressView removeFromSuperview];
}

#pragma mark - data
- (void)setUrlStr:(NSString *)urlStr {
    urlStr = @"http://webmdev.central.vpclub.cn/#/openaccount/nfc/home?supplierId=5768482822786372010&cityCode=0910&businessCode=stormAction";
    if (urlStr.length) {
        if (![urlStr hasPrefix:@"http"]) {
            urlStr = [NSString stringWithFormat:@"%@%@", CurrentUser.cmccH5Prefix, urlStr];
        }
        NSLog(@"原url:%@", urlStr);
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        NSLog(@"转码去中文url:%@",  urlStr);
        _urlStr = urlStr;
        NSLog(@"web-url==%@",urlStr);
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [self.webView loadRequest:self.request];
    }
    
    // test 本地html
//    [self loadWebHTMLSring:@"index"];
}

- (void)loadWebWithContentSring:(NSString *)string{
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:string];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    NSURL *baseUrl = [NSURL URLWithString:@"file:///assets/"];
    [self.webView loadHTMLString:htmlString baseURL:baseUrl];
}

//  加载本地网页
- (void)loadWebHTMLSring:(NSString *)string{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    
//    NSString *path = [NSString stringWithFormat:@"%@.html", string];
//    NSURL *pathURL = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
}

#pragma mark - 内部方法
// 清空WebView缓存
- (void)cleanWebView {
    if ([[[UIDevice currentDevice] systemVersion] intValue ] >= 9.0) {
        // 9.0之后才有的
//        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
//        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"清楚缓存完毕");
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

// 返回按钮
- (void)backAction {
    // -1 隐藏 0 返回 1 关闭
    if (self.backBtnAction == 0) {
        if (self.webView.canGoBack) {
            NSLog(@"当前URL：%@,返回列表：%@",self.webView.URL, self.webView.backForwardList);
            [self.webView goBack];
        } else {
            [self closeAction];
        }
    } else if (self.backBtnAction == 1) {
        [self closeAction];
    }
}

// 关闭按钮
-(void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 刷新按钮
- (void)reloadAction {
    [self.webView reload];
}

// 跳转原生页面
- (void)jumpOriginalPage:(NSString *)flagString {
    if ([flagString integerValue] <= 103) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarController object:flagString];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([flagString isEqualToString:@"104"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        // 登陆失效 跳回登陆页面
        [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
        [CurrentUser logout];
        //进入登录界面
//        LoginVC_SX * loginVC = [[LoginVC_SX alloc] init];
//        BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
//        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }
}

#pragma mark - WKNavigationDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"1 decidePolicyForNavigationAction   ====    %@", navigationAction);
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    NSLog(@"absoluteString   ====    %@\n",absoluteString);
    
//    // 唤起支付客户端
//    NSString* reqUrl = navigationAction.request.URL.absoluteString;
//    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        //bSucc是否成功调起支付宝
//    }
//    if ([reqUrl hasPrefix:@"weixin://"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        //bSucc是否成功调起微信
//    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"2 didStartProvisionalNavigation   ====    %@", navigation);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSLog(@"3 decidePolicyForNavigationResponse   ====    %@, statusCode:%zd", response.URL, response.statusCode);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

// 当内容开始到达主帧时被调用（即将完成）
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"4 didCommitNavigation   ====    %@", navigation);
}

// 页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"5 didFinishNavigation   ====    %@", navigation);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
//    [self alertWithMessage:error.userInfo];
}

// 在提交的主帧中发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation====%@\nerror====%@", navigation, error);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
    NSLog(@"webViewWebContentProcessDidTerminate");
}

// 加载HTTPS的链接，需要权限认证时调用
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKUIDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"js 方法名:%@ 参数：%@", message.name, message.body);
}

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%@,%@",prompt, defaultText);
    // 与js进行交互
    if ([prompt isEqualToString:@"getToken"]) {
        NSLog(@"%@",CurrentUser.token);
        completionHandler(CurrentUser.token);
        return;
    } else if ([prompt isEqualToString:@"getRequest"]) {
        NSData *jsonData = [defaultText dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSDictionary *backDic = [[[CCHTTPService alloc] init] setupRequestParameters:dic];
//        NSLog(@"%@", backDic);
        // 转成JSON字符串给H5
        NSString *backJsonStr = [NSString jsonStringWithObject:backDic];
//        NSLog(@"%@",backJsonStr);
        completionHandler(backJsonStr);
        return;
    } else if ([prompt isEqualToString:@"putTitle"]) {
        self.navigationItem.title = defaultText;
        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"setBackMode"]) {
        // -1 隐藏 0 返回 1 关闭
        if ([defaultText integerValue] == -1) {
            self.backBtnAction = -1;
            self.backBtn.hidden = YES;
        } else if ([defaultText integerValue] == 0){
            self.backBtnAction = 0;
            self.backBtn.hidden = NO;
        } else if ([defaultText integerValue] == 1) {
            self.backBtnAction = 1;;
            self.backBtn.hidden = NO;
        }
        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"jumpActivity"]) {
        // 100店铺 101营销 102工作台 103我的 104登录页
        [self jumpOriginalPage:defaultText];
        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"authResult"]) {
        if ([defaultText isEqualToString:@"0"] || [defaultText isEqualToString:@"1"]) {
            // 0无需认证 1认证成功
            // 开户第一步
            OpenAccountStepOneVC *stepOneVC = [[OpenAccountStepOneVC alloc] init];
            stepOneVC.businessCode = self.businessCode;
            stepOneVC.supplierModel = self.supplierModel;
            stepOneVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stepOneVC animated:YES];
            // 移除当前控制器
            NSMutableArray *naviVCsArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in naviVCsArray) {
                if ([vc isKindOfClass:[WebViewController class]]) {
                    [naviVCsArray removeObject:vc];
                    break;
                }
            }
            self.navigationController.viewControllers = naviVCsArray;
        } else {
//            [self alertWithMessage:@"认证失败"];
        }
        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"openScanner"]) {
        ScanVC *scanVC = [[ScanVC alloc] init];
        scanVC.ScanResultBlock = ^(NSString * _Nonnull string) {
            NSString *methodString = [NSString stringWithFormat:@"putIMEI('%@%@')", defaultText, string];
            [self.webView evaluateJavaScript:methodString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
            }];
        };
        [self.navigationController pushViewController:scanVC animated:YES];
        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"putMenu"]) {
        // 保存数据
        NSData *jsonData = [defaultText dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        self.shareDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSString *share = [self.shareDic objectForKey:@"share"];
//        NSString *poster = [self.shareDic objectForKey:@"poster"];
//        NSString *qrCode = [self.shareDic objectForKey:@"qrCode"];
        if (share.integerValue == 1) {
            // 增加分享按钮
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(0, 0, 20, 20);
            [shareBtn setImage:[UIImage imageNamed:@"shop_more_black"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
            self.navigationItem.rightBarButtonItem = shareItem;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }

        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"putShareContent"]) {
        // 保存数据
        NSData *jsonData = [defaultText dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        self.shareDetailDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

        completionHandler(@"");
        return;
    } else if ([prompt isEqualToString:@"openSMRZ"]) {
        // iOS没有提供可用的URL scheme，不能打开实名认证APP
        NSString *scheme = @"IDENTITYAUTHENTICATION://";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            // 请手动打开实名认证APP进行身份认证
            completionHandler(@"2");
            return;
        } else {
            // 提示下载APP
            completionHandler(@"0");
            return;
        }
    } else if ([prompt isEqualToString:@"authParameter"]) {
        NSString *jsonString = [self URLEncodedString:defaultText]; //URLEncoded，⻅下⽅
        NSString *scheme = @"IDENTITYAUTHENTICATION://"; //构建调⽤用⽤用插件的URL scheme
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",scheme ,jsonString]];
        NSLog(@"唤起实名认证APP 完整URL\n%@", url);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            completionHandler(@"1");
            [[UIApplication sharedApplication] openURL:url];
            return;
        } else {
            // 提示下载APP
            completionHandler(@"0");
            return;
        }
    }

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.textColor = [UIColor blackColor];
//        textField.placeholder = defaultText;
//    }];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler([[alert.textFields lastObject] text]);
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(@"123");
//    }]];
//    [self presentViewController:alert animated:YES completion:NULL];
    completionHandler(@"000");
}

#pragma mark - 转码
- (NSString *)URLEncodedString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

#pragma mark - 实名认证
- (void)handelSMRZResult:(NSNotification *)notification {
    NSLog(@"实名认证结果:%@", [notification object]);
    // 认证结果保存到服务器
    
    // 通知H5认证结果 0失败 1成功
    NSString *methodString = @"SMRZResult('0')";
    [self.webView evaluateJavaScript:methodString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
    
}

#pragma mark - 分享
- (void)shareAction:(UIButton *)sender {
//    [YBPopupMenu showRelyOnView:sender titles:@[@"二维码", @"分享", @"海报"] icons:@[@"shop_share_qrCode", @"shop_share_share", @"shop_share_haibao"] menuWidth:120 delegate:self];
    [YBPopupMenu showRelyOnView:sender titles:@[@"分享"] icons:@[@"shop_share_share"] menuWidth:120 delegate:self];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    
    ShareSDKModel *model = [[ShareSDKModel alloc] init];
    model.shareDesc = [self.shareDetailDic objectForKey:@"shareDesc"];
    model.shareTitle = [self.shareDetailDic objectForKey:@"title"];
    NSString *link = [self.shareDetailDic objectForKey:@"shareLink"];
    link = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)link, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    model.shareLink = link;
    model.shareImgurl = [self.shareDetailDic objectForKey:@"shareImg"];
    
    ShareView *shareView = [[ShareView alloc] initWithNib];
    [shareView showShareView:model];

}

#pragma mark - UI
- (void)initProgressView {
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navBounds.size.height-2, SCREEN_WIDTH, 2);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    [self.navigationController.navigationBar addSubview:self.progressView];

    self.progressView.progressTintColor = hexStringToColor(COLOR_Btn);
//    self.progressView.trackTintColor = [UIColor redColor];
    self.progressView.progress = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.1倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.1f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
}

- (void)initBarItem {
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 20, 20);
    [self.backBtn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    
//    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//    close.frame = CGRectMake(0, 0, 20, 20);
//    [close setTitle:@"关闭" forState:UIControlStateNormal];
//    [close setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:close];
    // 添加item
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;  //偏移距离  -向左偏移, +向右偏移
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];

    self.backBtnAction = 0;// 返回
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - 中文判断
// 是否有中文字
- (BOOL)isHaveChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.javaScriptEnabled = YES;
        if (@available(iOS 9.0, *)) {// 内嵌视频播放 允许视频播放
            config.allowsAirPlayForMediaPlayback = YES;
        }
        config.allowsInlineMediaPlayback = YES;// 允许在线播放
        // 允许可以与网页交互，选择视图
        config.selectionGranularity = YES;
        // 扩展显示js的console.log
        config.showConsole = YES;
        config.userContentController = [[WKUserContentController alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"log"];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, Nav_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Nav_Height) configuration:config];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //开启右滑返回手势
        _webView.allowsBackForwardNavigationGestures = YES;
        //适应你设定的尺寸
        [_webView sizeToFit];
        // 页面不可滚动
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}
@end
