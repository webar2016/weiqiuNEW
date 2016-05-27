//
//  WBWebViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/30.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBWebViewController : UIViewController

@property (nonatomic, assign) BOOL mapView;
-(instancetype)initWithUrl:(NSURL *)url andTitle:(NSString *)title;

@end
