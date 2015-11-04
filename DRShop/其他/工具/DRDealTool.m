//
//  DRDealTool.m
//  DRShop
//
//  Created by drouce on 15/10/30.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRDealTool.h"
#import "FMDB.h"
#import "DRDeal.h"

@implementation DRDealTool

static FMDatabase *_db;
//数据库只需要初始化一次，在第一次类的时候初始化
+(void)initialize {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [path stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if ( ![_db open]) {
        return;
    }
    //2. 创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL)"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL)"];

}


+(NSArray *)collectDeals:(int)page {

    int size = 20;
    int pos = (page - 1)*20;
    //取数据用:executeQueryWithFormat
    FMResultSet *set = [_db executeQueryWithFormat:@"select *from t_collect_deal order by id desc limit %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        DRDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
    
}

+(void)addCollectDeal:(DRDeal *)deal {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"insert into t_collect_deal(deal,deal_id) values(%@,%@);",data,deal.deal_id];
}

+(void)removeCollectDeal:(DRDeal *)deal {
    [_db executeUpdateWithFormat:@"delete from t_collect_deal where deal_id = %@;",deal.deal_id];
}

+ (BOOL)isCollected:(DRDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount
{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}

@end
