//
//  SharingPlansLine.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharingPlansLine : UIView

@property (nonatomic)CGFloat lineWidth;

@property (nonatomic, strong)UIColor* lineColor;

@property (nonatomic, copy)NSArray* linePoints;

@property (nonatomic)BOOL isStraight;

@property (nonatomic)BOOL isDash;

@property (nonatomic)BOOL isVertical;

@property (nonatomic)CGPoint startPoint;

@property (nonatomic)CGPoint endPoint;

@end
