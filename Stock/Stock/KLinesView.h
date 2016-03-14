//
//  KLinesView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

@interface KLinesView : UIView

@property (nonatomic)CGFloat kLineWidth;

@property (nonatomic)CGFloat kLinePadding;

- (void)updateView:(KLineModel*)model;

- (void)updateViewIfNoData;

@end
