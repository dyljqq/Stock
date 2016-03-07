//
//  ViewController.m
//  Stock
//
//  Created by 季勤强 on 16/3/7.
//  Copyright © 2016年 季勤强. All rights reserved.
//

#import "ViewController.h"
#import "KLineModel.h"
#import "MainStockView.h"

@interface ViewController ()

@end

#define APPLICATION_SIZE [UIScreen mainScreen].bounds.size

@implementation ViewController{
    KLineModel* kLineModel;
    MainStockView* stockView;
    UIButton* alterStockButton;
}

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"股票";
    
    stockView = [[MainStockView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_SIZE.width, APPLICATION_SIZE.height - 64)];
    [self.view addSubview:stockView];
    
    kLineModel = [KLineModel new];
    [kLineModel getKLineRequest:@"http://img1.money.126.net/data/hs/kline/day/history/2016/0600725.json" callback:^{
        [stockView updateView:kLineModel];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
