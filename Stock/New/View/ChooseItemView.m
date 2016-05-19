//
//  ChooseItemView.m
//  DDTG
//
//  Created by 季勤强 on 16/5/11.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "ChooseItemView.h"

@implementation ChooseItemView{
    NSInteger tag;
    NSInteger originIndex;
    NSArray* itemArray;
}

- (instancetype)initWithArray:(NSArray *)items{
    self = [super init];
    if(self){
        itemArray = items;
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = TextGrayColor;
    
    tag = 0;
    
    CGFloat ratio = 1.0 / [itemArray count];
    UIView* lastView = nil;
    for (NSString* title in itemArray) {
        UIView* subView = [self addView:title];
        [self addSubview:subView];
        if(lastView == nil){
            ((UILabel*)[subView viewWithTag:8888]).textColor = NavColor;
            [subView viewWithTag:8889].hidden = NO;
        }
        [subView mas_makeConstraints:^(MASConstraintMaker* make){
            make.width.equalTo(self).multipliedBy(ratio);
            make.height.and.top.equalTo(self);
            if(lastView){
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(self);
            }
        }];
        lastView = subView;
    }
}

- (void)itemDidChooseByIndex:(NSInteger)index{
    if(index == originIndex){
        return ;
    }
    [self changeItemStyle:[self viewWithTag:index] changeeItem:[self viewWithTag:originIndex]];
    originIndex = index;
}

#pragma Action

- (void)itemDidTouch:(UITapGestureRecognizer*)tap{
    [self itemDidChooseByIndex:tap.view.tag];
    if ([self.delegate respondsToSelector:@selector(chooseItemViewDidSelect:)]) {
        [self.delegate chooseItemViewDidSelect:tap.view.tag];
    }
}

#pragma Private Method

- (UIView*)addView:(NSString*)title{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.tag = tag++;
    
    UILabel* label = [UILabel new];
    label.text = title;
    label.textColor = self.textColor;
    label.font = Font(15);
    label.tag = 8888;
    [view addSubview:label];
    
    UIView* line = [UIView new];
    line.backgroundColor = NavColor;
    line.hidden = YES;
    line.tag = 8889;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidTouch:)];
    [view addGestureRecognizer:tap];
    view.userInteractionEnabled = YES;
    
    [view addSubview:label];
    [view addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker* make){
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(view);
        make.width.equalTo(label).offset(8);
    }];
    
    return view;
}

- (void)changeItemStyle:(UIView*)view changeeItem:(UIView*)changedView{
    ((UILabel*)[view viewWithTag:8888]).textColor = NavColor;
    [view viewWithTag:8889].hidden = NO;
    
    ((UILabel*)[changedView viewWithTag:8888]).textColor = self.textColor;
    [changedView viewWithTag:8889].hidden = YES;
}

@end
