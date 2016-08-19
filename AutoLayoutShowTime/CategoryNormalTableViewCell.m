//
//  CategoryNormalTableViewCell.m
//  Taowaitao
//
//  Created by 宓珂璟 on 16/7/4.
//

#import "CategoryNormalTableViewCell.h"
#import "SecondCategoryCollectionViewCell.h"
#import "CategoryModel.h"

@interface CategoryNormalTableViewCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

static NSString *identyfy = @"SecondCategoryCollectionViewCell";

@implementation CategoryNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.normalLeftImageView.clipsToBounds = YES;
    self.normalMiddleImageView.clipsToBounds = YES;
    self.normalRightImageView.clipsToBounds = YES;
    self.normalLeftMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.normalRightMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.normalMiddleMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    self.selectedLeftImageView.clipsToBounds = YES;
    self.selectedMiddleImageView.clipsToBounds = YES;
    self.selectedRightImageView.clipsToBounds = YES;
    self.selectedLeftMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.selectedMiddleMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.selectedRightMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    // 0 1 2三组图片加点击事件
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftPic:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftPic:)];
    self.normalLeftImageView.userInteractionEnabled = YES;
    self.selectedLeftImageView.userInteractionEnabled = YES;
    [self.normalLeftImageView addGestureRecognizer:tap1];
    [self.selectedLeftImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMiddlePic:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMiddlePic:)];
    self.normalMiddleImageView.userInteractionEnabled = YES;
    self.selectedMiddleImageView.userInteractionEnabled = YES;
    [self.normalMiddleImageView addGestureRecognizer:tap3];
    [self.selectedMiddleImageView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRightPic:)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRightPic:)];
    self.normalRightImageView.userInteractionEnabled = YES;
    self.selectedRightImageView.userInteractionEnabled = YES;
    [self.normalRightImageView addGestureRecognizer:tap5];
    [self.selectedRightImageView addGestureRecognizer:tap6];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor =[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellWithReuseIdentifier:identyfy];
    
}

- (void)clickLeftPic:(UITapGestureRecognizer *)tap
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickImageViewCallBack:imageIndex:)])
    {
        [self.delegate clickImageViewCallBack:self imageIndex:0];
        
    }
}

- (void)clickMiddlePic:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageViewCallBack:imageIndex:)]) {
        [self.delegate clickImageViewCallBack:self imageIndex:1];
    }
}

- (void)clickRightPic:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageViewCallBack:imageIndex:)]) {
        [self.delegate clickImageViewCallBack:self imageIndex:2];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.secondClassificationLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondCategoryInfomation *secondInfo = self.secondClassificationLists[indexPath.item];
    SecondCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identyfy forIndexPath:indexPath];
    if (indexPath.item == 0)
    {
        cell.secondCategoryName.text = @"全部";
    }
    else
    {
        cell.secondCategoryName.text = secondInfo.secondCategoryName;
    }
    cell.secondCategoryName.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (SCREEN_WIDTH - 24 * 2 - 8 * 3) / 4;
    return CGSizeMake(width, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16, 24, 16, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
