//
//  DRDropDownSecondCell.m
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRDropDownSecondCell.h"

@implementation DRDropDownSecondCell

/** 初始化方法：创建DRDropDownSecondCell */
+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *secondCell = @"main";
    DRDropDownSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCell];
    if (!cell) {
        cell = [[DRDropDownSecondCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:secondCell];
    }
    return cell;
}

#pragma mark - 初始化Secondcell的背景与选中的背景图片
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背景颜色与选中颜色
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    return self;
}

@end
