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
        [self customAnnotationWithTitle:@"头像" latitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    }
}

- (void)mapViewWillStartLoadingMap:(MAMapView *)mapView {
    
    //夫子庙 32.02255 118.78362
    //总统府 32.04434 118.79731
    //中山陵 32.06351 118.84819
    
    [self customAnnotationWithTitle:@"夫子庙" latitude:32.02255 longitude:118.78362];
    [self customAnnotationWithTitle:@"总统府" latitude:32.04434 longitude:118.79731];
    [self customAnnotationWithTitle:@"中山陵" latitude:32.06351 longitude:118.84819];
}

- (void)customAnnotationWithTitle:(NSString *)title latitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSLog(@"latitude : %f,longitude: %f",location.coordinate.latitude,location.coordinate.longitude);
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = location.coordinate;
    pointAnnotation.title = title;
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
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",annotation.title]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 20;
        annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
        annotationView.bubbleImage = imageView.image;
        annotationView.canShowCallout= NO;
        annotationView.draggable = NO;
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
