//
//  WBHelp_Group_Sign.h
//  微球
//
//  Created by 贾玉斌 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBHelp_Group_Sign : NSObject
@property (nonatomic,assign)int Id;
@property (nonatomic,assign) NSInteger sign_id;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *sign_describe;
@property (nonatomic,copy) NSString *type_flag;
@end
