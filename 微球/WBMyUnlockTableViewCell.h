//
//  WBMyUnlockTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/4/27.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTbl_Unlock_City.h"
#import "WBTbl_Unlocking_City.h"

@interface WBMyUnlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(void)setModel:(WBTbl_Unlock_City *)model;
-(void)setUnlockingModel:(WBTbl_Unlocking_City *)model;

@end
