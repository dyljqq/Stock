//
//  JQQSearchBar.h
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* JQQSearchBarCallbackData = @"JQQSearchBarCallbackData";

@protocol JQQSearchBarDelegate <NSObject>

- (void)reloadData:(NSArray*)dataArray;

@end

@interface JQQSearchBar : UIView

@property (nonatomic, weak)id<JQQSearchBarDelegate> delegate;

@end
