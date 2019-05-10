//
//  APIManager.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "APIManager.h"
#import "MyMD5.h"

@implementation APIManager

static APIManager *instance = nil;
+ (APIManager * _Nullable)shareApiManager {
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpService = [[CCHTTPService alloc] init];
    }
    return self;
}

- (AFNetworkReachabilityStatus)netStatus {
    _netStatus = _httpService.netStatus;
    return _netStatus;
}

#pragma mark - 系统相关
// APP版本
/**
 * 返回值 @block 成功或失败
 */
- (void)getAPPVersionBlock:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:APPVersion parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 保存升级信息
            APPVersionModel *model = [[APPVersionModel alloc] initWithDictionary:(NSDictionary *)responseModel.body error:nil];
            if (block) {
                block(model, nil);
            }
        }
    }];
}

// 查询系统参数配置列表
- (void)getSystemParameterList {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:SystemParameterList parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 保存系统参数
            NSArray *bodyArray = (NSArray *)responseModel.body;
            NSLog(@"系统参数：%@", bodyArray);
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = bodyArray[i];
                NSString *code = dic[@"code"];
                if ([code isEqualToString:@"imgServerPrefix"]) {
                    CurrentUser.imgServerPrefix = dic[@"value"];
                }
                if ([code isEqualToString:@"cmccH5Prefix"]) {
                    CurrentUser.cmccH5Prefix = dic[@"value"];
                }
                if ([code isEqualToString:@"productDetailUrl"] || [code isEqualToString:@"cmccProductDetailUrl"]) {
                    CurrentUser.productDetailUrl = dic[@"value"];
                }
                if ([code isEqualToString:@"fileServerPrefix"]) {
                    CurrentUser.fileServerPrefix = dic[@"value"];
                }
                if ([code isEqualToString:@"codeShopSettingUrl"]) {
                    CurrentUser.codeShopSettingUrl = dic[@"value"];
                }
                if ([code isEqualToString:@"businessListTwoUrl"]) {
                    CurrentUser.businessListTwoUrl = dic[@"value"];
                }
                if ([code isEqualToString:@"businessListSubject"]) {
                    CurrentUser.businessListSubject = dic[@"value"];
                }
            }
            [CurrentUser archive];
        } else if ([headModel.code isEqualToString:@"100019"]) {
            // 系统时间错误，重新请求
            [self getSystemParameterList];
        }
    }];
}

#pragma mark - 登陆注册接口
// 手机号密码登录
- (void)loginWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:Login parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 保存用户信息
            UserModel *userModel = [UserModel initUserWithDictionary:(NSDictionary *)responseModel.body];
            if (block) {
                block(userModel, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

// 手机号验证码登录
- (void)smsLoginWithDic:(NSDictionary * _Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:SmsCodeLogin parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 保存用户信息
            UserModel *userModel = [UserModel initUserWithDictionary:(NSDictionary *)responseModel.body];
            if (block) {
                block(userModel, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

// 获取4A认证验证码
- (NSURLSessionDataTask * _Nullable)getCertificateSMSCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {

    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:GetCerSMSCode parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}

// 4A 账号认证
- (NSURLSessionDataTask * _Nullable)auth4AWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:Auth4A parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSDictionary *body = (NSDictionary *)responseModel.body;
            CurrentUser.token = body[@"token"];
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}

// 4A 授权列表
- (void)getAuthListWithBlock:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthorizeList parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSArray *body = (NSArray *)responseModel.body;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < body.count; i++) {
                NSDictionary *dic = (NSDictionary *)body[i];
                AuthDetailModel *model = [[AuthDetailModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            if (block) {
                block(dataArray, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }

    }];
}

// 4A 授权
- (void)authorizeUserWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthorizeUser parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}

// 4A 授权信息修改
- (void)authorizeModifyWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthorizeModify parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}

// 4A解绑
- (void)authorizeUnbindWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthorizeUnbind parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}

// 发送验证码
- (NSURLSessionDataTask * _Nullable)getSmsCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    // type字段  验证码类别:1注册 2重置登录密码 3绑定手机号 4验证码登录 5支付验证码 6添加店员 7 4A授权
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:SendSmsCode parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
//            NSDictionary *body = (NSDictionary *)responseModel.body;
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}

