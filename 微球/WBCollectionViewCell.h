//
//  WBCollectionViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCollectionViewModel.h"
#define CollectionCellWidth (SCREENWIDTH-30)/2


@protocol CollectionGoHomePage <NSObject>

-(void)goHomepage:(NSString *)userId;

@end

@interface WBCollectionViewCell : UICollectionViewCell
{
   
    UIView *_backgroundViewTop;
    UIView *_backgroundViewButtom;
    UIImageView *_headImageView;
    UILabel *_nickName;
    UILabel *_timelabel;
    
    
    UIButton *_ageButton;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UILabel *_localLabel;
    
}

@property (nonatomic, copy)UIImageView *mainImageView;

@property(nonatomic,weak)WBCollectionViewModel *model;
- (void)setModel:(WBCollectionViewModel *)model imageHeight:(CGFloat)imageHeight;

@property(nonatomic,assign)id <CollectionGoHomePage> delegate;

@end

