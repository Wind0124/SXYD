//
//  NoticeModel.h
//  Manager
//
//  Created by vpclub on 2018/11/29.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"

@interface NoticeModel : BaseModel

@property (nonatomic, strong) NSNumber<Optional> * appId;
@property (nonatomic, strong) NSString<Optional> * appName;
@property (nonatomic, strong) NSString<Optional> * coverPicture;
@property (nonatomic, strong) NSNumber<Optional> * createBy;
@property (nonatomic, strong) NSString<Optional> * createdTime;
@property (nonatomic, strong) NSNumber<Optional> * deleteBy;
// 记录状态1正常，2已删除
@property (nonatomic, strong) NSString<Optional> * deleteState;
@property (nonatomic, strong) NSString<Optional> * deleteTime;
// 详情类型(1.文本内容 2.链接 3.空)
@property (nonatomic, strong) NSNumber<Optional> * detailType;
@property (nonatomic, strong) NSString<Optional> * dictionaryDisplayPositionCode;
@property (nonatomic, strong) NSString<Optional> * dictionaryProjectTypeCode;
@property (nonatomic, strong) NSString<Optional> * employeeFileUrl;
@property (nonatomic, strong) NSString<Optional> * employeeNumbers;
@property (nonatomic, strong) NSNumber<Optional> * message_id; // == id
@property (nonatomic, strong) NSNumber<Optional> * publishSupplierInfoId;
@property (nonatomic, strong) NSString<Optional> * publishSupplierInfoName;
@property (nonatomic, strong) NSString<Optional> * readNumber;
@property (nonatomic, strong) NSNumber<Optional> * readStatus;
@property (nonatomic, strong) NSString<Optional> * releaseTime;
@property (nonatomic, strong) NSNumber<Optional> * status;
@property (nonatomic, strong) NSString<Optional> * summary;
@property (nonatomic, strong) NSString<Optional> * textContent;
@property (nonatomic, strong) NSString<Optional> * title;
@property (nonatomic, strong) NSNumber<Optional> * type;
@property (nonatomic, strong) NSNumber<Optional> * updateBy;
@property (nonatomic, strong) NSString<Optional> * updatedTime;
@property (nonatomic, strong) NSString<Optional> * url;

@end
