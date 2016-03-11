//
//  StockBarView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockBarViewDelegate <NSObject>

- (void)passPageIndex:(NSInteger)pageIndex;

@end

@interface StockBarView : UIView

@property (nonatomic, weak)id<StockBarViewDelegate> delegate;

- (instancetype)initWithBarNums:(CGRect)frame contents:(NSArray*)array;

- (void)updateView:(NSInteger)page;

@end
