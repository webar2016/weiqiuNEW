//
//  WBDraftSave.h
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import <Foundation/Foundation.h>

@interface WBDraftSave : NSObject <NSCoding>

@property (nonatomic, strong) NSTextStorage *draft;

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *questionId;

@end
