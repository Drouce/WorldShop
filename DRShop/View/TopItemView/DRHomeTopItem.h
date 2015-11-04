//
//  DRHomeTopItem.h
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRHomeTopItem : UIView


+(instancetype)item;

- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitle:(NSString *)title;

- (void)setsubTitle:(NSString *)subTitle;

- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
@end
