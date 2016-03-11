//
//  KLinesView.m
//  DDTG
//
//  Created by 季勤强 on 16/3/8.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "KLinesView.h"
#import "KLine.h"
#import "UIColor+Helper.h"
#import "StockCommand.h"

#define FONT [UIFont systemFontOfSize:8]

@interface KLinesView ()

@property (nonatomic, strong)UILabel* stockNameLabel;
@property (nonatomic, strong)UILabel* contentLabel;
@property (nonatomic, strong)UILabel* timeLabel;

@property (nonatomic, strong)UIView* mainView;
@property (nonatomic, strong)UIView* bottomView;
@property (nonatomic, strong)UILabel* unitLabel;

@property (nonatomic, strong)KLine* kLine;
@property (nonatomic, strong)KLine* volumnLine;

@property (nonatomic, strong)UILabel* startTimeLabel;
@property (nonatomic, strong)UILabel* endTimeLabel;

@property (nonatomic, strong)UILabel* priceLabel;

@property (nonatomic, strong)UILabel* moveTimeLabel;

@property (nonatomic, strong)UIView* verticalLine;

@property (nonatomic, strong)UIView* horizontalLine;

@end

@implementation KLinesView{
    NSMutableArray* mainLeftLabels;
    NSMutableArray* bottomLabels;
    NSMutableArray* pointArray;
    KLineModel* kLineModel;
    NSMutableArray* catogary;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    //初始化参数
    self.kLineWidth = 5;
    self.kLinePadding = 1;
    
    [self addSubview:self.stockNameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.unitLabel];
    [self addSubview:self.mainView];
    [self addSubview:self.bottomView];
    [self addSubview:self.startTimeLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.verticalLine];
    [self.mainView addSubview:self.horizontalLine];
    [self addSubview:self.priceLabel];
    [self addSubview:self.moveTimeLabel];
    
    float width = [HandleString lableWidth:@"2015-03-07 14:33:24" withSize:CGSizeMake(100, 13) withFont:Font(8)] + 5;
    self.timeLabel.frame = CGRectMake(self.mainView.frame.size.width + self.mainView.frame.origin.x - width, 5, width, 9);
    
    mainLeftLabels = [NSMutableArray array];
    CGFloat y = self.mainView.frame.origin.y - 5;
    for (int i = 0; i < 8; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 35, 10)];
        label.textColor = NavColor;
        label.font = FONT;
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        [mainLeftLabels addObject:label];
        y += self.mainView.frame.size.height/7;
    }
    
    bottomLabels = [NSMutableArray array];
    y = self.bottomView.frame.origin.y - 5;
    for (int i = 0; i < 5; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 35, 10)];
        label.textColor = TextGrayColor;
        label.font = FONT;
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        [bottomLabels addObject:label];
        y += self.bottomView.frame.size.height/4;
    }
    
    CGFloat padRealValue = self.mainView.frame.size.height / 6;
    for (int i = 0; i < 7; i++) {
        CGFloat y = self.mainView.frame.size.height - padRealValue * i;
        KLine *line = [[KLine alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
        line.isColorString = NO;
        line.uicolor = RGB(224, 225, 228);
        line.startPoint = CGPointMake(0, y);
        line.endPoint = CGPointMake(self.mainView.frame.size.width, y);
        [self.mainView addSubview:line];
    }
    
    padRealValue = self.bottomView.frame.size.height / 3;
    for (int i = 0; i < 7; i++) {
        CGFloat y = self.bottomView.frame.size.height - padRealValue * i;
        KLine *line = [[KLine alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
        line.isColorString = NO;
        line.uicolor = RGB(224, 225, 228);
        line.startPoint = CGPointMake(0, y);
        line.endPoint = CGPointMake(self.bottomView.frame.size.width, y);
        [self.bottomView addSubview:line];
    }
    
    [self.mainView addSubview:self.kLine];
    [self.bottomView addSubview:self.volumnLine];
}

- (void)updateView:(KLineModel*)model{
    kLineModel = model;
    
    self.stockNameLabel.text = [NSString stringWithFormat:@"sh%@", model.symbol];
    float width = [HandleString lableWidth:self.stockNameLabel.text withSize:CGSizeMake(100, 9) withFont:Font(8)];
    self.stockNameLabel.frame = CGRectMake(self.mainView.frame.origin.x, 5, width, 9);
    self.contentLabel.frame = CGRectMake(self.stockNameLabel.frame.size.width + self.stockNameLabel.frame.origin.x + 30, 5, 150, 9);
    
    CGFloat unitValue = (model.maxValue - model.minValue)/8;
    for (int i = 0; i < [mainLeftLabels count]; i++) {
        UILabel* label = (UILabel*)mainLeftLabels[i];
        label.text = [NSString stringWithFormat:@"%.2f", model.maxValue - unitValue * i];
    }
    
    CGFloat unitVolum = (model.maxVolumeValue - model.minVolumeValue)/4;
    for (int i = 0; i < [bottomLabels count]; i++) {
        UILabel* label = (UILabel*)bottomLabels[i];
        CGFloat value = model.maxVolumeValue - unitVolum * i;
        label.text = [NSString stringWithFormat:@"%@", [StockCommand changePriceUnit:value]];
    }
    self.unitLabel.text = [NSString stringWithFormat:@"%@", [StockCommand changePrice:model.minVolumeValue]];
    
    self.kLineWidth = self.mainView.frame.size.width / [model.stockArray count] - self.kLinePadding;
    NSArray* stockAxisArray = [self changeKPointWithData:model.stockArray];
    self.kLine.lineWidth = self.kLineWidth;
    self.kLine.points = stockAxisArray;
    [self.kLine setNeedsDisplay];
    
    // 开始画连接线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    // MA5
    
    for (UIView* view in self.mainView.subviews) {
        if(view.tag == (8888 + 5) || view.tag == (8888 + 6) || view.tag == (8888 + 7))
            [view removeFromSuperview];
    }
    
    //MA5
    [self drawMAWithIndex:5 andColor:@"#000000"];
    // MA10
    [self drawMAWithIndex:6 andColor:@"#FF99OO"];
    // MA20
    [self drawMAWithIndex:7 andColor:@"#FF00FF"];
    
    self.volumnLine.points = [self changeVolumePointWithData:kLineModel.stockArray]; // 换算成实际成交量坐标数组
    self.volumnLine.lineWidth = self.kLineWidth;
    [self.volumnLine setNeedsDisplay];
    
    if([model.timeArray count] > 0){
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@", model.timeArray[0]];
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@", model.timeArray[[model.timeArray count] - 1]];
    }
}

#pragma mark 把股市数据换算成实际的点坐标数组
-(NSArray*)changeKPointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    pointArray = [[NSMutableArray alloc] init];
    CGFloat pointStartX = self.kLineWidth/2.0; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat heightvalue = [[item objectAtIndex:1] floatValue];// 得到最高价
        CGFloat lowvalue = [[item objectAtIndex:2] floatValue];// 得到最低价
        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
        CGFloat yHeight = kLineModel.maxValue - kLineModel.minValue ; // y的价格高度
        CGFloat yViewHeight = self.mainView.frame.size.height ;// y的实际像素高度
        // 换算成实际的坐标
        CGFloat heightPointY = yViewHeight * (1 - (heightvalue - kLineModel.minValue) / yHeight);
        CGPoint heightPoint =  CGPointMake(pointStartX, heightPointY); // 最高价换算为实际坐标值
        CGFloat lowPointY = yViewHeight * (1 - (lowvalue - kLineModel.minValue) / yHeight);;
        CGPoint lowPoint =  CGPointMake(pointStartX, lowPointY); // 最低价换算为实际坐标值
        CGFloat openPointY = yViewHeight * (1 - (openvalue - kLineModel.minValue) / yHeight);;
        CGPoint openPoint =  CGPointMake(pointStartX, openPointY); // 开盘价换算为实际坐标值
        CGFloat closePointY = yViewHeight * (1 - (closevalue - kLineModel.minValue) / yHeight);;
        CGPoint closePoint =  CGPointMake(pointStartX, closePointY); // 收盘价换算为实际坐标值
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(heightPoint),
                                 NSStringFromCGPoint(lowPoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 [catogary objectAtIndex:[data indexOfObject:item]], // 保存日期时间
                                 [item objectAtIndex:3], // 收盘价
                                 [item objectAtIndex:5], // MA5
                                 [item objectAtIndex:6], // MA10
                                 [item objectAtIndex:7], // MA20
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        //[pointArray addObject:[NSNumber numberWithFloat:PointStartX]];
        currentArray = Nil;
        pointStartX += self.kLineWidth + self.kLinePadding; // 生成下一个点的x轴
    }
    pointArray = tempArray;
    return tempArray;
}

#pragma mark 画各种均线
-(void)drawMAWithIndex:(int)index andColor:(NSString*)color{
    NSArray *tempArray = [self changePointWithData:kLineModel.stockArray andMA:index]; // 换算成实际坐标数组
    KLine* averageline = [[KLine alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    averageline.color = color;
    averageline.points = tempArray;
    averageline.isKLine = NO;
    averageline.tag = 8888 + index;
    [self.mainView addSubview:averageline];
}

#pragma mark 把股市数据换算成实际的点坐标数组  MA = 5 为MA5 MA=6 MA10  MA7 = MA20
-(NSArray*)changePointWithData:(NSArray*)data andMA:(int)MAIndex{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = 0.0f; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat currentValue = [[item objectAtIndex:MAIndex] floatValue];// 得到前五天的均价价格
        // 换算成实际的坐标
        CGFloat currentPointY = self.mainView.frame.size.height - ((currentValue - kLineModel.minValue) / (kLineModel.maxValue - kLineModel.minValue) * self.mainView.frame.size.height);
        CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
        [tempArray addObject:NSStringFromCGPoint(currentPoint)]; // 把坐标添加进新数组
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
    }
    return tempArray;
}

#pragma mark 把股市数据换算成成交量的实际坐标数组
-(NSArray*)changeVolumePointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = self.kLineWidth/2; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat volumevalue = [[item objectAtIndex:4] floatValue];// 得到没份成交量
        CGFloat yHeight = kLineModel.maxVolumeValue - kLineModel.minValue ; // y的价格高度
        CGFloat yViewHeight = self.bottomView.frame.size.height ;// y的实际像素高度
        // 换算成实际的坐标
        CGFloat volumePointY = yViewHeight * (1 - (volumevalue - kLineModel.minVolumeValue) / yHeight);
        CGPoint volumePoint =  CGPointMake(PointStartX, volumePointY); // 成交量换算为实际坐标值
        CGPoint volumePointStart = CGPointMake(PointStartX, yViewHeight);
        // 把开盘价收盘价放进去好计算实体的颜色
        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
        CGPoint openPoint =  CGPointMake(PointStartX, closevalue); // 开盘价换算为实际坐标值
        CGPoint closePoint =  CGPointMake(PointStartX, openvalue); // 收盘价换算为实际坐标值
        
        
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(volumePointStart),
                                 NSStringFromCGPoint(volumePoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        currentArray = Nil;
        PointStartX += self.kLineWidth + self.kLinePadding; // 生成下一个点的x轴
        
    }
    NSLog(@"处理完成");
    
    return tempArray;
}

#pragma Action
- (void)mainTapAction:(UITapGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:tap.view];
    if(tap.state == UIGestureRecognizerStateBegan || tap.state == UIGestureRecognizerStateChanged){
        [self hideView:NO];
        int index = point.x/(self.kLineWidth + self.kLinePadding);
        if(index >= 0 && index < [kLineModel.stockArray count]){
            self.priceLabel.text = [NSString stringWithFormat:@"%@", kLineModel.stockArray[index][1]];
            self.moveTimeLabel.text = kLineModel.timeArray[index];
            float width = [HandleString lableWidth:self.moveTimeLabel.text withSize:CGSizeMake(50, 10) withFont:Font(9)];
            self.moveTimeLabel.frame = CGRectMake(self.mainView.frame.origin.x + point.x - width/2, self.bottomView.frame.origin.y + self.bottomView.frame.size.height, width, 10);
            width = [HandleString lableWidth:self.priceLabel.text withSize:CGSizeMake(50, 10) withFont:Font(9)];
            if(point.x > self.frame.size.width/2){
                self.priceLabel.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y + point.y - 5, width + 10, 10);
            }else{
                self.priceLabel.frame = CGRectMake(self.mainView.frame.size.width + self.mainView.frame.origin.x - width -  10, self.mainView.frame.origin.y + point.y - 5, width + 10, 10);
            }
            self.verticalLine.frame = CGRectMake(self.mainView.frame.origin.x + point.x, self.mainView.frame.origin.y, 0.5, self.bottomView.frame.size.height + self.bottomView.frame.origin.y - self.mainView.frame.origin.y);
            self.horizontalLine.frame = CGRectMake(0, point.y, self.mainView.frame.size.width, 0.5);
        }
    }else{
        [self hideView:YES];
    }
}

