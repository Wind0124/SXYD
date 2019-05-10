//
//  StopWatchView.m
//  小移云店
//
//  Created by 倪荡坤 on 2018/7/31.
//  Copyright © 2018年 liuyingjieyeah. All rights reserved.
//

#import "StopWatchView.h"
#import "wendu_yuan2.h"
// 隐藏显示码表按钮
#import "ShowOrHideBtn.h"
//#import "UIView+YYAdd.h"
@interface StopWatchView()

@property (nonatomic, strong) UILabel *flowTitleLbl;//流量
@property (nonatomic, strong) UIButton *checkUsedBtn;//查看已用
@property (nonatomic, strong) UILabel *telTimeLbl;//通话
@property (nonatomic, strong) ShowOrHideBtn *hideOrShowBtn;//隐藏码表

@property (nonatomic, strong) wendu_yuan2 *progressView1;// 大码表1
@property (nonatomic, strong) wendu_yuan2 *littleProgressView1;// 小码表1
@property (nonatomic,strong) wendu_yuan2 *progressView2;// 大码表2
@property (nonatomic,strong) wendu_yuan2 *littleProgressView2;// 小码表2

// 新增
@property (nonatomic, strong) UILabel *usedFlowLbl;//剩余流量
@property (nonatomic, strong) UILabel *usedTelTimeLbl;//剩余时间

@property (nonatomic, assign) BOOL isShow;//默认是yes

@property (nonatomic, strong) UITapGestureRecognizer *tapDetail;//剩余时间

@end

@implementation StopWatchView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadView];
}

- (instancetype)init{
    self = [super init];
    [self loadView];
    return self;
}

-(void)loadView{
    self.backgroundColor = UIColor.whiteColor;
    self.isShow = YES;
    
    //流量
    [self addSubview:self.progressView1];
    
    self.progressView1.userInteractionEnabled = true;
    
    //剩余流量
    [self.progressView1 addSubview:self.littleProgressView1];
    //通话
    [self addSubview:self.progressView2];
    //剩余通话
    [self.progressView2 addSubview:self.littleProgressView2];
    
    [self addSubview:self.usedFlowLbl];
    [self addSubview:self.usedTelTimeLbl];
    
    [self addSubview:self.checkUsedBtn];
    [self addSubview:self.flowTitleLbl];
    [self addSubview:self.telTimeLbl];
    [self addSubview:self.hideOrShowBtn];
    
    [self addSubview:self.usedFlowLbl];
    [self addSubview:self.telTimeLbl];
    
    self.SWheight = CGRectGetMaxY(_hideOrShowBtn.frame) + 15*layoutBy6();
    
    [_progressView1 addGestureRecognizer:self.tapDetail];
    
    [_progressView2 addGestureRecognizer:self.tapDetail];
    
}

-(void)tapDetailAction{
    self.clickDetailBlock ? self.clickDetailBlock() : nil;
}


#pragma mark - setter && getter
- (UITapGestureRecognizer *)tapDetail{
    //一个tap只能被一个view 响应。。。
    _tapDetail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetailAction)];
    return _tapDetail;
}

- (void)setModel:(AuthUserInfoModel *)model {
    NSLog(@"剩余流量：%f,流量：%f,剩余分钟：%f,分钟：%f", [model.surplusflow floatValue], [model.totalFlow floatValue], [model.remainingMinutes floatValue], [model.buffetTotalMinutes floatValue]);
//#if ENVIRONMENT == 0
//    model.surplusflow = @"600";
//    model.totalFlow = @"1000";
//    model.buffetTotalMinutes = @"1";
//#endif
    _model = model;
    if ([model.totalFlow floatValue] > 0) {
        self.littleProgressView1.progress = [model.surplusflow floatValue] / [model.totalFlow floatValue];
    } else {
        self.littleProgressView1.progress = 0;
    }
    NSString *remainFlow = [NSString stringWithFormat:@"剩余:%.0f",[model.surplusflow floatValue]];
    [self.littleProgressView1 setRemainLabel:remainFlow];
    self.usedFlowLbl.text = remainFlow;

    if ([model.buffetTotalMinutes floatValue] > 0) {
        self.littleProgressView2.progress = [model.remainingMinutes floatValue] / [model.buffetTotalMinutes floatValue];
    } else {
        self.littleProgressView2.progress = 0;
    }
    NSString *remainMinutes = [NSString stringWithFormat:@"剩余:%.0f",[model.remainingMinutes floatValue]];
    [self.littleProgressView2 setRemainLabel:remainMinutes];
    self.usedTelTimeLbl.text = remainMinutes;
    
    self.progressView1.progress = 100.0/100.0;
    self.progressView2.progress = 100.0/100.0;
    [self.progressView1 start];
    [self.littleProgressView1 start];
    [self.progressView2 start];
    [self.littleProgressView2 start];
}

