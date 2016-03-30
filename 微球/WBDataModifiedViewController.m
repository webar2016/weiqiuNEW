//
//  WBDataModifiedViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBDataModifiedViewController.h"
#import "WBPlaceChooseViewController.h"
#import "WBPositionList.h"
#import "MyDownLoadManager.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBDataModifiedViewController ()<UITextFieldDelegate,PassValueDelegate,UIActionSheetDelegate,PassPositionDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    UIImageView *_bigImageView;
    UIImageView *_headImageView;
    //性别复选框
    
    UITableView *_tableView;
    NSArray *_leftLabelName;
    
    NSMutableArray *_rightLabelName;
    //时间选择器
    UIView *_datePickerView;
    UIDatePicker    *_datePicker;
    NSNumber *_provinceId;
    NSNumber *_cityId;
    
    BOOL            _datePickerIsHide;
    
    UITextView *_introduceTextView;
    UILabel *_placeHoldLabel;
    
    UIImagePickerController *_imagePicker;
    
}
@end

@implementation WBDataModifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    _rightLabelName = [NSMutableArray array];
    
    
    [self createNavi];
    [self createUI];
    
    [self setContent];
    [self setUpDatePicker];
}

-(void)createNavi{
    //设置标题
    self.navigationItem.title = @"资料修改";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = MAINFONTSIZE;
    button.backgroundColor = [UIColor initWithGreen];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    button.frame = CGRectMake(0, 0, 50, 25);
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
}


-(void)createUI{
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 168)];
    _bigImageView.backgroundColor = [UIColor initWithBackgroundGray];
    [self.view addSubview:_bigImageView];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    _headImageView.backgroundColor = [UIColor initWithGreen];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 32;
    _headImageView.center = _bigImageView.center;
    [self.view addSubview:_headImageView];
    _headImageView.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImagePick)];
    [_headImageView addGestureRecognizer:tap];
    
    
    _leftLabelName = @[@"昵称",@"性别",@"生日",@"所在地"];
    
    [_rightLabelName addObject:@"女"];
    [_rightLabelName addObject:@"2000-09-09"];
    [_rightLabelName addObject:@"南京"];
    for (NSInteger i =0; i<4; i++) {
        UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 168+40*i, SCREENWIDTH, 39)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapBtnClick:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 178+40*i, 100, 20)];
        label.text = _leftLabelName[i];
        label.font = MAINFONTSIZE;
        label.textColor = [UIColor initWithLightGray];
        [self.view addSubview:label];
        
        
        if (i!=0) {
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 178+40*i, 200, 20)];
            rightLabel.textColor =[UIColor initWithLightGray];
            rightLabel.font = MAINFONTSIZE;
            rightLabel.text = [_rightLabelName objectAtIndex:i-1];
            rightLabel.tag = 200+i;
            [self.view addSubview:rightLabel];
        }
    }
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 178, 200, 20)];
    textField.placeholder = @"昵称";
    textField.font = MAINFONTSIZE;
    textField.textColor = [UIColor initWithLightGray];
    textField.delegate = self;
    textField.tag = 200;
    [self.view addSubview:textField];
    
    
    UIView *introduceView = [[UIView alloc]initWithFrame:CGRectMake(0, 328+9, SCREENWIDTH, 117)];
    introduceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:introduceView];
    
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,10, 100, 20)];
    introduceLabel.text = @"个人简介";
    introduceLabel.font = MAINFONTSIZE;
    introduceLabel.textColor = [UIColor initWithLightGray];
    [introduceView addSubview:introduceLabel];
    
    
    _introduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(100, 10, SCREENWIDTH-100-20, 117-10)];
    [introduceView addSubview:_introduceTextView];
    _introduceTextView.font = MAINFONTSIZE;
    _introduceTextView.delegate = self;
    _introduceTextView.tag = 204;
    _introduceTextView.keyboardType = UIKeyboardTypeDefault;
    // [_introduceTextView becomeFirstResponder];
    
    _placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREENWIDTH-100-20, 30)];
    _placeHoldLabel.text = @"说点什么介绍下自己...";
    _placeHoldLabel.font = MAINFONTSIZE;
    _placeHoldLabel.textColor = [UIColor initWithNormalGray];
    [introduceView addSubview:_placeHoldLabel];
    
}

