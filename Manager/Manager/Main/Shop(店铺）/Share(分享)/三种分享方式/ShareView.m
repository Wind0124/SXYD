//
//  ShareView.m
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShareView.h"
//微信SDK头文件
#import "WXApi.h"

@interface ShareView()

@property (nonatomic, strong) ShareSDKModel *model;
@end

@implementation ShareView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + IPHONEX_BOTTOM_SPACE);
    } else {
        self = [super init];
    }
    return self;
}

- (void)showInVC:(BaseVC *)fatherVC {
    NSLog(@"分享");
    [VPAPI getShareMessageWithType:2 para:@{@"shareType": @"1",} block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            ShareModel *model = (ShareModel *)object;
            ShareSDKModel *shareSDKModel = [[ShareSDKModel alloc] init];
            shareSDKModel.shareDesc = model.content.length > 0 ? model.content : @"欢迎光临";
            shareSDKModel.shareTitle = model.title;
            shareSDKModel.shareImgurl = [NSString getFullImageUrlString:model.picUrl server:CurrentUser.imgServerPrefix];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@&supplierId=%@&supplierName=%@&channelId=%@&clerkId=%@&userId=%@", model.linkUrl, CurrentUser.defaultSupplierId, CurrentUser.defaultSupplierName, CurrentUser.defaultChannelId, CurrentUser.thousandClerkId, CurrentUser.userId];
            urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            shareSDKModel.shareLink = urlStr;
//                shareSDKModel.shareLink = [NSString stringWithFormat:@"%@", model.linkUrl];
            // 显示
            self.model = shareSDKModel;
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [del.window addSubview:self];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [fatherVC alertWithMessage:message];
        }
    }];
}

// 分享，带分享数据
- (void)showShareView:(ShareSDKModel *)model {
    self.model = model;
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.window addSubview:self];
}

#pragma mark - 内部点击
- (IBAction)dismissAction:(UIButton *)sender {
    [self removeFromSuperview];
}

// 分享到微信
- (IBAction)shareToWechat:(UITapGestureRecognizer *)sender {
    NSLog(@"分享到微信");
    [ShareManger shareWithModel:self.model andType:SSDKPlatformTypeWechat block:^(SSDKResponseState code) {
        
    }];
    [self removeFromSuperview];
}

// 分享到微信朋友圈
- (IBAction)shareToWechatFriend:(UITapGestureRecognizer *)sender {
    NSLog(@"分享到微信朋友圈");
    [ShareManger shareWithModel:self.model andType:SSDKPlatformSubTypeWechatTimeline block:^(SSDKResponseState code) {
        
    }];
    [self removeFromSuperview];
}

@end
