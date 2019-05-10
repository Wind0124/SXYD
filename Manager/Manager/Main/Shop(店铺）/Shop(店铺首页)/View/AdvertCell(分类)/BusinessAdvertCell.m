//
//  BusinessAdvertCell.m
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import "BusinessAdvertCell.h"
#import "BusinessCCell.h"

@interface BusinessAdvertCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collView;


@end

@implementation BusinessAdvertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor blueColor];
        [self layoutIfNeeded];
        [self addSubview:self.collView];
    }
    return self;
}

#pragma mark - 数据
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    self.collView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80 * ceil(_dataArray.count / 4.0));
    [self.collView reloadData];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){SCREEN_WIDTH / 4, 80};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return (CGSize){SCREEN_WIDTH, 44};
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return (CGSize){SCREEN_WIDTH, 22};
//}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"BusinessCCell";
    BusinessCCell *cCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    [cell sizeToFit];
    if (indexPath.item < self.dataArray.count) {
        AdvertInfoModel *infoModel = (AdvertInfoModel *)self.dataArray[indexPath.item];
        // 处理图片地址
        NSString *fullImgString = [NSString getFullImageUrlString:infoModel.image server:CurrentUser.imgServerPrefix];
        [cCell.imgView sd_setImageWithURL:[NSURL URLWithString:fullImgString] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        cCell.nameLabel.text = infoModel.name;
    } else {
        cCell.backgroundColor = [UIColor clearColor];
        cCell.imgView.image = [UIImage imageNamed:@"tabbarIcon"];
    }
    // 布局查看
//    if (indexPath.item % 2 == 0) {
//        cCell.backgroundColor = [UIColor greenColor];
//    } else {
//        cCell.backgroundColor = [UIColor yellowColor];
//    }
    return cCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 使用block
    AdvertInfoModel *infoModel = (AdvertInfoModel *)self.dataArray[indexPath.item];
    if (self.block) {
        self.block(infoModel);
    }
}

#pragma mark - 懒加载
-(UICollectionView*)collView{
    if (!_collView) {
        UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init];
//        customLayout.itemSize = CGSizeMake(50, 50);
        _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) collectionViewLayout:customLayout];
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.backgroundColor = [UIColor whiteColor];
        _collView.showsVerticalScrollIndicator = NO;
        _collView.showsHorizontalScrollIndicator = NO;
        _collView.pagingEnabled = YES;
        [_collView registerClass:[BusinessCCell class] forCellWithReuseIdentifier:@"BusinessCCell"];
    }
    return _collView;
}

#pragma
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
