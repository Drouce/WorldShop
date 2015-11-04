
//
//  DSortViewController.m
//  DRShop
//
//  Created by drouce on 15/10/13.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DSortViewController.h"
#import "DRMetaTool.h"
#import "UIView+Extension.h"
#import "DRSort.h"
#import "DRConst.h"

@interface SortButton : UIButton
@property (nonatomic, strong) DRSort *sort;
@end

@implementation SortButton

/** 初始化button的frame */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置字体按钮颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //设置按钮背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];

    }
    return self;
}

-(void)setSort:(DRSort *)sort {
    _sort = sort;
    
    //设置按钮字体
    [self setTitle:sort.label forState:UIControlStateNormal];
    
}
@end

@interface DSortViewController ()

@end

@implementation DSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [DRMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 10;
    CGFloat btnStartY = 10;
    CGFloat btnMargin = 10;
    CGFloat height = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        
        SortButton *button = [[SortButton alloc]init];
        
        //传递模型
        button.sort = sorts[i];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        
        /*
        //设置字体按钮颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //设置按钮背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        //设置按钮字体
        [button setTitle:sort.label forState:UIControlStateNormal];
         */
 
        //添加按钮方法
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
        
    }
    
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(SortButton *)button {
    [DRNotificationCenter postNotificationName:DRSortDidChangeNotification object:nil userInfo:@{DRSelectSort : button.sort}];
}


@end
