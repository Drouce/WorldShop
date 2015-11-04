//
//  DRRestriction.h
//  DRShop
//
//  Created by drouce on 15/10/28.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRRestriction : NSObject
/** 是否需要预约 */
@property (nonatomic, assign) int is_reservation;
/** 是否支持随时退款 */
@property (nonatomic, assign) int is_refundable;
/** 附加信息（一般为团购信息的特别提示） */
@property (nonatomic, copy) NSString *special_tips;

@end
