//
//  PageModel.h
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"

@interface PageModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * pageCount;
@property (nonatomic, strong) NSString<Optional> * pageIndex;
@property (nonatomic, strong) NSString<Optional> * pageSize;
@property (nonatomic, strong) NSString<Optional> * totalCount;

@property (nonatomic, strong) id<Optional> otherDatas;
@property (nonatomic, strong) NSArray<Optional> * datas;

@end