#pragma mark - 绑定事件
-(void)hideProgressViewAction{
    if (self.isShow) {
        self.SWheight = 101*layoutBy6();
        // 隐藏
        self.progressView1.hidden = YES;
        self.progressView2.hidden = YES;
        self.hideOrShowBtn.y = CGRectGetMaxY(_checkUsedBtn.frame)+45.5*layoutBy6();
        self.usedFlowLbl.hidden = NO;
        self.usedTelTimeLbl.hidden = NO;
        self.isShow = NO;
        
        [self.hideOrShowBtn.titleBtn setTitle:@"显示码表" forState:UIControlStateNormal];
        [self.hideOrShowBtn.iconBtn setImage:[UIImage imageNamed:@"Workbench_icon_img_31"] forState:UIControlStateNormal];
    } else {
        // 显示
        self.progressView1.hidden = NO;
        self.progressView2.hidden = NO;
        self.hideOrShowBtn.y = CGRectGetMaxY(_progressView1.frame)-25*layoutBy6();
        self.usedFlowLbl.hidden = YES;
        self.usedTelTimeLbl.hidden = YES;
        self.isShow = YES;
        
        [self.hideOrShowBtn.titleBtn setTitle:@"隐藏码表" forState:UIControlStateNormal];
        [self.hideOrShowBtn.iconBtn setImage:[UIImage imageNamed:@"Workbench_icon_img_32"] forState:UIControlStateNormal];
        
        self.SWheight = CGRectGetMaxY(_hideOrShowBtn.frame) + 15*layoutBy6();
    }
    [self setViewHeight:self.SWheight];
   
    self.clickHideBlock ? self.clickHideBlock(self.SWheight) : nil;
}

#pragma mark - 初始化
- (UILabel *)usedFlowLbl {
    if (!_usedFlowLbl) {
        _usedFlowLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_flowTitleLbl.frame) + 40*layoutBy6(), SCREEN_WIDTH/2, 18.5*layoutBy6())];
        _usedFlowLbl.text = @"剩余:";
        _usedFlowLbl.font = [UIFont systemFontOfSize:13*layoutBy6()];
        _usedFlowLbl.textAlignment = NSTextAlignmentCenter;
        _usedFlowLbl.textColor = hexStringToColor(@"0084CF");
        _usedFlowLbl.hidden = YES;
    }
    return _usedFlowLbl;
}

- (UILabel *)usedTelTimeLbl {
    if (!_usedTelTimeLbl) {
        _usedTelTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(_flowTitleLbl.frame) + 40*layoutBy6(), SCREEN_WIDTH/2, 18.5*layoutBy6())];
        _usedTelTimeLbl.text = @"剩余:";
        _usedTelTimeLbl.font = [UIFont systemFontOfSize:13*layoutBy6()];
        _usedTelTimeLbl.textAlignment = NSTextAlignmentCenter;
        _usedTelTimeLbl.textColor = hexStringToColor(@"0084CF");
        _usedTelTimeLbl.hidden = YES;
    }
    return _usedTelTimeLbl;
}


