//
//  WBSetInformationViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/28.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSetInformationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyDownLoadManager.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBSetInformationViewController ()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePicker;
    UIView *_datePickerView;
    UIDatePicker    *_datePicker;
    BOOL            _datePickerIsHide;
    
    NSString *_sex;
    NSArray *_cityArray;
    //定位
    NSNumber *_provinceId;
    NSNumber *_cityId;
    
}
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation WBSetInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

    
    _cityArray = [NSArray array];
    
    [self createUI];
    [self setUpDatePicker];
}

-(void)createUI{
    
    _headImageView.tag = 100;
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headPick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImagePick)];
    [_headImageView addGestureRecognizer:headPick];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 35;

    _sexLabel.font = MAINFONTSIZE;
    _sexLabel.textColor = [UIColor initWithLightGray];
    
    
    _sexManBtn.titleLabel.font = MAINFONTSIZE;
    _sexManBtn.layer.masksToBounds = YES;
    _sexManBtn.layer.cornerRadius = 15;
    _sexManBtn.backgroundColor = [UIColor initWithGreen];
    [_sexManBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sexManBtn.tag = 200;
    
    _sexWomenBtn.titleLabel.font = MAINFONTSIZE;
    _sexWomenBtn.layer.masksToBounds = YES;
    _sexWomenBtn.layer.cornerRadius = 15;
    [_sexWomenBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    _sexWomenBtn.tag = 201;
    
   
    _birthdayLabel.font = MAINFONTSIZE;
    _birthdayLabel.textColor = [UIColor initWithLightGray];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    _birthdayPickLabel.text = dateTime;
    _birthdayPickLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_birthdayPickLabel addGestureRecognizer:tap];
    _birthdayPickLabel.font = MAINFONTSIZE;
    _birthdayPickLabel.textColor = [UIColor initWithLightGray];
    _birthdayPickLabel.tag = 300;
    
    
    _positionLabel.font = MAINFONTSIZE;
    _positionLabel.textColor = [UIColor initWithLightGray];
    
    
    _cityLabel.font = MAINFONTSIZE;
    _cityLabel.textColor = [UIColor initWithLightGray];
    _cityLabel.textAlignment = NSTextAlignmentRight;
    
    _positionBtn.titleLabel.textColor = [UIColor initWithLightGray];
    _positionBtn.titleLabel.font = MAINFONTSIZE;
    _positionBtn.tag = 400;
    
    
    

    _confirmBtn.tag = 500;
    _confirmBtn.backgroundColor = [UIColor initWithBackgroundGray];
    [_confirmBtn setEnabled:NO];
    [_confirmBtn setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = MAINFONTSIZE;
    _confirmBtn.layer.cornerRadius = 3;
    _confirmBtn.frame = CGRectMake(0, 0, 200, 43);
    
    

}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,3*SCREENHEIGHT/4 , SCREENWIDTH, SCREENHEIGHT / 4)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 4 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    toolBar.backgroundColor = [UIColor initWithLightGray];
    UIBarButtonItem *ensureButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(ensureDatePicker)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDatePicker)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    ensureButton.tintColor = [UIColor whiteColor];
    toolBar.items = @[flexibleButton,cancelButton,ensureButton];
    _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    _datePickerIsHide = YES;
    [_datePickerView addSubview:toolBar];
    [_datePickerView addSubview:_datePicker];
    [self.view addSubview:_datePickerView];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示3
    _datePicker.locale = locale;
}








#pragma mark -----点击事件-----
//选择生日
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self showDatePicker];
}

