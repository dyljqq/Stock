//
//  StockDetailView.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailView : UIView

/**
 *  更新大盘数据
 *
 *  @param tapeDic 大盘数据
 */
- (void)updateTape:(NSArray*)tapes;

/**
 *  更新分时图信息
 *
 *  @param model 分时图信息
 */
- (void)updateSharingTime:(id)model;

/**
 *  更新k线信息
 *
 *  @param model K先信息
 */
- (void)updateKLine:(id)model;

@end
