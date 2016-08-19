//
//  ViewController.m
//  AutoLayoutShowTime
//
//  Created by MKJING on 16/8/19.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "ViewController.h"
#import "MKJRequestHelper.h"
#import "CategoryModel.h"
#import "CategoryNormalTableViewCell.h"
#import <MJRefresh.h>
#import "UIView+Extension.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <UIImageView+WebCache.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController () <UITableViewDelegate,UITableViewDataSource,CategoryNormalTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *categoryLists;
@property (nonatomic,assign) BOOL isRefreshedData;
@property (nonatomic,assign) BOOL canDivisible;
@property (nonatomic,strong) CategoryInfomation *tempCategoryInfomation; // 临时存放
@property (nonatomic,strong) NSIndexPath *tempIndexpath;
@end

static NSString *normalIdentify = @"CategoryNormalTableViewCell";
static NSString *selectedIdentify = @"CatogoryPullDownTableViewCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.canDivisible = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:normalIdentify bundle:nil] forCellReuseIdentifier:normalIdentify];
    [self.tableView registerNib:[UINib nibWithNibName:selectedIdentify bundle:nil] forCellReuseIdentifier:selectedIdentify];
    
    // MJ
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 请求数据
- (void)refreshData
{
    self.tempIndexpath = nil;
    self.tempCategoryInfomation = nil;
    self.isRefreshedData = YES;
    __weak typeof(self)weakSelf = self;
    [[MKJRequestHelper shareRequestHelper] requestCategoryInfo:^(id obj, NSError *err) {
        
        weakSelf.categoryLists = ((NSMutableArray *)obj);
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - 点击图片的代理回调
- (void)clickImageViewCallBack:(CategoryNormalTableViewCell *)cell imageIndex:(NSInteger)idx
{
    // 获取到那个Indexpath
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    // 获取到数组里面的第几个
    NSInteger index = indexpath.row * 3 + idx;
    // 获取对象
    CategoryInfomation *category = self.categoryLists[index];
    // 修改字段
    // 点击同一个
    if (self.tempCategoryInfomation == category)
    {
        category.needShowSecondClassification = !category.needShowSecondClassification;
    }
    else
    {
        category.needShowSecondClassification = YES;
    }
    
    // 点击的每一次事件，都要让上一次存储的对象的需要展开变为NO
    if (self.tempCategoryInfomation)
    {
        // 如果是同一行的情况下
        if (indexpath.row  == self.tempIndexpath.row)
        {
            // 如果是同一个产品
            if (self.tempCategoryInfomation == category)
            {
                
                
            }
            else // 不同一个产品
            {
                self.tempCategoryInfomation.needShowSecondClassification = NO;
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.tempIndexpath = indexpath;
            self.tempCategoryInfomation = category;
            return;
            
        }
        else // 不是同一行的时候
        {
            self.tempCategoryInfomation.needShowSecondClassification = NO;
            [self.tableView reloadRowsAtIndexPaths:@[self.tempIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.tempIndexpath = indexpath;
    self.tempCategoryInfomation = category;
}



#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = self.canDivisible ? self.categoryLists.count / 3 : self.categoryLists.count / 3 + 1;
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryNormalTableViewCell *cell;
    // 能被整除，那么肯定都展示三个
    if (self.canDivisible)
    {
        CategoryInfomation *category = self.categoryLists[indexPath.row * 3 + 0];
        CategoryInfomation *category1 = self.categoryLists[indexPath.row * 3 + 1];
        CategoryInfomation *category2 = self.categoryLists[indexPath.row * 3 + 2];
        // 三个钟有一个是需要打开的，那么就加载选择状态下的cell
        if (category.needShowSecondClassification || category1.needShowSecondClassification || category2.needShowSecondClassification)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:selectedIdentify forIndexPath:indexPath];
            NSInteger selectedIndex;
            if (category.needShowSecondClassification)
            {
                selectedIndex = 0;
            }
            else if (category1.needShowSecondClassification)
            {
                selectedIndex = 1;
            }
            else
            {
                selectedIndex = 2;
            }
            cell = [self configSelectedCell:cell indexpath:indexPath selectedIndex:selectedIndex];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:normalIdentify forIndexPath:indexPath];
            cell = [self configNormalCell:cell indexpath:indexPath];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}


#pragma mark - 组装正常的cell
- (CategoryNormalTableViewCell *)configNormalCell:(CategoryNormalTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    cell.normalLeftView.hidden = NO;
    cell.normalRightView.hidden = NO;
    cell.normalMiddleView.hidden = NO;
    // 能被整除，那么肯定都展示三个
    if (self.canDivisible)
    {
        __weak typeof(cell)weakCell = cell;
        CategoryInfomation *category = self.categoryLists[indexpath.row * 3 + 0];
        CategoryInfomation *category1 = self.categoryLists[indexpath.row * 3 + 1];
        CategoryInfomation *category2 = self.categoryLists[indexpath.row * 3 + 2];
        [cell.normalLeftImageView sd_setImageWithURL:[NSURL URLWithString:category.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.normalLeftImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.normalLeftImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.normalLeftImageView.alpha = 1.0;
            }
            
        }];
        [cell.normalMiddleImageView sd_setImageWithURL:[NSURL URLWithString:category1.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.normalMiddleImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.normalMiddleImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.selectedMiddleImageView.alpha = 1.0;
            }
            
        }];
        [cell.normalRightImageView sd_setImageWithURL:[NSURL URLWithString:category2.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.normalRightImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.normalRightImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.normalRightImageView.alpha = 1.0;
            }
            
        }];
        
        cell.normalLeftlabel.text = category.categoryName;
        cell.normalMiddleLabel.text = category1.categoryName;
        cell.normalRightLabel.text = category2.categoryName;
        
    }
    return cell;
}

#pragma mark - 组装下拉的cell
// 参数1 本身cell
// 参数2 cell的indexptah
// 参数3 由于哪个图片触发了下拉
- (CategoryNormalTableViewCell *)configSelectedCell:(CategoryNormalTableViewCell *)cell indexpath:(NSIndexPath *)indexpath selectedIndex:(NSInteger)selectedIndex
{
    cell.leftArrow.hidden = NO;
    cell.middleArrow.hidden = NO;
    cell.rightArrow.hidden = NO;
    if (selectedIndex == 0)
    {
        cell.middleArrow.hidden = YES;
        cell.rightArrow.hidden = YES;
    }
    else if (selectedIndex == 1)
    {
        cell.leftArrow.hidden = YES;
        cell.rightArrow.hidden = YES;
    }
    else
    {
        cell.leftArrow.hidden = YES;
        cell.middleArrow.hidden = YES;
    }
    // 给CollectionView加载对应的数据  selectedIndex传的是具体的 0 1 2哪一个被点击了
    NSInteger idx = indexpath.row * 3 + selectedIndex;
    CategoryInfomation *category = self.categoryLists[idx];
    cell.secondClassificationLists = category.secondClassificationLists;
    cell.collectionView.width = SCREEN_WIDTH;
    [cell.collectionView reloadData];
    cell.selectedHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height > 200 ? 200 : cell.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    
    cell.selectedLeftView.hidden = NO;
    cell.selectedMiddleView.hidden = NO;
    cell.selectedRightView.hidden = NO;
    // 能被整除，那么肯定都展示三个
    if (self.canDivisible)
    {
        __weak typeof(cell)weakCell = cell;
        CategoryInfomation *category = self.categoryLists[indexpath.row * 3 + 0];
        CategoryInfomation *category1 = self.categoryLists[indexpath.row * 3 + 1];
        CategoryInfomation *category2 = self.categoryLists[indexpath.row * 3 + 2];
        [cell.selectedLeftImageView sd_setImageWithURL:[NSURL URLWithString:category.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.selectedLeftImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                   
                    weakCell.selectedLeftImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.selectedLeftImageView.alpha = 1.0;
            }
            
        }];
        [cell.selectedMiddleImageView sd_setImageWithURL:[NSURL URLWithString:category1.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.selectedMiddleImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.selectedMiddleImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.selectedMiddleImageView.alpha = 1.0;
            }
            
        }];
        [cell.selectedRightImageView sd_setImageWithURL:[NSURL URLWithString:category2.categoryPic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone)
            {
                weakCell.selectedRightImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.selectedRightImageView.alpha = 1.0;
                    
                }];
            }
            else
            {
                weakCell.selectedRightImageView.alpha = 1.0;
            }
            
        }];
        cell.selectedLeftLabel.text = category.categoryName;
        cell.selectedMiddleLabel.text = category1.categoryName;
        cell.selectedRightLabel.text = category2.categoryName;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat singleWidth = (SCREEN_WIDTH - 6) / 3;
    __weak typeof(self)weakSelf = self;
    // 能被整除，那么肯定都展示三个
    if (self.canDivisible)
    {
        CategoryInfomation *category = self.categoryLists[indexPath.row * 3 + 0];
        CategoryInfomation *category1 = self.categoryLists[indexPath.row * 3 + 1];
        CategoryInfomation *category2 = self.categoryLists[indexPath.row * 3 + 2];
        // 三个钟有一个是需要打开的，那么就加载选择状态下的cell
        if (category.needShowSecondClassification || category1.needShowSecondClassification || category2.needShowSecondClassification)
        {
            NSInteger selectedIndex;
            if (category.needShowSecondClassification)
            {
                selectedIndex = 0;
            }
            else if (category1.needShowSecondClassification)
            {
                selectedIndex = 1;
            }
            else
            {
                selectedIndex = 2;
            }
            return [tableView fd_heightForCellWithIdentifier:selectedIdentify cacheByIndexPath:indexPath configuration:^(CategoryNormalTableViewCell *cell)
                    {
                        [weakSelf configSelectedCell:cell indexpath:indexPath selectedIndex:selectedIndex];
                    }];
        }
        else
        {
            return 0.8 * singleWidth + 3;
            
        }
        
    }
    return 0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
