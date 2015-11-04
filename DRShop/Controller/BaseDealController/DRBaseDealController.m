//
//  DRBaseDealController.m
//  DRShop
//
//  Created by drouce on 15/10/20.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRBaseDealController.h"
#import "MJRefresh.h"
#import "DPAPI.h"
#import "DRDeal.h"
#import "MTDealCell.h"
#import "DRConst.h"
#import "UIView+AutoLayout.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
#import "DRDetailsController.h"

@interface DRBaseDealController ()<DPRequestDelegate,UICollectionViewDelegate>

/** 所有的团购数据 */
@property (nonatomic, strong)NSMutableArray *deals;

/** 记录当前的页码 */
@property (nonatomic)int page;
/** 记录总数 */
@property (nonatomic, assign) int totalCount;
/** 记录最后一个请求 */
@property (nonatomic, weak)DPRequest *lastRequest;
/** 没有数据时显示的图片 */
@property (nonatomic, strong) UIImageView *noDataView;

@end

@implementation DRBaseDealController

/**
 *  懒加载方法
 */


-(NSMutableArray *)deals {
    if (!_deals) {
        _deals = [[NSMutableArray alloc]init];
    }
    return _deals;
}

-(UIImageView *)noDataView {
    if (!_noDataView) {
        //添加一个”没有数据“的提醒
        self.noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        
        [self.view addSubview:self.noDataView];
        //位于父视图的中央
        [self.noDataView autoCenterInSuperview];
    }
    return _noDataView;
}

#pragma mark - 初始化和设置collection的size
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置collectioncell的大小
    layout.itemSize = CGSizeMake(305, 305);
    
    return [self initWithCollectionViewLayout:layout];
}


//随着大小发生变化，间距发生变化
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    //根据屏幕的宽度计算列数
    int cols = (size.width == 1024) ? 3 : 2;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    //设置每一行的间距
    layout.minimumLineSpacing = inset;
    
}


static NSString * const reuseIdentifier = @"dealCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = DRGlobalBg;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];

}


#pragma mark - 跟服务器交互


- (void)loadDeals {
    DPAPI *api = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //调用子类实现的方法
    [self setupParams:params];

    //每页的条数
    params[@"limit"] = @5;
    params[@"page"] = @(self.page);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    
    //NSLog(@"请求的参数：%@",params);
}
- (void)loadMoreDeals {
    self.page ++;
    [self loadDeals];
}

- (void)loadNewDeals {
    
    self.page = 1;
    [self loadDeals];
    
}

/**
 *  请求成功后调用
 */
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
    //判断是否是最后一个request
    if (request != self.lastRequest) {
        return;
    }
    
    self.totalCount = [result[@"total_count"] intValue];
    //1. 取出团购字典数组
    NSArray *newdeals = [DRDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.page == 1) {//说明正在加载第一个请求
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newdeals];
    //刷新表格
    [self.collectionView reloadData];
    //NSLog(@"--%@",result);
    
    //结束刷新
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
    
    
}

/**
 *  请求失败后调用
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    
    if (request != self.lastRequest) {
        return;
    }
    //1. 提醒失败
    [MBProgressHUD showError:@"网络繁忙，请稍后再试" toView:self.view];
    //2. 结束刷新
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
    
    //3. 上拉加载失败了
    if (self.page > 1) {
        self.page--;
    }
}



#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //刷新成功肯定运行
    //计算一遍内边距
    
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    //控制尾部刷新控件的显示和隐藏
    self.collectionView.footerHidden = (self.totalCount == self.deals.count);
    self.collectionView.headerHidden = (self.totalCount == self.deals.count);
    
    //控制”没有数据“的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    
    //NSLog(@"%ld",self.deals.count);
    return self.deals.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}


#pragma mark - UIColeectionDelegate方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DRDetailViewController *detailVc = [[DRDetailViewController alloc]initWithNibName:@"DRDetailViewController" bundle:nil];
//    //DRDetailViewController *detailVc = [[DRDetailViewController alloc]init];
//    detailVc.deal = self.deals[indexPath.row];
    DRDetailsController *detail = [[DRDetailsController alloc]init];
    detail.Ddeal = self.deals[indexPath.item];
    [self presentViewController:detail animated:YES
                     completion:nil];
}
@end