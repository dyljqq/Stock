//
//  MainStockSearchView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "MainStockSearchView.h"
#import "JQQSearchBar.h"
#import "StockSearchTableViewCell.h"
#import "StockDataModel.h"
#import "NowDataView.h"

@interface MainStockSearchView ()

@property (nonatomic, strong)JQQSearchBar* searchBar;
@property (nonatomic, strong)NowDataView* dataView;

@end

@implementation MainStockSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initParam];
    }
    return self;
}

- (void)initParam{
    self.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:self.tableView];
    if([_dataArray count] == 0)
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
    return [_dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockSearchTableViewCell* cell = (StockSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell = [[StockSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    [cell updateCell:_dataArray[indexPath.row][4] stockCode:_dataArray[indexPath.row][2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [StockDataModel setAllStocks:_dataArray[indexPath.row]];
    [StockDataModel setLastStock:_dataArray[indexPath.row]];
    [self.delegate selectCell:_dataArray[indexPath.row]];
}

#pragma Private method

- (JQQSearchBar *)searchBar{
    if(_searchBar == nil){
        _searchBar = [[JQQSearchBar alloc] initWithFrame:CGRectMake(15, 5, APPLICATION_SIZE.width - 30, 44)];
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.searchBar;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

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
