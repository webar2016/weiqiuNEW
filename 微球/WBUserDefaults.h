//
//  WBUserDefaults.h
//  微球
//
//  Created by 徐亮 on 16/3/17.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBUserDefaults : NSObject

/**
 *名称     键             类型
 
 *ID      userId         NSString
 *头像     headIcon       UIImage
 *昵称     nickname       NSString
 *签名     profile        NSString
 *年龄     age            NSString
 *生日     birthday       NSString
 *性别     sex            NSString
 *省份     province       NSString
 *城市     city           NSString
 *总收益   totalScore     NSString
 *今日收益  todayScore    NSString
 *经验     experience     NSString
 */
/*
age = 0;
areaId = 0;
cityNum = 0;
concerns = 0;
countryId = 0;
dir = "http://microball.oss-cn-hangzhou.aliyuncs.com/disk/webar/1447/ef851169-1eac-4619-8e48-60346378e704.jpg";
fans = 0;
isFriend = 0;
nickname = "";
profile = "\U4ecb\U7ecd\U4e00\U4e0b\U4f60\U81ea\U5df1\U5427";
provinceNum = 0;
qNum = 0;
sex = "\U7537";
state = 0;
userId = 1447;
username = 15001125798;
*/
/**
 *NSUserDefaults可存入数据类型：NSNumber(NSInteger、float、double),NSString,NSDate,NSArray,NSDictionary,BOOL,NSData
 *
 *除头像headIcon外，其余图片数据存入与取出均为NSData类型
 */

/**
 *存取单条数据
 */

+(NSString *)userId;
+(void)setUserId:(NSString *)userId;

+(NSString *)dir;
+(void)setDir:(NSString *)dir;

+(UIImage *)headIcon;
+(void)setHeadIcon:(UIImage *)headIcon;

+(NSString *)nickname;
+(void)setNickname:(NSString *)nickname;

+(NSString *)profile;
+(void)setProfile:(NSString *)profile;

+(NSString *)age;
+(void)setAge:(NSString *)age;

+(NSString *)birthday;
+(void)setBirthday:(NSString *)birthday;

+(NSString *)sex;
+(void)setSex:(NSString *)sex;

+(NSString *)province;
+(void)setProvince:(NSString *)province;

+(NSString *)city;
+(void)setCity:(NSString *)city;

+(NSString *)totalScore;
+(void)setTotalScore:(NSString *)totalScore;

+(NSString *)todayScore;
+(void)setTodayScore:(NSString *)totalScore;

+(NSString *)experience;
+(void)setExperience:(NSString *)experience;

+(NSString *)token;
+(void)setToken:(NSString *)token;

/**
 *存取数据
 *@ getSingleUserDefaultsWithUserDefaultsKey - 取出单条数据，传入key
 *
 *@ getAllUserDefaults - 取出所有自定义数据，返回字典
 *
 *@ getNeededUserDefaults: - 取出需要的数据，返回字典，头像取出UIImage对象
 *  userDefaultsKeyArray - 数组，由NSString构成，字符串为NSUserDefaults中的键
 *
 *@ setMutableUserDefaults: - 存入数据
 *  userInfos - 字典，键应与想要存入NSUserDefaults中的键相同，头像存入UIImage对象
 */

+(id)getSingleUserDefaultsWithUserDefaultsKey:(NSString *)key;
+(NSDictionary *)getAllUserDefaults;
+(NSDictionary *)getNeededUserDefaults:(NSArray *)userDefaultsKeyArray;
+(void)setMutableUserDefaults:(NSDictionary *)userInfos;

/**
 *删除数据
 *@ deleteAllUserDefaults - 删除所有自定义数据
 *
 *@ deleteSingleUserDefaults: - 删除一条数据，传入key
 *
 *@ deleteMutableUserDefaults: - 删除多条数据，传入key array
 */

+(void)deleteAllUserDefaults;
+(void)deleteSingleUserDefaults:(NSString *)userDefaultsKey;
+(void)deleteMutableUserDefaults:(NSArray *)userDefaultsKeyArray;

/**
 *添加一条新的数据
 *@ addUserDefaultsWithDictionary: - 传入想要存储的字典
 */

+(void)addUserDefaultsWithDictionary:(NSDictionary *)dictionary;

/**
 *打印数据
 *@ printAllKeysInUserDefaults - 打印所有自定义键
 *
 *@ printUserDefaults - 打印所有内容
 */

+(void)printAllKeysInUserDefaults;
+(void)printUserDefaults;

@end
