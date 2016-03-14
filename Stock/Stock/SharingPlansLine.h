//
//  SharingPlansLine.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SHARING_PLAN_VERTICAL_COLOR_RED,
    SHARING_PLAN_VERTICAL_COLOR_GREEN,
} SHARING_PLAN_VERTICAL_COLOR;

@interface SharingPlansLine : UIView

@property (nonatomic)CGFloat lineWidth;

@property (nonatomic, strong)UIColor* lineColor;

@property (nonatomic, copy)NSArray* linePoints;

@property (nonatomic, copy)NSArray* verticalColors;

@property (nonatomic)BOOL isStraight;

@property (nonatomic)BOOL isDash;

@property (nonatomic)BOOL isVertical;

@property (nonatomic)CGPoint startPoint;

@property (nonatomic)CGPoint endPoint;

@end
