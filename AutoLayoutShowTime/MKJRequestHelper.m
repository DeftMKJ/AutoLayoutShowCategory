//
//  MKJRequestHelper.m
//  AutoLayoutShowTime
//
//  Created by MKJING on 16/8/19.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJRequestHelper.h"
#import <MJExtension.h>
#import "CategoryModel.h"

@implementation MKJRequestHelper


static MKJRequestHelper *_requestHelper;

static id _requestHelp;

+ (instancetype)shareRequestHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [[self alloc] init];
    });
    return _requestHelp;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [super allocWithZone:zone];
    });
    return _requestHelp;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _requestHelp;
}

- (void)requestCategoryInfo:(requestHelperBlock)block
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"json"];
    NSString *categoryStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    NSArray *categoryArr = [categoryStr mj_JSONObject];
    // 直接给数组里面的字典进行模型赋值
    [CategoryInfomation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"categoryID":@"id",
                 @"categoryPic":@"pic",
                 @"categoryName":@"group",
                 @"secondClassificationLists":@"list"
                 };
    }];
    [CategoryInfomation mj_setupObjectClassInArray:^NSDictionary *{
        
        return @{@"secondClassificationLists":@"SecondCategoryInfomation"};
    }];
    // 子模型
    [SecondCategoryInfomation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"secondCategoryID":@"id",
                 @"secondCategoryName":@"name"
                 };
    }];
    // 通过数组加载数组模型，这里的类TWTBuyerMarket就是模型数组里面的小集合
    NSMutableArray *dataLists = [CategoryInfomation mj_objectArrayWithKeyValuesArray:categoryArr];
    
    // 把对应的每个分组的一级分组加入到二级分组里面去
    for (CategoryInfomation *category in dataLists)
    {
        NSMutableArray *secondLists = category.secondClassificationLists;
        SecondCategoryInfomation *secondNewModel = [[SecondCategoryInfomation alloc] init];
        secondNewModel.secondCategoryID = category.categoryID;
        secondNewModel.secondCategoryName = category.categoryName;
        [secondLists insertObject:secondNewModel atIndex:0];
    }
    
    if (block)
    {
        block(dataLists,nil);
    }

}

@end
