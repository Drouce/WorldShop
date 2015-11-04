//
//  DRDropDownMainCell.m
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRDropDownMainCell.h"

@implementation DRDropDownMainCell

/** 初始化方法：创建DRDropDownMainCell */
+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *mainCell = @"main";
    DRDropDownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCell];
    if (!cell) {
        cell = [[DRDropDownMainCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCell];
    }
    return cell;
}

#pragma mark - 初始化Maincell的背景与选中的背景图片
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背景与选中背景
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return self;
}

@end
