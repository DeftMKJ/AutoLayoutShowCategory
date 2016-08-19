//
//  MKJRequestHelper.h
//  AutoLayoutShowTime
//
//  Created by MKJING on 16/8/19.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestHelperBlock)(id obj,NSError *err);

@interface MKJRequestHelper : NSObject

+ (instancetype)shareRequestHelper;

- (void)requestCategoryInfo:(requestHelperBlock)block;

@end
