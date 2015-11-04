//
//  DRCity.m
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRCity.h"
#import "DRRegion.h"
#import "MJExtension.h"

@implementation DRCity

//@return 字典中的key是数组属性名，value是数组中存放模型的Class
- (NSDictionary *)objectClassInArray {
    return @{@"regions" : [DRRegion class]};
}
@end
