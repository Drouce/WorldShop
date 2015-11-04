//
//  DRCity.h
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRCity : NSObject

/** 城市名字 */
@property (nonatomic, strong) NSString *name;
/** 城市名字的拼音 */
@property (nonatomic, strong) NSString *pinYin;
/** 城市名字拼音的声母 */
@property (nonatomic, strong) NSString *pinYinHead;
/** 区域 */
@property (nonatomic, strong) NSArray *regions;

@end