- (IBAction)btnClicked:(id)sender {
    if (((UIButton *)sender).tag == 200) {
        _sexManBtn.backgroundColor = [UIColor initWithGreen];
        [_sexManBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sexWomenBtn.backgroundColor = [UIColor whiteColor];
        [_sexWomenBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    }else if (((UIButton *)sender).tag == 201){
        _sexWomenBtn.backgroundColor = [UIColor initWithGreen];
        [_sexWomenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sexManBtn.backgroundColor = [UIColor whiteColor];
        [_sexManBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];

    
    }else if (((UIButton *)sender).tag == 307){
        [self showDatePicker];
    
    
    }else if (((UIButton *)sender).tag == 400){
        //开始定位
        
        [self showHUD:@"开始定位" isDim:YES];
        NSLog(@"---local----");
        [self startLocation];
    
    }
    else if (((UIButton *)sender).tag ==500){
        //确认保存按钮
        // 保存数据到服务器
        [self sendDataToUp];
    
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

#pragma mark ---- datapicker ----
-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    ((UILabel *)[self.view viewWithTag:300]).text = date;
    [self cancelDatePicker];
}


-(void)cancelDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerIsHide = YES;
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    }];
}

-(void)showDatePicker{
    if (_datePickerIsHide) {
        [UIView animateWithDuration:0.3 animations:^{
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 5);
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 5);
            }];
        }];
    }
    _datePickerIsHide = NO;
}


#pragma mark -------定位-----------
//开始定位
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
   // NSLog(@"location ok");
   // NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            
            _cityLabel.text =[test objectForKey:@"City"];
            WBPositionList *positionList =[[WBPositionList alloc] init];
            _cityArray =  [NSArray arrayWithArray:[[positionList searchCityWithCithName:_cityLabel.text] objectAtIndex:0]];
            if (_cityArray) {
                [self finishBtn];
                [self showHUDComplete:@"定位成功"];
            }else{
                 [self showHUDComplete:@"定位失败"];
            }
        }
    }];
}

#pragma mark - === 提示框 图片选择===
- (void)headImagePick
{
    _imagePicker = [[UIImagePickerController alloc]init];
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePicker.delegate = self;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePicker.allowsEditing = YES;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:^{
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:^{
            
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        [_headImageView setImage:info[UIImagePickerControllerEditedImage]];
        [self finishBtn];
    }else{
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  ------确认按钮的禁用解锁------

-(void)finishBtn{
   // NSLog(@"_cityArray = %@",_cityArray);
    
     if (_cityArray.count&&_headImageView.image ) {
        [_confirmBtn setEnabled:YES];
        _confirmBtn.backgroundColor = [UIColor initWithGreen];
         [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }



}

#pragma mark ----保存数据到服务器------

-(void)sendDataToUp{
    
    [self showHUD:@"正在火速上传" isDim:YES];
    if ([_sexManBtn.backgroundColor isEqual:[UIColor initWithGreen]]) {
        _sex = @"男";
    }else{
        _sex = @"女";
    }
    
    NSDictionary *parameters = @{@"userId":[WBUserDefaults userId],@"sex":_sex,@"birthday":_birthdayPickLabel.text,@"sex":_sex,@"provinceId":_cityArray[2],@"homeCityId":_cityArray[1]};
    //  NSLog(@"parameters = %@",parameters);
    
    NSData *imageData = UIImageJPEGRepresentation(_headImageView.image, 0.05);
    [MyDownLoadManager postUserInfoUrl:@"http://app.weiqiu.me/user/updateUserInfo" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        if (![_headImageView.image isEqual:[WBUserDefaults headIcon]]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateTime = [formatter stringFromDate:[NSDate date]];
            
            [formData appendPartWithFileData:imageData name:dateTime fileName:[NSString stringWithFormat:@"%@head.jpg",dateTime] mimeType:@"image/jpeg"];
            
        }
        
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        //  NSLog(@"%@",representData);
        NSLog(@"success-------");
        [WBUserDefaults setSex:_sex];
        [WBUserDefaults setCity:_cityArray[0]];
        [WBUserDefaults setHeadIcon:_headImageView.image];
        [WBUserDefaults setBirthday:_birthdayPickLabel.text];
        [self showHUDComplete:@"上传成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"上传失败"];
        NSLog(@"failure");
        NSLog(@"%@",error.localizedCapitalizedString);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
