//
//  UserModel.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"

#define CurrentUser [UserModel currentUser]
@protocol ChannelModel
@end

@interface UserModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * deviceModel;
@property (nonatomic, strong) NSString<Optional> * isCertified;
@property (nonatomic, strong) NSString<Optional> * isLogged;
@property (nonatomic, strong) NSString<Optional> * loginTime;
@property (nonatomic, strong) NSString<Optional> * token;
// 登录信息保存
@property (nonatomic, strong) NSString<Optional> * authAccountNameString;// 4A账号名
@property (nonatomic, strong) NSString<Optional> * passwordString;
@property (nonatomic, strong) NSString<Optional> * workbenchCodeString;
@property (nonatomic, strong) NSString<Optional> * avatar;
@property (nonatomic, strong) NSString<Optional> * gesturesPassword;

// 用户信息接口 字段
@property (nonatomic, strong) NSString<Optional> * employeeNumber;// 员工号
@property (nonatomic, strong) NSString<Optional> * faceUrl;// 用户头像
@property (nonatomic, strong) NSString<Optional> * mobile;// 手机号
@property (nonatomic, strong) NSString<Optional> * nickName;// 用户名
@property (nonatomic, strong) NSString<Optional> * shopName;// 店铺名称
@property (nonatomic, strong) NSString<Optional> * frequenterCount;// 我的常客
@property (nonatomic, strong) NSString<Optional> * isShopManager;// 是否为店长 ‘true’/‘false’
@property (nonatomic, strong) NSString<Optional> * crmChannelId;// 4A账号返回的渠道id
@property (nonatomic, strong) NSString<Optional> * crmChannelName;// 4A账号返回的渠道名
@property (nonatomic, strong) NSString<Optional> * crmChannelCode;// 4A账号返回的渠道编码
@property (nonatomic, strong) NSString<Optional> * crmCityCode;// 4A账号返回的地市编码
@property (nonatomic, strong) NSString<Optional> * crmCityName;// 4A账号返回的地市名称
@property (nonatomic, strong) NSString<Optional> * crmChannelOrgId;// 4A账号返回的机构id
@property (nonatomic, strong) NSString<Optional> * crmChannelOrgName;// 4A账号返回的机构名称

@property (nonatomic, strong) NSNumber<Optional> * crmStatus;// 1已认证4A; 2被授权4A; 3未拥有4A
@property (nonatomic, strong) NSString<Optional> * crmYD;// 工号列表“,"拼接
@property (nonatomic, strong) NSNumber<Optional> * channelStatus;// -1无绑定渠道,0未注册千店万员,1已绑定渠道
@property (nonatomic, strong) NSArray<ChannelModel, Optional> *channelList;// 已绑定渠道列表
@property (nonatomic, strong) NSString<Optional> * shopId;// 店铺id
@property (nonatomic, strong) NSString<Optional> * thousandClerkId;// 千店万员店员id
@property (nonatomic, strong) NSString<Optional> * userId;// 用户id

// 本地保存字段
@property (nonatomic, strong) NSString<Optional> * defaultChannelCode;// 本地保存 选择的默认渠道编码
@property (nonatomic, strong) NSString<Optional> * defaultChannelId;// 本地保存 选择的默认渠道id
@property (nonatomic, strong) NSString<Optional> * defaultSupplierId;// 本地保存 选择的默认机构id
@property (nonatomic, strong) NSString<Optional> * defaultSupplierName;// 本地保存 选择的默认机构名称

// 系统参数配置
@property (nonatomic, strong) NSString<Optional> * cmccH5Prefix;
@property (nonatomic, strong) NSString<Optional> * imgServerPrefix;
@property (nonatomic, strong) NSString<Optional> * codeShopSettingUrl;// 首页 店铺设置
@property (nonatomic, strong) NSString<Optional> * businessListSubject;// 首页 专题跳转

@property (nonatomic, strong) NSString<Optional> * productDetailUrl;// 跳转商品（未使用）
@property (nonatomic, strong) NSString<Optional> * fileServerPrefix;// 文件服务器（未使用）
@property (nonatomic, strong) NSString<Optional> * businessListTwoUrl;// 业务跳转（未使用）


//初始化
+(UserModel *)initUserWithDictionary:(NSDictionary*)dictionary;
//获取用户
+(UserModel *)currentUser;

- (void)archive;
- (void)unarchive;

//退出登录
-(void)logout;

@end
