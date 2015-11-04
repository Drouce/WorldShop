//
//  DRDeal.m
//  DRDeals
//
//  Created by Drouce on 15/9/24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "DRDeal.h"
#import "MJExtension.h"

@implementation DRDeal

MJCodingImplementation;
- (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}

- (BOOL)isEqual:(DRDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}


@end
