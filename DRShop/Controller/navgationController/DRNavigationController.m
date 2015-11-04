//
//  DRNavigationController.m
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRNavigationController.h"
#import "DRConst.h"

@interface DRNavigationController ()

@end

@implementation DRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+(void)initialize {
    
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
}

@end
