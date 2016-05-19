//
//  VolumnView.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VOLUMN_VIEW_COLOR_RED,
    VOLUMN_VIEW_COLOR_GREEN,
} VOLUMN_VIEW_COLOR;

@interface VolumnView : UIView

@property (nonatomic, copy, readonly)NSArray* volumns;

@property (nonatomic, copy, readonly)NSArray* lineColors;

@property (nonatomic)CGFloat lineWidth;

- (void)drawVolumn:(NSArray*)volumns colors:(NSArray*)colors;

@end
