//
//  MTDealCell.h
//  黑团HD
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DRDeal, MTDealCell;

@protocol MTDealCellDelegate <NSObject>

@optional
- (void)dealCellCheckingStateDidChange:(MTDealCell *)cell;

@end


@interface MTDealCell : UICollectionViewCell
@property (nonatomic, strong) DRDeal *deal;

@property (nonatomic, weak) id<MTDealCellDelegate> delegate;
@end
