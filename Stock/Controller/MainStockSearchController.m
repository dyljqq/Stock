//
//  MainStockSearchController.m
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MainStockSearchController.h"
#import "MainStockSearchView.h"
#import "JQQSearchBar.h"
#import "StockSearchModel.h"
#import "StockDataModel.h"

@interface MainStockSearchController ()<MainStockSearchViewDelegate>

@end

@implementation MainStockSearchController{
    MainStockSearchView* searchView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"股票搜索";
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    searchView = [[MainStockSearchView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height - 64)];
    searchView.delegate = self;
    [self.view addSubview:searchView];
    searchView.dataArray = [StockDataModel allStocks];
    if([searchView.dataArray count] == 0){
        [searchView showDataView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchStockNotification:) name:JQQSearchBarCallbackData object:nil];
}

#pragma Delegate

- (void)selectCell:(NSArray *)array{    
    [self.delegate getStock:array];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Action

#pragma Notification

- (void)searchStockNotification:(NSNotification*)notification{
    NSString* searchText = notification.userInfo[@"searchText"];
    if([BaseMethod isNOTNull:searchText])
        [self searchStockData:searchText];
}

#pragma Private Method

- (void)searchStockData:(NSString*)searchString{
    NSString* urlString = [NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=111&key=%@&name=suggestdata_%f", searchString, [[NSDate date] timeIntervalSince1970]];
    [self getData:urlString];
}

- (void)getData:(NSString*)urlString{
    [StockSearchModel getStockRequest:urlString callback:^(NSArray* array){
        NSLog(@"search:%@", array);
        if([array count] >= 1 && [array[0] count] > 1){
            searchView.dataArray = array;
            [searchView.tableView reloadData];
            [searchView hideDataView];
        }else{
            [searchView showDataView];
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
