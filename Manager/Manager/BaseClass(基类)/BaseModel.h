//
//  BaseModel.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel

-(id)initWithDictionary:(NSDictionary*)d error:(NSError *__autoreleasing *)err;

@end
