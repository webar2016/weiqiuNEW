//
//  WBMapViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/5/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMapViewController.h"
#import "WBMapIntroduceViewController.h"
#import "CustomAnnotationView.h"

@interface WBMapViewController ()
{


}
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation WBMapViewController

#pragma mark - MAMapViewDelegate


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

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",annotation.title]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 30;
        annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
        annotationView.canShowCallout= NO;
        annotationView.draggable = NO;
        annotationView.bubbleImage = imageView.image;
        annotationView.name = annotation.title;
        annotationView.introduction = annotation.subtitle;
        [annotationView addSubview:imageView];
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
    WBIntroView *introView = [[WBIntroView alloc] initWithImage:annotationView.bubbleImage name:annotationView.name introduction:annotationView.introduction];
    introView.delegate = self;
    introView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2 - 35);
    [self.view addSubview:introView];
//    [view setSelected:NO animated:NO];
}

- (void)clickBubbleHandle{
    WBMapIntroduceViewController *MVC = [[WBMapIntroduceViewController alloc]init];
    [self.navigationController pushViewController:MVC animated:YES];
}



#pragma mark - Initialization

- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[3] = {
        {32.02255, 118.78362},
        {32.04434, 118.79731},
        {32.06351, 118.84819},
    };
    
    NSArray *tempArray = @[@"夫子庙",@"总统府",@"中山陵"];
    NSString *introduction = @"景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍景点介绍";
    for (int i = 0; i < 3; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = tempArray[i];
        a1.subtitle   = introduction;
        [self.annotations addObject:a1];
    }
}


#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initAnnotations];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsBuildings = NO;
    self.mapView.showTraffic = NO;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsLabels = NO;
    
}

@end
