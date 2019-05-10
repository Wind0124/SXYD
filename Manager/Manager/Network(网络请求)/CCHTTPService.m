//
//  CCHTTPService.m
//  Srpingrass
//
//  Created by tianlong on 17/3/11.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import "CCHTTPService.h"
#import "CCHTTPClient.h"
#import "MyMD5.h"
//#import "LoginVC.h"
#import "LoginVC_SX.h"
#import "CCAES128.h"

@interface CCHTTPService ()
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end
@implementation CCHTTPService
- (instancetype)init {
    if (self = [super init]) {
        _networkStatus = AFNetworkReachabilityStatusUnknown;
        [self startNetworkMonitoring];
    }
    return self;
}

// 监控网络
- (void)startNetworkMonitoring {
    AFNetworkReachabilityManager *afNetworkReachbilityManager = \
    [AFNetworkReachabilityManager sharedManager];
    
    [afNetworkReachbilityManager startMonitoring];
    
    [afNetworkReachbilityManager setReachabilityStatusChangeBlock:\
     ^(AFNetworkReachabilityStatus status) {
         
         _netStatus = status;
         
         switch (status) {
             case AFNetworkReachabilityStatusUnknown: {
                 NSLog(@"网络状态未知");
                 break;
             }
             case AFNetworkReachabilityStatusNotReachable: {
                 self.networkStatus = AFNetworkReachabilityStatusNotReachable;
                 NSLog(@"网络连接失败!");
                 break;
             }
             case AFNetworkReachabilityStatusReachableViaWWAN: {
                 self.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                 NSLog(@"网络连接需要消耗流量");
                 break;
             }
             case AFNetworkReachabilityStatusReachableViaWiFi: {
                 self.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                 NSLog(@"通过wifi连接");
                 break;
             }
             default: {
                 break;
             }
         }
     }];
}

/** webService 请求: GET / POST /PUT*/
- (NSURLSessionDataTask * _Nullable)dataTaskWithHTTPMethod:(CCRequestMethodType)method
                                                   apiName:(NSString* _Nullable)apiName
                                                parameters:(NSDictionary * _Nullable)parameters
                                                completion:(ResponseResultBlock _Nullable)res
{
    
    NSLog(@"发送网络请求接口：%@", apiName);

    NSDictionary *requestParameters = [self setupRequestParameters:parameters];
    
    NSURLSessionDataTask *task = nil;
    switch (method) {
        case CCRequestMethodGET: {
            task = [self dataTaskWithHTTPGETApiName:apiName parameters:requestParameters completion:res];
            break;
        }
        case CCRequestMethodPOST: {
            task = [self dataTaskWithHTTPPOSTApiName:apiName parameters:requestParameters completion:res];
            break;
        }
        default: {
            NSAssert(false, @"未知的HTTP请求方式");
            break;
        }
    }
    return task;
}

