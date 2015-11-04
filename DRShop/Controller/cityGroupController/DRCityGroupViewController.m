//
//  DRCityGroupViewController.m
//  DRShop
//
//  Created by drouce on 15/10/10.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRCityGroupViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DRCityGroup.h"
#import "MJExtension.h"
#import "MJConst.h"
#import "UIView+AutoLayout.h"
#import "DRSearchResultController.h"
#import "DRConst.h"
#import "DRMetaTool.h"

@interface DRCityGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *cityGroup;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (nonatomic, strong) DRSearchResultController *searchResult;
@end

@implementation DRCityGroupViewController

-(DRSearchResultController *)searchResult {
    if (!_searchResult) {
        self.searchResult = [[DRSearchResultController alloc]init];
        [self addChildViewController:self.searchResult];
        
        [self.view addSubview:self.searchResult.view];
        
        //除了顶部，其他边约束都为0
        [self.searchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        //设置顶部约束
        [self.searchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];
    }
    return _searchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"切换城市";
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(closeClick) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    //加载城市数据
    self.cityGroup = [DRMetaTool cityGroups];
    
    //修改索引的文本颜色和背景颜色
    //self.cityTableView.sectionIndexColor = [UIColor blueColor];
    //self.cityTableView.sectionIndexBackgroundColor = [UIColor yellowColor];
    
    //设置搜索框cancle字体颜色
    self.searchBar.tintColor = MJColor(32, 191, 179);
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DRCityGroup *group = self.cityGroup[section];
    return group.cities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    DRCityGroup *group = self.cityGroup[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}


//系统自带的头部索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //使用KVC
    //找到self.cityGroup数组中的title属性，将它存到新的数组中返回回去
    return [self.cityGroup valueForKeyPath:@"title"];
}
//返回分组Head的文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DRCityGroup *group = self.cityGroup[section];
    return group.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DRCityGroup *group = self.cityGroup[indexPath.section];
    
    //发出通知
    [DRNotificationCenter postNotificationName:DRCityDidSelectNotification object:nil userInfo:@{DRSelectCity : group.cities[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma  mark - searchBar代理方法

//开始文本编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    //1. 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    //3. 显示右边取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //4.显示遮盖：显示一个半透明的uiview
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverButton.alpha = 0.5;
    }];
}

//结束文本编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //2.恢复搜索框图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    //3. 隐藏右边取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    //4.隐藏遮盖
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverButton.alpha = 0.0;
    }];
    
    //5.移除搜索结果
    self.searchResult.view.hidden = YES;
    searchBar.text = nil;
    
}

//取消按钮点击事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//文本发生变化时调用该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        [self.searchResult.view setHidden:NO];
        self.searchResult.searchText = searchText;
    } else {
        [self.searchResult.view setHidden:YES];
    }
}

//点击隐藏遮盖
- (IBAction)clickCover {
    [self.searchBar resignFirstResponder];
}

@end
