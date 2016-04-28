//
//  WBJoinTableViewCell.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMyGroupModel.h"

@interface WBGroupTableViewCell : UITableViewCell

@property (nonatomic, retain) WBMyGroupModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isJoin:(BOOL)isJoin;

- (void)setModel:(WBMyGroupModel *)model;

@end
