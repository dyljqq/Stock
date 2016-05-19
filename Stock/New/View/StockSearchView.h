//
//  StockSearchView.h
//  DDTG
//
//  Created by 季勤强 on 16/5/10.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockSearchProtocol.h"

@interface StockSearchView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSArray* dataArray;

@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, weak)id<StockSearchProtocol> delegate;

@end
