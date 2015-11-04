//
//  DRRegion.h
//  DRShop
//
//  Created by drouce on 15/10/12.
//  Copyright © 2015年 drouce. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DRRegion : NSObject

/** 城市名字 */
@property (nonatomic, copy) NSString *name;

/** 城市的子区域 */
@property (nonatomic, strong) NSArray *subregions;

@end
