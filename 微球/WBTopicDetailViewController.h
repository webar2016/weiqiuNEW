//
//  WBTopicDetailViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WBPostMenuButton.h"
#import <MediaPlayer/MediaPlayer.h>


@interface WBTopicDetailViewController : UIViewController

@property (nonatomic,assign) NSInteger topicID;

@property (strong, nonatomic) MPMoviePlayerController *player; 
@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;




@end
