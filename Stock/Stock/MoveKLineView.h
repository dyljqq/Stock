//
//  MoveKLineView.h
//  DDTG
//
//  Created by 季勤强 on 16/3/9.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveKLineView : UIView

- (void)updateView:(CGPoint)point stockPrice:(NSString*)price time:(NSString*)time;

@end
