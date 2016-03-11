//
//  HandicapView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandicapView : UIView

- (instancetype)initWithArray:(CGRect)frame dataArray:(NSArray*)array textColors:(NSArray*)colors;

- (void)updateView:(NSArray*)array textColors:(NSArray*)colors;

@end