// 重置密码
- (NSURLSessionDataTask * _Nullable)resetPasswordWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ResetLoginPwd parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
//            NSDictionary *body = (NSDictionary *)responseModel.body;
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}
// 修改密码
- (void)modifyPasswordWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ModifyLoginPwd parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
//            NSDictionary *body = (NSDictionary *)responseModel.body;
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}
// 查询用户的工号列表
- (NSURLSessionDataTask * _Nullable)getListEmployeeNumber:(ModelArrayResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ListEmployeeNumber parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSArray *body = (NSArray *)responseModel.body;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < body.count; i++) {
                NSDictionary *dic = (NSDictionary *)body[i];
                EmployeeModel *model = [[EmployeeModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
            }
            if (block) {
                block(dataArray, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
    return task;
}
// 设置工号
- (NSURLSessionDataTask * _Nullable)setEmployeeNumberWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:SetEmployeeNumber parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}

// 手势认证
- (NSURLSessionDataTask * _Nullable)handAuth:(BooleanResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:HandAuth parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}
// 用户信息
- (NSURLSessionDataTask * _Nullable)getUserInfo:(BooleanResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:UserInfo parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            UserModel *userModel = [UserModel initUserWithDictionary:bodyDic];
            NSLog(@"用户信息：%@",userModel);
            if (userModel.channelList.count == 0) {
                if (CurrentUser.defaultChannelId) {
                    // 渠道列表为空，清空默认渠道
                    CurrentUser.defaultChannelCode = nil;
                    CurrentUser.defaultChannelId = nil;
                    CurrentUser.defaultSupplierId = nil;
                    CurrentUser.defaultSupplierName = nil;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDefaultChannel object:nil];
                }
            } else {
                if (CurrentUser.defaultChannelId) {
                    // 判断默认渠道是否存在列表内
                    BOOL isExit = NO;
                    for (int i = 0; i < userModel.channelList.count; i++) {
                        ChannelModel *model = userModel.channelList[i];
                        if ([model.channelId isEqualToString:CurrentUser.defaultChannelId]) {
                            isExit = YES;
                            break;
                        }
                    }
                    if (!isExit) {
                        // 设置第一个为默认渠道
                        ChannelModel *model = userModel.channelList[0];
                        CurrentUser.defaultChannelCode = model.channelCode;
                        CurrentUser.defaultChannelId = model.channelId;
                        CurrentUser.defaultSupplierId = model.supplierId;
                        CurrentUser.defaultSupplierName = model.supplierName;
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDefaultChannel object:nil];
                    }
                } else {
                    // 设置第一个为默认渠道
                    ChannelModel *model = userModel.channelList[0];
                    CurrentUser.defaultChannelCode = model.channelCode;
                    CurrentUser.defaultChannelId = model.channelId;
                    CurrentUser.defaultSupplierId = model.supplierId;
                    CurrentUser.defaultSupplierName = model.supplierName;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDefaultChannel object:nil];
                }
            }
            [CurrentUser archive];
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
    return task;
}

// 修改用户头像
- (void)modifyUserAvatarWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ModifyUserAvatar parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}

// 注册千店万员
- (void)registerClerkWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:RegisterClerk parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}

// 查询实名认证手机号码
- (void)QueryAcceptOrderMobileWithBlock:(DictionaryResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:QueryAcceptOrderMobile parameters:nil completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            block ? block(bodyDic, nil) :nil;
        } else {
            block ? block(nil, headModel) : nil;
        }
    }];
}

// 保存接受工单短信号码
- (void)saveAcceptOrderMobileWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:SaveAcceptOrderMobile parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            block ? block(YES, nil) :nil;
        } else {
            block ? block(NO, headModel) : nil;
        }
    }];
}

// 设置默认渠道
/**
 * 参数 @parameters 字段1：str（渠道id）
 * 返回值 @block 成功或失败
 */
- (void)setDefaultChannelWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:setDefaultChannel parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];

}

#pragma mark - 首页
// 按广告类型查询列表接口
- (NSURLSessionDataTask * _Nullable)getAdvertInfoWithDic:(NSDictionary *_Nullable)parameters block:(ModelAndArrayResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AdvertInfo parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 总数据 包含页数 总量
            PageModel *model = [[PageModel alloc] initWithDictionary:(NSDictionary *)responseModel.body error:nil];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < model.datas.count; i++) {
                NSDictionary *dic = model.datas[i];
                AdvertInfoModel *infoModel = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:infoModel];
            }
            if (block) {
                block(model, dataArray, nil);
            }
        } else {
            if (block) {
                block(nil, nil, headModel);
            }
        }
    }];
    return task;
}

// 查询公告信息列表
- (NSURLSessionDataTask * _Nullable)getMessageNoticeWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:MessageNoticePage parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // 总数据 包含页数 总量
            PageModel *model = [[PageModel alloc] initWithDictionary:(NSDictionary *)responseModel.body error:nil];
            // 处理字典数据成NoticeModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < model.datas.count; i++) {
                NSDictionary *dic = (NSDictionary *)model.datas[i];
                NoticeModel *notice = [[NoticeModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:notice];
            }
            model.datas = dataArray;
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
    return task;
}
// 首页专题列表
- (NSURLSessionDataTask * _Nullable)getActivityInfoWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ActivityInfo parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是数组
            NSArray *bodyArray = (NSArray *)responseModel.body;
            // 处理body数组中的字典数据成ActivityModel
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < bodyArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)bodyArray[i];
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic error:nil];
                [dataArray addObject:model];
