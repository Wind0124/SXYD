//
//  GuideVC.m
//  Manager
//
//  Created by vpclub on 2018/12/15.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "GuideVC.h"
#import "WebViewController.h"

@interface GuideVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (nonatomic, strong) AdvertInfoModel *model;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;
// 跳转时设为YES，看完广告页面后，返回直接进入到登录页面
@property (nonatomic, assign) BOOL goToLogin;

@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.secondBtn.layer.cornerRadius = self.secondBtn.viewWidth/2;
    self.secondBtn.hidden = YES;
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.goToLogin) {
//        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginOrGesture object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)getData {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": SplashScreenPage},
                           };
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        if (object) {
            PageModel *pageModel = (PageModel *)object;
            NSArray *array = pageModel.datas;
            if (array.count >= 1) {
                NSDictionary *dic = array[0];
                AdvertInfoModel *infoModel = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
                self.model = infoModel;
                [self.bgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:infoModel.image server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    self.secondBtn.hidden = NO;
                    self.num = 4;
                    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                    [self.timer fire];
                }];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginOrGesture object:nil];
            }
        } else {
            if ([error.code isEqualToString:@"100019"]) {
                // 服务器时间错误，重新发起请求
                [self getData];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginOrGesture object:nil];
//                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
        }
    }];
}

- (void)count {
    self.num--;
    if (self.num <= 0) {
        [self.timer invalidate];
        self.timer = nil;
//        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginOrGesture object:nil];
        return;
    }
    [self.secondBtn setTitle:[NSString stringWithFormat:@"%ldS", self.num] forState:UIControlStateNormal];
}

- (IBAction)clickAction:(UIButton *)sender {
    self.goToLogin = YES;
    [self jumpH5];
}

- (void)jumpH5 {
    // 外部链接 advertOtherLink advertExternalLink
    WebViewController * web = [[WebViewController alloc] init];
    web.urlStr = self.model.linkAddr;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)dismissAction:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginOrGesture object:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
