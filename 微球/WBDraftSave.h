//
//  WBDraftSave.h
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import <Foundation/Foundation.h>

@interface WBDraftSave : NSObject <NSCoding>

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *questionId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, copy) NSString *imageRate;

@end
