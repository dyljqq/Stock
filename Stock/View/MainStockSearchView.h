//
//  MainStockSearchView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainStockSearchViewDelegate <NSObject>

- (void)selectCell:(NSArray*)array;

@end

@interface MainStockSearchView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSArray* dataArray;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, weak)id<MainStockSearchViewDelegate> delegate;

- (void)showDataView;

- (void)hideDataView;

@end
