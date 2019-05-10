//
//  ShareSDKModel.h
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareSDKModel : BaseModel

@property (nonatomic,strong) NSString<Optional>* shareTitle;
@property (nonatomic,strong) NSString<Optional>* shareDesc;
@property (nonatomic,strong) NSString<Optional>* shareLink;
@property (nonatomic,strong) NSString<Optional>* shareImgurl;
@property (nonatomic, strong) UIImage *shareImg;

@end

NS_ASSUME_NONNULL_END
