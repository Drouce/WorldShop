//
//  DRHomeTopItem.m
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRHomeTopItem.h"

@interface DRHomeTopItem ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation DRHomeTopItem

/**
 * 加载xib视图
 */

+(instancetype)item {
    return [[[NSBundle mainBundle]loadNibNamed:@"DRHomeTopItem" owner:nil options:nil]firstObject];
}


/**
 * 不让左边的view进行拉伸
 */

-(void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}


/**
 *设置监听的方法
 */
- (void)addTarget:(id)target action:(SEL)action {
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setsubTitle:(NSString *)subTitle {
    self.subtitleLabel.text = subTitle;
}

- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon {
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [self.iconButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}


@end
