//
//  MainStockSearchTableViewController.m
//  DDTG
//
//  Created by 季勤强 on 16/3/14.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MainStockSearchTableViewController.h"
#import "StockSearchModel.h"
#import "StockDataModel.h"
#import "StockSearchTableViewCell.h"
#import "NowDataView.h"

@interface MainStockSearchTableViewController ()

@property (nonatomic, strong)UISearchController *searchController;

@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, strong)NowDataView* dataView;

@end

@implementation MainStockSearchTableViewController{
    NSMutableArray* searchList;
    NSMutableArray* dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParam];
}

- (void)initParam{
    self.title = @"股票搜索";
    [self.view addSubview:self.tableView];
    searchList = [[StockDataModel allStocks] mutableCopy];
    dataList = [[StockDataModel allStocks] mutableCopy];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.dataView];
    if([searchList count] == 0 || [dataList count] == 0)
        self.dataView.hidden = NO;
    else
        self.dataView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.active = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [searchList count];
    }else{
        return [dataList count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockSearchTableViewCell* cell = (StockSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell = [[StockSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if(self.searchController.active){
        [cell updateCell:searchList[indexPath.row][4] stockCode:searchList[indexPath.row][2]];
    }else {
        [cell updateCell:dataList[indexPath.row][4] stockCode:dataList[indexPath.row][2]];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.searchController.active){
        [self.delegate getStock:searchList[indexPath.row]];
        [StockDataModel setAllStocks:searchList[indexPath.row]];
        [StockDataModel setLastStock:searchList[indexPath.row]];
    }else{
        [self.delegate getStock:dataList[indexPath.row]];
        [StockDataModel setAllStocks:dataList[indexPath.row]];
        [StockDataModel setLastStock:dataList[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    if ([BaseMethod isNOTNull:searchString]) {
        NSString* urlString = [NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=111&key=%@&name=suggestdata_%f", searchString, [[NSDate date] timeIntervalSince1970]];
        [self getData:urlString];
    }
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    [searchController.searchBar becomeFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.searchController.searchBar.showsCancelButton = YES;
    }];
    return YES;
}

#pragma Action

- (void)resignAction:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.searchController.searchBar.showsCancelButton = NO;
    }];
    [self.searchController.searchBar resignFirstResponder];
}

#pragma Private Method

- (UISearchController *)searchController{
    if(_searchController == nil){
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.searchController.searchBar.showsCancelButton = YES;
        UIButton *cancelButton = [self.searchController.searchBar valueForKey:@"_cancelButton"];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:NavColor forState:UIControlStateNormal];

    }
    return _searchController;
}

- (NowDataView *)dataView{
    if(!_dataView){
        _dataView = [[NowDataView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height)];
        _dataView.text = @"暂无数据";
        [_dataView updateImageView:[UIImage imageNamed:@"icon-kong"] height:37.5];
        _dataView.hidden = YES;
    }
    return _dataView;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAction:)];
//        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (void)getData:(NSString*)urlString{
    __weak typeof(self) weakSelf = self;
    [StockSearchModel getStockRequest:urlString callback:^(NSArray* array){
        NSLog(@"search:%@", array);
        __strong typeof(self) strongSelf = weakSelf;
        if([array count] >= 1 && [array[0] count] > 1){
            searchList = [array mutableCopy];
            dataList = [searchList copy];
            [self.tableView reloadData];
            strongSelf.dataView.hidden = YES;
        }else{
            strongSelf.dataView.hidden = NO;
        }
    }];
}

- (void)dealloc{
    self.searchController = nil;
}

@end
