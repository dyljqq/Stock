//
//  KLine.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLine : UIView

@property (nonatomic,assign) CGPoint startPoint; // 线条起点
@property (nonatomic,assign) CGPoint endPoint; // 线条终点
@property (nonatomic,retain) NSArray *points; // 多点连线数组
@property (nonatomic,retain) NSString *color; // 线条颜色
@property (nonatomic,assign) CGFloat lineWidth; // 线条宽度
@property (nonatomic,assign) BOOL isKLine;// 是否是实体K线 默认是连接线
@property (nonatomic,assign) BOOL isVol;// 是否是画成交量的实体

@property (nonatomic, strong)UIColor* uicolor;
@property (nonatomic)BOOL isColorString;

@end
