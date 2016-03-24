//
//  WBAllocateScoreTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAllocateScoreModel.h"

@protocol ScoreClickedEnent <NSObject>
- (void)buttonClickedEvent:(UIButton *)btn;
@end

@interface WBAllocateScoreTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ScoreClickedEnent> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,strong)WBAllocateScoreModel *model ;
-(void)setModel:(WBAllocateScoreModel *)model cellScore:(NSString *)cellScore indexPath:(NSIndexPath *)indexPath;
@end
