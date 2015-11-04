//
//  MTDealCell.m
//  黑团HD
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDealCell.h"
#import "DRDeal.h"
#import "UIImageView+WebCache.h"

@interface MTDealCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
/**
 属性名不能以new开头
 */
@property (weak, nonatomic) IBOutlet UIImageView *dealNewView;

@property (weak, nonatomic) IBOutlet UIButton *cover;

@property (weak, nonatomic) IBOutlet UIImageView *checkView;

@end

@implementation MTDealCell

/** 平铺与拉伸的第一种方法 */
-(void)awakeFromNib {
    
    //拉伸
    //[self setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]]];
    
    //平铺
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_dealcell"]];
}

- (void)setDeal:(DRDeal *)deal
{
    _deal = deal;
    self.titleLabel.text = deal.title;
    self.descLabel.text = deal.desc;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已购%d",deal.purchase_count];

    //现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",deal.current_price];
    NSUInteger dotLocation = [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (dotLocation != NSNotFound) {
        //超过两位小数,截掉
        if (self.currentPriceLabel.text.length - dotLocation > 3) {
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:dotLocation + 3];
        }
    }

    //原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
    
    //是否显示新单
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSString *nowstr = [formate stringFromDate:nowdate];
    //NSLog(@"%@,%@",deal.publish_date,nowstr);
    //隐藏时机：发布日期  < 今天日期
    self.dealNewView.hidden = ([deal.publish_date compare:nowstr] == NSOrderedAscending);
    
    // 根据模型属性来控制cover的显示和隐藏
    self.cover.hidden = !deal.isEditting;
    
    // 根据模型属性来控制打钩的显示和隐藏
    self.checkView.hidden = !deal.isChecking;

}


/** 平铺与拉伸的第二种方法 */
- (void)drawRect:(CGRect)rect {
    
    //拉伸
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
    
     //平铺
    //[[UIImage imageNamed:@"bg_dealcell"] drawAsPatternInRect:rect];
}

- (IBAction)coverClick:(UIButton *)sender {
    // 设置模型
    self.deal.checking = !self.deal.isChecking;
    // 直接修改状态
    self.checkView.hidden = !self.checkView.isHidden;
    
    if ([self.delegate respondsToSelector:@selector(dealCellCheckingStateDidChange:)]) {
        [self.delegate dealCellCheckingStateDidChange:self];
    }

}
@end
