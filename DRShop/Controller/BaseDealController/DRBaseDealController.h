//
//  DRBaseDealController.h
//  DRShop
//
//  Created by drouce on 15/10/20.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRBaseDealController : UICollectionViewController
/**
 *  设置请求参数：交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;

@end
