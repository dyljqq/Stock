//
//  JQQSearchBar.m
//  DDTG
//
//  Created by 季勤强 on 16/3/30.
//  Copyright © 2016年 翟玉磊. All rights reserved.
//

#import "JQQSearchBar.h"

@interface JQQSearchBar ()<UISearchBarDelegate>

@property (nonatomic, strong)UISearchBar* searchBar;
@property (nonatomic, strong)UITextField* textField;

@end

@implementation JQQSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initParam];
    }
    return self;
}

- (void)initParam{
    self.backgroundColor = BACKGROUND_COLOR;
    [self.searchBar becomeFirstResponder];
    //去除searcbar背景
    for (UIView *view in self.searchBar.subviews){
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0){
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self addSubview:self.searchBar];
}

#pragma Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [[NSNotificationCenter defaultCenter] postNotificationName:JQQSearchBarCallbackData object:nil userInfo:@{@"searchText": searchText}];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma Private Method

- (UISearchBar *)searchBar{
    if(_searchBar == nil){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SIZE.width, 44)];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.backgroundColor = [UIColor clearColor];
    }
    return _searchBar;
}

@end
