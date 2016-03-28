//
//  MainStockSearchTableViewController.h
//  DDTG
//
//  Created by 季勤强 on 16/3/14.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainStockSearchTableViewControllerDelegate <NSObject>

- (void)getStock:(NSArray*)stocks;

@end

@interface MainStockSearchTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, weak)id<MainStockSearchTableViewControllerDelegate> delegate;

@end
