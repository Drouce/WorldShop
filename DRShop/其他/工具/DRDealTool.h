//
//  DRDealTool.h
//  DRShop
//
//  Created by drouce on 15/10/30.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRDeal.h"
@interface DRDealTool : NSObject


/**
 *  返回第page页收藏团购数据：page从1开始
 */
+(NSArray *)collectDeals:(int)page;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(DRDeal *)deal;
/**
 *  移除一个收藏
 */
+ (void)removeCollectDeal:(DRDeal *)deal;
/** 判断是否被收藏 */
+ (BOOL)isCollected:(DRDeal *)deal;
/** 收藏的数量 */
+ (int)collectDealsCount;
@end
