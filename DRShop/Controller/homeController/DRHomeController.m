//
//  DRHomeController.m
//  DRShop
//
//  Created by drouce on 15/10/9.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRHomeController.h"
#import "DRConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "DRHomeTopItem.h"
#import "DRCategoryViewController.h"
#import "DRRegionViewController.h"
#import "DRCity.h"
#import "DRMetaTool.h"
#import "DSortViewController.h"
#import "DRSort.h"
#import "DRCategory.h"
#import "DRRegion.h"
#import "DRSearchViewController.h"
#import "DRNavigationController.h"
#import "MJRefresh.h"
#import "AwesomeMenu.h"
#import "UIView+AutoLayout.h"
#import "DRCollectViewController.h"
#import "DRHistoryViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface DRHomeController ()<AwesomeMenuDelegate>

@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@property (nonatomic, weak) UIBarButtonItem *regionItem;
@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, copy) NSString *selectedCityName;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, copy) NSString *selectedRegionName;
@property (nonatomic, strong) DRSort *selectedSort;

@property (nonatomic, strong) UIPopoverController *categoryPopover;
@property (nonatomic, strong) UIPopoverController *regionPopover;
@property (nonatomic, strong) UIPopoverController *sortPopover;

@end

@implementation DRHomeController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNotification];
    
    //设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    //创建awesomeMenu
    [self setupAwesomeMenu];
}

-(void)dealloc {
    [DRNotificationCenter removeObserver:self];
}

- (void)setupNotification {
    
    //监听city
    [DRNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:DRCityDidSelectNotification object:nil];
    //监听sort
    [DRNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:DRSortDidChangeNotification object:nil];
    //监听category
    [DRNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:DRCategoryDidChangeNotification object:nil];
    //监听region
    [DRNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:DRRegionDidChangeNotification object:nil];

}


- (void)setupAwesomeMenu {
    
    //设置起始的item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
    //设置周边的item
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];

    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];

    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0,item1,item2,item3];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc]initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    //设置菜单的活动角度
    menu.menuWholeAngle = M_PI_2;
    menu.alpha = 0.2;
    menu.delegate = self;
    
    menu.rotateAddButton = NO;
    //设置菜单的初始化位置
    menu.startPoint = CGPointMake(50, 150);
    [self.view addSubview:menu];
    
    //设置菜单在视图的左下角
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}


#pragma mark - AweSomeMenu代理方法

