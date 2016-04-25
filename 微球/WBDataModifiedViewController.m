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
#import "AddressChoicePickerView.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBDataModifiedViewController ()<UITextFieldDelegate,UIActionSheetDelegate,PassPositionDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextInputTraits>
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
    
    UITextView *_introduceTextView;
    UITextField *_textField;
    UILabel *_placeHoldLabel;
    
    UIImagePickerController *_imagePicker;
    BOOL _isClicked;
    
}
@end

@implementation WBDataModifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    _rightLabelName = [NSMutableArray array];
    _isClicked = NO;
    
    [self createNavi];
    [self createUI];
    
    [self setContent];
    [self setUpDatePicker];
}

-(void)createNavi{
    //设置标题
    self.navigationItem.title = @"资料修改";
    //设置返回按钮
   // UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
  //  item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = MAINFONTSIZE;
    button.backgroundColor = [UIColor initWithGreen];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    button.frame = CGRectMake(0, 0, 50, 25);
    button.tag = 50;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
}


-(void)createUI{
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
    _bigImageView.backgroundColor = [UIColor initWithBackgroundGray];
    _bigImageView.layer.masksToBounds = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([WBUserDefaults coverImage]) {
        _bigImageView.image = [WBUserDefaults coverImage];
    } else {
        _bigImageView.image = [UIImage imageNamed:@"cover"];
    }
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
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    [_rightLabelName addObject:[dateformatter stringFromDate:senddate]];
    
    [_rightLabelName addObject:@""];
    for (NSInteger i =0; i<4; i++) {
        UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 140+40*i, SCREENWIDTH, 39)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapBtnClick:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 150+40*i, 100, 20)];
        label.text = _leftLabelName[i];
        label.font = MAINFONTSIZE;
        label.textColor = [UIColor initWithLightGray];
        [self.view addSubview:label];
        
        
        if (i!=0) {
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150+40*i, 200, 20)];
            rightLabel.textColor =[UIColor initWithLightGray];
            rightLabel.font = MAINFONTSIZE;
            rightLabel.text = [_rightLabelName objectAtIndex:i-1];
            rightLabel.tag = 200+i;
            [self.view addSubview:rightLabel];
        }
    }
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 150, 200, 20)];
    _textField.placeholder = @"昵称";
    _textField.font = MAINFONTSIZE;
    _textField.textColor = [UIColor initWithLightGray];
    _textField.delegate = self;
    _textField.tag = 200;
    _textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textField];
    
    
    UIView *introduceView = [[UIView alloc]initWithFrame:CGRectMake(0, 300+9, SCREENWIDTH, 117)];
    introduceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:introduceView];
    introduceView.tag = 500;
    
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,10, 100, 20)];
    introduceLabel.text = @"个人简介";
    introduceLabel.font = MAINFONTSIZE;
    introduceLabel.textColor = [UIColor initWithLightGray];
    [introduceView addSubview:introduceLabel];
    
    
    _introduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(95, 5, SCREENWIDTH-95-10, 117-10)];
    [introduceView addSubview:_introduceTextView];
    _introduceTextView.font = MAINFONTSIZE;
    _introduceTextView.delegate = self;
    _introduceTextView.tag = 204;
    _introduceTextView.returnKeyType = UIReturnKeyDone;
    _introduceTextView.keyboardType = UIKeyboardTypeDefault;
    _introduceTextView.textColor = [UIColor initWithLightGray];
    

    
}

-(void)setContent{
   // [WBUserDefaults printUserDefaults];
    
    if ([WBUserDefaults nickname]) {
        ((UITextField *)[self.view viewWithTag:200]).text =[NSString stringWithFormat:@"%@",[WBUserDefaults nickname]];
    }
    if ([WBUserDefaults sex]) {
        ((UILabel *)[self.view viewWithTag:201]).text = [NSString stringWithFormat:@"%@",[WBUserDefaults sex]];
    }
    if ([WBUserDefaults birthday]) {
        ((UILabel *)[self.view viewWithTag:202]).text = [NSString stringWithFormat:@"%@",[WBUserDefaults birthday]];
    }
    
    if ([WBUserDefaults city]) {
         ((UILabel *)[self.view viewWithTag:203]).text = [NSString stringWithFormat:@"%@",[WBUserDefaults city]];
    }
    
    if ([WBUserDefaults headIcon]) {
        _headImageView.image =[WBUserDefaults headIcon];
    }
    if ([WBUserDefaults profile]) {
        _introduceTextView.text =[WBUserDefaults profile];
    }else{
        _placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREENWIDTH-100-20, 30)];
        _placeHoldLabel.text = @"说点什么介绍下自己...";
        _placeHoldLabel.userInteractionEnabled = NO;
        _placeHoldLabel.font = MAINFONTSIZE;
        _placeHoldLabel.textColor = [UIColor initWithNormalGray];
        UIView *introduceView = (UIView *)[self.view viewWithTag:500];
        [introduceView addSubview:_placeHoldLabel];
    
    }
    
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





