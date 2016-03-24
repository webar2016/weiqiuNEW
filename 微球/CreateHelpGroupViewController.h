//
//  SecondVC.h
//  BROptionsButtonDemo
//
//  Created by Basheer Malaa on 3/10/14.
//  Copyright (c) 2014 Basheer Malaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMainTabBarController.h"

@interface CreateHelpGroupViewController : UIViewController

@property (nonatomic, weak) id<CommonDelegate> commonDelegate;

@property (nonatomic, assign) BOOL fromNextPage;
@property (nonatomic, assign) BOOL fromSlidePage;

@end
