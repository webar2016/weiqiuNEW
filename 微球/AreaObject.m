

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    if ([self.city isEqualToString:@""]||self.city==NULL||self.city==nil) {
        if ([self.province isEqualToString:@""]||self.province==NULL||self.province==nil) {
            
             return [NSString stringWithFormat:@"%@",self.country];
        }
         return [NSString stringWithFormat:@"%@ ",self.province];
    }
    return [NSString stringWithFormat:@"%@",self.city];
}

@end
