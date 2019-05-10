//
//  wendu_yuan2.m
//  2014621
//
//  Created by 孔凡群 on 14-6-30.
//  Copyright (c) 2014年 孔凡群. All rights reserved.
//

#import "wendu_yuan2.h"
#import "yuan2_sc.h"
#import "yuan2_zj.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface wendu_yuan2()
@property (nonatomic, strong) UILabel *numLbl;//剩余量
@property (nonatomic, strong) UILabel *valuePercentLbl;//百分比
@end

@implementation wendu_yuan2
//代码创建初始化
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setchushihua];
    
    _zj.array1 = [NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor], nil];
    _zj.array2 = [NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor], nil];
    
    return  self;
}

-(void)setIsDifferent:(BOOL)isDifferent{
    _isDifferent = isDifferent;
    _zj.isDifferent = YES;
    

    
    
    UILabel *zeroPercentLbl = [[UILabel alloc]initWithFrame:CGRectMake(25*layoutBy6(), 106*layoutBy6()-14*layoutBy6(), 16*layoutBy6(), 14*layoutBy6())];
    zeroPercentLbl.text = @"0%";
    zeroPercentLbl.font = [UIFont systemFontOfSize:10*layoutBy6()];
    zeroPercentLbl.textColor = hexStringToColor(@"999999");
    zeroPercentLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:zeroPercentLbl];
    
    UILabel *hundredPercentLbl = [[UILabel alloc]initWithFrame:CGRectMake(106*layoutBy6()-30*layoutBy6()- 25*layoutBy6(), 106*layoutBy6()-14*layoutBy6(), 30*layoutBy6(), 14*layoutBy6())];
    hundredPercentLbl.text = @"100%";
    hundredPercentLbl.font = [UIFont systemFontOfSize:10*layoutBy6()];
    hundredPercentLbl.textAlignment = NSTextAlignmentRight;
    hundredPercentLbl.textColor = hexStringToColor(@"999999");
    [self addSubview:hundredPercentLbl];
    
    // 中心圆 灰色
    UIView *circleViewBg = [[UIView alloc]initWithFrame:CGRectMake(13.5*layoutBy6(), 11.5*layoutBy6(), 82*layoutBy6(), 82*layoutBy6())];
    circleViewBg.backgroundColor = hexStringToColor(@"F4F5FA");
    circleViewBg.layer.cornerRadius = 41*layoutBy6();
//    circleViewBg.centerX = CGRectGetMidX(self.frame);
    [self addSubview:circleViewBg];
    
    
    //剩余的百分比
    self.valuePercentLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, -10*layoutBy6(), 106*layoutBy6(), 14*layoutBy6())];
    self.valuePercentLbl.text = @"0%";
    self.valuePercentLbl.font = [UIFont systemFontOfSize:10*layoutBy6()];
    self.valuePercentLbl.textColor = hexStringToColor(@"999999");
    self.valuePercentLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.valuePercentLbl];
    
    
    UILabel *useredLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*layoutBy6(), 82*layoutBy6(), 15*layoutBy6())];
    useredLbl.text = @"剩余";
    useredLbl.font = [UIFont systemFontOfSize:13*layoutBy6()];
    useredLbl.textAlignment = NSTextAlignmentCenter;
    useredLbl.textColor = hexStringToColor(@"0084CF");
    [circleViewBg addSubview:useredLbl];
    
    self.numLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(useredLbl.frame)+2.5*layoutBy6(), 82*layoutBy6(), 24*layoutBy6())];
    self.numLbl.text = @"分钟";
    self.numLbl.font = [UIFont systemFontOfSize:17*layoutBy6()];
    self.numLbl.textAlignment = NSTextAlignmentCenter;
    self.numLbl.textColor = hexStringToColor(@"0084CF");
    [circleViewBg addSubview:self.numLbl];
    
    UILabel *detailLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numLbl.frame)+2.5*layoutBy6(), 82*layoutBy6(), 15*layoutBy6())];
    detailLbl.text = @"查看详情";
    detailLbl.font = [UIFont systemFontOfSize:11*layoutBy6()];
    detailLbl.textAlignment = NSTextAlignmentCenter;
    detailLbl.textColor = hexStringToColor(@"0084CF");
    [circleViewBg addSubview:detailLbl];
    
}

- (void)setRemainLabel:(NSString *)remain{
    self.numLbl.text = remain;
    self.valuePercentLbl.text = [NSString stringWithFormat:@"%.0f%%", self.progress * 100];
}

-(void)setchushihua{
    _kd = 10;
    _sc = [[yuan2_sc alloc]init];
    _sc.backgroundColor = [UIColor clearColor];
    _zj = [[yuan2_zj alloc]init];
    _zj.backgroundColor = [UIColor clearColor];
    _zj.toValue = self.progress;
    [self insertSubview:_zj atIndex:1];
    [self insertSubview:_sc atIndex:2];
}


//重绘方法
-(void)drawRect:(CGRect)rect{

    [self draw_scdcdt:rect];
}

//添加上层,中间层，底层
-(void)draw_scdcdt:(CGRect)rect{
        _sc.frame = rect;
        _zj.frame = rect;
        //宽度，值，宽度
        _sc.sc_kd = _kd+5;
        _zj.z = _z;
        _zj.zj_kd = _kd;
}

-(void)setKd:(float)kd{
    _kd = kd> 10?10:kd;
    [self setNeedsDisplay];
}
-(void)setZ:(float)z{
    _z = z;
    [self setNeedsDisplay];
}
-(void)setProgress:(float)progress
{
    _progress = progress;
    _zj.toValue = progress;
}
-(void)start
{
    [_zj startAnimaition];
}
@end
