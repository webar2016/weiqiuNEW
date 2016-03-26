//
//  WBUserDefaults.m
//  微球
//
//  Created by 徐亮 on 16/3/17.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUserDefaults.h"
#import "LoadViewController.h"

@implementation WBUserDefaults

+(NSString *)userId{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        LoadViewController *loadView = [[LoadViewController alloc]init];
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [rootViewController presentViewController:loadView animated:YES completion:^{
            NSLog(@"%@",rootViewController);
        }];
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}
+(void)setUserId:(NSString *)userId{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [self setUserDefaultsArrayWithKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+(UIImage *)headIcon{
    return [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"headIcon"]];
}
+(void)setHeadIcon:(UIImage *)headIcon{
    NSData *imageData = UIImageJPEGRepresentation(headIcon, 1.0);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"headIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"headIcon"];
}

+(NSString *)nickname{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
}
+(void)setNickname:(NSString *)nickname{
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"nickname"];
}

+(NSString *)profile{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
}
+(void)setProfile:(NSString *)profile{
    [[NSUserDefaults standardUserDefaults] setObject:profile forKey:@"profile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"profile"];
}

+(NSString *)age{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
}
+(void)setAge:(NSString *)age{
    [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"age"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"age"];
}

+(NSString *)birthday{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
}
+(void)setBirthday:(NSString *)birthday{
    [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"birthday"];
}

+(NSString *)sex{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
}
+(void)setSex:(NSString *)sex{
    [[NSUserDefaults standardUserDefaults] setObject:sex forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"sex"];
}

+(NSString *)province{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"province"];
}
+(void)setProvince:(NSString *)province{
    [[NSUserDefaults standardUserDefaults] setObject:province forKey:@"province"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"province"];
}

+(NSString *)city{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
}

+(void)setCity:(NSString *)city{
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"city"];
}

+(NSString *)totalScore{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"totalScore"];
}
+(void)setTotalScore:(NSString *)totalScore{
    [[NSUserDefaults standardUserDefaults] setObject:totalScore forKey:@"totalScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"totalScore"];
}

+(NSString *)todayScore{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"todayScore"];
}
+(void)setTodayScore:(NSString *)totalScore{
    [[NSUserDefaults standardUserDefaults] setObject:totalScore forKey:@"totalScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"totalScore"];
}

+(NSString *)experience{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"experience"];
}
+(void)setExperience:(NSString *)experience{
    [[NSUserDefaults standardUserDefaults] setObject:experience forKey:@"experience"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setUserDefaultsArrayWithKey:@"experience"];
}

+(id)getSingleUserDefaultsWithUserDefaultsKey:(NSString *)key{
    if (![[self keysInUserDefaults] containsObject:key]) {
        NSLog(@"输入的键不存在------%@",key);
        return nil;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(NSDictionary *)getAllUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *oneKey in [self keysInUserDefaults]) {
        if ([oneKey isEqualToString:@"headIcon"]) {
            dic[@"headIcon"] = [UIImage imageWithData:[userDefaults objectForKey:@"headIcon"]];
        }
        dic[oneKey] = [userDefaults objectForKey:oneKey];
    }
    return dic;
}

+(NSDictionary *)getNeededUserDefaults:(NSArray *)userDefaultsKeyArray{
    for (NSString *oneKey in userDefaultsKeyArray) {
        if (![[self keysInUserDefaults] containsObject:oneKey]) {
            NSLog(@"输入的键不存在------%@",oneKey);
            return nil;
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *oneKey in userDefaultsKeyArray) {
        if ([oneKey isEqualToString:@"headIcon"]) {
            dic[@"headIcon"] = [UIImage imageWithData:[userDefaults objectForKey:@"headIcon"]];
        }
        dic[oneKey] = [userDefaults objectForKey:oneKey];
    }
    return dic;
}

+(void)setMutableUserDefaults:(NSDictionary *)userInfos{
    for (NSString *oneKey in userInfos.allKeys) {
        if (![[self keysInUserDefaults] containsObject:oneKey]) {
            NSLog(@"输入的键不存在------%@",oneKey);
            return;
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *oneKey in userInfos.allKeys) {
        if ([oneKey isEqualToString:@"headIcon"]) {
            [userDefaults setObject:UIImageJPEGRepresentation(userInfos[@"headIcon"], 1.0) forKey:@"headIcon"];
        }
        [userDefaults setObject:userInfos[oneKey] forKey:oneKey];
    }
    [userDefaults synchronize];
}

+(void)deleteAllUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *oneKey in [self keysInUserDefaults]) {
        [userDefaults removeObjectForKey:oneKey];
    }
    [userDefaults removeObjectForKey:@"defaultsArray"];
    [userDefaults synchronize];
}

+(void)deleteSingleUserDefaults:(NSString *)userDefaultsKey{
    NSMutableArray *defaultsArray = (NSMutableArray *)[self keysInUserDefaults];
    if (!defaultsArray || ![defaultsArray containsObject:userDefaultsKey]) {
        NSLog(@"%@------不存在，无法删除",userDefaultsKey);
        return;
    }
    [defaultsArray removeObject:userDefaultsKey];
    [defaultsArray removeObject:userDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:defaultsArray forKey:@"defaultsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)deleteMutableUserDefaults:(NSArray *)userDefaultsKeyArray{
    NSMutableArray *defaultsArray = [NSMutableArray arrayWithArray:[self keysInUserDefaults]];
    for (NSString *oneKey in userDefaultsKeyArray) {
        if (![defaultsArray containsObject:oneKey]) {
            NSLog(@"输入的键不存在------%@",oneKey);
            return;
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *oneKey in userDefaultsKeyArray) {
        [userDefaults removeObjectForKey:oneKey];
        [defaultsArray removeObject:oneKey];
    }
    [userDefaults setObject:defaultsArray forKey:@"defaultsArray"];
    [userDefaults synchronize];
}

+(void)addUserDefaultsWithDictionary:(NSDictionary *)dictionary{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *defaultsArray = [self keysInUserDefaults];
    
    
    for (NSString *oneKey in dictionary.allKeys) {
        [defaultsArray containsObject:oneKey];
        if (![defaultsArray containsObject:oneKey]) {
            [self setUserDefaultsArrayWithKey:oneKey];
            [userDefaults setObject:dictionary[oneKey] forKey:oneKey];
        } else {
            NSLog(@"%@------已存在",oneKey);
        }
        
    }
    [userDefaults synchronize];
}

+(void)printAllKeysInUserDefaults{
    NSLog(@"%@",[self keysInUserDefaults]);
}

+(void)printUserDefaults{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

//将添加的数据的key保存为一个单独的数据数组
+(void)setUserDefaultsArrayWithKey:(NSString *)key{
    NSMutableArray *defaultsArray = [NSMutableArray arrayWithArray:[self keysInUserDefaults]];
    if (defaultsArray && [defaultsArray containsObject:key]) {
        return;
    }
    if (defaultsArray && ![defaultsArray containsObject:key]) {
        [defaultsArray addObject:key];
        [[NSUserDefaults standardUserDefaults] setObject:defaultsArray forKey:@"defaultsArray"];
    }
    if (!defaultsArray) {
        NSMutableArray *firstKey = [NSMutableArray array];
        [firstKey addObject:key];
        [[NSUserDefaults standardUserDefaults] setObject:firstKey forKey:@"defaultsArray"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//返回由存入数据的key组成的数组
+(NSArray *)keysInUserDefaults{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"defaultsArray"];
}

@end
