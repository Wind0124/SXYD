//
//  IDInfoModel.h
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IDInfoModel : BaseModel

// http://172.16.124.2/showdoc/web/#/14?page_id=7586 实名认证接口
// http://172.16.124.2/showdoc/web/#/14?page_id=7579 创建订单接口
// 实名认证回调接口字段有好几个与订单接口字段不一致，需要兼容

@property (nonatomic, strong) NSString<Optional> * custCertAddr;// 证件地址
@property (nonatomic, strong) NSString<Optional> * birthday;//  生日（yyyy-MM-dd）
@property (nonatomic, strong) NSString<Optional> * certExpDate;//  身份证失效日期（yyyy-MM-dd）
@property (nonatomic, strong) NSString<Optional> * certValidDate;//  身份证生效日期（yyyy-MM-dd）
@property (nonatomic, strong) NSString<Optional> * psptId;// 证件号码
@property (nonatomic, strong) NSString<Optional> * custName;// 名称
@property (nonatomic, strong) NSString<Optional> * nation;// 民族
@property (nonatomic, strong) NSString<Optional> * gender;// 性别（0代表女， 1 代表男）
@property (nonatomic, strong) NSString<Optional> * issuingAuthority;// 签证机关

@end

NS_ASSUME_NONNULL_END
