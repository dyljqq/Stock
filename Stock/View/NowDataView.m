//
//  NowDataView.m
//  ShangHaiShiKe
//
//  Created by mac mini on 15/6/18.
//  Copyright (c) 2015年 com.ShangHaiShiKe. All rights reserved.
//

#import "NowDataView.h"

@implementation NowDataView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUND_COLOR;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 46) / 2, (frame.size.height - 67)/2, 46, 38)];
        [imageView setImage:[UIImage imageNamed:@"icon-kong"]];
        [self addSubview:imageView];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + 16, self.frame.size.width, 13)];
        textLabel.font = Font(13);
        textLabel.textColor = TextGrayColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    textLabel.text = text;
}

- (void)updateImageView:(UIImage*)image height:(float)height{
    imageView.image = image;
    CGRect frame = imageView.frame;
    frame.origin.y = (self.frame.size.height - height - 29)/2;
    frame.size.height = height;
    imageView.frame = frame;
    frame = textLabel.frame;
    frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + 16;
    textLabel.frame = frame;
}

- (void)addButton:(UIButton *)but height:(float)h {
    [but setFrame:CGRectMake(but.frame.origin.x, textLabel.frame.origin.y + h, but.frame.size.width, but.frame.size.height)];
    [self addSubview:but];    
}
@end
