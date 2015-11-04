//
//  DRMetaTool.m
//  DRShop
//
//  Created by drouce on 15/10/12.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRMetaTool.h"
#import "DRCity.h"
#import "MJExtension.h"
#import "DRCategory.h"
#import "DRSort.h"
#import "DRCityGroup.h"

@implementation DRMetaTool

static NSArray *_cities;
+ (NSArray *)cities {
    if(!_cities) {
        _cities = [DRCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories {
    if(!_categories) {
        _categories = [DRCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts {
    if(!_sorts) {
        _sorts = [DRSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


static NSArray *_cityGroups;
+ (NSArray *)cityGroups {
    if(!_cityGroups) {
        _cityGroups = [DRCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

@end
