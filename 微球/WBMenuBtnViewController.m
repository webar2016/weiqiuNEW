//
//  WBMenuBtnViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMenuBtnViewController.h"

@interface WBMenuBtnViewController ()

@end

@implementation WBMenuBtnViewController



//创建悬浮按钮

-(void)createMenuButton{
    //点击悬浮按钮后的透明度
    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundView.alpha = 0;
    _backgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_backgroundView];
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *BGTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
    [_backgroundView addGestureRecognizer:BGTap];
    
    
    //旋转菜单按钮
    _imageViewMenu= [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, self.view.frame.size.height-150, 37, 37)];
    
    _imageViewMenu.image = [UIImage imageNamed:@"btn_cancel.png"];
    _imageViewMenu.transform = CGAffineTransformMakeRotation(M_PI/4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
    _imageViewMenu.userInteractionEnabled = YES;
    [_imageViewMenu addGestureRecognizer:tap];
    [self.view addSubview:_imageViewMenu];
    
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30+15, self.view.frame.size.height-150, 64  , 30)];
    _photoImageView.image = [UIImage imageNamed:@"btn_photo.png"];
    _photoImageView.alpha = 0;
    [self.view addSubview:_photoImageView];
    
    _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30, self.view.frame.size.height-150, 79  , 30)];
    _videoImageView.image = [UIImage imageNamed:@"icon_video.png"];
    _videoImageView.alpha = 0;
    [self.view addSubview:_videoImageView];
    
    _textImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30, self.view.frame.size.height-150, 79  , 30)];
    _textImageView.image = [UIImage imageNamed:@"btn_ariticle.png"];
    _textImageView.alpha = 0;
    [self.view addSubview:_textImageView];
}


//菜单栏按钮动画效果
-(void)menuBtnClicled{
    if (_backgroundView.alpha == 0) {
        _photoImageView.alpha = 1;
        _videoImageView.alpha = 1;
        _textImageView.alpha  = 1;
        _backgroundView.alpha = 0.5;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _imageViewMenu.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
        }];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame1 = _photoImageView.frame;
            frame1.origin.y -=70;
            _photoImageView.frame = frame1;
            CGRect frame2 = _videoImageView.frame;
            frame2.origin.y -=140;
            _videoImageView.frame = frame2;
            CGRect frame3 = _textImageView.frame;
            frame3.origin.y -=210;
            _textImageView.frame = frame3;
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _backgroundView.alpha = 0;
            _imageViewMenu.transform = CGAffineTransformMakeRotation(M_PI/4);
            CGRect frame1 = _photoImageView.frame;
            frame1.origin.y +=70;
            _photoImageView.frame = frame1;
            CGRect frame2 = _videoImageView.frame;
            frame2.origin.y +=140;
            _videoImageView.frame = frame2;
            CGRect frame3 = _textImageView.frame;
            frame3.origin.y +=210;
            _textImageView.frame = frame3;
        } completion:^(BOOL finished) {
            _photoImageView.alpha = 0;
            _videoImageView.alpha = 0;
            _textImageView.alpha  = 0;
        }];
    }
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
