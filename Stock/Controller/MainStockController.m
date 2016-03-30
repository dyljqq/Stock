//
//  MainStockController.m
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MainStockController.h"
#import "KLineModel.h"
#import "MainStockView.h"
#import "HandicapModel.h"
#import "SharingPlansModel.h"
#import "MainStockSearchController.h"
#import "StockDataModel.h"

#define KLINE_URL_PREFIX @"http://img1.money.126.net/data/hs/kline/day/history/2016/"
#define SHARING_PLANS_URL_PREFIX @"http://img1.money.126.net/data/hs/time/today/"
#define HANDICAP_URL_PREFIX @"http://hq.sinajs.cn/list="

@interface MainStockController ()<MainStockViewDelegate, MainStockSearchControllerDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *TradingDayTimer;

@end

@implementation MainStockController{
    MainStockView* stockView;
    UIButton* alterStockButton;
    NSString* kLineUrl;
    NSString* sharingPlansUrl;
    NSString* handicapUrl;
    NSString* fullStock;
    KLineModel* kModel;
    NSString* suffix;
    NSString* stockCode;
    NSString* stockName;
}

- (id)init {
    self = [super init];
    if (self) {        
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    stockView = [[MainStockView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height - 64)];
    stockView.delegate = self;
    [self.view addSubview:stockView];
    
    if([StockDataModel allStocks]){
        [self getStock:[StockDataModel lastStock]];
    }else{
        fullStock = @"sh600725";
        stockName = @"云维股份";
        stockCode = @"600725";
        kModel = [KLineModel new];
        kLineUrl = @"http://img1.money.126.net/data/hs/kline/day/history/2016/0600725.json";
        sharingPlansUrl = @"http://img1.money.126.net/data/hs/time/today/0600725.json";
        handicapUrl = @"http://hq.sinajs.cn/list=sh600725";
        [self getData];
    }
    [self createNavi];
}

- (void)createNavi{
    alterStockButton = [[UIButton alloc] initWithFrame:CGRectMake(APPLICATION_SIZE.width - 15 - 100, 26.5, 100, 31)];
    [alterStockButton setTitle:@"更换股票" forState:UIControlStateNormal];
    [alterStockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    alterStockButton.titleLabel.font = Font(16);
//    alterStockButton.backgroundColor = RGBA(232, 83, 110, 0.36);
    alterStockButton.layer.cornerRadius = 3;
    alterStockButton.layer.masksToBounds = YES;
    alterStockButton.layer.borderColor = [UIColor whiteColor].CGColor;
    alterStockButton.layer.borderWidth = 0.5;
    [alterStockButton setImage:[UIImage imageNamed:@"iconfont_ss"] forState:UIControlStateNormal];
    [alterStockButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [alterStockButton addTarget:self action:@selector(alterStockAction) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithCustomView:alterStockButton];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma Delegate

- (void)getStock:(NSArray *)stocks{
    stockName = stocks[4];
    NSString* s = [NSString stringWithFormat:@"%@", stocks[3]];
    fullStock = s;
    suffix = @"sh";
    int sh = 0;
    if([s containsString:@"sz"]){
        sh = 1;
        suffix = @"sz";
    }
    stockCode = [NSString stringWithFormat:@"%@", stocks[2]];
    kLineUrl = [NSString stringWithFormat:@"%@%d%@.json", KLINE_URL_PREFIX, sh, stocks[2]];
    sharingPlansUrl = [NSString stringWithFormat:@"%@%d%@.json", SHARING_PLANS_URL_PREFIX, sh, stocks[2]];
    handicapUrl = [NSString stringWithFormat:@"%@%@", HANDICAP_URL_PREFIX, stocks[3]];
    [self getData];
}

#pragma Action

- (void)alterStockAction{
    MainStockSearchController* searchController = [MainStockSearchController new];
    searchController.delegate = self;
    [self.navigationController pushViewController:searchController animated:YES];
}

#pragma Private Method

- (void)getData{
    KLineModel* kLineModel = [KLineModel new];
    [kLineModel getKLineRequest:kLineUrl callback:^{
        kModel = kLineModel;
        [stockView updateView:kLineModel];
        self.title = [NSString stringWithFormat:@"%@(%@)", stockName, stockCode];
    }];
    
    /**
     0：”大秦铁路”，股票名字；
     1：”27.55″，今日开盘价；
     2：”27.25″，昨日收盘价；
     3：”26.91″，当前价格；
     4：”27.55″，今日最高价；
     5：”26.20″，今日最低价；
     6：”26.91″，竞买价，即“买一”报价；
     7：”26.92″，竞卖价，即“卖一”报价；
     8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
     9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
     10：”4695″，“买一”申请4695股，即47手；
     11：”26.91″，“买一”报价；
     12：”57590″，“买二”
     13：”26.90″，“买二”
     14：”14700″，“买三”
     15：”26.89″，“买三”
     16：”14300″，“买四”
     17：”26.88″，“买四”
     18：”15100″，“买五”
     19：”26.87″，“买五”
     20：”3100″，“卖一”申报3100股，即31手；
     21：”26.92″，“卖一”报价
     (22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖五的情况”
     30：”2008-01-11″，日期；
     31：”15:05:32″，时间；
     **/
    [HandicapModel getHandicapRequest:handicapUrl callback:^(NSArray* array){
        if([array count] <= 1){
            NSLog(@"该股票已退市");
            [stockView updateStockView:nil colors:nil];
            return ;
        }
        int index = 0;
        NSMutableArray* contents = [NSMutableArray array];
        NSMutableArray* colors = [NSMutableArray array];
        while (index < 10) {
            NSMutableArray* arr = [NSMutableArray array];
            [arr addObject:[NSString stringWithFormat:@"卖%d", (10 - index)/2]];
            CGFloat f = [[NSString stringWithFormat:@"%@", array[29 - index]] floatValue];
            [arr addObject:[NSString stringWithFormat:@"%.2f", f]];
            CGFloat f1 = [[NSString stringWithFormat:@"%@", array[29 - index - 1]] floatValue]/100;
            [arr addObject:[NSString stringWithFormat:@"%.0f", f1]];
            index += 2;
            [contents addObject:arr];
            [colors addObject:@[TextFontColor, NavColor, NavColor]];
        }
        index = 0;
        while (index < 10) {
            NSMutableArray* arr = [NSMutableArray array];
            [arr addObject:[NSString stringWithFormat:@"买%d", index/2 + 1]];
            CGFloat f = [[NSString stringWithFormat:@"%@", array[10 + index + 1]] floatValue];
            [arr addObject:[NSString stringWithFormat:@"%.2f", f]];
            CGFloat f1 = [[NSString stringWithFormat:@"%@", array[10 + index]] floatValue]/100;
            [arr addObject:[NSString stringWithFormat:@"%.0f", f1]];
            index += 2;
            [contents addObject:arr];
            [colors addObject:@[TextFontColor, RGB(76, 209, 207), TextGrayColor]];
        }
        CGFloat f = [[NSString stringWithFormat:@"%@", array[1]] floatValue];
        [contents addObject:@[@"今开", [NSString stringWithFormat:@"%.2f", f]]];
        [colors addObject:@[TextFontColor, NavColor]];
        
        f = [[NSString stringWithFormat:@"%@", array[2]] floatValue];
        [contents addObject:@[@"昨收", [NSString stringWithFormat:@"%.2f", f]]];
        [colors addObject:@[TextFontColor, NavColor]];
        
        f = [[NSString stringWithFormat:@"%@", array[4]] floatValue];
        [contents addObject:@[@"最高", [NSString stringWithFormat:@"%.2f", f]]];
        [colors addObject:@[TextFontColor, NavColor]];
        
        f = [[NSString stringWithFormat:@"%@", array[5]] floatValue];
        [contents addObject:@[@"最低", [NSString stringWithFormat:@"%.2f", f]]];
        [colors addObject:@[TextFontColor, RGB(76, 209, 207)]];
        float min = [array[5] floatValue];
        float max = [array[4] floatValue];
        float m = (max - min) / (min > 0 ? min : 1);
        [contents addObject:@[@"振幅", [NSString stringWithFormat:@"%.2f%%", m * 100]]];
        [colors addObject:@[TextFontColor, NavColor]];
        [contents addObject:@[@"涨停价", [NSString stringWithFormat:@"%.2f", [array[2] floatValue] * 1.1]]];
        [colors addObject:@[TextFontColor, NavColor]];
        [contents addObject:@[@"跌停价", [NSString stringWithFormat:@"%.2f", [array[2] floatValue] * 0.9]]];
        [colors addObject:@[TextFontColor, RGB(76, 209, 207)]];
        [stockView updateStockView:contents colors:colors];
    }];
    
    [SharingPlansModel getSharingPlansRequest:sharingPlansUrl callback:^(SharingPlanModel* model){
        [stockView updateSharingPlansView:model];
    }];
}


@end
