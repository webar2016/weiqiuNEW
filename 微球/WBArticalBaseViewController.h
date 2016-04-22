//
//  WBArticalBaseViewController.h
//  微球
//
//  Created by 徐亮 on 16/4/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBRefreshViewController.h"
#import "WBTextAttachment.h"
#import "AFHTTPSessionManager.h"
#import "NSAttributedString + attributedString.h"
#import "NSString+string.h"
#import "WBImage.h"
#import "WBDraftSave.h"
#import "WBDraftManager.h"

@interface WBArticalBaseViewController : WBRefreshViewController

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableDictionary *parameters;

- (void)setParameters;

- (NSDictionary *)draftDic;

@end
