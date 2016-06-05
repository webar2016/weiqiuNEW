//
//  WBLocationManager.m
//  微球
//
//  Created by 贾玉斌 on 16/6/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBLocationManager.h"

@implementation WBLocationManager

+(CLLocation *)getMyLoaction{

    [[[WBLocationManager alloc] init] start];
    
    


    return  nil;
}

-(void) start {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    // 设置定位精度，十米，百米，最好
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;
    
    // 开始时时定位
    [locationManager startUpdatingLocation];
}




// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

//// 6.0 以上调用这个函数
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    
//    NSLog(@"%ld", [locations count]);
//    
//    CLLocation *newLocation = locations[0];
//    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
//    
//    //    CLLocation *newLocation = locations[1];
//    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
//    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
//    
//    // 计算两个坐标距离
//    //    float distance = [newLocation distanceFromLocation:oldLocation];
//    //    NSLog(@"%f",distance);
//    
//    [manager stopUpdatingLocation];
//    
//    //------------------位置反编码---5.0之后使用-----------------
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks, NSError *error){
//                       
//                       for (CLPlacemark *place in placemarks) {
//                           UILabel *label = (UILabel *)[self.window viewWithTag:101];
//                           label.text = place.name;
//                           NSLog(@"name,%@",place.name);                       // 位置名
//                           //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//                           //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//                           //                           NSLog(@"locality,%@",place.locality);               // 市
//                           //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
//                           //                           NSLog(@"country,%@",place.country);                 // 国家
//                       }
//                       
//                   }];
//    
//}
//
//// 6.0 调用此函数
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"%@", @"ok");
//}
//


@end
