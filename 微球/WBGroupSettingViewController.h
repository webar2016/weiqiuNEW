//
//  WBGroupSettingViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBGroupSettingViewController : UITableViewController

@property (nonatomic, assign) BOOL isMaster;

@property (nonatomic, assign) BOOL isPush;

@property (nonatomic, assign) NSString *groupId;

@end
