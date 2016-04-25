//
//  WBUnlockViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUnlockViewController.h"
#import "MyDownLoadManager.h"
#import "WBTbl_Unlock_City.h"
#import "MyDBmanager.h"

#define UNLOCK_URL @"http://app.weiqiu.me/album/unlockApplication"

@interface WBUnlockViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextInputTraits> {
    UIScrollView    *_scrollView;
    UILabel         *_unlockInfo;
    UIButton        *_imagePicker;
    UITextView      *_contentview;
    UIButton        *_dateButton;
    UILabel         *_tip;
    UIDatePicker    *_datePicker;
    UIView          *_datePickerView;
    
    NSNumber        *_imageScale;
    NSData          *_fileData;
    NSString        *_imageName;
    
    UIImagePickerController *_imagePickerController;
    
    BOOL            _isSuccess;
    BOOL            _isUnlock;
}

@end

@implementation WBUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    self.navigationItem.title = @"上传照片";
    UIButton *rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtton.frame = CGRectMake(0, 0, 48, 22) ;
    rightBtton.backgroundColor = [UIColor initWithGreen];
    rightBtton.titleLabel.font = MAINFONTSIZE;
    rightBtton.layer.cornerRadius = 5;
    [rightBtton setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtton addTarget:self action:@selector(unlockCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self setUpUI];
    [self setUpDatePicker];
    [self setUpImagePicker];

}




-(void)resignKeyboard{
    [_contentview resignFirstResponder];
}

-(void)setUpUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:_scrollView];
    
    UILabel *titleOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 44, 64, 16)];
    titleOne.font = FONTSIZE16;
    titleOne.textColor = [UIColor initWithNormalGray];
    titleOne.text = @"解锁城市";
    
    _unlockInfo = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 80, 290, 60)];
    _unlockInfo.backgroundColor = [UIColor whiteColor];
    _unlockInfo.textColor = [UIColor initWithNormalGray];
    _unlockInfo.font = FONTSIZE16;
    _unlockInfo.textAlignment = NSTextAlignmentCenter;
    _unlockInfo.text = self.cityName;
    UITapGestureRecognizer *unlockInfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    _unlockInfo.userInteractionEnabled = YES;
    [_unlockInfo addGestureRecognizer:unlockInfoTap];
    
    
    
    UILabel *titleTwo = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 184, 64, 16)];
    titleTwo.font = FONTSIZE16;
    titleTwo.textColor = [UIColor initWithNormalGray];
    titleTwo.text = @"拍摄时间";
    
    _dateButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 220, 290, 60)];
    _dateButton.backgroundColor = [UIColor initWithNormalGray];
    _dateButton.titleLabel.font = FONTSIZE16;
    [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dateButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_dateButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleThree = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 324, 96, 16)];
    titleThree.font = FONTSIZE16;
    titleThree.textColor = [UIColor initWithNormalGray];
    titleThree.text = @"说些什么";
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 32, 328, 48, 12)];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = [UIColor initWithNormalGray];
    tip.font = FONTSIZE12;
    tip.text = @"（选填）";
    
    _contentview = [[UITextView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 360, 290, 60)];
    _contentview.backgroundColor = [UIColor whiteColor];
    _contentview.font = FONTSIZE16;
    _contentview.textColor = [UIColor initWithNormalGray];
    _contentview.delegate = self;
    _contentview.returnKeyType = UIReturnKeyDone;
    
    UILabel *titleFour = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 464, 64, 16)];
    titleFour.font = FONTSIZE16;
    titleFour.textColor = [UIColor initWithNormalGray];
    titleFour.text = @"上传照片";
    
    _imagePicker = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 500, 290, 60)];
    [_imagePicker setBackgroundImage:[UIImage imageNamed:@"btn_uploadimg"] forState:UIControlStateNormal];
    [_imagePicker addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    _tip = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 150, 570, 300, 30)];
    _tip.font = FONTSIZE12;
    _tip.numberOfLines = 0;
    _tip.textColor = [UIColor initWithNormalGray];
    _tip.textAlignment = NSTextAlignmentCenter;
    _tip.text = @"24小时认证解锁\n请选择自己的真实照片，否则可能解锁失败";
    
    [_scrollView addSubview:titleOne];
    [_scrollView addSubview:_unlockInfo];
    [_scrollView addSubview:titleTwo];
    [_scrollView addSubview:_dateButton];
    [_scrollView addSubview:titleThree];
    [_scrollView addSubview:tip];
    [_scrollView addSubview:_contentview];
    [_scrollView addSubview:titleFour];
    [_scrollView addSubview:_imagePicker];
    [_scrollView addSubview:_tip];
    
    CGFloat maxHegiht = CGRectGetMaxY(_tip.frame);
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht + 80);
}

