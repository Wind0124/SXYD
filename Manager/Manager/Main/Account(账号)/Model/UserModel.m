//
//  UserModel.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

static UserModel* instance = nil;
+ (UserModel*)initUserWithDictionary:(NSDictionary *)dictionary {
    if (!instance) {
        instance = [[self alloc] initWithDictionary:dictionary error:nil];
    } else {
        instance = [instance initWithDictionary:dictionary error:nil];
    }
    return instance;
}

+ (UserModel*)currentUser {
    if (!instance) {
        instance = [[self alloc]init];
    }
    return instance;
}

+(JSONKeyMapper *)keyMapper{
    // 默认渠道机构id和名称用原先的supplier代替
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"defaultChannelOrgId":@"defaultSupplierId",
                                                       @"defaultChannelOrgName": @"defaultSupplierName"}];
}

- (void)archive {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.deviceModel forKey:@"deviceModel"];
    [archiver encodeObject:self.isCertified forKey:@"isCertified"];
    [archiver encodeObject:self.isLogged forKey:@"isLogged"];
    [archiver encodeObject:self.loginTime forKey:@"loginTime"];
    [archiver encodeObject:self.token forKey:@"token"];
    
    [archiver encodeObject:self.authAccountNameString forKey:@"authAccountNameString"];
    [archiver encodeObject:self.passwordString forKey:@"passwordString"];
    [archiver encodeObject:self.workbenchCodeString forKey:@"workbenchCodeString"];
    [archiver encodeObject:self.avatar forKey:@"avatar"];
    [archiver encodeObject:self.gesturesPassword forKey:@"gesturesPassword"];
    
    [archiver encodeObject:self.employeeNumber forKey:@"employeeNumber"];
    [archiver encodeObject:self.faceUrl forKey:@"faceUrl"];
    [archiver encodeObject:self.mobile forKey:@"mobile"];
    [archiver encodeObject:self.nickName forKey:@"nickName"];
    [archiver encodeObject:self.shopName forKey:@"shopName"];
    [archiver encodeObject:self.frequenterCount forKey:@"frequenterCount"];
    [archiver encodeObject:self.crmChannelId forKey:@"crmChannelId"];
    [archiver encodeObject:self.crmChannelName forKey:@"crmChannelName"];
    [archiver encodeObject:self.crmChannelCode forKey:@"crmChannelCode"];
    [archiver encodeObject:self.crmCityCode forKey:@"crmCityCode"];
    [archiver encodeObject:self.crmCityName forKey:@"crmCityName"];
    [archiver encodeObject:self.crmChannelOrgId forKey:@"crmChannelOrgId"];
    [archiver encodeObject:self.crmChannelOrgName forKey:@"crmChannelOrgName"];
    [archiver encodeObject:self.crmStatus forKey:@"crmStatus"];
    [archiver encodeObject:self.isShopManager forKey:@"isShopManager"];
    [archiver encodeObject:self.crmYD forKey:@"crmYD"];
    [archiver encodeObject:self.channelStatus forKey:@"channelStatus"];
    [archiver encodeObject:self.shopId forKey:@"shopId"];
    [archiver encodeObject:self.thousandClerkId forKey:@"thousandClerkId"];
    [archiver encodeObject:self.userId forKey:@"userId"];

    [archiver encodeObject:self.defaultChannelCode forKey:@"defaultChannelCode"];
    [archiver encodeObject:self.defaultChannelId forKey:@"defaultChannelId"];
    [archiver encodeObject:self.defaultSupplierId forKey:@"defaultSupplierId"];
    [archiver encodeObject:self.defaultSupplierName forKey:@"defaultSupplierName"];

    [archiver encodeObject:self.cmccH5Prefix forKey:@"cmccH5Prefix"];
    [archiver encodeObject:self.imgServerPrefix forKey:@"imgServerPrefix"];
    [archiver encodeObject:self.codeShopSettingUrl forKey:@"codeShopSettingUrl"];
    [archiver encodeObject:self.businessListSubject forKey:@"businessListSubject"];
    [archiver encodeObject:self.productDetailUrl forKey:@"productDetailUrl"];
    [archiver encodeObject:self.fileServerPrefix forKey:@"fileServerPrefix"];
    [archiver encodeObject:self.businessListTwoUrl forKey:@"businessListTwoUrl"];

    [archiver finishEncoding];
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array.firstObject stringByAppendingPathComponent:@"userModel"];
    [data writeToFile:filePath atomically:YES];
    NSLog(@"\n用户数据保存成功\n");
}

