//
//  WBLocateList.m
//  微球
//
//  Created by 贾玉斌 on 16/4/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBLocateList.h"
#import "MJExtension.h"

@implementation WBLocateList


+(NSArray *)myGetAllAreaList{
    WBLocateList *list = [[WBLocateList alloc]init];
    return [list getAllAreaList];
}

+(NSArray *)myGetAllCountryList{
    WBLocateList *list = [[WBLocateList alloc]init];
    return  [list getAllCountryList];
}

+(NSArray *)myGetAllProvinceList{
    WBLocateList *list = [[WBLocateList alloc]init];
    return  [list getAllProvinceList];
    
}

+(NSArray *)myGetAllCityList{
    WBLocateList *list = [[WBLocateList alloc]init];
    return  [list getAllCityList];
}

+(NSDictionary *)mySearchPositionById:(NSInteger)number{
    WBLocateList *list = [[WBLocateList alloc]init];
    return  [list searchPositionById:number];
}



-(NSArray *)getAllAreaList{
    if (_areaArray) {
        return _areaArray;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Localtion" ofType:@"plist"];
    NSArray *areaArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    _areaArray = [NSArray arrayWithArray:areaArray];
    return _areaArray;
    
}

-(NSArray *)getAllCountryList{
    if (_countryArray) {
        return _countryArray;
    }
    NSArray *tempArray = [self getAllAreaList];
    NSMutableArray *countryArray = [NSMutableArray array];
    for (NSDictionary *tempDic in tempArray) {
        [countryArray addObjectsFromArray:tempDic[@"countrys"]];
    }
    _countryArray = [NSArray arrayWithArray:countryArray];
    return _countryArray;
}

-(NSArray *)getAllProvinceList{
    
    if (_provinceArray) {
        return _provinceArray;
    }
    NSDictionary *tempDic = [[self getAllCountryList] objectAtIndex:0];
    NSArray *tempArray = tempDic[@"provinces"];
    _provinceArray = [NSArray arrayWithArray:tempArray];
    return _provinceArray;
}

-(NSArray *)getAllCityList{
    if (_cityArray) {
        return _cityArray;
    }
    NSArray *tempArray = [NSArray arrayWithArray:[self getAllProvinceList]];
    NSMutableArray *cityArray = [NSMutableArray array];
    for (NSInteger i=0; i<tempArray.count; i++) {
        [cityArray addObjectsFromArray:[tempArray objectAtIndex:i][@"citys"]];
        
    }
    _cityArray = [NSArray arrayWithArray:cityArray];
    //NSLog(@"%@",_cityArray);
    return  _cityArray;
    
}


+(NSString *)myGetPositionNameById:(NSInteger)number{
    WBLocateList *list = [[WBLocateList alloc]init];
    NSDictionary *tempDic = [list searchPositionById:number];
    
    if ([tempDic[@"type"] integerValue]==0) {
        return tempDic[@"areaName"];
    }else if ([tempDic[@"type"] integerValue]==1){
        return tempDic[@"country"];
    }else if ([tempDic[@"type"] integerValue]==2){
        return tempDic[@"provinceName"];
    }else{
    return tempDic[@"cityName"];
    }
}

+(NSInteger )myGetPositionTypeById:(NSInteger)number{
    WBLocateList *list = [[WBLocateList alloc]init];
    NSDictionary *tempDic = [list searchPositionById:number];
    return [tempDic[@"type"] integerValue];
}

-(NSDictionary *)searchPositionById:(NSInteger)number{
    NSMutableDictionary  *returnDic = [NSMutableDictionary dictionary];
    if (number>99&&number<1000) {
        //国家
        NSArray *tempArray=[self getAllCountryList];
        for (NSDictionary *tempDic in tempArray) {
            if ([tempDic[@"id"] integerValue] == number) {
                // NSLog(@"------");
                [returnDic addEntriesFromDictionary:tempDic];
                [returnDic setObject:@"1" forKey:@"type"];
                
                break;
            }
        }
    }else if(number>999&&number<10000){
        //大区域
        //NSLog(@"2");
        NSArray *tempArray=[self getAllAreaList];
        for (NSDictionary *tempDic in tempArray) {
            if ([tempDic[@"areaId"] integerValue] == number) {
                // NSLog(@"------");
                [returnDic addEntriesFromDictionary:tempDic];
                [returnDic setObject:@"0" forKey:@"type"];
                break;
            }
        }
    }else if(number>99999&&number%10000==0){
        //省份
        // NSLog(@"3");
        NSArray *tempArray=[self getAllProvinceList];
        for (NSDictionary *tempDic in tempArray) {
            if ([tempDic[@"provinceId"] integerValue] == number) {
                // NSLog(@"------");
                [returnDic addEntriesFromDictionary:tempDic];
                [returnDic setObject:@"2" forKey:@"type"];
                break;
            }
        }
    }else{
        //城市
        //NSLog(@"4");
        NSArray *tempArray=[self getAllCityList];
        for (NSDictionary *tempDic in tempArray) {
            if ([tempDic[@"cityId"] integerValue] == number) {
                // NSLog(@"------");
                [returnDic addEntriesFromDictionary:tempDic];
                [returnDic setObject:@"3" forKey:@"type"];
                break;
            }
        }
    }
    return returnDic;
}




@end
