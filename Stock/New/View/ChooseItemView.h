//
//  ChooseItemView.h
//  DDTG
//
//  Created by 季勤强 on 16/5/11.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseItemViewDelegate <NSObject>

- (void)chooseItemViewDidSelect:(NSInteger)index;

@end

@interface ChooseItemView : UIView

@property (nonatomic, strong)UIColor* textColor;

@property (nonatomic, weak)id<ChooseItemViewDelegate> delegate;

- (instancetype)initWithArray:(NSArray*)items;

/**
 *  点击的是第几个item
 *
 *  @param index item序号
 */
- (void)itemDidChooseByIndex:(NSInteger)index;

@end
