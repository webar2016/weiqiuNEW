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
    CGFloat _scale;
    BOOL _isFullWidth;
}

-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
         self.view.backgroundColor = [UIColor blackColor];
        [self setUpImageWithImage:image];
        [self setUpSaveButtonForImage];
    }
    return self;
}

-(instancetype)initWithDir:(NSString *)dir{
    if (self = [super init]) {
         self.view.backgroundColor = [UIColor blackColor];
        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dir]]];
        [self setUpImageWithImage:image];
        [self setUpSaveButtonForImage];
    }
    return self;
}

-(instancetype)initWithDir:(NSString *)dir andContent:(NSString *)content{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blackColor];
        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dir]]];
        [self setUpImageWithImage:image];
        [self setUpContentWithContent:content];
        [self setUpSaveButtonForImage];
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
    CGFloat maximumZoomScale;
    _scale = 1;
    
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    
    if (rate <= 1.78) {
        showWidth = SCREENWIDTH;
        showHeight = showWidth * rate;
        maximumZoomScale = 1.78/rate;
    } else {
        showHeight = SCREENHEIGHT;
        showWidth = showHeight / rate;
        maximumZoomScale = rate/1.78;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    _scrollView.maximumZoomScale=maximumZoomScale*3;//图片的放大倍数
    
    _scrollView.minimumZoomScale=1.0;//图片的最小倍率
    _scrollView.delegate = self;
  //  _scrollView.canCancelContentTouches = YES;
    
    _imageView.frame = CGRectMake(0, 0, showWidth, showHeight);
    _imageView.center = self.view.center;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewer)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tapImgViewTwice];
    [tap requireGestureRecognizerToFail:tapImgViewTwice];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImageView:)];
    [_scrollView addGestureRecognizer:pinch];

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
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    
    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapImgViewTwice];
    
    [tap requireGestureRecognizerToFail:tapImgViewTwice];
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImageView:)];
    
    [self.view addGestureRecognizer:pinch];
    
    
}


#pragma mark ------scrollView delegate----

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
    if (_imageView.frame.size.height > SCREENHEIGHT) {
        if (_imageView.frame.size.width>SCREENWIDTH) {
            _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width,  _imageView.frame.size.height);
        }else{
            _imageView.frame = CGRectMake((SCREENWIDTH - _imageView.frame.size.width)/2, 0, _imageView.frame.size.width,  _imageView.frame.size.height);
        }
    }else{
        _imageView.frame = CGRectMake(_imageView.frame.origin.x, (SCREENHEIGHT - _imageView.frame.size.height)/2, _imageView.frame.size.width,  _imageView.frame.size.height);
    }
}



-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    if (_imageView.frame.size.height > SCREENHEIGHT) {
        if (_imageView.frame.size.width>SCREENWIDTH) {
            _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width,  _imageView.frame.size.height);
        }else{
            _imageView.frame = CGRectMake((SCREENWIDTH - _imageView.frame.size.width)/2, 0, _imageView.frame.size.width,  _imageView.frame.size.height);
        }
    }else{
        _imageView.frame = CGRectMake(_imageView.frame.origin.x, (SCREENHEIGHT - _imageView.frame.size.height)/2, _imageView.frame.size.width,  _imageView.frame.size.height);
    }
    return _imageView;//要放大的视图
}

-(void)tapImgViewHandleTwice:(UITapGestureRecognizer *)tap{
    if (_scrollView.zoomScale>1) {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.zoomScale=1.0;
            _imageView.center = self.view.center;
            _scale = 1;
        }];
    }else{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.zoomScale=_scrollView.maximumZoomScale/3;//双击放大到两倍
        _scale = _scrollView.maximumZoomScale/3;
    }];
    }
    
}

-(void)pinchImageView:(UIPinchGestureRecognizer *)pinch{
    
 //   NSLog(@"------");
    if (pinch.state == UIGestureRecognizerStateEnded) {
        _scale = _scale*pinch.scale;
        if (_scale>_scrollView.maximumZoomScale) {
            _scale = _scrollView.maximumZoomScale;
        }
        _scrollView.zoomScale = _scale;
        
    }else{
        _scrollView.zoomScale =_scale*pinch.scale;
    }
}

-(void)setUpSaveButtonForImage{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, 10, 40, 35)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveThisImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

-(void)saveThisImage{
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    if (error) {//error.userInfo[@"NSLocalizeDescription"] == @"Data unavailable"
        [self showHUDText:@"保存失败，无相册权限"];
        return;
    }
    [self showHUDText:@"保存成功"];
}

@end
