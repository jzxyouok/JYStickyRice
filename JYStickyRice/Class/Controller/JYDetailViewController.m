//
//  JYDetailViewController.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/22.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYDetailViewController.h"
#import "JYDetail.h"

@interface JYDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSNumber *dealId;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *detailDescription;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UIWebView *consumerTips;
@property (weak, nonatomic) IBOutlet UIWebView *buyDetails;

@end

@implementation JYDetailViewController

- (instancetype)initWithDealId:(NSNumber *)dealId {
    if(self = [super init]){
        _dealId = dealId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detailRequest];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    for (UIView *view in bar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            [view removeFromSuperview];
        }
    }
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 2, 28, 28)];
    [left setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftButton];
    [bar pushNavigationItem:item animated:NO];
    [self.view addSubview:bar];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
    NSString *httpArg = [NSString stringWithFormat:@"deal_id=%@",_dealId];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%d", error.localizedDescription, error.code);
                               } else {
                                   //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *detailDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   self.detailDic = [NSDictionary dictionaryWithDictionary:detailDicWithNSJSON[@"deal"]];
                                   //NSLog(@"%@",_detailDic);
                                   [self setDetailData];
                               }
                           }];
}

- (void)setDetailData {
    JYDetail *detail = [[JYDetail alloc]initWithDict:_detailDic];
    
    NSURL *url=[NSURL URLWithString:detail.image];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    self.image.image = image;
    self.detailTitle.text = detail.title;
    self.saleNum.text = [NSString stringWithFormat:@"已售%@",detail.sale_num];
    self.detailDescription.text = detail.long_title;
    int currentPrice = [detail.current_price intValue]/100;
    self.currentPrice.text = [NSString stringWithFormat:@"￥%d",currentPrice];
    int marketPrice = [detail.market_price intValue]/100;
    self.marketPrice.text = [NSString stringWithFormat:@"团购价%d市场价",marketPrice];
    [self.consumerTips loadHTMLString:detail.consumer_tips baseURL:nil];
    [self.buyDetails loadHTMLString:detail.buy_details baseURL:nil];
    self.consumerTips.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
