//
//  WBRefreshViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/5.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBRefreshViewController.h"

@interface WBRefreshViewController ()

@end

@implementation WBRefreshViewController

-(void)showHUDText:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.opacity = 0.7;
        self.hud.dimBackground = NO;
        self.hud.labelText = title;
        [self hideHUDDelay:1.0];
    });
    
}

-(void)showHUDIndicator{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.activityIndicatorColor = [UIColor blackColor];
         });
}

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.opacity = 0.7;
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
        });
}

-(void)showHUDComplete:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    self.hud.opacity = 0.7;
    [self hideHUDDelay:1.0];
        });
}

-(void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self hideHUDDelay:0];
        });
}

-(void)hideHUDDelay:(NSTimeInterval)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.hud hide:YES afterDelay:delay];
        });
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
