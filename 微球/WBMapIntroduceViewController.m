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
#import "WB_Unlocking_Scenery.h"

typedef void(^DoSomething)(void);

@interface WBMapIntroduceViewController ()<UITextViewDelegate,UITextInputTraits,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 48, 20);
    [button setTitle:@"解锁" forState:UIControlStateNormal];
    button.titleLabel.font = MAINFONTSIZE;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(unlock) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor initWithGreen]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}


-(void)createMyUI{
    self.datePick.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PickDate)];
    [self.datePick addGestureRecognizer:tap];
    _textView.delegate = self;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imagePickerLabel.frame) + 8, SCREENWIDTH - 30, 100)];
    _imageView.userInteractionEnabled = YES;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    _imageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImagePick)];
    [_imageView addGestureRecognizer:imageTap];
    [_scrollView addSubview: _imageView];
    
    _sceneryNameLabel.text = _sceneryName;
    
//    _scrollView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
//    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_imageView.frame) + 64 + 28);
}

-(void)setSceneryName:(NSString *)sceneryName{
    _sceneryName = sceneryName;
}


//解锁
-(void)unlock{
    
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Unlocking_Scenery];
    NSArray *tempArray = [manager searchAllItems];
    [manager closeFBDM];
    for (WB_Unlocking_Scenery *model in tempArray) {
        //NSLog(@"%@",_sceneryId);
        // NSLog(@"%@",model.sceneryId);
        if ([model.sceneryId isEqualToString:_sceneryId]) {
            [self showHUDText:@"该景点正在解锁中"];
            return;
        }
    }
    
    
    
    if ([_datePick.text isEqualToString:@"请选择"]) {
        [self showHUDText:@"请选择拍摄时间"];
    }else{
        if (!_imageView.image) {
            [self showHUDText:@"请选择解锁照片"];
        }else{
            [self uploadData];
        }
    }
}



-(void)uploadData{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_cityId forKey:@"cityId"];
    [dic setObject:_datePick.text forKey:@"unlockDate"];
    [dic setObject:[WBUserDefaults userId] forKey:@"userId"];
    [dic setObject:_textView.text forKey:@"content"];
    [dic setObject:_sceneryId forKey:@"sceneryId"];
    NSData *imageDate =UIImageJPEGRepresentation(_imageView.image, 1);
    [self showHUD:@"正在火速上传" isDim:YES];
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *  timeString=[dateformatter stringFromDate:senddate];
    
    
    [MyDownLoadManager postUserInfoUrl:[NSString stringWithFormat:@"%@/scenery/setUnlock",WEBAR_IP] withParameters:dic fieldData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageDate name:timeString fileName:[NSString stringWithFormat:@"%@.jpg",timeString] mimeType:@"image/jpeg"];
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
        //[self showHUD:[NSString stringWithFormat:@"%.2f%%",100*(float)FieldDataBlock.completedUnitCount/(float)FieldDataBlock.totalUnitCount] isDim:YES];
    } andSuccess:^(id representData) {
        NSLog(@"success");
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",result);
        [self showHUDComplete:@"正在火速审核中"];
        
        
        MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Unlocking_Scenery];
        WB_Unlocking_Scenery *model = [[WB_Unlocking_Scenery alloc]init];
        model.userId = [WBUserDefaults userId];
        model.sceneryId =_sceneryId;
        model.cityId =_cityId;
        model.unlockDir = result[@"msg"];
        model.content =_textView.text;
        
        [manager addItem:model];
        [manager closeFBDM];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } andFailure:^(NSString *error) {
        NSLog(@"failure");
        [self showHUDComplete:@"上传失败"];
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
    NSDate *  senddate=[NSDate date];
   
    _datePicker.date =senddate;
    
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 4 + 60);
    }];
}

#pragma mark ------textView delegate---

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [_textView becomeFirstResponder];
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0.0f, - 120.0,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0.0f, 64,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
        UIImage *image = info[UIImagePickerControllerEditedImage];
        CGFloat scale = image.size.height / image.size.width;
        CGRect frame = _imageView.frame;
        CGFloat height = frame.size.width * scale;
        _imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_imageView.frame) + 28);
        [_imageView setImage:info[UIImagePickerControllerEditedImage]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
