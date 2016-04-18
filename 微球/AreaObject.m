

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    if ([self.city isEqualToString:@""]) {
        
        if ([self.province isEqualToString:@""]) {
             return [NSString stringWithFormat:@"%@",self.country];
            
        }
        
        
        
         return [NSString stringWithFormat:@"%@ ",self.province];
    }
    return [NSString stringWithFormat:@"%@",self.city];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com