//
//  WBGroupInfoController.h
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressChoicePickerView.h"
#import "AreaObject.h"

@interface WBGroupInfoController : WBRefreshViewController

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic,assign) NSInteger index;

@end
