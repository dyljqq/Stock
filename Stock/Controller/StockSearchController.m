//
//  StockSearchController.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchController.h"
#import "StockSearchModel.h"
#import "StockSearchView.h"
#import "StockDataModel.h"

@interface StockSearchController ()<StockSearchViewDelegate>

@end

@implementation StockSearchController{
    StockSearchView* stockSearchView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"查找股票";
    self.view.backgroundColor = [UIColor whiteColor];    
    stockSearchView = [[StockSearchView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height - 64)];
    stockSearchView.delegate = self;
    [self.view addSubview:stockSearchView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)getData:(NSString*)urlString{
    [StockSearchModel getStockRequest:urlString callback:^(NSArray* array){
        NSLog(@"search:%@", array);
        if([array count] > 1 && [array[0] count] > 1){
            stockSearchView.filterArray = array;
            stockSearchView.dataArray = array;
            [stockSearchView.tableView reloadData];
            [stockSearchView hideDataView];
        }else{
            [stockSearchView showDataView];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    stockSearchView.searchController.searchBar.hidden = YES;
    [stockSearchView.searchController.searchBar resignFirstResponder];
}

#pragma Delegate

- (void)passSearchText:(NSString*)text{
    NSString* urlString = [NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=111&key=%@&name=suggestdata_%f", text, [[NSDate date] timeIntervalSince1970]];
    [self getData:urlString];
}

- (void)chooseItem:(NSArray *)array{
    [self.delegate getStock:array];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
