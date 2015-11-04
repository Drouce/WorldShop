//
//  DRDeal.h
//  DRDeals
//
//  Created by Drouce on 15/9/24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRRestriction.h"



@interface DRDeal : NSObject
/**团购单ID*/
@property (nonatomic, strong)NSString *deal_id;
/**团购标题*/
@property (nonatomic, strong)NSString *title;
/**团购描述*/
@property (nonatomic, strong)NSString *desc;
/**团购包含商品原价值*/
@property (nonatomic, strong)NSNumber *list_price;
/**团购价格*/
@property (nonatomic, strong)NSNumber *current_price;
/**团购当前已购买数*/
@property (nonatomic)int purchase_count;
/**团购图片链接*/
@property (nonatomic, strong)NSString *image_url;
/**小尺寸团购图片链接*/
@property (nonatomic, strong)NSString *s_image_url;
/**团购发布上线日期*/
@property (nonatomic, strong)NSString *publish_date;
/** 团购购买截止日期 */
@property (nonatomic, strong)NSString *purchase_deadline;
/** 详情页面链接 */
@property (nonatomic, strong)NSString *deal_h5_url;
@property (nonatomic, strong)NSString *deal_url;

/** 限制 */
@property (nonatomic, strong) DRRestriction *restrictions;

/** 是否正在编辑 */
@property (nonatomic, assign, getter=isEditting) BOOL editing;
/** 是否被勾选了 */
@property (nonatomic, assign, getter=isChecking) BOOL checking;
@end
