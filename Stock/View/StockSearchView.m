//
//  StockSearchView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchView.h"

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
    
    self.dataArray = [NSArray array];
    self.filterArray = [NSArray array];
    
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchController.active){
        return [self.filterArray count];
    }
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if(self.searchController.active){
        cell.detailTextLabel.text = _filterArray[indexPath.row][4];
        cell.textLabel.text = _filterArray[indexPath.row][0];
    }else {
        cell.detailTextLabel.text = _dataArray[indexPath.row][4];
        cell.textLabel.text = _dataArray[indexPath.row][0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.searchController.active){
        [self.delegate chooseItem:_filterArray[indexPath.row]];
    }else{
        [self.delegate chooseItem:_dataArray[indexPath.row]];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* text = searchController.searchBar.text;
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
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
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
    }
    return _tableView;
}

@end
