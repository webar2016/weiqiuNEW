//
//  WBMenuBtnViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/4/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBPostIamgeViewController.h"
#import "WBPostArticleViewController.h"
#import "WBPostVideoViewController.h"

@interface WBMenuBtnViewController : WBRefreshViewController
{
    UIView *_backgroundView;
    //悬浮按钮
    UIImageView *_imageViewMenu;
    //photo
    UIImageView *_photoImageView;
    //段视频按钮
    UIImageView *_videoImageView;
    //text
    UIImageView *_textImageView;

}

-(void)createMenuButton;

-(void)menuBtnClicled;
@end
