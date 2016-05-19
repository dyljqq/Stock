//
//  CurveLine.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveLine : UIView

@property (nonatomic, strong)UIColor* lineColor;

@property (nonatomic)CGFloat lineWidth;

@property (nonatomic, copy)NSArray* points;

@property (nonatomic)BOOL isClothPath;

@end
