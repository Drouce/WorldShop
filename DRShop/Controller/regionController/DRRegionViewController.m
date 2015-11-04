//
//  DRRegionViewController.m
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRRegionViewController.h"
#import "DRHomeDropDown.h"
#import "UIView+Extension.h"
#import "DRCityGroupViewController.h"
#import "DRNavigationController.h"
#import "DRMetaTool.h"
#import "DRRegion.h"
#import "DRConst.h"


@interface DRRegionViewController ()<DRHomeDropDownDataSource,DRHomeDropDownDelegate>

@end

@implementation DRRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载分类数据
    
    UIView *title = [self.view.subviews firstObject];
    DRHomeDropDown *homedropDown = [DRHomeDropDown dropDown];
    homedropDown.y = title.height;
    homedropDown.dataSource = self;
    homedropDown.delegate = self;
    [self.view addSubview:homedropDown];

    //设置控制器view在popover中的尺寸
    self.preferredContentSize = CGSizeMake(homedropDown.width, CGRectGetMaxY(homedropDown.frame));
    
//    self.regions = [[DRRegion alloc]init];
   
}
- (IBAction)changeCity:(UIButton *)sender {
    
    [self.popover dismissPopoverAnimated:YES];
    DRCityGroupViewController *cityGroup = [[DRCityGroupViewController alloc]init];
    DRNavigationController *nav = [[DRNavigationController alloc]initWithRootViewController:cityGroup];
    //让nav模态风格呈表的形式展现出来
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - DRHomeDropDownDataSource 方法


- (NSInteger)numberofRowInMainTable:(DRHomeDropDown *)homeDrop {
    return self.regions.count;
}

- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop titleForRowInMainTable:(NSInteger)row {
    DRRegion *region = self.regions[row];
    return region.name;
}


- (NSArray *)homeDropDown:(DRHomeDropDown *)homeDrop subDataForRowInMainTable:(NSInteger)row {
    DRRegion *region = self.regions[row];
    return region.subregions;
    
}

#pragma mark - DRHomeDropDownDelegate 方法

- (void) homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInMainTable:(NSInteger)row {
    DRRegion *region = self.regions[row];
    
    //发出通知
    if (!region.subregions) {
        [DRNotificationCenter postNotificationName:DRRegionDidChangeNotification object:nil userInfo:@{DRSelectRegion : region}];
    }
    
}

- (void)homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInsubTable:(NSInteger)subRow InMainTable:(NSInteger)mainRow {
     DRRegion *region = self.regions[mainRow];
    [DRNotificationCenter postNotificationName:DRRegionDidChangeNotification object:nil userInfo:@{DRSelectRegion : region, DRSelectSubRegion : region.subregions[subRow]}];
    
}



@end
