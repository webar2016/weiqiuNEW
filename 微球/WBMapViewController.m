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
#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBMapModel.h"
#define kCalloutViewMargin          -8

@interface WBMapViewController ()
{
    NSMutableArray *_dataList;


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
        if (annotationView == nil){
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        for (WBMapModel *model in _dataList) {
            if ([model.sceneryName isEqualToString:annotation.title]) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
                if (model.unlock) {
                    imageView.image = [self grayscale:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",annotation.title]] type:0];
                    annotationView.isUnlock = YES;
                }else{
                    imageView.image = [self grayscale:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",annotation.title]] type:1];
                    annotationView.isUnlock = NO;
                }
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 10;
                annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
                annotationView.canShowCallout= NO;
                annotationView.draggable = YES;
                annotationView.bubbleImage = imageView.image;
                annotationView.name = annotation.title;
                annotationView.introduction = annotation.subtitle;
                annotationView.sceneryId = model.sceneryId;
                annotationView.cityId = model.cityId;
                annotationView.sceneryName = model.sceneryName;
                [annotationView addSubview:imageView];
                [annotationView goUnlockView:^(NSString *sceneryName,NSString *sceneryId,NSString *cityId) {
                    WBMapIntroduceViewController *VC = [[WBMapIntroduceViewController alloc]init];
                    VC.sceneryId = sceneryId;
                    VC.cityId = cityId;
                    VC.sceneryName = sceneryName;
                    
                    [self.navigationController pushViewController:VC animated:YES];
                }];
            }
        }
        
        if ([annotation.title isEqualToString:@"问题"]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",annotation.title]];
            annotationView.isUnlock = YES;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 10;
            annotationView.image = [UIImage imageNamed:@"mapPointerBg"];
            annotationView.canShowCallout= NO;
            annotationView.draggable = YES;
            annotationView.bubbleImage = imageView.image;
            annotationView.name = annotation.title;
            annotationView.introduction = annotation.subtitle;
            [annotationView addSubview:imageView];
            
        }
        
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

}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}



#pragma mark  --download-

-(void)loadData{
    NSString *url =[NSString stringWithFormat:@"%@/scenery/city?cityId=%@&userId=%@", WEBAR_IP, self.cityId, [WBUserDefaults userId]];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        _dataList = [WBMapModel mj_objectArrayWithKeyValuesArray:result[@"sceneryList"]];
        [self initAnnotations];
    } andFailure:^(NSString *error) {
    }];
}

#pragma mark - Initialization

- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    for (NSInteger i =0; i<_dataList.count; i++) {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        WBMapModel *tempModel = _dataList[i];
        NSArray *array =[tempModel.locat componentsSeparatedByString:@","];
        a1.coordinate = CLLocationCoordinate2DMake(((NSString *)array[0]).floatValue, ((NSString *)array[1]).floatValue);
        a1.title      = tempModel.sceneryName;
        a1.subtitle   = tempModel.content;
        [self.annotations addObject:a1];
    }
    
    [self addQuestionAnnotation];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];

}


#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self){
        [self initAnnotations];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _dataList = [NSMutableArray array];
    [self loadData];
}

-(void)addQuestionAnnotation{
    if (self.hasLocation) {
        
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        
        a1.coordinate = self.location;
        a1.title      = @"问题";
        a1.subtitle   = self.question;
        
        [self.annotations addObject:a1];
    }
}


- (void)viewDidAppear:(BOOL)animated{
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