- (UIButton *)checkUsedBtn {
    if (!_checkUsedBtn) {
        _checkUsedBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 12*layoutBy6(), 50*layoutBy6(), 15*layoutBy6())];
        [_checkUsedBtn setTitle:@"查看已用" forState:UIControlStateNormal];
        [_checkUsedBtn setTitleColor:hexStringToColor(@"0084CF") forState:UIControlStateNormal];
        _checkUsedBtn.layer.cornerRadius = 7.5*layoutBy6();
        _checkUsedBtn.layer.borderColor = hexStringToColor(@"0084CF").CGColor;
        _checkUsedBtn.layer.borderWidth = 0.5*layoutBy6();
        _checkUsedBtn.titleLabel.font = [UIFont systemFontOfSize:10*layoutBy6()];
        [_checkUsedBtn addTarget:self action:@selector(tapDetailAction) forControlEvents:UIControlEventTouchUpInside];
        _checkUsedBtn.centerX = SCREEN_WIDTH/2;
    }
    return _checkUsedBtn;
}

- (UILabel *)flowTitleLbl {
    if (!_flowTitleLbl) {
        _flowTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*layoutBy6(), 30*layoutBy6(), 18.5*layoutBy6())];
        _flowTitleLbl.text = @"流量";
        _flowTitleLbl.textColor = hexStringToColor(@"414141");
        _flowTitleLbl.textAlignment = NSTextAlignmentCenter;
        _flowTitleLbl.font = [UIFont systemFontOfSize:13*layoutBy6()];
        _flowTitleLbl.centerX = CGRectGetMidX(_progressView1.frame);
    }
    return _flowTitleLbl;
}
- (UILabel *)telTimeLbl {
    if (!_telTimeLbl) {
        _telTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*layoutBy6(), 30*layoutBy6(), 18.5*layoutBy6())];
        _telTimeLbl.text = @"通话";
        _telTimeLbl.textColor = hexStringToColor(@"414141");
        _telTimeLbl.textAlignment = NSTextAlignmentCenter;
        _telTimeLbl.font = [UIFont systemFontOfSize:13*layoutBy6()];
        _telTimeLbl.centerX = CGRectGetMidX(_progressView2.frame);
    }
    return _telTimeLbl;
}

- (ShowOrHideBtn *)hideOrShowBtn {
    if (!_hideOrShowBtn) {
        _hideOrShowBtn = [[ShowOrHideBtn alloc]initWithFrame:CGRectMake(162*layoutBy6(), CGRectGetMaxY(_progressView1.frame)-25*layoutBy6(), 51*layoutBy6(), 19*layoutBy6())];
        [_hideOrShowBtn addTarget:self action:@selector(hideProgressViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideOrShowBtn;
}

- (wendu_yuan2 *)littleProgressView2 {
    if (!_littleProgressView2) {
        _littleProgressView2 = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(18*layoutBy6(), 19.5*layoutBy6(), CGRectGetWidth(_progressView2.frame)-36*layoutBy6(), CGRectGetWidth(_progressView2.frame)-36*layoutBy6())];
        _littleProgressView2.backgroundColor = [UIColor clearColor];
        _littleProgressView2.isDifferent = YES;
        _littleProgressView2.kd = 5*layoutBy6();
    }
    return _littleProgressView2;
}

- (wendu_yuan2*)progressView2 {
    if (_progressView2  == nil) {
        _progressView2 = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20*layoutBy6()-142*layoutBy6(), 35.5*layoutBy6(), 142*layoutBy6(), 142*layoutBy6())];
        _progressView2.backgroundColor = [UIColor clearColor];
    }
    return _progressView2;
}



- (wendu_yuan2 *)littleProgressView1 {
    if (!_littleProgressView1) {
        _littleProgressView1 = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(18*layoutBy6(), 19.5*layoutBy6(), CGRectGetWidth(_progressView1.frame)-36*layoutBy6(), CGRectGetWidth(_progressView1.frame)-36*layoutBy6())];
        _littleProgressView1.isDifferent = YES;
        _littleProgressView1.backgroundColor = [UIColor clearColor];
        _littleProgressView1.kd = 5*layoutBy6();
    }
    return _littleProgressView1;
}

- (wendu_yuan2*)progressView1 {
    if (_progressView1  == nil) {
        _progressView1 = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(20*layoutBy6(), 35.5*layoutBy6(), 142*layoutBy6(), 142*layoutBy6())];
        _progressView1.backgroundColor = [UIColor clearColor];
        
    }
    return _progressView1;
}

@end
