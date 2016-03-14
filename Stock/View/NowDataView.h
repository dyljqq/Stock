//
//  NowDataView.h
//  ShangHaiShiKe
//
//  Created by mac mini on 15/6/18.
//  Copyright (c) 2015年 com.ShangHaiShiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowDataView : UIView {
    UIImageView *imageView;   //没有数据的图片
    UILabel *textLabel;     //文案
}

@property (nonatomic, strong) NSString *text;

- (void)updateImageView:(UIImage*)image height:(float)height;

- (void)addButton:(UIButton *)but height:(float)h;
@end
