//
//  DRDetailsController.m
//  DRShop
//
//  Created by drouce on 15/10/22.
//  Copyright © 2015年 drouce. All rights reserved.
//

#import "DRDetailsController.h"
#import "DRDeal.h"
#import "DRConst.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "DRRestriction.h"
#import "DRDealTool.h"

@interface DRDetailsController ()<UIWebViewDelegate,DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/**
 *  不能使用loadView，是关键字,是一个方法，会导致报错，view的属性不能用
 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSString *beginURL;
@property (nonatomic, strong) NSString *detailURL;
@property (weak, nonatomic) IBOutlet UIImageView *imageContain;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
/** 购买截止日期 */
@property (weak, nonatomic) IBOutlet UIButton *purchaseDeadLine;

/** 已售数量 */
@property (weak, nonatomic) IBOutlet UIButton *purchaseCount;
/** 收藏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
/** 随时退款按钮 */
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTime;
/** 过期退款按钮 */
@property (weak, nonatomic) IBOutlet UIButton *refundableExpire;


@end

@implementation DRDetailsController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DRColor(236, 236, 236);
    NSString *ID = [self.Ddeal.deal_id substringFromIndex:[self.Ddeal.deal_id rangeOfString:@"-"].location + 1];
    self.beginURL = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/%@",ID];
    self.detailURL = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Ddeal.deal_h5_url]]];
    [self.imageContain sd_setImageWithURL:[NSURL URLWithString:self.Ddeal.image_url]];
    self.titleLabel.text = self.Ddeal.title;
    self.descLabel.text = self.Ddeal.desc;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.Ddeal.current_price];
    self.listPriceLabel.text = [NSString stringWithFormat:@"原价￥%@",self.Ddeal.list_price];
    [self.purchaseCount setTitle:[NSString stringWithFormat:@"已售数量 %d",self.Ddeal.purchase_count] forState:UIControlStateNormal];
    
    //设置剩余多少天
    NSDate *today = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-yy";
    NSDate *dead = [formate dateFromString:self.Ddeal.purchase_deadline];
    //追加一天
    [dead dateByAddingTimeInterval:24 *3600];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmp = [[NSCalendar currentCalendar] components:unit fromDate:today toDate:dead options:0];
    if (cmp.day > 365) {
        
        [self.purchaseDeadLine setTitle:@"一年内不会过期" forState:UIControlStateNormal];
    } else if (cmp.day < 0){
        [self.purchaseDeadLine setTitle:@"已过期" forState:UIControlStateNormal];
    } else {
        [self.purchaseDeadLine setTitle:[NSString stringWithFormat:@"剩余%ld天%ld小时%ld分",cmp.day,cmp.hour,cmp.minute] forState:UIControlStateNormal];
    }
    
    
    //发送请求ihuode更详细的团购数据
    DPAPI *api = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //页码
    params[@"deal_id"] = self.Ddeal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    //设置收藏状态
    self.collectionButton.selected = [DRDealTool isCollected:self.Ddeal];
}

#pragma DPRequestDelegate 协议方法
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
    //NSLog(@"%@",self.Ddeal.restriction);
    //设置退款信息
    self.Ddeal = [DRDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    self.refundableAnyTime.selected = self.Ddeal.restrictions.is_refundable;
    self.refundableExpire.selected = self.Ddeal.restrictions.is_refundable;
}

-(void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    [MBProgressHUD showError:@"网络繁忙，请稍后再试" toView:self.view];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置横竖屏支持的方向
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;

}

#pragma mark - UIWebViewDelegate 代理方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    if ([webView.request.URL.absoluteString isEqualToString:self.beginURL]) {
    
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailURL]]];
        } else {
            
            
            //用来拼接所有的js
            NSMutableString *js = [NSMutableString string];
            //删除头部返回
            [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
            [js appendString:@"header.parentNode.removeChild(header);"];
            
            //删除头部购买
            [js appendString: @"var box = document.getElementsByClassName('cost-box')[0];"];
            [js appendString:@"box.parentNode.removeChild(box);"];
            
            //删除底部购买
            [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
            [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
            //利用webView执行JS
            [webView stringByEvaluatingJavaScriptFromString:js];
            
            webView.hidden = NO;
            //隐藏loadingView
            [self.loadingView stopAnimating];
            
        }

}

- (IBAction)BuyNow:(id)sender {
}

- (IBAction)collect:(id)sender {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[DRCollectDealKey] = self.Ddeal;
    
    if (self.collectionButton.isSelected) { // 取消收藏
        [DRDealTool removeCollectDeal:self.Ddeal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        
        info[DRIsCollectKey] = @NO;
    } else { // 收藏
        [DRDealTool addCollectDeal:self.Ddeal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        
        info[DRIsCollectKey] = @YES;
    }
    
    // 按钮的选中取反
    self.collectionButton.selected = !self.collectionButton.isSelected;
    
    // 发出通知
    [DRNotificationCenter postNotificationName:DRCollectStateDidChangeNotification object:nil userInfo:info];

}

- (IBAction)share:(id)sender {
}


@end
