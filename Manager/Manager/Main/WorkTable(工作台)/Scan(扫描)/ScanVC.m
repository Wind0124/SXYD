//
//  ScanVC.m
//  Manager
//
//  Created by vpclub on 2018/12/26.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ScanVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIImageView *cornerImgView;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong)AVCaptureSession *session;//输入输出的中间桥梁

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"IMEI扫描";
    self.edgesForExtendedLayout = UIRectEdgeNone;

//    self.view.backgroundColor = hexStringToColor(@"5B5B5B");
//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.cornerImgView];
    [self.view addSubview:self.lineImgView];
    [self.view addSubview:self.tipLabel];
    //300为正方形扫描区域边长
    [self startScanWithSize:250];
    
    self.timer = [NSTimer timerWithTimeInterval:0.02f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
}

- (void)countDown {
    const CGFloat yOffset = 2;
    if (self.lineImgView.y >= self.cornerImgView.maxY) {
        CGRect lineFrame = self.lineImgView.frame;
        lineFrame.origin.y = self.cornerImgView.y;
        self.lineImgView.frame = lineFrame;
    } else {
        CGRect lineFrame = self.lineImgView.frame;
        lineFrame.origin.y += yOffset;
        self.lineImgView.frame = lineFrame;
    }
}

#pragma mark - 开始扫描
- (void)startScanWithSize:(CGFloat)sizeValue {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input) {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //设置为宽高为200的正方形区域相对于屏幕居中
//        layer.frame = CGRectMake((self.view.bounds.size.width - sizeValue) / 2.0, (self.view.bounds.size.height - sizeValue) / 2.0, sizeValue, sizeValue);
        layer.frame = self.cornerImgView.frame;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获图像:
        [_session startRunning];
    }
}

#pragma mark - 扫面结果在这个代理方法里获取到
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //获取到信息后停止扫描:
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串:
        NSLog(@"%@", metaDataObject.stringValue);
        self.ScanResultBlock ? self.ScanResultBlock(metaDataObject.stringValue) : nil;
        [self.navigationController popViewControllerAnimated:YES];
        //移除扫描视图:
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - 懒加载
- (UIImageView *)cornerImgView {
    if (!_cornerImgView) {
        _cornerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH - 100, SCREEN_WIDTH - 100)];
        [_cornerImgView setImage:[UIImage imageNamed:@"scan_border"]];
    }
    return _cornerImgView;
}

- (UIImageView *)lineImgView {
    if (!_lineImgView) {
        _lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cornerImgView.x, self.cornerImgView.y, self.cornerImgView.viewWidth, 2)];
        [_lineImgView setImage:[UIImage imageNamed:@"scan_line"]];
    }
    return _lineImgView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.cornerImgView.maxY + 10, SCREEN_WIDTH, 20)];
        _tipLabel.text = @"请将条码放入框内，将自动扫码";
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
@end
