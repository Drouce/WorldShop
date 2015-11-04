//
//  DRCategoryViewController.m
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRCategoryViewController.h"
#import "DRHomeDropDown.h"
#import "DRCategory.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "DRMetaTool.h"
#import "DRConst.h"


@interface DRCategoryViewController ()<DRHomeDropDownDataSource,DRHomeDropDownDelegate>

@end

@implementation DRCategoryViewController


-(void)loadView {
    DRHomeDropDown *dropDown = [DRHomeDropDown dropDown];
    dropDown.dataSource = self;
    dropDown.delegate = self;
    self.view = dropDown;
    
    //设置控制器view在popover中的尺寸
    self.preferredContentSize = dropDown.size;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - DRHomeDropDownDataSource 方法


- (NSInteger)numberofRowInMainTable:(DRHomeDropDown *)homeDrop {
    return [DRMetaTool categories].count;
}

- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop titleForRowInMainTable:(NSInteger)row {
    DRCategory *category = [DRMetaTool categories][row];
    return category.name;
}

- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop iconForRowInMainTable:(NSInteger)row {
    DRCategory *category = [DRMetaTool categories][row];
    return category.small_icon;

}

- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop selectedIconForRowInMainTable:(NSInteger)row {
    DRCategory *category = [DRMetaTool categories][row];
    return category.small_highlighted_icon;

}

- (NSArray *)homeDropDown:(DRHomeDropDown *)homeDrop subDataForRowInMainTable:(NSInteger)row {
    DRCategory *category = [DRMetaTool categories][row];
    return category.subcategories;

}

#pragma mark - DRHomeDropDownDelegate 方法

- (void) homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInMainTable:(NSInteger)row {
    DRCategory *category = [DRMetaTool categories][row];
    
    //发出通知
    if (!category.subcategories) {
        [DRNotificationCenter postNotificationName:DRCategoryDidChangeNotification object:nil userInfo:@{DRSelectCategory : category}];
    }
    
}

- (void)homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInsubTable:(NSInteger)subRow InMainTable:(NSInteger)mainRow {
    DRCategory *category = [DRMetaTool categories][mainRow];
    [DRNotificationCenter postNotificationName:DRCategoryDidChangeNotification object:nil userInfo:@{DRSelectCategory : category, DRSelectSubCategory : category.subcategories[subRow]}];

}

@end
