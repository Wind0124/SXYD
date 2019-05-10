//
//  HeadlineCell.m
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import "HeadlineCell.h"
#import "SDCycleScrollView.h"

@interface HeadlineCell()

@property (nonatomic, strong) SDCycleScrollView * cycleScrollview;
@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * imgArray;

@end

@implementation HeadlineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleArray = [[NSMutableArray alloc]init];
        self.imgArray = [[NSMutableArray alloc]init];
//        self.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.imgView];
        [self addSubview:self.cycleScrollview];
    }
    return self;
}

#pragma mark - 加载数据
- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    for (NoticeModel * model in modelArray) {
        if (model.title.length > 0) {
            [self.titleArray addObject:model.title];
        }
    }
    self.cycleScrollview.imageURLStringsGroup = self.titleArray;
    self.cycleScrollview.titlesGroup = self.titleArray;
}

#pragma mark - 懒加载
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headline"]];
        _imgView.frame = CGRectMake(17, 16, 55, 16);
        UILabel * line = [[UILabel alloc]init];
        line.backgroundColor = hexStringToColor(COLOR_Line);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(0.5);
            make.left.mas_equalTo(80);
        }];
    }
    return _imgView;
}

-(SDCycleScrollView *)cycleScrollview{
    if (!_cycleScrollview) {
        _cycleScrollview = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(83, 0, SCREEN_WIDTH, 50)];
        _cycleScrollview.autoScroll = true;
        _cycleScrollview.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollview.autoScrollTimeInterval = 3.0;
        _cycleScrollview.backgroundColor = [UIColor whiteColor];
        _cycleScrollview.imageURLStringsGroup =@[@""];
//        _cycleScrollview.placeholderImage = [UIImage imageWithColor:WhiteColor];
        _cycleScrollview.titlesGroup = @[@""];
//        _cycleScrollview.delegate = self;
        [_cycleScrollview disableScrollGesture];
        _cycleScrollview.titleLabelTextColor = [UIColor blackColor];
        _cycleScrollview.titleLabelHeight = 50;
        _cycleScrollview.titleLabelBackgroundColor = [UIColor whiteColor];;
        
        _cycleScrollview.showPageControl = NO;
        __weak typeof(self) weakSelf = self;
        _cycleScrollview.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"点击了第%zd个", currentIndex);
            NSInteger index = currentIndex % self.modelArray.count;
            if (weakSelf.block) {
                weakSelf.block(index);
            }
        };
    }
    return _cycleScrollview;
}
#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
