//
//  WBMyUnlockTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/4/27.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMyUnlockTableViewCell.h"
#import "WBTbl_Unlock_City.h"

#import "UIImageView+WebCache.h"
#import "WBLocateList.h"

@implementation WBMyUnlockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headImageView.backgroundColor = [UIColor initWithBackgroundGray];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 0;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(WBTbl_Unlock_City *)model{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    _nameLabel.text = [WBLocateList myGetPositionNameById:model.cityId];

}

-(void)setUnlockingModel:(WBTbl_Unlocking_City *)model{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.photoPath]];
    _nameLabel.text = [WBLocateList myGetPositionNameById:[model.cityId integerValue]];
}


-(void)setUnlockSceneryModel:(WB_Unlock_Scenery *)UnlockSceneryModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:UnlockSceneryModel.unlockDir]];
    _nameLabel.text = UnlockSceneryModel.sceneryId;
    
}

-(void)setUnlockingSceneryModel:(WB_Unlocking_Scenery *)UnlockingSceneryModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:UnlockingSceneryModel.unlockDir]];
    _nameLabel.text = UnlockingSceneryModel.sceneryId;
}





@end
