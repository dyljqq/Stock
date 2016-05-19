//
//  StockSearchProtocol.h
//  DDTG
//
//  Created by 季勤强 on 16/5/13.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STOCK_SEARCH_PROTOCOL_DEFAULT,
    STOCK_SEARCH_PROTOCOL_SEARCHING,
} STOCK_SEARCH_PROTOCOL;

@protocol StockSearchProtocol <NSObject>

/**
 *  判断是哪个view的stock
 *
 *  @param index 1.默认 2.搜索到的
 */
- (void)didTouchStock:(id)model;

/**
 *  结束搜索
 */
- (void)resignFirstResponder;

@end
