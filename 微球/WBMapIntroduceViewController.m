//
//  WBMapIntroduceViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/5/20.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMapIntroduceViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MyDownLoadManager.h"

@interface WBMapIntroduceViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //时间选择器
    UIView *_datePickerView;
    UIDatePicker    *_datePicker;
    
    UIImagePickerController *_imagePicker;

}
@end

@implementation WBMapIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    [self createMyUI];
    [self setUpDatePicker];
}


-(void)createNav{
    self.title = @"景点解锁";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"解锁" style:UIBarButtonItemStylePlain target:self action:@selector(unlock)];
    self.navigationItem.rightBarButtonItem = item;
    
}


-(void)createMyUI{
    self.datePick.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PickDate)];
    [self.datePick addGestureRecognizer:tap];
    
    _textView.delegate = self;
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImagePick)];
    [_imageView addGestureRecognizer:imageTap];
    
    
    
}

//解锁
-(void)unlock{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"320100" forKey:@"cityId"];
    [dic setObject:_datePick.text forKey:@"unlockDate"];
    [dic setObject:[WBUserDefaults userId] forKey:@"userId"];
    [dic setObject:_textView.text forKey:@"content"];
    [dic setObject:@"1" forKey:@"sceneryId"];


    NSData *imageDate =UIImageJPEGRepresentation(_imageView.image, 1);
    
    [self showHUD:@"uploading" isDim:YES];
    
    
    [MyDownLoadManager postUserInfoUrl:@"http://192.168.1.138/mbapp/scenery/setUnlock" withParameters:dic fieldData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageDate name:@"dddddddd" fileName:@"dsadad.jpg" mimeType:@"image/jpeg"];

    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        NSLog(@"success");
        [self showHUDComplete:@"success"];
        
    } andFailure:^(NSString *error) {
         NSLog(@"failure");
        [self showHUDComplete:@"failure"];
    }];


}


//选择时间
-(void)PickDate{

    [self showDatePicker];


}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 4 * 3, SCREENWIDTH, SCREENHEIGHT / 3)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 3 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.maximumDate = [[NSDate alloc] init];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    toolBar.backgroundColor = [UIColor initWithLightGray];
    UIBarButtonItem *ensureButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(ensureDatePicker)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDatePicker)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    ensureButton.tintColor = [UIColor whiteColor];
    toolBar.items = @[flexibleButton,cancelButton,ensureButton];
    _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    [_datePickerView addSubview:toolBar];
    [_datePickerView addSubview:_datePicker];
    [self.view addSubview:_datePickerView];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示3
    _datePicker.locale = locale;
}

#pragma mark ---- datapicker ----

-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    _datePick.text = date;
    [self cancelDatePicker];
}

-(void)cancelDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    }];
}

-(void)showDatePicker{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    //   [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    //  NSLog(@"%@",[df dateFromString:((UILabel *)[self.view viewWithTag:202]).text]);
    if ([WBUserDefaults birthday]) {
        _datePicker.date =[df dateFromString:[WBUserDefaults birthday]];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 4 + 60);
    }];
}

#pragma mark ------textView delegate---

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [_textView becomeFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}


#pragma mark ==-imagePick---

#pragma mark - === 提示框 图片选择===
- (void)headImagePick
{
    [_textView resignFirstResponder];
    _imagePicker = [[UIImagePickerController alloc]init];
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePicker.delegate = self;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    _imagePicker.allowsEditing = YES;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
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
        [_imageView setImage:info[UIImagePickerControllerEditedImage]];
    }else{
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
