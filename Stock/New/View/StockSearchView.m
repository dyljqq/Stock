//
//  StockSearchView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "StockSearchView.h"
#import "StockSearchCell.h"

@implementation StockSearchView{
    NSArray* sectionTitles;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = BACKGROUND_COLOR;
    
    sectionTitles = @[@"历史记录", @"热门股票"];
    [self addSubview:self.tableView];
}

#pragma Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [UILabel new];
    label.text = sectionTitles[section];
    label.textColor = RGB(154, 154, 159);
    label.font = Font(11);
    [view addSubview:label];
    
    UIView* line = [UIView new];
    line.backgroundColor = LINE_COLOR;
    [view addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker* make){
        make.bottom.mas_equalTo(-6);
        make.left.mas_equalTo(LeftSpacing);
        make.height.mas_equalTo(12);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.mas_equalTo(LeftSpacing);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELL_WITH_SECTION(indexPath.section, indexPath.row)];
    if(cell == nil){
        cell = [[StockSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_CELL_WITH_SECTION(indexPath.section, indexPath.row)];
    }
    [cell updateCell:self.dataArray[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didTouchStock:self.dataArray[indexPath.section][indexPath.row]];
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
