//
//  DRSort.h
//  DRShop
//
//  Created by drouce on 15/10/13.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRSort : NSObject

/** 排序名称 */
@property (nonatomic, strong) NSString *label;

/** 排序的值 */
@property (nonatomic, assign) NSInteger value;
@end
