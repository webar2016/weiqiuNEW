//
//  NSAttributedString + attributedString.h
//  微球
//
//  Created by 徐亮 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (NSAttributedString)

- (NSString *)getPlainStringWithImageArray:(NSMutableArray *)imageArray byNameArray:(NSMutableArray *)nameArray byImageRate:(NSMutableArray *)rateArray;


//-(void)replacePlaceHolderImageWithImages:(NSArray *)imageArray;

@end
