//
//  WBLocationManager.h
//  微球
//
//  Created by 贾玉斌 on 16/6/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WBLocationManager : NSObject<CLLocationManagerDelegate>


+(CLLocation *)getMyLoaction;
-(void)start;
@end
