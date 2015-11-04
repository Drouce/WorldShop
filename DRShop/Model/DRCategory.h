//
//  DRCategory.h
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRCategory : NSObject

/** 类别的名称*/
@property (nonatomic, strong) NSString *name;

/** 子类别：里面都是字符串*/
@property (nonatomic, strong) NSArray *subcategories;

/** 显示在下拉菜单的小图标*/
@property (nonatomic, strong) NSString *small_highlighted_icon;
@property (nonatomic, strong) NSString *small_icon;

/** 显示在导航栏顶部的大图标*/
@property (nonatomic, strong) NSString *highlighted_icon;
@property (nonatomic, strong) NSString *icon;

/** 显示在地图上的图标*/
@property (nonatomic, strong) NSString *map_icon;

@end
