//
//  EmployeeModel.h
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"
@protocol WorkbenchModel
@end

@interface EmployeeModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * employeeNumber;
@property (nonatomic, strong) NSArray<WorkbenchModel, Optional> * listWorkbench;

@end
