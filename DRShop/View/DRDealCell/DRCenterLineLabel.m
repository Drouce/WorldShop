//
//  DRCenterLineLabel.m
//  DRShop
//
//  Created by Drouce on 15/10/15.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRCenterLineLabel.h"
#import "UIView+Extension.h"
@implementation DRCenterLineLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIRectFill(CGRectMake(0,7.5 , rect.size.width, 1));
}

@end