- (NSDictionary *)setupRequestParameters:(NSDictionary *)parameters {
    // head
    NSString * appVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [NSString stringWithFormat:@"cloud_%@", appVersion];
    NSDate *date = [NSDate date];
    NSTimeInterval currentInterval = [date timeIntervalSince1970];
    double timeGap = [[[NSUserDefaults standardUserDefaults] objectForKey:@"timeGap"] floatValue];
    NSLog(@"传参调整时间差：%f", timeGap);
    NSTimeInterval interval = currentInterval + timeGap;
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", interval * 1000];
    NSString *token = CurrentUser.token ? CurrentUser.token : @"";
    NSString *transactionId = [[NSUUID UUID] UUIDString];;
    NSDictionary *head = @{@"apiVersion": APIVERSION,
                           @"appKey": APPKEY,
                           @"appVersion": appVersion,
                           @"timestamp": timestamp,
                           @"token": token,
                           @"transactionId": transactionId,
                           @"busiScene": @"cloudShop",
                           };
    NSString *headString = [NSString jsonStringWithObject:head];
    NSData *headData = [headString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *headBase64 = [headData base64EncodedStringWithOptions:0];
    
    // body sign
    NSString *bodyString = @"";
    NSData *bodyData;
    NSString *bodyBase64 = @"";
    NSString *sign = @"";
    if (parameters != nil) {
        bodyString = [NSString jsonStringWithObject:parameters];
        bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        bodyBase64 = [bodyData base64EncodedStringWithOptions:0];
        sign = [NSString stringWithFormat:@"%@%@%@", headString, APPSECRET, bodyString];
    } else {
        sign = [NSString stringWithFormat:@"%@%@", headString, APPSECRET];
    }
    NSLog(@"\n未加密请求参数==%@,%@", head, parameters);
    NSString *MD5SIGN = [[MyMD5 md5:sign] uppercaseString];
    // base64组装最终请求参数
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    [requestParameters setObject:headBase64 forKey:@"head"];
    if (bodyBase64.length > 0) {
        [requestParameters setObject:bodyBase64 forKey:@"body"];
    }
    [requestParameters setObject:MD5SIGN forKey:@"sign"];
    NSLog(@"加密请求参数==%@",requestParameters);
    return requestParameters;
}

- (NSDictionary *)setupRequestParameters_encrypt:(NSDictionary *)parameters {
    // head
    NSString * appVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [NSString stringWithFormat:@"cloud_%@", appVersion];
    NSDate *date = [NSDate date];
    NSTimeInterval currentInterval = [date timeIntervalSince1970];
    double timeGap = [[[NSUserDefaults standardUserDefaults] objectForKey:@"timeGap"] floatValue];
    NSLog(@"传参调整时间差：%f", timeGap);
    NSTimeInterval interval = currentInterval + timeGap;
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", interval * 1000];
    NSString *token = CurrentUser.token ? CurrentUser.token : @"";
    NSString *transactionId = [[NSUUID UUID] UUIDString];;
    NSDictionary *head = @{@"apiVersion": APIVERSION,
                           @"appKey": APPKEY,
                           @"appVersion": appVersion,
                           @"timestamp": timestamp,
                           @"token": token,
                           @"transactionId": transactionId,
                           @"busiScene": @"cloudShop",
                           };
    NSString *headString = [NSString jsonStringWithObject:head];
    
    // body sign
    NSString *bodyString = @"";
    NSString *sign = @"";
    if (parameters != nil) {
        bodyString = [NSString jsonStringWithObject:parameters];
        sign = [NSString stringWithFormat:@"%@%@%@", headString, APPSECRET, bodyString];
    } else {
        sign = [NSString stringWithFormat:@"%@%@", headString, APPSECRET];
    }
    NSString *MD5SIGN = [[MyMD5 md5:sign] uppercaseString];
    NSLog(@"\n未加密的请求参数\nhead==%@\n\nbody==%@\n", headString, bodyString);
    NSLog(@"\n签名\nsign==%@\n", MD5SIGN);
    
    // AES加密
    NSString *headKey = [NSString stringWithFormat:@"vpHead@888%@", MD5SIGN];
    NSString *headAESBase64 = [CCAES128 aes128_encryptKey:headKey Encrypttext:headString];
    NSString *bodyKey = [NSString stringWithFormat:@"vpBody@888%@", MD5SIGN];
    NSString *bodyAESBase64 = [CCAES128 aes128_encryptKey:bodyKey Encrypttext:bodyString];
    NSLog(@"\nAES加密后转Base64的参数\nhead==%@\n\nbody==%@\n", headAESBase64, bodyAESBase64);
    
    // base64组装最终请求参数
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    [requestParameters setObject:headAESBase64 forKey:@"head"];
    [requestParameters setObject:bodyAESBase64 forKey:@"body"];
    [requestParameters setObject:MD5SIGN forKey:@"sign"];
//    NSLog(@"加密请求参数==%@",requestParameters);
    return requestParameters;
}

#pragma mark - 内部方法
- (NSURLSessionDataTask * _Nullable)dataTaskWithHTTPPOSTApiName:(NSString*)apiName parameters:(NSDictionary * _Nullable)parameters completion:(ResponseResultBlock _Nullable)resBlock {
    
    NSURLSessionDataTask *task = [[CCHTTPClient sharedInstance] POST:apiName parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseString);
        
        NSDictionary *responseDic = @{};
        if ([responseString hasPrefix:@"{"]) {
            // 返回数据没加密
            responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        } else {
            // AES解密
            NSString *decodeKey = @"89aab6b29eddd327f72ef05d3fa1ca17";
            NSString *decodeString = [CCAES128 aes128_decryptKey:decodeKey Decrypttext:responseObject];
            NSData *decodeData = [decodeString dataUsingEncoding:NSUTF8StringEncoding];
            responseDic = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingAllowFragments error:nil];
        }
        
        if (ShowResponseData) {
            NSLog(@"成功，返回数据：%@",responseDic);
        }
        ResponseModel *model = [[ResponseModel alloc] initWithDictionary:responseDic error:nil];
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)model.head error:nil];
        NSLog(@"%@, %@, %@", task.response.URL.absoluteString, headModel.code, headModel.msg);
        if ([headModel.code isEqualToString:@"100009"]) {
            // 登陆失效 跳回登陆页面
            [CurrentUser logout];
            [[NSNotificationCenter defaultCenter] postNotificationName:Logout object:nil];
            //进入登录界面
//            LoginVC_SX * loginVC = [[LoginVC_SX alloc] init];
//            BaseNav * nav = [[BaseNav alloc] initWithRootViewController:loginVC];
//            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        } else if ([headModel.code isEqualToString:@"100019"]) {
            // 服务器时间错误，靠前端同步
            NSDate *date = [NSDate date];
            NSTimeInterval interval = [date timeIntervalSince1970];
            NSLog(@"系统时间戳：%f", interval);

            NSString *serverTimeString = model.timestamp;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *serverDate = [formatter dateFromString:serverTimeString];
            NSTimeInterval serverInterval = [serverDate timeIntervalSince1970];
            NSLog(@"服务器时间戳：%f", serverInterval);
            
            NSTimeInterval timeGap = serverInterval - interval;
            NSLog(@"（服务器 - 系统）时间差：%f", timeGap);
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:timeGap] forKey:@"timeGap"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (resBlock) {
                resBlock(model);
            }
        } else {
            if (resBlock) {
                resBlock(model);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"code": @"",
                                   @"msg": error.localizedDescription
                                   };
//        NSLog(@"url=%@ POST请求出错", task.response.URL.absoluteString);
//        NSLog(@"参数=%@", parameters);
        NSLog(@"失败\n底层错误原因==%@\n底层错误==%@\n\n", error.userInfo, error.localizedDescription);
        ResponseModel *model = [[ResponseModel alloc] init];
        model.head = errorDic;
        if (resBlock) {
            resBlock(model);
        }
    }];
    return task;
}

