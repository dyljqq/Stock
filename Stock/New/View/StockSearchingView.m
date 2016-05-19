//
//  StockSearchingView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchingView.h"
#import "StockSearchCell.h"
#import "StockRecord.h"

@implementation StockSearchingView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:self.tableView];
}

#pragma Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELL_WITH_SECTION(indexPath.section, indexPath.row)];
    if(cell == nil){
        cell = [[StockSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_CELL_WITH_SECTION(indexPath.section, indexPath.row)];
    }
    [cell updateCell:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [StockRecord setStock:self.dataArray[indexPath.row]];
    [self.delegate didTouchStock:self.dataArray[indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.delegate resignFirstResponder];
}

#pragma Getter/Setter

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
