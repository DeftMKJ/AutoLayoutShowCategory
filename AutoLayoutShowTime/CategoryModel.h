//
//  CategoryModel.h
//  AutoLayoutShowTime
//
//  Created by MKJING on 16/8/19.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfomation : NSObject

@property (nonatomic,copy) NSString *categoryID;
@property (nonatomic,copy) NSString *categoryPic;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,strong) NSMutableArray *secondClassificationLists; //!< 二级分类数组

// 一个关键的bool，检测是否需要打开二级分类 默认NO
@property (nonatomic,assign) BOOL needShowSecondClassification;

@end

@interface SecondCategoryInfomation : NSObject

@property (nonatomic,strong) NSString *secondCategoryID;
@property (nonatomic,strong) NSString *secondCategoryName;


@end
