//
//  WBDraftSave.m
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import "WBDraftSave.h"

@implementation WBDraftSave

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        self.groupId = [aDecoder decodeObjectForKey:@"groupId"];
        self.questionId = [aDecoder decodeObjectForKey:@"questionId"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.topicId = [aDecoder decodeObjectForKey:@"topicId"];
        self.imageRate = [aDecoder decodeObjectForKey:@"imageRate"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.groupId forKey:@"groupId"];
    [aCoder encodeObject:self.questionId forKey:@"questionId"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.topicId forKey:@"topicId"];
    [aCoder encodeObject:self.imageRate forKey:@"imageRate"];
}

@end
