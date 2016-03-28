//
//  StockSearchView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchView.h"
#import "StockDataModel.h"
#import "NowDataView.h"
#import "StockSearchTableViewCell.h"

@interface StockSearchView () <UISearchBarDelegate>

@property (nonatomic, strong)NowDataView* dataView;

@end

@implementation StockSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [StockDataModel allStocks];
    self.filterArray = [StockDataModel allStocks];    
    [self addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.dataView];
    if([self.dataArray count] == 0 || [self.filterArray count] == 0)
        [self showDataView];
}

- (void)showDataView{
    self.dataView.hidden = NO;
}

- (void)hideDataView{
    self.dataView.hidden = YES;
}

#pragma Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchController.active){
        return [self.filterArray count];
    }
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockSearchTableViewCell* cell = (StockSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell = [[StockSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if(self.searchController.active){
        [cell updateCell:_filterArray[indexPath.row][4] stockCode:_filterArray[indexPath.row][2]];
    }else {
        [cell updateCell:_dataArray[indexPath.row][4] stockCode:_dataArray[indexPath.row][2]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.searchController.active){
        [self.delegate chooseItem:_filterArray[indexPath.row]];
        [StockDataModel setAllStocks:_filterArray[indexPath.row]];
        [StockDataModel setLastStock:_filterArray[indexPath.row]];
    }else{
        [self.delegate chooseItem:_dataArray[indexPath.row]];
        [StockDataModel setAllStocks:_dataArray[indexPath.row]];
        [StockDataModel setLastStock:_dataArray[indexPath.row]];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* text = searchController.searchBar.text;
    if([BaseMethod isNOTNull:text])
        [self.delegate passSearchText:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString* text = searchBar.text;
    [self.delegate passSearchText:text];
}

#pragma Private Method

- (UISearchController *)searchController{
    if(_searchController == nil){
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = false;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _tableView;
}

#pragma Private Method
- (NowDataView *)dataView{
    if(!_dataView){
        _dataView = [[NowDataView alloc] initWithFrame:self.bounds];
        _dataView.text = @"暂无数据";
        [_dataView updateImageView:[UIImage imageNamed:@"icon-kong"] height:37.5];
        _dataView.hidden = YES;
    }
    return _dataView;
}

@end
