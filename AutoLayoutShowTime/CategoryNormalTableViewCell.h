//
//  CategoryNormalTableViewCell.h
//  Taowaitao
//
//  Created by 宓珂璟 on 16/7/4.
//

#import <UIKit/UIKit.h>

@class CategoryNormalTableViewCell;
@protocol CategoryNormalTableViewCellDelegate <NSObject>

- (void)clickImageViewCallBack:(CategoryNormalTableViewCell *)cell imageIndex:(NSInteger)idx;

@end

@interface CategoryNormalTableViewCell : UITableViewCell

// normal
// left
@property (weak, nonatomic) IBOutlet UIImageView *normalLeftImageView;
@property (weak, nonatomic) IBOutlet UIView *normalLeftView;
@property (weak, nonatomic) IBOutlet UIView *normalLeftMaskView;
@property (weak, nonatomic) IBOutlet UILabel *normalLeftlabel;

// middle
@property (weak, nonatomic) IBOutlet UIImageView *normalMiddleImageView;
@property (weak, nonatomic) IBOutlet UIView *normalMiddleView;
@property (weak, nonatomic) IBOutlet UIView *normalMiddleMaskView;
@property (weak, nonatomic) IBOutlet UILabel *normalMiddleLabel;

// right
@property (weak, nonatomic) IBOutlet UIImageView *normalRightImageView;
@property (weak, nonatomic) IBOutlet UIView *normalRightView;
@property (weak, nonatomic) IBOutlet UIView *normalRightMaskView;
@property (weak, nonatomic) IBOutlet UILabel *normalRightLabel;


// selected
// left
@property (weak, nonatomic) IBOutlet UIImageView *selectedLeftImageView;
@property (weak, nonatomic) IBOutlet UIView *selectedLeftView;
@property (weak, nonatomic) IBOutlet UIView *selectedLeftMaskView;

@property (weak, nonatomic) IBOutlet UILabel *selectedLeftLabel;

// middle
@property (weak, nonatomic) IBOutlet UIImageView *selectedMiddleImageView;
@property (weak, nonatomic) IBOutlet UIView *selectedMiddleView;
@property (weak, nonatomic) IBOutlet UIView *selectedMiddleMaskView;
@property (weak, nonatomic) IBOutlet UILabel *selectedMiddleLabel;

// right
@property (weak, nonatomic) IBOutlet UIImageView *selectedRightImageView;
@property (weak, nonatomic) IBOutlet UIView *selectedRightView;
@property (weak, nonatomic) IBOutlet UIView *selectedRightMaskView;
@property (weak, nonatomic) IBOutlet UILabel *selectedRightLabel;

// left middle right arrow
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *middleArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
// collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// datasource
@property (nonatomic,strong) NSMutableArray *secondClassificationLists;

// collectionView height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedHeightConstraint;

// delegate
@property (nonatomic,weak) id<CategoryNormalTableViewCellDelegate>delegate;



@end
