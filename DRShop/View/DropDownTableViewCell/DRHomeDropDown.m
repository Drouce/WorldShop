//
//  DRHomeDropDown.m
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRHomeDropDown.h"
#import "DRDropDownMainCell.h"
#import "DRDropDownSecondCell.h"

@interface DRHomeDropDown ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *secondTableView;
/** 左边主表选中的行数 */
@property (nonatomic, assign) NSInteger selectedMainRow;

@end

@implementation DRHomeDropDown

+(instancetype)dropDown {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"DRHomeDropDown" owner:nil options:nil]firstObject];
}

- (void)awakeFromNib {
    //防止跟随父视图的变化而变化
    self.autoresizingMask = UIViewAutoresizingNone;
}



#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return [self.dataSource numberofRowInMainTable:self];
    } else {
        return [self.dataSource homeDropDown:self subDataForRowInMainTable:self.selectedMainRow].count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.mainTableView) {
        
        cell = [DRDropDownMainCell cellWithTableView:tableView];
        
        //取出模型，显示文字
        //DRCategory *category = self.dropDownArray[indexPath.row];
        cell.textLabel.text = [self.dataSource homeDropDown:self titleForRowInMainTable:indexPath.row];
        if ([self.dataSource respondsToSelector:@selector(homeDropDown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropDown:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropDown:selectedIconForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropDown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        //设置辅助图标指示器
        NSArray *subData = [self.dataSource homeDropDown:self subDataForRowInMainTable:indexPath.row];
        if (subData.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else {
        
        cell = [DRDropDownSecondCell cellWithTableView:tableView];
        NSArray *subData = [self.dataSource homeDropDown:self subDataForRowInMainTable:self.selectedMainRow];
        cell.textLabel.text = subData[indexPath.row];
        
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //显示从表数据
        self.selectedMainRow = indexPath.row;
        [self.secondTableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(homeDropDown:didSelectedInMainTable:)]) {
            [self.delegate homeDropDown:self didSelectedInMainTable:indexPath.row];
        }
    }else {
        
        if ([self.delegate respondsToSelector:@selector(homeDropDown:didSelectedInsubTable:InMainTable:)]) {
            [self.delegate homeDropDown:self didSelectedInsubTable:indexPath.row InMainTable:self.selectedMainRow];
        }
    }
}

@end
