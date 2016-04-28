
//
//区域对象
#import <Foundation/Foundation.h>

@interface AreaObject : NSObject

//区域
@property (copy, nonatomic) NSString *area;

@property (copy, nonatomic) NSString *areaId;
//国家
@property (copy, nonatomic) NSString *country;

@property (copy, nonatomic) NSString *countryId;
//省名
@property (copy, nonatomic) NSString *province;

@property (copy, nonatomic) NSString *provinceId;
//城市名
@property (copy, nonatomic) NSString *city;

@property (copy, nonatomic) NSString *cityId;

@property (assign,nonatomic) BOOL isCountry;

-(NSString *)getId;


@end
