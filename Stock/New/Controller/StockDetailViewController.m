//
//  StockDetailViewController.m
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockDetailViewController.h"
#import "StockRequest.h"
#import "StockDetailView.h"
#import "HandleMethod.h"

static const NSString* KLINE_PREFIX = @"http://img1.money.126.net/data/hs/kline/day/history/2016/";
static const NSString* SHAREING_TIME_PREFIX = @"http://img1.money.126.net/data/hs/time/today/";
static const NSString* TAPE_PREFIX = @"http://hq.sinajs.cn/list=";

@implementation StockDetailViewController{
    StockDetailView* stockDetailView;
    NSTimer* timer;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@(%@)", self.stockSearchModel.stockName, self.stockSearchModel.stockFullCode];
    self.navigationController.navigationBar.translucent = NO;
    
    stockDetailView = [[StockDetailView alloc] initWithFrame:COMMON_FRAME];
    [self.view addSubview:stockDetailView];
    
    [self getStockData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getStockData) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([timer isValid]) {
        [timer invalidate];
    }
}

#pragma Private Method

- (void)getStockData{
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
    __weak typeof(self) weakSelf = self;
    [StockRequest tapeRequest:[NSString stringWithFormat:@"%@%@", TAPE_PREFIX, self.stockSearchModel.stockFullCode] callback:^(NSArray* array){
        __strong typeof(self) strongSelf = weakSelf;
        if([array count] <= 1){
            NSLog(@"该股票已退市");
            return ;
        }
        int index = 0;
        NSMutableArray* contents = [NSMutableArray array];
        CGFloat f = [[NSString stringWithFormat:@"%@", array[1]] floatValue];
        [contents addObject:[NSString stringWithFormat:@"今开 %.2f", f]];
        
        f = [[NSString stringWithFormat:@"%@", array[2]] floatValue];
        [contents addObject:[NSString stringWithFormat:@"昨收 %.2f", f]];
        
        f = [[NSString stringWithFormat:@"%@", array[4]] floatValue];
        [contents addObject:[NSString stringWithFormat:@"最高 %.2f", f]];
        
        f = [[NSString stringWithFormat:@"%@", array[5]] floatValue];
        [contents addObject:[NSString stringWithFormat:@"最低 %.2f", f]];
        
        [contents addObject:[NSString stringWithFormat:@"成交量 %@", [HandleMethod handleTapeData:[array[8] floatValue] / 100]]];
        [contents addObject:[NSString stringWithFormat:@"成交额 %@", [HandleMethod handleTapeData:[array[9] floatValue]]]];
        [contents addObject:[NSString stringWithFormat:@"涨停价 %.2f", [array[2] floatValue] * 1.1]];
        [contents addObject:[NSString stringWithFormat:@"跌停价 %.2f", [array[2] floatValue] * 0.9]];
        
        while (index < 10) {
            CGFloat f = [[NSString stringWithFormat:@"%@", array[29 - index]] floatValue];
            CGFloat f1 = [[NSString stringWithFormat:@"%@", array[29 - index - 1]] floatValue]/100;
            [contents addObject:[NSString stringWithFormat:@"卖%d %.2f %.0f", (10 - index)/2, f, f1]];
            index += 2;
        }
        index = 0;
        while (index < 10) {
            CGFloat f = [[NSString stringWithFormat:@"%@", array[10 + index + 1]] floatValue];
            CGFloat f1 = [[NSString stringWithFormat:@"%@", array[10 + index]] floatValue]/100;
            [contents addObject:[NSString stringWithFormat:@"卖%d %.2f %.0f", index/2 + 1, f, f1]];
            index += 2;
        }
        [strongSelf->stockDetailView updateTape:[contents copy]];
    }];
    
    NSInteger sh = 0;
    if ([self.stockSearchModel.stockFullCode rangeOfString:@"sh"].location == NSNotFound) {
        sh = 1;
    }
    [StockRequest sharingTimeRequest:[NSString stringWithFormat:@"%@%ld%@.json", SHAREING_TIME_PREFIX, sh, self.stockSearchModel.stockCode] callback:^(id model){
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->stockDetailView updateSharingTime:model];
    }];
    [StockRequest kLineRequest:[NSString stringWithFormat:@"%@%ld%@.json", KLINE_PREFIX, sh, self.stockSearchModel.stockCode] callback:^(id model){
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->stockDetailView updateKLine:model];
    }];
}

@end
