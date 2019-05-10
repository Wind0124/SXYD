//
//  BlockDefine.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#ifndef BlockDefine_h
#define BlockDefine_h

// 网络请求返回
typedef void (^ResponseResultBlock)(ResponseModel* responseModel);
typedef void (^ModelResultBlock)(BaseModel* object, HeadModel *error);
typedef void (^ModelAndArrayResultBlock)(BaseModel *object, NSArray *array, HeadModel *error);
typedef void (^BooleanResultBlock)(BOOL successed, HeadModel *error);
typedef void (^ModelArrayResultBlock)(NSArray* objects, HeadModel *error);
typedef void (^StringResultBlock)(NSString *string, HeadModel *error);
typedef void (^StringAndBooleanResultBlock)(NSString *string, BOOL successed, HeadModel *error);
typedef void (^DictionaryResultBlock)(NSDictionary *dic, HeadModel *error);

#endif /* BlockDefine_h */
