

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    if ([self.city isEqualToString:@""]||self.city==NULL||self.city==nil) {
        if ([self.province isEqualToString:@""]||self.province==NULL||self.province==nil) {
            if ([self.country isEqualToString:@""]||self.country==NULL||self.country==nil) {
                return [NSString stringWithFormat:@"%@",self.area];
            }
             return [NSString stringWithFormat:@"%@",self.country];
        }
         return [NSString stringWithFormat:@"%@ ",self.province];
    }
    return [NSString stringWithFormat:@"%@",self.city];
}

-(NSString *)getId{


    if ([self.cityId  isEqual:@""]||self.cityId==NULL||self.cityId==nil) {
        if ([self.provinceId isEqual:@""]||self.provinceId==NULL||self.provinceId==nil) {
            if ([self.countryId isEqual:@""]||self.countryId==NULL||self.countryId==nil) {
                if ([self.areaId isEqual:@""]||self.areaId==NULL||self.areaId==nil) {
                    return [NSString stringWithFormat:@"%@",@"all"];
                }
                
                return [NSString stringWithFormat:@"%@",self.areaId];
            }
            return [NSString stringWithFormat:@"%@",self.countryId];
        }
        return [NSString stringWithFormat:@"%@ ",self.provinceId];
    }
    return [NSString stringWithFormat:@"%@",self.cityId];



}



@end
