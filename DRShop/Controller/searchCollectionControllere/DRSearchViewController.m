//
//  DRSearchViewController.m
//  DRShop
//
//  Created by drouce on 15/10/20.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DRConst.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

@interface DRSearchViewController ()<UISearchBarDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;
@end

@implementation DRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边的方法
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    //中间的搜索框
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键字";
    searchBar.delegate = self;
    //设置搜索框cancle字体颜色
    searchBar.tintColor = DRColor(32, 191, 179);
    self.navigationItem.titleView = searchBar;

    self.searchBar = searchBar;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma  mark - searchBar代理方法

/**
 *  点击搜索
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.collectionView headerBeginRefreshing];
    [searchBar resignFirstResponder];
}

//文本发生变化时调用该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        [self.collectionView headerBeginRefreshing];
        
    } else {
//        searchBar.text = @"";
//        [self.collectionView headerBeginRefreshing];
        //[self viewDidLoad];
    }
}

#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params {
    params[@"city"] = self.cityName;
    params[@"keyword"] = self.searchBar.text;
}


@end
