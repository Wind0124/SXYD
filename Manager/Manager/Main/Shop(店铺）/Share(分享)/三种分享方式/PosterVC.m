//
//  PosterVC.m
//  Manager
//
//  Created by vpclub on 2018/12/8.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "PosterVC.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+LXDCreateBarcode.h"
#import <Photos/Photos.h>
#import "ShareView.h"

@interface PosterVC ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *posterImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImgView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) ShareModel *model;

@end

@implementation PosterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"海报";
    self.shareBtn.layer.borderWidth = 1;
    self.shareBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.shareBtn.layer.masksToBounds = YES;
    
    [VPAPI getShareMessageWithType:1 para:@{@"shareType": @"1",} block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            NSLog(@"海报：%@",object);
            self.model = (ShareModel *)object;
            [self showQrcode];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)showQrcode{
    NSString *posterUrlString = [NSString getFullImageUrlString:self.model.coverUrl server:CurrentUser.imgServerPrefix];
    [self.posterImgView sd_setImageWithURL:[NSURL URLWithString:posterUrlString]];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", self.model.name];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@%@%@%@",self.model.province, self.model.city, self.model.district, self.model.businessAddress];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", self.model.mobile];
    //生成二维码
    NSString *urlStr = [NSString stringWithFormat:@"%@&supplierId=%@&supplierName=%@&channelId=%@&clerkId=%@&userId=%@", self.model.qrCodeUrl, CurrentUser.defaultSupplierId, CurrentUser.defaultSupplierName, CurrentUser.defaultChannelId, CurrentUser.thousandClerkId, CurrentUser.userId];
    urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,35, 35)];
    [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * img = [UIImage imageOfQRFromURL:urlStr codeSize: 1000 red: 0 green: 0 blue: 0 insertImage:imgV.image roundRadius: 5.0f];
        self.QRImgView.backgroundColor = [UIColor whiteColor];
        self.QRImgView.image = img;
    }];
}

#pragma mark - 内部事件
- (IBAction)saveAction:(UIButton *)sender {
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
            } else {
                [self alertWithMessage:@"保存失败"];
            }
        });
    }];
}

- (IBAction)shareAction:(UIButton *)sender {
    self.shareImg = [self captureImageFromView:self.backView];

    ShareSDKModel *shareModel = [[ShareSDKModel alloc] init];
    shareModel.shareTitle = self.model.title;
    shareModel.shareDesc = @"";
    shareModel.shareLink = self.model.qrCodeUrl;
    shareModel.shareImg = self.shareImg;
    
    ShareView *shareView = [[ShareView alloc] initWithNib];
    [shareView showShareView:shareModel];

}


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

@end
