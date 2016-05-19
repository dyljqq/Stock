//
//  StockSearchController.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchController.h"
#import "StockSearchView.h"
#import "StockSearchModel.h"
#import "StrategyRequest.h"
#import "StockSearchingView.h"
#import "StockRecord.h"
#import "StockDetailViewController.h"

typedef enum : NSUInteger {
    STOCK_SEARCH_STATUS_DEFAULT,
    STOCK_SEARCH_STATUS_DISPLAY,
} STOCK_SEARCH_STATUS;

@interface StockSearchController () <UISearchBarDelegate, StockSearchProtocol>

@property (nonatomic, strong)UISearchBar* searchBar;
@property (nonatomic, strong)StockSearchView* stockSearchView;
@property (nonatomic, strong)StockSearchingView* stockSearchingView;
@property (nonatomic, strong)NSTimer* timer;

@end

@implementation StockSearchController{
    NSMutableArray* defaultArray;
    NSMutableArray* displayArray;
    STOCK_SEARCH_STATUS status;
    NSString* urlString;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self createNavigationBar];
    
    [self.view addSubview:self.stockSearchingView];
    [self.view addSubview:self.stockSearchView];
    
    displayArray = [NSMutableArray array];
    defaultArray = [NSMutableArray array];
    
    [self getStockDatas:STOCK_SEARCH_STATUS_DEFAULT];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getStockCurrentPrice) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

#pragma Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    urlString = [NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=111&key=%@&name=suggestdata_%f", searchText, [[NSDate date] timeIntervalSince1970]];
    if (searchText.length > 0) {
        self.stockSearchView.hidden = YES;
        status = STOCK_SEARCH_STATUS_DISPLAY;
    }else{
        self.stockSearchView.hidden = NO;
        status = STOCK_SEARCH_STATUS_DEFAULT;
        [defaultArray replaceObjectAtIndex:0 withObject:[[StockRecord getAllStocks] copy]];
        [self getStockDatas:STOCK_SEARCH_STATUS_DEFAULT];
    }
    [self getStockDatas:STOCK_SEARCH_STATUS_DISPLAY];
}

- (void)resignFirstResponder{
    [self.searchBar resignFirstResponder];
}

- (void)didTouchStock:(id)model{
    StockDetailViewController* detailController = [StockDetailViewController new];
    detailController.stockSearchModel = model;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma Action

- (void)getStockCurrentPrice{
    switch (status) {
        case STOCK_SEARCH_STATUS_DEFAULT:
            [self getStockDatas:STOCK_SEARCH_STATUS_DEFAULT];
            break;
            
        case STOCK_SEARCH_STATUS_DISPLAY:
            [self getStockDatas:STOCK_SEARCH_STATUS_DISPLAY];
            break;
            
        default:
            break;
    }
}

#pragma Private Method

- (void)createNavigationBar{
    //去除searcbar背景
    for (UIView *view in self.searchBar.subviews){
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0){
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.searchBar becomeFirstResponder];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
}

- (void)getStockDatas:(STOCK_SEARCH_STATUS)st{
    __weak typeof(self) weakSelf = self;
    switch (st) {
        case STOCK_SEARCH_STATUS_DEFAULT:
        {
            [defaultArray removeAllObjects];
            [defaultArray addObjectsFromArray:[StockRecord getAllStocks]];
            NSMutableArray* stocks = [NSMutableArray array];
            for (StockSearchModel* model in defaultArray) {
                [stocks addObject:model.stockFullCode];
            }
            __strong typeof(self) strongSelf = weakSelf;
            [self getCurrentPrice:[stocks copy] callback:^(NSArray* array){
                defaultArray = [[strongSelf handleStocks:array stocks:defaultArray] mutableCopy];
                NSArray* historyArray = [defaultArray subarrayWithRange:NSMakeRange(0, [[StockRecord getAllStocks] count])];
                [defaultArray removeObjectsInArray:historyArray];
                NSMutableArray* arr = [NSMutableArray array];
                [arr addObject:[historyArray copy]];
                [arr addObject:[defaultArray copy]];
                strongSelf.stockSearchView.dataArray = [arr copy];
                [strongSelf.stockSearchView.tableView reloadData];
                defaultArray = [arr mutableCopy];
            }];
        }
            break;
            
        case STOCK_SEARCH_STATUS_DISPLAY:
        {
            [StrategyRequest getStockRequest:urlString complete:^(NSArray* array){
                __strong typeof(self) strongSelf = weakSelf;
                [displayArray removeAllObjects];
                NSMutableArray* stockFullCodes = [NSMutableArray array];
                NSMutableArray* stocks = [NSMutableArray array];
                for (NSArray* arr in array) {
                    if ([arr count] <= 1) {
                        continue;
                    }
                    StockSearchModel* model = [StockSearchModel new];
                    model.stockFullCode = arr[3];
                    model.stockCode = arr[0];
                    model.stockName = arr[4];
                    [stockFullCodes addObject:model.stockFullCode];
                    [stocks addObject:model];
                }
                [displayArray addObjectsFromArray:[stocks copy]];
                [strongSelf getCurrentPrice:stockFullCodes callback:^(NSArray* array){
                    displayArray = [[strongSelf handleStocks:array stocks:displayArray] mutableCopy];
                    strongSelf.stockSearchingView.dataArray = [displayArray copy];
                    [strongSelf.stockSearchingView.tableView reloadData];
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)getCurrentPrice:(NSArray*)array callback:(void(^)(NSArray* array))callback{
    [StrategyRequest getStockCurrentPrice:array complete:^(NSArray* array){
        if (callback) {
            callback(array);
        }
    }];
}

- (NSArray*)handleStocks:(NSArray*)array stocks:(NSArray*)stocks{
    NSInteger count = MIN([array count], [stocks count]);
    for (int i = 0; i < count; i++) {
        StockSearchModel* model = stocks[i];
        NSArray* arr = array[i];
        model.currentPrice = [arr[1] floatValue];
        model.yesterdayPrice = [arr[0] floatValue];
        if ([arr[1] isEqualToString:@""]) {
            model.status = STOCK_STATUS_DELISTING;
        }else if(model.currentPrice == 0.0){
            model.status = STOCK_STATUS_SUSPENTION;
        }else{
            model.status = STOCK_STATUS_NORMAL;
        }
        if (model.yesterdayPrice > 0) {
            model.ratio = (model.currentPrice - model.yesterdayPrice) / model.yesterdayPrice;
        }else{
            model.ratio = 0.0;
        }
    }
    return stocks;
}

#pragma Getter/Setter

- (UISearchBar *)searchBar{
    if(_searchBar == nil){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(LeftSpacing, 0, APPLICATION_SIZE.width - 2 * LeftSpacing, 44)];
        _searchBar.placeholder = @"点击搜索股票";
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.backgroundColor = [UIColor clearColor];
    }
    return _searchBar;
}

- (StockSearchingView *)stockSearchingView{
    if(_stockSearchingView == nil){
        _stockSearchingView = [[StockSearchingView alloc] initWithFrame:COMMON_FRAME];
        _stockSearchingView.delegate = self;
    }
    return _stockSearchingView;
}

- (StockSearchView *)stockSearchView{
    if (_stockSearchView == nil) {
        _stockSearchView = [[StockSearchView alloc] initWithFrame:COMMON_FRAME];
        _stockSearchView.delegate = self;
    }
    return _stockSearchView;
}

- (void)dealloc{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

@end
