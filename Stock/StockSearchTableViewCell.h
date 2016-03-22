//
//  StockSearchTableViewCell.h
//  DDTG
//
//  Created by 季勤强 on 16/3/19.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockSearchTableViewCell : UITableViewCell

- (void)updateCell:(NSString*)stockName stockCode:(NSString*)stockCode;

@end
