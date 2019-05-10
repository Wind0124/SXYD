//
//  StoreQrCodeView.m
//  智汇随身厅
//
//  Created by vivian on 2017/5/19.
//  Copyright © 2017年 vivian. All rights reserved.
//

#import "StoreQrCodeVC.h"
//生成二维码,支持iOS7.0以上
#import <CoreImage/CoreImage.h>
#import "UIImage+LXDCreateBarcode.h"
#import "Masonry.h"

#import <Photos/Photos.h>
#import "ShareView.h"

@interface StoreQrCodeVC ()

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *qrImgV;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) ShareModel *model;
@end

@implementation StoreQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"二维码";
    
    self.view.backgroundColor = hexStringToColor(@"B3D7EB");
    self.view.layer.cornerRadius = 3;
    self.view.layer.masksToBounds = YES;
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.shopNameLabel];
    [self.backView addSubview:self.qrImgV];
    [self.backView addSubview:self.phoneLabel];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.shareBtn];
    
    // 不显示手机号(陕西)
    self.phoneLabel.text = CurrentUser.mobile;
    self.phoneLabel.hidden = YES;
    
    [VPAPI getShareMessageWithType:0 para:@{@"shareType": @"1",} block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            self.model = (ShareModel *)object;
            [self showQrcode];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self alertWithMessage:message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)showQrcode{
    // 分享链接拼接参数
    NSString *urlStr = [NSString stringWithFormat:@"%@&supplierId=%@&supplierName=%@&channelId=%@&clerkId=%@&userId=%@", self.model.linkUrl, CurrentUser.defaultSupplierId, CurrentUser.defaultSupplierName, CurrentUser.defaultChannelId, CurrentUser.thousandClerkId, CurrentUser.userId];
    urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    //生成二维码
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * img = [UIImage imageOfQRFromURL:urlStr codeSize: 1000 red: 0 green: 0 blue: 0 insertImage: imgV.image roundRadius: 5.0f];
        self.qrImgV.backgroundColor = [UIColor whiteColor];
        self.qrImgV.image = img;
        self.shareImg = [self captureImageFromView:self.backView];
    }];
}

#pragma mark - 点击事件
- (void)shareBtnAction {
    self.shareImg = [self captureImageFromView:self.backView];

    ShareSDKModel *shareModel = [[ShareSDKModel alloc] init];
    shareModel.shareTitle = @"";
    shareModel.shareDesc = @"";
    shareModel.shareLink = @"";
    shareModel.shareImg = self.shareImg;
    
    ShareView *shareView = [[ShareView alloc] initWithNib];
    [shareView showShareView:shareModel];
}

//点击保存二维码到相册
-(void)saveBtnAction{
    self.shareImg = [self captureImageFromView:self.backView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:self.shareImg];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            if (success) {
                [self alertWithMessage:@"保存成功"];
                
                //成功后取相册中的图片对象
    //            __block PHAsset *imageAsset = nil;
    //            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
    //            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                imageAsset = obj;
    //                *stop = YES;
    //            }];
    //            if (imageAsset)
    //            {
    //                //加载图片数据
    //                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
    //                                                                  options:nil
    //                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
    //                                                                NSLog(@"imageData = %@", imageData);
    //                                                            }];
    //            }
            } else {
                [self alertWithMessage:@"保存失败"];
            }
        });
    }];

}

//长按保存二维码到相册
//-(void)saveQrCode:(UILongPressGestureRecognizer*)gesture{
//    if(gesture.state == UIGestureRecognizerStateBegan){
//        [[AppSingleton shareSingleton] loadImageFinished:self.qrImgV.image];
//    }
//}


//对某个view进行截图
-(UIImage *)captureImageFromView:(UIView *)view {
    CGRect screenRect = [view bounds];
    CGFloat scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5) {
            scale = 2.0;
        }
        if (tmp > 2.5) {
            scale = 3.0;
        }
    }
    if (scale > 1.5) {
        UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(screenRect.size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - 懒加载
-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 96, 250, 300)];
        _backView.image = [UIImage imageNamed:@"shop_share_bg"];
    }
    return _backView;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.backView.viewWidth - 40, 50)];
        _phoneLabel.textColor = hexStringToColor(@"#333333");
        _shopNameLabel.textAlignment = NSTextAlignmentCenter;
        _shopNameLabel.font = [UIFont systemFontOfSize:20];
        _shopNameLabel.numberOfLines = 0;
        _shopNameLabel.text = [NSString stringWithFormat:@"%@的二维码", CurrentUser.shopName];
    }
    return _shopNameLabel;
}

- (UIImageView*)qrImgV{
    if (!_qrImgV) {
        _qrImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.backView.frame)-150)/2,CGRectGetMaxY(self.shopNameLabel.frame) + 10, 150, 150)];
        _qrImgV.userInteractionEnabled = YES;
//        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveQrCode:)];
//        longPressGr.minimumPressDuration = 1.0;
//        [_qrImgV addGestureRecognizer:longPressGr];
    }
    return _qrImgV;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.qrImgV.frame)+20, CGRectGetWidth(self.backView.frame), 15)];
        _phoneLabel.textColor = hexStringToColor(@"#0084CF");
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = [UIFont systemFontOfSize:13];
    }
    return _phoneLabel;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backView.frame) + 50, SCREEN_WIDTH - 30, 40)];
        _saveBtn.backgroundColor = hexStringToColor(@"#0084CF");
        _saveBtn.layer.cornerRadius = 4;
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn setTitle:@"保存" forState:0];
        [_saveBtn setTitleColor:hexStringToColor(@"FFFFFF") forState:0];
        [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.saveBtn.frame) + 15, SCREEN_WIDTH - 30, 40)];
        _shareBtn.backgroundColor = [UIColor whiteColor];
        _shareBtn.layer.borderColor = hexStringToColor(@"#0084CF").CGColor;
        _shareBtn.layer.borderWidth = 1;
        _shareBtn.layer.cornerRadius = 4;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn setTitle:@"分享" forState:0];
        [_shareBtn setTitleColor:hexStringToColor(@"#0084CF") forState:0];
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}


@end
