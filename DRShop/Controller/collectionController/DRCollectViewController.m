//
//  DRCollectViewController.m
//  DRShop
//
//  Created by drouce on 15/10/20.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRCollectViewController.h"
#import "DRConst.h"
#import "UIBarButtonItem+Extension.h"
#import "DRConst.h"
#import "DRDealTool.h"
#import "MTDealCell.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "DRDetailsController.h"
#import "MJRefresh.h"

NSString *const MTDone = @"完成";
NSString *const MTEdit = @"编辑";
#define MTString(str) [NSString stringWithFormat:@"  %@  ", str]

@interface DRCollectViewController ()<MTDealCellDelegate>
@property (nonatomic, weak) UIImageView *noDataView;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;
@end

@implementation DRCollectViewController
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
        self.removeItem.enabled = NO;
    }
    return _removeItem;
}

- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

static NSString * const reuseIdentifier = @"dealCell";
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的团购";
    self.collectionView.backgroundColor = DRGlobalBg;
    
    // 左边的返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    // 加载第一页的收藏数据
    [self loadMoreDeals];
    
    // 监听收藏状态改变的通知
    [DRNotificationCenter addObserver:self selector:@selector(collectStateChange:) name:DRCollectStateDidChangeNotification object:nil];
    
    // 添加上啦加载
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    // 设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
}

#pragma mark - 右上角按钮编辑
/**
 *  编辑方法
 */
- (void)edit:(UIBarButtonItem *)item
{
    
    if ([item.title isEqualToString:MTEdit]) {
        item.title = MTDone;
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.removeItem];
        
        // 进入编辑状态
        for (DRDeal *deal in self.deals) {
            deal.editing = YES;
        }
    } else {
        item.title = MTEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        // 结束编辑状态
        for (DRDeal *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    // 刷新表格
    [self.collectionView reloadData];

}

/**
 *  全选
 */
- (void)selectAll
{
    for (DRDeal *deal in self.deals) {
        deal.checking = YES;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = YES;
}



/**
 *  全不选
 */
- (void)unselectAll
{
    for (DRDeal *deal in self.deals) {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}
/**
 *  删除
 */


- (void)remove
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (DRDeal *deal in self.deals) {
        if (deal.isChecking) {
            [DRDealTool removeCollectDeal:deal];
            
            [tempArray addObject:deal];
        }
    }
    
    // 删除所有打钩的模型
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

- (void)loadMoreDeals
{
    // 1.增加页码
    self.currentPage++;
    
    // 2.增加新数据
    [self.deals addObjectsFromArray:[DRDealTool collectDeals:self.currentPage]];
    
    // 3.刷新表格
    [self.collectionView reloadData];
    
    // 4.结束刷新
    [self.collectionView footerEndRefreshing];
}

- (void)collectStateChange:(NSNotification *)notification
{
    //    if ([notification.userInfo[MTIsCollectKey] boolValue]) {
    //        // 收藏成功
    //        [self.deals insertObject:notification.userInfo[MTCollectDealKey] atIndex:0];
    //    } else {
    //        // 取消收藏成功
    //        [self.deals removeObject:notification.userInfo[MTCollectDealKey]];
    //    }
    //
    //    [self.collectionView reloadData];
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    [self loadMoreDeals];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mrak - 实现协议方法
- (void)dealCellCheckingStateDidChange:(MTDealCell *)cell
{
    BOOL hasChecking = NO;
    for (DRDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
    
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.removeItem.enabled = hasChecking;
}


/**
 当屏幕旋转,控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // 设置每一行之间的间距
    layout.minimumLineSpacing = inset;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 计算一遍内边距
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // 控制尾部控件的显示和隐藏
    self.collectionView.footerHidden = (self.deals.count == [DRDealTool collectDealsCount]);
    
    // 控制"没有数据"的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DRDetailsController *detailVc = [[DRDetailsController alloc] init];
    detailVc.Ddeal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
