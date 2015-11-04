//
//  DRMetaTool.h
//  DRShop
//
//  Created by drouce on 15/10/12.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRMetaTool : NSObject

/** 返回所有的城市 */
+ (NSArray *)cities;

/** 返回所有的分类数据 */
+ (NSArray *)categories;

/** 返回所有的排序数据 */
+ (NSArray *)sorts;

/** 返回城市数据 */
+ (NSArray *)cityGroups;

@end
