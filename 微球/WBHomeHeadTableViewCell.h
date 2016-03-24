//
//  WBHomeHeadTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadDelegate <NSObject>

- (void)pushViewBtnClicked:(UIButton *)btn;
- (void)changeTableViewBody:(NSInteger)Number;

@end


@interface WBHomeHeadTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSelfHomePage:(BOOL)isSelfHomePage;

-(void)setUIWithUserInfo:(NSDictionary *)userInfo;

@property (nonatomic,assign) id<HeadDelegate>delegate;

@end
