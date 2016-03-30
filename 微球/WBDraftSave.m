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
//        self.imageArray = [aDecoder decodeObjectForKey:@"imageArray"];
//        self.nameArray = [aDecoder decodeObjectForKey:@"nameArray"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.groupId forKey:@"groupId"];
    [aCoder encodeObject:self.questionId forKey:@"questionId"];
    [aCoder encodeObject:self.content forKey:@"content"];
//    [aCoder encodeObject:self.imageArray forKey:@"imageArray"];
//    [aCoder encodeObject:self.nameArray forKey:@"nameArray"];
}

@end