- (void)unarchive {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array.firstObject stringByAppendingPathComponent:@"userModel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchvice = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.deviceModel = [unarchvice decodeObjectForKey:@"deviceModel"];
        self.isCertified = [unarchvice decodeObjectForKey:@"isCertified"];
        self.isLogged = [unarchvice decodeObjectForKey:@"isLogged"];
        self.loginTime = [unarchvice decodeObjectForKey:@"loginTime"];
        self.token = [unarchvice decodeObjectForKey:@"token"];
        
        self.authAccountNameString = [unarchvice decodeObjectForKey:@"authAccountNameString"];
        self.passwordString = [unarchvice decodeObjectForKey:@"passwordString"];
        self.workbenchCodeString = [unarchvice decodeObjectForKey:@"workbenchCodeString"];
        self.avatar = [unarchvice decodeObjectForKey:@"avatar"];
        self.gesturesPassword = [unarchvice decodeObjectForKey:@"gesturesPassword"];
        
        self.employeeNumber = [unarchvice decodeObjectForKey:@"employeeNumber"];
        self.faceUrl = [unarchvice decodeObjectForKey:@"faceUrl"];
        self.mobile = [unarchvice decodeObjectForKey:@"mobile"];
        self.nickName = [unarchvice decodeObjectForKey:@"nickName"];
        self.shopName = [unarchvice decodeObjectForKey:@"shopName"];
        self.frequenterCount = [unarchvice decodeObjectForKey:@"frequenterCount"];
        self.crmChannelId = [unarchvice decodeObjectForKey:@"crmChannelId"];
        self.crmChannelName = [unarchvice decodeObjectForKey:@"crmChannelName"];
        self.crmChannelCode = [unarchvice decodeObjectForKey:@"crmChannelCode"];
        self.crmCityCode = [unarchvice decodeObjectForKey:@"crmCityCode"];
        self.crmCityName = [unarchvice decodeObjectForKey:@"crmCityName"];
        self.crmChannelOrgId = [unarchvice decodeObjectForKey:@"crmChannelOrgId"];
        self.crmChannelOrgName = [unarchvice decodeObjectForKey:@"crmChannelOrgName"];
        self.crmStatus = [unarchvice decodeObjectForKey:@"crmStatus"];
        self.isShopManager = [unarchvice decodeObjectForKey:@"isShopManager"];
        self.crmYD = [unarchvice decodeObjectForKey:@"crmYD"];
        self.channelStatus = [unarchvice decodeObjectForKey:@"channelStatus"];
        self.shopId = [unarchvice decodeObjectForKey:@"shopId"];
        self.thousandClerkId = [unarchvice decodeObjectForKey:@"thousandClerkId"];
        self.userId = [unarchvice decodeObjectForKey:@"userId"];

        self.defaultChannelCode = [unarchvice decodeObjectForKey:@"defaultChannelCode"];
        self.defaultChannelId = [unarchvice decodeObjectForKey:@"defaultChannelId"];
        self.defaultSupplierId = [unarchvice decodeObjectForKey:@"defaultSupplierId"];
        self.defaultSupplierName = [unarchvice decodeObjectForKey:@"defaultSupplierName"];

        self.cmccH5Prefix = [unarchvice decodeObjectForKey:@"cmccH5Prefix"];
        self.imgServerPrefix = [unarchvice decodeObjectForKey:@"imgServerPrefix"];
        self.codeShopSettingUrl = [unarchvice decodeObjectForKey:@"codeShopSettingUrl"];
        self.businessListSubject = [unarchvice decodeObjectForKey:@"businessListSubject"];
        self.productDetailUrl = [unarchvice decodeObjectForKey:@"productDetailUrl"];
        self.fileServerPrefix = [unarchvice decodeObjectForKey:@"fileServerPrefix"];
        self.businessListTwoUrl = [unarchvice decodeObjectForKey:@"businessListTwoUrl"];

        NSLog(@"%@", self);
        [unarchvice finishDecoding];
    }
}

- (void)logout {
    self.deviceModel = nil;
    self.isCertified = nil;
    self.isLogged = nil;
    self.loginTime = nil;
    self.token = nil;
    
    self.authAccountNameString = nil;
    self.passwordString = nil;
    self.avatar = nil;
    self.gesturesPassword = nil;
    
    self.employeeNumber = nil;
    self.faceUrl = nil;
    self.mobile = nil;
    self.nickName = nil;
    self.shopName = nil;
    self.frequenterCount = nil;
    self.isShopManager = nil;

    self.crmChannelId = nil;
    self.crmChannelName = nil;
    self.crmChannelCode = nil;
    self.crmCityCode = nil;
    self.crmCityName = nil;
    self.crmChannelOrgId = nil;
    self.crmChannelOrgName = nil;
    self.crmStatus = nil;
    self.crmYD = nil;
    self.channelStatus = nil;
    self.shopId = nil;
    self.thousandClerkId = nil;
    self.userId = nil;
    
    self.defaultChannelCode = nil;
    self.defaultChannelId = nil;
    self.defaultSupplierId = nil;
    self.defaultSupplierName = nil;
    [self archive];
}

@end
