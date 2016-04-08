//
//  WBUnlockMessage.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUnlockMessage.h"

@implementation WBUnlockMessage

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.isUnlock = [aDecoder decodeObjectForKey:@"isUnlock"];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.isUnlock forKey:@"isUnlock"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.imageURL forKey:@"imageURL"];
    [dataDict setObject:self.isUnlock forKey:@"isUnlock"];
    [dataDict setObject:self.cityId forKey:@"cityId"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
            self.content = dictionary[@"content"];
            self.imageURL = dictionary[@"imageURL"];
            self.isUnlock = dictionary[@"isUnlock"];
            self.cityId = dictionary[@"cityId"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.content;
}

///消息的类型名
+ (NSString *)getObjectName {
    return WBUnlockMessageIdentifier;
}

@end
