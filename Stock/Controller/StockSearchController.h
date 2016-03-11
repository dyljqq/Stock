//
//  StockSearchController.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockSearchControllerDelegate <NSObject>

- (void)getStock:(NSArray*)stocks;

@end

@interface StockSearchController : UIViewController

@property (nonatomic, weak)id<StockSearchControllerDelegate> delegate;

@end