-(void)tapClicked:(UITapGestureRecognizer *)tap{

    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:SinglePlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        if (isSelected) {
            _unlockInfo.text =[NSString stringWithFormat:@"%@",locate];
        }
    };
    [addressPickerView show];

}


-(void)setUpImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = YES;
}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 3 * 2, SCREENWIDTH, SCREENHEIGHT / 3)];
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
}

-(void)imagePicker{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    CGFloat scale = image.size.height / image.size.width;
    _imageScale = [NSNumber numberWithFloat:scale];
    NSURL *imageURL = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
    _imageName = [[imageString componentsSeparatedByString:@"="][1] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    _fileData = UIImageJPEGRepresentation(image, 0.05);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_imagePicker setBackgroundImage:image forState:UIControlStateNormal];
        _imagePicker.frame = CGRectMake(SCREENWIDTH / 2 - 145, 500, 290, 290 * scale);
        _tip.frame = CGRectMake(SCREENWIDTH / 2 - 150, 510 + 290 * scale, 300, 30);
        CGFloat maxHegiht = CGRectGetMaxY(_tip.frame);
        
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht + 80);
    }];
}

-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    [_dateButton setTitle:date forState:UIControlStateNormal];
    [self cancelDatePicker];
}

-(void)cancelDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    }];
}

-(void)showDatePicker{
    [_contentview resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 4 + 60);
    }];
}

-(void)unlockCity{
    [_contentview resignFirstResponder];
    if ([_dateButton.currentTitle isEqualToString:@"请选择"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择拍摄时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (!_fileData) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择解锁照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHUD:@"正在努力上传" isDim:YES];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"userId"] = [WBUserDefaults userId];
    data[@"photoDate"] = _dateButton.currentTitle;
    data[@"provinceId"] = self.provinceId;
    data[@"cityId"] = self.cityId;
    data[@"content"] = _contentview.text;
    data[@"imgRate"] = _imageScale;
    
    [MyDownLoadManager postUrl:UNLOCK_URL withParameters:data fileData:_fileData name:_imageName fileName:_imageName mimeType:@"image/jpeg" whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        _isSuccess = YES;
        
        WBTbl_Unlocking_City *model = [[WBTbl_Unlocking_City alloc]init];
        model.userId =[WBUserDefaults userId];
        model.cityId =[self.cityId stringValue];
        MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlocking_city];
        [manager addItem:model];
        [manager closeFBDM];
        [self showHUDComplete:@"已经上传，正在火速审核中"];
        
        
    } andFailure:^(NSString *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _isSuccess = NO;
        [self showHUDComplete:@"上传失败，请稍后再试"];
    }];
    
}

-(void)dismissView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mak - text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    _scrollView.frame = CGRectMake(0.0f, - 150.0,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    _scrollView.frame = CGRectMake(0.0f, 0.0f,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - MBprogress

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    self.hud.opacity = 0.7;
    [self.hud hide:YES afterDelay:2.0];
    if (_isSuccess||_isUnlock) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0];
    }
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
