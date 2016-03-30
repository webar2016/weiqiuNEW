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
        self.draft = [aDecoder decodeObjectForKey:@"draft"];
        self.groupId = [aDecoder decodeObjectForKey:@"groupId"];
        self.questionId = [aDecoder decodeObjectForKey:@"questionId"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.draft forKey:@"draft"];
    [aCoder encodeObject:self.groupId forKey:@"groupId"];
    [aCoder encodeObject:self.questionId forKey:@"questionId"];
}

@end
