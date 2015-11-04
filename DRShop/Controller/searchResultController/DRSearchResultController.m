//
//  DRSearchResultController.m
//  DRShop
//
//  Created by drouce on 15/10/12.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRSearchResultController.h"
#import "DRMetaTool.h"
#import "DRCity.h"
#import "DRConst.h"

@interface DRSearchResultController ()
@property (nonatomic ,strong) NSArray *resultCities;

@end

@implementation DRSearchResultController

-(void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    
    //根据关键字搜索想要的城市的数据
    searchText = searchText.lowercaseString;
    
    //NSPredicate :过滤器，能从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.resultCities = [[DRMetaTool cities] filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


#pragma mark - 数据源方法


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"citiesID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    DRCity *cities = self.resultCities[indexPath.row];
    cell.textLabel.text = cities.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"共有%ld个结果",self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DRCity *city = self.resultCities[indexPath.row];
    //发出通知
    [DRNotificationCenter postNotificationName:DRCityDidSelectNotification object:nil userInfo:@{DRSelectCity : city.name}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
