//
//  MainStockSearchController.h
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainStockSearchControllerDelegate

- (void)getStock:(NSArray*)stock;

@end

@interface MainStockSearchController : UIViewController

@property (nonatomic, weak)id<MainStockSearchControllerDelegate> delegate;

@end
