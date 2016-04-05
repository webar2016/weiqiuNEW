//
//  WBAttentionTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBFansModel.h"
#import "MBProgressHUD.h"

@protocol progressState <NSObject>
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@end

@interface WBAttentionTableViewCell : UITableViewCell


@property (nonatomic,strong)WBFansModel *model;
@property (nonatomic,copy)NSString *fansId;

@property(nonatomic,assign)id<progressState>delegate;

@end