-(void)setContent{

    if ([WBUserDefaults nickname]) {
        ((UITextField *)[self.view viewWithTag:200]).text =[NSString stringWithFormat:@"%@",[WBUserDefaults nickname]];
    }
    if ([WBUserDefaults sex]) {
        ((UILabel *)[self.view viewWithTag:201]).text = [NSString stringWithFormat:@"%@",[WBUserDefaults sex]];
    }
    if ([WBUserDefaults age]) {
        ((UILabel *)[self.view viewWithTag:202]).text = [NSString stringWithFormat:@"%@",[WBUserDefaults age]];
    }
    
    
    if ([WBUserDefaults headIcon]) {
        _headImageView.image =[WBUserDefaults headIcon];
    }
    
    


}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 4 * 3, SCREENWIDTH, SCREENHEIGHT / 3)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 3 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.minimumDate = [[NSDate alloc] init];
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



-(void)loadData{
    
    



}

#pragma mark ----右键保存------
-(void)rightBtnClicked{
    
    
    [WBUserDefaults setNickname:((UITextField*)[self.view viewWithTag:200]).text];
    [WBUserDefaults setSex:((UILabel*)[self.view viewWithTag:201]).text];
    
    if (![_headImageView.image isEqual:[WBUserDefaults headIcon]]) {
        [WBUserDefaults setHeadIcon:_headImageView.image];

    }
   
    
        NSDictionary *parameters = @{@"userId":[WBUserDefaults userId],@"nickname":((UITextField*)[self.view viewWithTag:200]).text,@"sex":((UILabel*)[self.view viewWithTag:201]).text};
      //  NSLog(@"parameters = %@",parameters);
    
     NSData *imageData = UIImageJPEGRepresentation(_headImageView.image, 1.0);
    [MyDownLoadManager postUserInfoUrl:@"http://121.40.132.44:92/user/updateUserInfo" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        if (![_headImageView.image isEqual:[WBUserDefaults headIcon]]) {
            
            
             [formData appendPartWithFileData:imageData name:@"dsds" fileName:@"asadad.jpg" mimeType:@"image/jpeg"];
            
        }
       
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
      //  NSLog(@"%@",representData);
       NSLog(@"success-------");
        

        [self.delegate ModefyViewDelegate];
    } andFailure:^(NSString *error) {
        NSLog(@"failure");
        NSLog(@"%@",error.localizedCapitalizedString);
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
    }else{
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}






#pragma mark ---- datapicker ----
-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    ((UILabel *)[self.view viewWithTag:202]).text = date;
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
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 4);
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 4);
            }];
        }];
    }
    _datePickerIsHide = NO;
}



-(void)TapBtnClick:(UITapGestureRecognizer *)tap{
   // NSLog(@"-----------");
    if (tap.view.tag == 101) {
        WBSexViewController *SVC = [[WBSexViewController alloc]init];
        SVC.passDelegate = self;
        [self.navigationController pushViewController:SVC animated:YES];
        
        
    }else if (tap.view.tag == 102){
        
        [self showDatePicker];
        
    }else if (tap.view.tag == 103){
        WBPlaceChooseViewController *PVC = [[WBPlaceChooseViewController alloc]init];
        PVC.passPositionDelegate = self;
        [self.navigationController pushViewController:PVC animated:YES];
        
    }
    
}




#pragma mark -----  PassValueDelegate --------

- (void)setSexValue:(NSString *)value{
    _rightLabelName[0] = value;
    ((UILabel *)[self.view viewWithTag:200+1]).text = value;
    
    
    
}
#pragma mark -----  PassPositionDelegate --------
- (void)setPositionProvinceId:(NSNumber *)provinceId andCityId:(NSNumber *)cityId{
    
    WBPositionList *positionList =[[WBPositionList alloc] init];
    UILabel *label = (UILabel *)[self.view viewWithTag:203];
    _cityId = cityId;
    _provinceId = provinceId;
    label.text =  [positionList cityNameWithCityId:cityId];
    
}


#pragma mark -------textView delegate ------
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [_introduceTextView becomeFirstResponder];
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [_introduceTextView resignFirstResponder];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    _placeHoldLabel.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        _placeHoldLabel.hidden = NO;
        
    }
    
    return YES;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