-(void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu {
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    [UIView animateWithDuration:menu.animationDuration animations:^{
        menu.alpha = 1.0;
    }];
}


- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu {
    
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    [UIView animateWithDuration:menu.animationDuration animations:^{
        menu.alpha = 0.2;
    }];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
   menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    
    switch (idx) {
        case 1: {//收藏
                DRNavigationController *nav = [[DRNavigationController alloc]initWithRootViewController:[[DRCollectViewController alloc]init]];
                [self presentViewController:nav animated:YES completion:nil];
            }
            
            break;
            
        case 2:{//历史记录
            DRNavigationController *nav = [[DRNavigationController alloc]initWithRootViewController:[[DRHistoryViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - 监听通知
- (void)cityDidChange:(NSNotification *)notification {
    self.selectedCityName = notification.userInfo[DRSelectCity];
    
    //更换区域顶部item的文字
    DRHomeTopItem *topItem = (DRHomeTopItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部",self.selectedCityName]];
    [topItem setsubTitle:nil];
    
    //2. 刷新数据
    [self.collectionView headerBeginRefreshing];
}

- (void)sortDidChange:(NSNotification *)notification {
    
    //1. 跟换顶部item的文字
    self.selectedSort = notification.userInfo[DRSelectSort];
    
    DRHomeTopItem *topItem = (DRHomeTopItem *)self.sortItem.customView;
    [topItem setsubTitle:self.selectedSort.label];
    
    //2. 关闭popover
    [self.sortPopover dismissPopoverAnimated:YES];
    
    //3. 刷新数据
    [self.collectionView headerBeginRefreshing];
    
    
}

- (void)categoryDidChange:(NSNotification *)notification {
    

    DRCategory *category = notification.userInfo[DRSelectCategory];
    NSString *subCategory = notification.userInfo[DRSelectSubCategory];
    
    if (!category.subcategories || [subCategory isEqualToString:@"全部"]) {
        self.selectedCategoryName = category.name;
    } else {
        
        self.selectedCategoryName = subCategory;
    }
    if ([category.name isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    //1. 跟换顶部item的文字
    DRHomeTopItem *topItem = (DRHomeTopItem *)self.categoryItem.customView;
    [topItem setTitle:category.name];
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setsubTitle:subCategory];
    
    //2. 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    //3. 刷新数据
    [self.collectionView headerBeginRefreshing];
}

- (void)regionDidChange:(NSNotification *)notification {
    
    
    DRRegion *region = notification.userInfo[DRSelectRegion];
    NSString *subRegion = notification.userInfo[DRSelectSubRegion];
    //1. 跟换顶部item的文字
    DRHomeTopItem *topItem = (DRHomeTopItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name]];
    [topItem setsubTitle:subRegion];
    
    
    if (!region.subregions || [subRegion isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    } else {
        
        self.selectedRegionName = subRegion;
    }
    if ([region.name isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    //2. 关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    //3. 刷新数据
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params {
    
        //城市
        params[@"city"] = self.selectedCityName;
    
        //分类
        if (self.selectedCategoryName) {
            params[@"category"] = self.selectedCategoryName;
        }
    
        //排序
        if (self.selectedSort.value) {
            params[@"sort"] = @(self.selectedSort.value);
        }
    
    
        //区域
        if (self.selectedRegionName) {
            params[@"region"] = self.selectedRegionName;
        }
    

}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav {
    
    //1. LOGO
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    logoItem.enabled = NO;
    
    //2. 类别
    DRHomeTopItem *category = [DRHomeTopItem item];
    UIBarButtonItem *categoryItem= [[UIBarButtonItem alloc]initWithCustomView:category];
    self.categoryItem = categoryItem;
    [category addTarget:self action:@selector(categoryClick)];
    
    //3. 地区
    DRHomeTopItem *region = [DRHomeTopItem item];
    UIBarButtonItem *regionItem= [[UIBarButtonItem alloc]initWithCustomView:region];
    self.regionItem = regionItem;
    [region addTarget:self action:@selector(regionClick)];
    
    //4. 排序
    DRHomeTopItem *sort = [DRHomeTopItem item];
    UIBarButtonItem *sortItem= [[UIBarButtonItem alloc]initWithCustomView:sort];
    [sort setTitle:@"排序"];
    [sort setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    self.sortItem = sortItem;
    
    
    [sort addTarget:self action:@selector(sortClick)];
    
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,regionItem,sortItem];
}

- (void)setupRightNav {
    
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(mapClick) image:@"icon_map" highImage:@"icon_map_highlighted"];
    //控制两张图片之间的间距
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClick) image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}

- (void)mapClick {
    
}

- (void)searchClick {
    
    if (self.selectedCityName) {
        DRSearchViewController *searchVC = [[DRSearchViewController alloc]init];
        searchVC.cityName = self.selectedCityName;
        DRNavigationController *nav = [[DRNavigationController alloc]initWithRootViewController:searchVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        [MBProgressHUD showError:@"请选择城市后在搜索" toView:self.view];
    }
    
    
}



#pragma mark - 设置顶部图标按钮的方法
- (void)categoryClick {
    
    //显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc]initWithContentViewController:[[DRCategoryViewController alloc]init]];
    self.categoryPopover.backgroundColor = [UIColor whiteColor];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)regionClick {
   
    DRRegionViewController *region = [[DRRegionViewController alloc]init];
    if (self.selectedCityName) {
        
        DRCity *city = [[[DRMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]]firstObject];
        region.regions = city.regions;
    }
    
    //显示区域菜单
     self.regionPopover = [[UIPopoverController alloc]initWithContentViewController:region];
    self.regionPopover.backgroundColor = [UIColor whiteColor];
    [self.regionPopover presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    region.popover = self.regionPopover;

    
}

- (void)sortClick {
   
     self.sortPopover = [[UIPopoverController alloc]initWithContentViewController:[[DSortViewController alloc]init]];
    self.sortPopover.backgroundColor = [UIColor whiteColor];
    [self.sortPopover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


@end