#pragma Private Method

- (UILabel *)stockNameLabel{
    if(_stockNameLabel == nil){
        _stockNameLabel = [UILabel new];
        _stockNameLabel.textColor = TextFontColor;
        _stockNameLabel.font = Font(8);
    }
    return _stockNameLabel;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [UILabel new];
        _contentLabel.text = @"上证指数 - 日K线图";
        _contentLabel.textColor = TextFontColor;
        _contentLabel.font = Font(8);
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [UILabel new];
        _timeLabel.textColor = TextFontColor;
        _timeLabel.font = Font(8);
        NSDateFormatter* fommater = [NSDateFormatter new];
        fommater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        _timeLabel.text = [fommater stringFromDate:[NSDate date]];
    }
    return _timeLabel;
}

- (UIView *)mainView{
    if(_mainView == nil){
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(40, 20, self.frame.size.width - 60, 100)];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.borderColor = [UIColor grayColor].CGColor;
        _mainView.layer.borderWidth = 0.5;
        _mainView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainTapAction:)];
        [_mainView addGestureRecognizer:tap];
        _mainView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [longPressGestureRecognizer addTarget:self action:@selector(mainTapAction:)];
        [longPressGestureRecognizer setMinimumPressDuration:0.3f];
        [longPressGestureRecognizer setAllowableMovement:50.0];
        [_mainView addGestureRecognizer:longPressGestureRecognizer];
    }
    return _mainView;
}