- (NSURLSessionDataTask * _Nullable)dataTaskWithHTTPGETApiName:(NSString*)apiName
                                                    parameters:(NSDictionary * _Nullable)parameters
                                                    completion:(ResponseResultBlock _Nullable)resBlock {
    
    NSURLSessionDataTask *task =\
    [[CCHTTPClient sharedInstance] \
     GET:apiName parameters:parameters
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
         
//         CCLog(@"\nGet请求:head=%@\nurl=%@\n参数=%@\n\n",task.currentRequest.allHTTPHeaderFields,task.response.URL,parameters == nil?@"不需要参数":parameters);
//         NSDictionary *resDict = [self decryptData:(NSData *)responseObject];
//
//         NSError *nextErr = nil;
//
//         CCResponseModel *responseModel = [[CCResponseModel alloc] initWithDictionary:resDict error:&nextErr];
//
//         if (responseModel.code.integerValue == CC_User_Token_Invalid) {
//             [CCLocal removeObjectForKey:CCUserToken];
//             [[NSNotificationCenter defaultCenter]postNotificationName:CC_User_Login_Action object:nil];
//         }
//         if (resBlock) {
//             resBlock (responseModel);
//         }
     }
     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//         CCLog(@"\npost请求:head=%@\nurl=%@\n参数=%@\n错误返回=%@\n底层错误原因=%@\n底层错误:%@\n\n",task.currentRequest.allHTTPHeaderFields,task.response.URL,parameters == nil?@"不需要参数":parameters,[task response],error.userInfo,error.localizedDescription);
//         CCResponseModel *responseModel = [[CCResponseModel alloc] init];
//         responseModel.code = [NSNumber numberWithInteger:error.code];
//         responseModel.msg = error.domain;
//
//         if (resBlock) {
//             resBlock (responseModel);
//         }
     }];
    
    return task;

}
@end
