//
//  LoadViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BackDelegate <NSObject>

- (void)loadBack;

@end




@interface LoadViewController : UIViewController

@property (nonatomic, assign) id <BackDelegate> delegate;


@end