- (UIView *)bottomView{
    if(_bottomView == nil){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(40, self.mainView.frame.size.height + 40, self.frame.size.width - 60, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderColor = [UIColor grayColor].CGColor;
        _bottomView.layer.borderWidth = 0.5;
    }
    return _bottomView;
}

- (UILabel *)unitLabel{
    if(_unitLabel == nil){
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y - 10, 100, 10)];
        _unitLabel.textColor = TextGrayColor;
        _unitLabel.font = FONT;
    }
    return _unitLabel;
}

- (KLine *)kLine{
    if(_kLine == nil){
        _kLine = [[KLine alloc] initWithFrame:self.mainView.bounds];
        _kLine.lineWidth = self.kLineWidth;
        _kLine.isKLine = YES;
    }
    return _kLine;
}

- (KLine *)volumnLine{
    if(_volumnLine == nil){
        _volumnLine = [[KLine alloc] initWithFrame:self.bottomView.bounds];
        _volumnLine.lineWidth = self.kLineWidth;
        _volumnLine.isKLine = YES;
        _volumnLine.isVol = YES;
    }
    return _volumnLine;
}

- (UILabel *)startTimeLabel{
    if(_startTimeLabel == nil){
        _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + self.bottomView.frame.size.height + 2, 100, 10)];
        _startTimeLabel.textColor = TextGrayColor;
        _startTimeLabel.font = Font(9);
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel{
    if(_endTimeLabel == nil){
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.origin.x + self.bottomView.frame.size.width - 100, self.bottomView.frame.origin.y + self.bottomView.frame.size.height + 2, 100, 10)];
        _endTimeLabel.textColor = TextGrayColor;
        _endTimeLabel.font = Font(9);
        _endTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _endTimeLabel;
}

- (UILabel *)priceLabel{
    if(_priceLabel == nil){
        _priceLabel = [UILabel new];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = Font(9);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _priceLabel;
}

- (UILabel *)moveTimeLabel{
    if(_moveTimeLabel == nil){
        _moveTimeLabel = [UILabel new];
        _moveTimeLabel.textColor = [UIColor whiteColor];
        _moveTimeLabel.font = Font(9);
        _moveTimeLabel.textAlignment = NSTextAlignmentCenter;
        _moveTimeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _moveTimeLabel;
}

- (UIView *)verticalLine{
    if(_verticalLine == nil){
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = TextFontColor;
    }
    return _verticalLine;
}

- (UIView *)horizontalLine{
    if(_horizontalLine == nil){
        _horizontalLine = [UIView new];
        _horizontalLine.backgroundColor = TextFontColor;
    }
    return _horizontalLine;
}

- (void)hideView:(BOOL)isHide{
    if(isHide){
        self.moveTimeLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.verticalLine.hidden = YES;
        self.horizontalLine.hidden = YES;
    }else{
        self.moveTimeLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.verticalLine.hidden = NO;
        self.horizontalLine.hidden = NO;
    }
}

@end