#pragma mark ----右键保存------
-(void)rightBtnClicked{
    
    if (_isClicked) {
        
    }else{
        _isClicked=YES;
    [_introduceTextView resignFirstResponder];
    [_textField resignFirstResponder];
    
    [self showHUD:@"正在保存" isDim:YES];
    UIBarButtonItem *btn = self.navigationItem.rightBarButtonItem;
    [btn setEnabled:NO];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[WBUserDefaults userId],@"nickname":((UITextField*)[self.view viewWithTag:200]).text,@"sex":((UILabel*)[self.view viewWithTag:201]).text,@"birthday":((UITextField*)[self.view viewWithTag:202]).text,@"profile":_introduceTextView.text}];
    WBPositionList *positionList =[[WBPositionList alloc] init];
    if (((UILabel *)[self.view viewWithTag:203]).text==nil||((UILabel *)[self.view viewWithTag:203]).text==NULL||[((UILabel *)[self.view viewWithTag:203]).text isEqualToString:@"" ]) {
    }else{
        
        NSArray *positionArray =  [NSArray arrayWithArray:[[positionList searchCityWithCithName:((UILabel *)[self.view viewWithTag:203]).text] objectAtIndex:0]];
        [parameters setValue:@"provinceId" forKey:positionArray[2]];
    }
    [MyDownLoadManager postUserInfoUrl:@"http://app.weiqiu.me/user/updateUserInfo" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        if (![_headImageView.image isEqual:[WBUserDefaults headIcon]]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateTime = [formatter stringFromDate:[NSDate date]];
            NSData *imageData = UIImageJPEGRepresentation(_headImageView.image, 0.05);
            [formData appendPartWithFileData:imageData name:dateTime fileName:[NSString stringWithFormat:@"%@head.jpg",dateTime] mimeType:@"image/jpeg"];
        }
    } whenProgress:^(NSProgress *FieldDataBlock) {
    } andSuccess:^(id representData) {
      //  NSLog(@"%@",representData);
      // NSLog(@"success-------");
        [WBUserDefaults setNickname:((UITextField*)[self.view viewWithTag:200]).text];
        [WBUserDefaults setSex:((UILabel*)[self.view viewWithTag:201]).text];
        if (![_headImageView.image isEqual:[WBUserDefaults headIcon]]) {
            [WBUserDefaults setHeadIcon:_headImageView.image];
        }
       
        if (((UILabel*)[self.view viewWithTag:203]).text) {
            [WBUserDefaults setCity:((UILabel*)[self.view viewWithTag:203]).text];
        }
        [WBUserDefaults setProfile:_introduceTextView.text];
        [WBUserDefaults setAge:[NSString stringWithFormat:@"%ld",(long)[self calculateAge]]];
        [self.delegate ModefyViewDelegate];
        [self showHUDComplete:@"修改成功"];
        [self performSelector:@selector(isClicked) withObject:nil afterDelay:2.0];
        
    } andFailure:^(NSString *error) {
        NSLog(@"failure");
        NSLog(@"%@",error.localizedCapitalizedString);
        [self showHUDComplete:@"上传失败"];
        [btn setEnabled:YES];
    }];
}


-(NSInteger)calculateAge{
    
    //转换时间格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSLog(@"%@",[df dateFromString:((UILabel *)[self.view viewWithTag:202]).text]);
       // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[df dateFromString:((UILabel *)[self.view viewWithTag:202]).text]];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;


}

#pragma mark - === 提示框 图片选择===
- (void)headImagePick
{
    [_textField resignFirstResponder];
    [_introduceTextView resignFirstResponder];
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



-(void)TapBtnClick:(UITapGestureRecognizer *)tap{
    [_textField resignFirstResponder];
    [_introduceTextView resignFirstResponder];
    if (tap.view.tag == 101) {
        UILabel *label = (UILabel *)[self.view viewWithTag:201];
        
        UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            label.text = @"男";
        }];
        UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            label.text = @"女";
        }];
        
        UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [aleVC addAction:act1];
        [aleVC addAction:act2];
        [aleVC addAction:act3];
        [self presentViewController:aleVC animated:YES completion:nil];
        
    }else if (tap.view.tag == 102){
        
        [self showDatePicker];
        
    }else if (tap.view.tag == 103){
        AddressChoicePickerView *AVC = [[AddressChoicePickerView alloc]initWithPlaceStyle:SinglePlaceChoice];
        AVC.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
            if (isSelected) {
                self.areaObject = locate;
                ((UILabel *)[self.view viewWithTag:203]).text = [NSString stringWithFormat:@"%@",locate];
            }
            
            
        };
        
        [AVC show];
        
        
//        WBPlaceChooseViewController *PVC = [[WBPlaceChooseViewController alloc]init];
//        PVC.passPositionDelegate = self;
//        [self.navigationController pushViewController:PVC animated:YES];
        
    }
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -150,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 64.0,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]){
        _placeHoldLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        _placeHoldLabel.hidden = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
