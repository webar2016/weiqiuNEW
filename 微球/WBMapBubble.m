//
//  WBMapBubble.m
//  微球
//
//  Created by 徐亮 on 16/5/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMapBubble.h"

@interface WBMapBubble ()

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UITextView *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *unlockLabel;

@end

@implementation WBMapBubble

#define kArrorHeight        10
#define kPortraitMargin     5
#define kPortraitHeight     40

#define kTitleWidth         200
#define kTitleHeight        20

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin * 2, kPortraitMargin * 2, kPortraitHeight, kPortraitHeight)];
    
    self.portraitView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.portraitView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 4 + kPortraitHeight, kPortraitMargin * 4, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    
    
    self.subtitleLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 60, self.frame.size.width-20, self.frame.size.height-100)];
    self.subtitleLabel.allowsEditingTextAttributes = NO;
    self.subtitleLabel.editable = NO;
    
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.font = MAINFONTSIZE;
    self.subtitleLabel.text = @"titletitletitletitle";
    [self addSubview:self.subtitleLabel];
    
    self.unlockLabel = [[UILabel alloc]init];
    self.unlockLabel.frame = CGRectMake(self.frame.size.width-170, self.frame.size.height-40, 150, 30);
    self.unlockLabel.text = @"解锁这个景点";
    self.unlockLabel.textAlignment = NSTextAlignmentRight;
    self.unlockLabel.textColor = [UIColor initWithGreen];
    self.unlockLabel.font = MAINFONTSIZE;
    [self addSubview:self.unlockLabel];
    
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}

-(void)setIntroduction:(NSString *)introduction{
    self.subtitleLabel.text = introduction;
}

-(void)setIsUnlock:(BOOL)isUnlock{
    if (!isUnlock) {
        self.unlockLabel.alpha =1;
    }else{
        self.unlockLabel.alpha = 0;
    }
}

@end
