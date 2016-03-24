//
//  WBLeftViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/2/27.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface WBLeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    UIImageView     *_userIcon;
    UILabel         *_nickName;
    UITextView      *_profile;
    UILabel         *_totalScoreNumber;
    UILabel         *_todayScoreNumber;
}

@end
