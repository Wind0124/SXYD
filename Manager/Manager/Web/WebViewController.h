//
//  WebViewController.h
//  Guess
//
//  Created by vpclub on 16/11/21.
//  Copyright © 2016年 wankr. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WebViewController : BaseVC

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSString *businessCode;// 开户业务code
@property (nonatomic, strong) ChannelModel *supplierModel; // 开户业务机构数据

// 开户认证结果回调
@property (nonatomic, copy) void (^WebViewAfterAuthResultBlock)(NSString *result);// 0无需认证 1认证成功 2认证失败

/**
 加载纯文本网页
 
 @param string 网页文本
 */
- (void)loadWebWithContentSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
- (void)loadWebHTMLSring:(NSString *)string;

@end
