//
//  WBIntroView.m
//  微球
//
//  Created by 徐亮 on 16/5/25.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBIntroView.h"
#import "NSString+string.h"

@interface WBIntroView () {
    NSString *_name;
}

@end

@implementation WBIntroView

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name introduction:(NSString *)introduction{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpWithImage:image name:name introduction:introduction];
    }
    return self;
    
    
}

- (void)setUpWithImage:(UIImage *)image name:(NSString *)name introduction:(NSString *)introduction {
    _name = name;
    CGFloat width = SCREENWIDTH  - 60;
    CGFloat maxHeight = SCREENHEIGHT - 60 - 70;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8;
    [scrollView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, width - 120, 60)];
    nameLabel.font = BIGFONTSIZE;
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = [UIColor initWithLightGray];
    nameLabel.text = name;
    [scrollView addSubview:nameLabel];
    
    CGSize introSize = [introduction adjustSizeWithWidth:width - 30 andFont:MAINFONTSIZE];
    UILabel *introLabel = [[UILabel alloc] initWithFrame:(CGRect){{20,100},introSize}];
    introLabel.font = MAINFONTSIZE;
    introLabel.textColor = [UIColor initWithNormalGray];
    introLabel.text = introduction;
    introLabel.numberOfLines = 0;
    [scrollView addSubview:introLabel];
    
    CGFloat currentHeight = CGRectGetMaxY(introLabel.frame);
    scrollView.contentSize = CGSizeMake(width, currentHeight);
    
    CGFloat height = currentHeight > maxHeight ? maxHeight : currentHeight + 40;
    
    scrollView.frame = CGRectMake(0, 0, width, height - 40);
    self.frame = CGRectMake(30, 30, width, height);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    [self addSubview:scrollView];
    
    UIButton *closeView = [[UIButton alloc] initWithFrame:CGRectMake(width - 80, height - 30, 60, 20)];
    [closeView setTitle:@"关闭介绍" forState:UIControlStateNormal];
    [closeView setTitleColor:[UIColor initWithDarkGray] forState:UIControlStateNormal];
    closeView.titleLabel.font = MAINFONTSIZE;
    [closeView addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeView];
    
    
    if (![name isEqualToString:@"头像"]) {
        UIButton *unlock = [[UIButton alloc] initWithFrame:CGRectMake(20, height - 30, 100, 20)];
        [unlock setTitle:@"解锁这个景点" forState:UIControlStateNormal];
        [unlock setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
        unlock.titleLabel.font = MAINFONTSIZE;
        [unlock addTarget:self action:@selector(enterUnlockVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unlock];
    }else{
        nameLabel.text = @"问题";
        [closeView setTitle:@"关闭" forState:UIControlStateNormal];
    }
    
    
    
}

- (void)enterUnlockVC {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBubbleHandleWithName:)]) {
        [self closeView];
        [self.delegate clickBubbleHandleWithName:_name];
    }
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
