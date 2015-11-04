//
//  DRHomeDropDown.h
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRHomeDropDown;
@protocol DRHomeDropDownDataSource <NSObject>

/** 左边表格共有多少行 */
- (NSInteger)numberofRowInMainTable:(DRHomeDropDown *)homeDrop;
/** 左边表格每一行的标题 */
- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop titleForRowInMainTable:(NSInteger)row;
/** 左边表格每一行的数据 */
- (NSArray *)homeDropDown:(DRHomeDropDown *)homeDrop subDataForRowInMainTable:(NSInteger)row;

@optional

/** 左边表格每一行的图标 */
- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop iconForRowInMainTable:(NSInteger)row;
/** 左边表格每一行的选中图标 */
- (NSString *)homeDropDown:(DRHomeDropDown *)homeDrop selectedIconForRowInMainTable:(NSInteger)row;

@end


@protocol DRHomeDropDownDelegate <NSObject>

/** 选中主表的某一行 */
- (void)homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInMainTable:(NSInteger)row;

/** 主表对应的从表的某一行 */
- (void)homeDropDown:(DRHomeDropDown *)homeDrop didSelectedInsubTable:(NSInteger)subRow InMainTable:(NSInteger)mainRow;


@end

@interface DRHomeDropDown : UIView

@property (nonatomic, weak) id<DRHomeDropDownDataSource> dataSource;
@property (nonatomic, weak) id<DRHomeDropDownDelegate> delegate;
+ (instancetype)dropDown;

@end
