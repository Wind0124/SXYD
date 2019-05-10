//
//  CCHTTPService.h
//  Srpingrass
//
//  Created by tianlong on 17/3/11.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

//http通信层

#import <Foundation/Foundation.h>
#import "APIDefine.h"

typedef NS_ENUM(NSUInteger, CCRequestMethodType) {
    CCRequestMethodGET = 1,
    CCRequestMethodPOST = 2
};//http请求方法枚举变量

@class NSURLSessionDataTask;
@interface CCHTTPService : NSObject

@property (nonatomic,readonly) AFNetworkReachabilityStatus netStatus;
/** webService 请求: GET / POST*/
- (NSURLSessionDataTask * _Nullable)dataTaskWithHTTPMethod:(CCRequestMethodType)method
                                                   apiName:(NSString* _Nullable)apiName
                                                parameters:(NSDictionary * _Nullable)parameters
                                                completion:(ResponseResultBlock _Nullable)res;
// 处理请求参数
- (NSDictionary *)setupRequestParameters:(NSDictionary *)parameters;
/** 文件上传*/
//- (NSURLSessionDataTask * _Nonnull)uploadFileModel:(CCFileModel * __nullable)fileModel
//                                          progress:(NSProgress * _Nullable __autoreleasing * _Nullable)progress
//                                        completion:(ResponseResultBlock __nullable)resBlock;
//
///** 文件下载*/
//- (NSURLSessionDownloadTask * _Nonnull)downloadFileByURLString:(NSString * __nullable)urlStr
//                                                      fileName:(NSString * __nullable)fileName
//                                                      progress:( NSProgress * _Nullable  __autoreleasing * _Nullable)progress
//                                                    completion:(CCDataResultBlock __nullable)resBlock;
@end
