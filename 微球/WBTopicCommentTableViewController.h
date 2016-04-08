//
//  WBTopicCommentTableViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface WBTopicCommentTableViewController : WBRefreshViewController

@property (nonatomic,assign)NSInteger commentId;

@property (nonatomic,copy)NSString *userId;

@end
