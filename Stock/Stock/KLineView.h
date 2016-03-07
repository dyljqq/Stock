//
//  KLineView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

typedef void(^KLineViewUpdateBlock)(id);

@interface KLineView : UIView

@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) NSMutableArray *category;
@property (nonatomic,retain) NSString *req_freq;
@property (nonatomic,retain) NSString *req_type;
@property (nonatomic,retain) NSString *req_url;
@property (nonatomic,retain) NSString *req_security_id;
@property (nonatomic,retain) NSDate *startDate;
@property (nonatomic,retain) NSDate *endDate;
@property (nonatomic,assign) CGFloat xWidth; // x轴宽度
@property (nonatomic,assign) CGFloat yHeight; // y轴高度
@property (nonatomic,assign) CGFloat bottomBoxHeight; // y轴高度
@property (nonatomic,assign) CGFloat kLineWidth; // k线的宽度 用来计算可存放K线实体的个数，也可以由此计算出起始日期和结束日期的时间段
@property (nonatomic,assign) CGFloat kLinePadding;
@property (nonatomic,assign) int kCount; // k线中实体的总数 通过 xWidth / kLineWidth 计算而来
@property (nonatomic,retain) UIFont *font;

@property (nonatomic, strong)KLineModel* kLineModel;

@property (nonatomic,copy)KLineViewUpdateBlock finishUpdateBlock; // 定义一个block回调 更新界面


/**
 *  开始绘图
 */
- (void)start;

/**
 * 更新K线图
 */
- (void)update;

@end
