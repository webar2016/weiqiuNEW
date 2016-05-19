//
//  WBMapViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/5/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMapViewController.h"
#import "CustomAnnotationView.h"

@interface WBMapViewController ()

@end

@implementation WBMapViewController

#pragma mark - MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = userLocation.coordinate;
        pointAnnotation.title = self.userNameTitle;
        NSLog(@"%@",userLocation);
        [self.mapView addAnnotation:pointAnnotation];
    }
}

- (void)mapViewWillStartLoadingMap:(MAMapView *)mapView {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:20 longitude:120];
    NSLog(@"latitude : %f,longitude: %f",location.coordinate.latitude,location.coordinate.longitude);
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = location.coordinate;
    pointAnnotation.title = self.userNameTitle;
    [self.mapView addAnnotation:pointAnnotation];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)];
        imageView.image = self.titleImage;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 20;
        annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
        annotationView.bubbleImage = self.titleImage;
        annotationView.canShowCallout= NO;
        annotationView.draggable = YES;
        annotationView.delegate = self;
        [annotationView addSubview:imageView];
        
        return annotationView;
    }
    return nil;
}

#pragma mark - NSKeyValueObservering

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"showsUserLocation"])
    {
//        NSNumber *showsNum = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

#pragma mark - Initialization


- (void)initObservers
{
    /* Add observer for showsUserLocation. */
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initObservers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsBuildings = NO;
    self.mapView.showTraffic = NO;
    self.mapView.rotateEnabled = NO;
}

- (void)clickBubbleHandle {
    UIViewController *emptyVC = [[UIViewController alloc] init];
    emptyVC.view.backgroundColor = [UIColor grayColor];
    [self.navigationController pushViewController:emptyVC animated:YES];
}

@end
