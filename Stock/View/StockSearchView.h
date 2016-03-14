//
//  StockSearchView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockSearchViewDelegate <NSObject>

- (void)passSearchText:(NSString*)text;

- (void)chooseItem:(NSArray*)array;

@end

@interface StockSearchView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, strong)UISearchController* searchController;

@property (nonatomic, strong)NSArray* dataArray;

@property (nonatomic, strong)NSArray* filterArray;

@property (nonatomic, weak)id<StockSearchViewDelegate> delegate;

- (void)showDataView;

- (void)hideDataView;

@end
