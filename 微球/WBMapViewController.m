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
#define kCalloutViewMargin          -8

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

        if ([annotation.title isEqualToString:@"中山陵"]) {
            UIImage *myImage = [self grayscale:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",annotation.title]] type:1];
            imageView.image = myImage;
        }else{
            UIImage *myImage = [self grayscale:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",annotation.title]] type:0];
            imageView.image = myImage;
        }
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
        annotationView.canShowCallout= NO;
        annotationView.draggable = YES;
        
        annotationView.bubbleImage = imageView.image;
        annotationView.name = annotation.title;
        annotationView.introduction = annotation.subtitle;
        [annotationView addSubview:imageView];
        
        [annotationView goUnlockView:^(NSString *name) {
            WBMapIntroduceViewController *VC = [[WBMapIntroduceViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }];
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint screenAnchor = [self.mapView getMapStatus].screenAnchor;
            CGPoint theCenter = CGPointMake(self.mapView.bounds.size.width * screenAnchor.x, self.mapView.bounds.size.height * screenAnchor.y);
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }

    
//    NSLog(@"success");
//    
//    CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
//    
//
//        WBIntroView *introView = [[WBIntroView alloc] initWithImage:annotationView.bubbleImage name:annotationView.name introduction:annotationView.introduction];
//        introView.delegate = self;
//        introView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2 - 35);
//        [self.view addSubview:introView];
    
    
//    [view setSelected:NO animated:NO];
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
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
    
    [self addQuestionAnnotation];
    
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
    
}


-(void)addQuestionAnnotation{

    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.longitude);
    a1.title      = @"问题";
    a1.subtitle   = @"问题：南京有什么好吃的？";
    [self.annotations addObject:a1];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsBuildings = NO;
    self.mapView.showTraffic = NO;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsLabels = NO;
    
}


- (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
    
}

@end
