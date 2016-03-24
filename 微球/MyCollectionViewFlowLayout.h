//
//  MyCollectionViewFlowLayout.h
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, assign) NSInteger cellCount;//cell的个数
@property (nonatomic, strong) NSMutableArray *colArr;//存放列的高度
@property (nonatomic, strong) NSMutableDictionary *attributeDict;//存放cell的位置信息
@end
