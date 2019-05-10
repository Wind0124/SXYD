//
//  ShopAddressVC.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopAddressVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKLocationViewDisplayParam.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BMKGeoCodeSearchOption/BMKSearchComponent.h>

@interface ShopAddressVC ()<BMKMapViewDelegate, BMKLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) UIImageView *pinImgView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *currentLabel;

@property (nonatomic, assign) CLLocationCoordinate2D userLocation;// 用户当前位置
@property (nonatomic, strong) ShopInfoModel *modifyModel;

@end

@implementation ShopAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"店铺地址";
    [self jude];

    // 右上角保存按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

    //初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;

//    self.modifyModel = [[ShopInfoModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.mapView = [[BMKMapView alloc] init];
    [self.mapView setMapType:BMKMapTypeStandard];
    [self.mapView setZoomLevel:17];
    self.mapView.showsUserLocation = YES;
    [self.mapView viewWillAppear];
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80);
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.pinImgView];
    [self.view addSubview:self.bottomView];

    
    self.pinImgView.center = self.mapView.center;

    //将定位的点居中显示
    NSLog(@"起始点 === lati:%@, lon:%@", self.model.latitude, self.model.longitude);
    if (self.model.latitude.length > 0 && self.model.longitude.length > 0) {
        BMKCoordinateRegion region;
        region.center.latitude = [self.model.latitude floatValue];
        region.center.longitude = [self.model.longitude floatValue];
        self.mapView.region = region;
        [self reverWithLatitude:region.center.latitude longitude:region.center.longitude];
    } else {
        [self firstGetUserLocation];
    }
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(113.922660, 22.542164)];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}

#pragma mark - 内部事件
//判断是否开启定位服务
- (void)jude {
    
}

- (void)firstGetUserLocation {
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        if (location) {//得到定位信息，添加annotation
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
                BMKCoordinateRegion region;
                region.center.latitude = location.location.coordinate.latitude;
                region.center.longitude = location.location.coordinate.longitude;
                self.mapView.region = region;
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
            }
        }
        NSLog(@"netstate = %d",state);
    }];
}

- (void)save {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.model.province forKey:@"province"];
    [parameters setValue:self.model.city forKey:@"city"];
    [parameters setValue:self.model.district forKey:@"district"];
    [parameters setValue:self.model.businessAddress forKey:@"businessAddress"];
    [parameters setValue:self.model.info_id forKey:@"id"];
    [parameters setValue:self.model.latitude forKey:@"latitude"];
    [parameters setValue:self.model.longitude forKey:@"longitude"];
    [VPAPI modifyShopWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            NSLog(@"更新成功");
//            [self alertWithMessage:@"更新成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//                [self showWithMessage:message];
            [self alertWithMessage:message];
        }
    }];

}

//发起逆地理编码检索
- (void)reverWithLatitude:(double)latitude longitude:(double)longitude {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    reverseGeoCodeSearchOption.location = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"逆geo检索发送成功");
    } else {
        NSLog(@"逆geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反逆地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKAddressComponent *detail = result.addressDetail;
        NSLog(@"%@ %@ %@ %@ %@ %@",detail.province, detail.city, detail.district, detail.town, detail.streetName, detail.streetNumber);
        NSLog(@"地址：%@",result.address);
        NSLog(@"%@",result.sematicDescription);
        self.currentLabel.text = [NSString stringWithFormat:@"当前位置：%@%@%@%@", detail.province, detail.city, detail.district, result.sematicDescription];
        self.model.province = detail.province;
        self.model.city = detail.city;
        self.model.district = detail.district;
        self.model.businessAddress = result.sematicDescription;
        self.model.latitude = [NSString stringWithFormat:@"%f", result.location.latitude];
        self.model.longitude = [NSString stringWithFormat:@"%f", result.location.longitude];
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"更新:latitude--%f,longtitude---%f",self.mapView.region.center.latitude,self.mapView.region.center.longitude);
    double latitude = self.mapView.region.center.latitude;//纬度
    double longitude = self.mapView.region.center.longitude;//精度
    
    [self reverWithLatitude:latitude longitude:longitude];
}

#pragma mark - 懒加载
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
        [imgView setImage:[UIImage imageNamed:@"myShop_img_2"]];
        [_bottomView addSubview:imgView];
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 60 - 20, 80)];
        self.currentLabel.numberOfLines = 0;
        self.currentLabel.font = [UIFont systemFontOfSize:15];
        self.currentLabel.text = @"";
        [_bottomView addSubview:self.currentLabel];
    }
    return _bottomView;
}

- (UIImageView *)pinImgView {
    if (!_pinImgView) {
        _pinImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_pinImgView setImage:[UIImage imageNamed:@"myShop_img_2"]];
    }
    return _pinImgView;
}
@end
