//
//  WBImageViewer.m
//  微球
//
//  Created by 徐亮 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBImageViewer.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "NSString+string.h"

@implementation WBImageViewer {
    UIImageView *_imageView;
}

-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
         self.view.backgroundColor = [UIColor blackColor];
        [self setUpImageWithImage:image];
    }
    return self;
}

-(instancetype)initWithDir:(NSString *)dir{
    if (self = [super init]) {
         self.view.backgroundColor = [UIColor blackColor];
        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dir]]];
        [self setUpImageWithImage:image];
    }
    return self;
}

-(instancetype)initWithDir:(NSString *)dir andContent:(NSString *)content{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blackColor];
        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dir]]];
        [self setUpImageWithImage:image];
        [self setUpContentWithContent:content];
    }
    return self;
}

-(void)closeViewer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpImageWithImage:(UIImage *)image{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat rate = height / width;
    
    CGFloat showWidth;
    CGFloat showHeight;
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    
    if (rate <= 1.78) {
        showWidth = SCREENWIDTH;
        showHeight = showWidth * rate;
    } else {
        showHeight = SCREENHEIGHT;
        showWidth = showHeight / rate;
    }
    
    _imageView.frame = CGRectMake(0, 0, showWidth, showHeight);
    _imageView.center = self.view.center;
    
    [self.view addSubview:_imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewer)];
    [self.view addGestureRecognizer:tap];
}

-(void)setUpContentWithContent:(NSString *)content{
    UIView *wraperView = [[UIView alloc] initWithFrame:CGRectZero];
    wraperView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = MAINFONTSIZE;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 0;
    CGSize labelSize = [content adjustSizeWithWidth:(SCREENWIDTH - 40) andFont:MAINFONTSIZE];
    contentLabel.frame = CGRectMake(20, 10, SCREENWIDTH - 40, labelSize.height);
    contentLabel.text = content;
    [wraperView addSubview:contentLabel];
    wraperView.frame = CGRectMake(0, SCREENHEIGHT - labelSize.height - 20, SCREENWIDTH, labelSize.height + 20);
    [self.view addSubview:wraperView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewer)];
    [self.view addGestureRecognizer:tap];
}

@end
