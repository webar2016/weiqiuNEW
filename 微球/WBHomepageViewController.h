//
//  WBHomepageViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBHomepageViewController : WBRefreshViewController

@property (nonatomic,copy) NSString *userId;
@property (strong, nonatomic) MPMoviePlayerController *player;

@end
