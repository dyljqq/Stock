//
//  MainStockView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

@protocol MainStockViewDelegate <NSObject>

- (void)buy;

@end

@interface MainStockView : UIView

@property (nonatomic, weak)id<MainStockViewDelegate> delegate;

- (void)updateView:(KLineModel*)model;

- (void)updateStockView:(NSArray*)contents colors:(NSArray*)colors;

- (void)updateSharingPlansView:(id)model;

@end