//                NSLog(@"父/子/商品 专区\n：%@", model);
            }
            NSLog(@"专区数量：%zd", dataArray.count);
            if (block) {
                block(dataArray, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
    return task;
}

// 获取店铺信息
- (void)getShopInfoBlock:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ShopInfo parameters:@{} completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            ShopInfoModel *model = [[ShopInfoModel alloc] initWithDictionary:bodyDic error:nil];
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];

}

// 编辑店铺信息
- (void)modifyShopWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:ModifyShop parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            if (block) {
                block(YES, nil);
            }
        } else {
            if (block) {
                block(NO, headModel);
            }
        }
    }];
}
// 上传图片
- (void)uploadImage:(UIImage *_Nullable)img block:(StringResultBlock _Nullable)block{
    NSData *imageData;
    NSString *imageFormat;
    if (UIImagePNGRepresentation(img) != nil) {
        imageFormat = @"Content-Type: image/png \r\n";
        imageData = UIImagePNGRepresentation(img);
    } else {
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(img, 1.0);
    }
    
    //运用AFN实现照片上传
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = [_httpService setupRequestParameters:@{}];
    [manager POST:[NSString stringWithFormat:@"%@%@", BASEURL, UploadImg] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:_myModel.personID fileName:[NSString stringWithFormat:@"%@.jpg",_myModel.personID] mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"icon.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--------%@",responseObject);
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:responseObject[@"head"] error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            NSDictionary *bodyDic = responseObject[@"body"];
            NSString *shortUrlString = bodyDic[@"shortUrl"];
            if (block) {
                block(shortUrlString, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"code": [NSString stringWithFormat:@"%ld", error.code],
                                   @"msg": error.domain
                                   };
        NSLog(@"失败\n底层错误原因==%@\n底层错误==%@\n\n", error.userInfo, error.localizedDescription);
//        ResponseModel *model = [[ResponseModel alloc] init];
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:errorDic error:nil];
        if (block) {
            block(nil, headModel);
        }

    }];
}

- (NSData *)getDataWithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

// 分享 type:0 二维码/ 1 海报/ 2 分享微信
- (void)getShareMessageWithType:(NSInteger)type para:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    NSString *apiString;
    if (type == 0) {
        apiString = ShareQRCode;
    } else if (type == 1) {
        apiString = SharePoster;
    } else if (type == 2) {
        apiString = ShareWeChat;
    }
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:apiString parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            ShareModel *model = [[ShareModel alloc] initWithDictionary:bodyDic error:nil];
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

#pragma mark - 工作台
// 工作台 本日本月业务量
- (NSURLSessionDataTask * _Nullable)getTodayOrMonthWithDic:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    NSURLSessionDataTask *task = [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:TodayAndMonthBusiness parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            AllStatisticsModel *model = [[AllStatisticsModel alloc] initWithDictionary:bodyDic error:nil];
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
    return task;
}
// 查询所有业务分类
- (void)getAllAdvertBusinessWithDic:(NSDictionary *_Nullable)parameters block:(ModelArrayResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AdverBusiness parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            NSArray *contentArray = bodyDic[@"advertBusinessContentRespBodies"];
            NSMutableArray *contentModelArray = [NSMutableArray array];
            for (int i = 0; i < contentArray.count; i++) {
                NSDictionary *dic = (NSDictionary *)contentArray[i];
                AdvertInfoModel *model = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
                [contentModelArray addObject:model];
            }
            if (block) {
                block(contentModelArray, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];

}

// 用户鉴权验证码
- (void)getUserAuthSmsCodeWithDic:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthSendSmsCode parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            BOOL isSucceed = bodyDic[@"isSucceed"];
            if (block) {
                block(isSucceed, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

// 用户鉴权
- (void)UserAuth:(NSDictionary *_Nullable)parameters block:(BooleanResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthCheckOut parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSLog(@"%@",responseModel);
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            BOOL isSucceed = bodyDic[@"isSucceed"];
            if (block) {
                block(isSucceed, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

// 鉴权用户余额、流量、话费等
- (void)getAuthUserInfo:(NSDictionary *_Nullable)parameters block:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:AuthUserInfo parameters:parameters completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            AuthUserInfoModel *model = [[AuthUserInfoModel alloc] initWithDictionary:bodyDic error:nil];
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}

#pragma mark - 我的
// 本月本日酬金、业务量
- (void)getWeekMonthRewardBlcok:(ModelResultBlock _Nullable)block {
    [_httpService dataTaskWithHTTPMethod:CCRequestMethodPOST apiName:WeekMonthReward parameters:@{} completion:^(ResponseModel *responseModel) {
        HeadModel *headModel = [[HeadModel alloc] initWithDictionary:(NSDictionary *)responseModel.head error:nil];
        if ([headModel.code isEqualToString:@"100000"]) {
            // body是字典
            NSDictionary *bodyDic = (NSDictionary *)responseModel.body;
            WeekMonthRewardModel *model = [[WeekMonthRewardModel alloc] initWithDictionary:bodyDic error:nil];
            if (block) {
                block(model, nil);
            }
        } else {
            if (block) {
                block(nil, headModel);
            }
        }
    }];
}
@end
