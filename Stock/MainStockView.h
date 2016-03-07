//
//  MainStockView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

@interface MainStockView : UIView

- (void)updateView:(KLineModel*)model;

@end
