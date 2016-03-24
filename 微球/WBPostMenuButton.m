//
//  WBPostMenuButton.m
//  微球
//
//  Created by 贾玉斌 on 16/3/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostMenuButton.h"

@interface WBPostMenuButton ()
{
    UIView *_backgroundView;
    UIImageView *_imageViewMenu;
    UIImageView *_photoImageView;
    UIImageView *_videoImageView;
    UIImageView *_textImageView;
}
@end



@implementation WBPostMenuButton

-(instancetype)initWithFrame:(CGRect)frame PointX:(CGFloat)pointX PointY:(CGFloat)pointY superView:(UIView *)superView{
    self = [super initWithFrame:frame];
    if (self) {
       // [superView addSubview:self];
        self.frame = frame;
        self.backgroundColor = [UIColor grayColor];
        
        self.alpha = 0;
    //    [superView addSubview:_backgroundView];
        
        //旋转菜单按钮
        _imageViewMenu= [[UIImageView alloc]initWithFrame:CGRectMake(pointX, pointY, 37, 37)];
        
        _imageViewMenu.image = [UIImage imageNamed:@"btn_cancel.png"];
        _imageViewMenu.transform = CGAffineTransformMakeRotation(M_PI/4);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
        _imageViewMenu.userInteractionEnabled = YES;
        [_imageViewMenu addGestureRecognizer:tap];
        [superView addSubview:_imageViewMenu];
        //上传照片
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pointX-35, pointY, 64  , 30)];
        _photoImageView.image = [UIImage imageNamed:@"btn_photo.png"];
        UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
        _photoImageView.userInteractionEnabled = YES;
        [_photoImageView addGestureRecognizer:tapPhoto];
        _photoImageView.alpha = 0;
        [superView addSubview:_photoImageView];
        //上传视频
        _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pointX-50, pointY, 79  , 30)];
        _videoImageView.image = [UIImage imageNamed:@"icon_video.png"];
        UITapGestureRecognizer *tapMedio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
        _videoImageView.userInteractionEnabled = YES;
        [_videoImageView addGestureRecognizer:tapMedio];
        _videoImageView.alpha = 0;
        [superView addSubview:_videoImageView];
        
        //上传文字
        _textImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pointX-50, pointY, 79  , 30)];
        _textImageView.image = [UIImage imageNamed:@"btn_ariticle.png"];
        UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
        _textImageView.userInteractionEnabled = YES;
        [_textImageView addGestureRecognizer:tapText];
        _textImageView.alpha = 0;
        [superView addSubview:_textImageView];

        
    }
    return self;

}
        //点击悬浮按钮后的透明度
        
     
        

-(void)menuBtnClicled{
    if ( self.alpha ==0) {
       self.alpha = 0.5;

        _photoImageView.alpha = 1;
        _videoImageView.alpha = 1;
        _textImageView.alpha  = 1;
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
            self.alpha = 0;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
