//
//  WBHomepageViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WBHomepageViewController : UIViewController

@property (nonatomic,copy) NSString *userId;



@property (nonatomic,strong)MBProgressHUD *hud;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@property (strong, nonatomic) MPMoviePlayerController *player;
@end
