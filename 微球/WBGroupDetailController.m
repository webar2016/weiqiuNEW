//
//  WBGroupDetailController.m
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupDetailController.h"

#import "AFHTTPSessionManager.h"
#import <RongIMKit/RongIMKit.h>

#define SCORE_STEP 10
#define ALL_TIME  15*24*60*60

@interface WBGroupDetailController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UIScrollView *_scrollView;
    UILabel      *_scoreLable;
    UIButton     *_minusButton;
    UIButton     *_plusbutton;
    UILabel      *_memberNumber;
    UIButton     *_imagePicker;
    UILabel      *_tip;
    
    NSString     *_currentDate;
    NSString     *_closeDate;
    
    CGFloat     _imageScale;
    NSData      *_fileData;
    NSString    *_imageName;
    
    UIImagePickerController *_imagePickerController;
}

@end

@implementation WBGroupDetailController

-(NSMutableDictionary *)dataDic{
    if (_dataDic) {
        return _dataDic;
    }
    _dataDic = [NSMutableDictionary dictionary];
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    NSLog(@"%@",self.dataDic);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:_scrollView];
    
    self.navigationItem.title = @"创建帮帮团";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(lastStep)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    _currentDate = [dateformatter stringFromDate:[[NSDate alloc] init]];
    _closeDate = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:ALL_TIME]];
    
    [self setUpUI];
    
    [self setUpImagePicker];
}

#pragma mark - navigation button

-(void)lastStep{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStep{
    self.dataDic[@"beginTime"] = _currentDate;
    self.dataDic[@"endTime"] = _closeDate;
    self.dataDic[@"maxMembers"] = _memberNumber.text;
    self.dataDic[@"imgRate"] = [NSString stringWithFormat:@"%.2f",_imageScale];
    self.dataDic[@"groupSign"] = @"吃喝玩乐嫖赌毒";
    self.dataDic[@"rewardIntegral"] = _scoreLable.text;
    
    self.dataDic[@"userId"] = @"29";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/createHG"];
    [manager POST:url parameters:self.dataDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:_fileData name:_imageName fileName:_imageName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"create---success");
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSLog(@"%@",responseObject[@"msg"]);
        }
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_GROUP targetId:responseObject[@"msg"] content:[RCInformationNotificationMessage notificationWithMessage:@"句首输入 ?:\n就可以直接提问啦！" extra:nil] pushContent:nil success:^(long messageId) {
            NSLog(@"message---success");
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"message---failure");
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"create---failure");
    }];
}

#pragma mark - UI

-(void)setUpUI{
    UILabel *titleOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 44, 64, 16)];
    titleOne.font = FONTSIZE16;
    titleOne.textColor = [UIColor initWithNormalGray];
    titleOne.text = @"悬赏球票";
    
    _scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 90, 80, 180, 60)];
    _scoreLable.backgroundColor = [UIColor whiteColor];
    _scoreLable.textColor = [UIColor initWithNormalGray];
    _scoreLable.font = FONTSIZE16;
    _scoreLable.textAlignment = NSTextAlignmentCenter;
    _scoreLable.text = @"500";
    
    _minusButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 91.5, 37, 37)];
    [_minusButton setImage:[UIImage imageNamed:@"icon_minus_abled"] forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(changeScore:) forControlEvents:UIControlEventTouchUpInside];
    _minusButton.tag = 0;
    
    _plusbutton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 108, 91.5, 37, 37)];
    [_plusbutton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [_plusbutton addTarget:self action:@selector(changeScore:) forControlEvents:UIControlEventTouchUpInside];
    _plusbutton.tag = 1;
    
    UILabel *titleTwo = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 184, 64, 16)];
    titleTwo.font = FONTSIZE16;
    titleTwo.textColor = [UIColor initWithNormalGray];
    titleTwo.text = @"团员上限";
    
    _memberNumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 220, 290, 60)];
    _memberNumber.backgroundColor = [UIColor initWithNormalGray];
    _memberNumber.font = FONTSIZE16;
    _memberNumber.textColor = [UIColor whiteColor];
    _memberNumber.textAlignment = NSTextAlignmentCenter;
    _memberNumber.text = @"8";
    
    UILabel *titleThree = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 48, 324, 96, 16)];
    titleThree.font = FONTSIZE16;
    titleThree.textColor = [UIColor initWithNormalGray];
    titleThree.text = @"最迟闭团时间";
    
    UILabel *closeTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 360, 290, 60)];
    closeTime.backgroundColor = [UIColor whiteColor];
    closeTime.font = FONTSIZE16;
    closeTime.textColor = [UIColor initWithNormalGray];
    closeTime.textAlignment = NSTextAlignmentCenter;
    closeTime.text = [NSString stringWithFormat:@"%@      共15天",_closeDate];
    
    UILabel *titleFour = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 464, 64, 16)];
    titleFour.font = FONTSIZE16;
    titleFour.textColor = [UIColor initWithNormalGray];
    titleFour.text = @"上传照片";
    
    _imagePicker = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 500, 290, 60)];
    [_imagePicker setBackgroundImage:[UIImage imageNamed:@"btn_uploadimg"] forState:UIControlStateNormal];
    [_imagePicker addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    _tip = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 42, 570, 84, 16)];
    _tip.font = FONTSIZE12;
    _tip.textColor = [UIColor initWithNormalGray];
    _tip.text = @"让别人更了解你";
    
    
    [_scrollView addSubview:titleOne];
    [_scrollView addSubview:_scoreLable];
    [_scrollView addSubview:_minusButton];
    [_scrollView addSubview:_plusbutton];
    [_scrollView addSubview:titleTwo];
    [_scrollView addSubview:_memberNumber];
    [_scrollView addSubview:titleThree];
    [_scrollView addSubview:closeTime];
    [_scrollView addSubview:titleFour];
    [_scrollView addSubview:_imagePicker];
    [_scrollView addSubview:_tip];
    
    CGFloat maxHegiht = CGRectGetMaxY(_tip.frame);
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht);
}

-(void)setUpImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
}

#pragma mark - operations

-(void)changeScore:(UIButton *)sender{
    int score = [_scoreLable.text intValue];
    if (sender.tag == 0) {
        score -= SCORE_STEP;
    }
    if (sender.tag == 1) {
        score += SCORE_STEP;
    }
    _scoreLable.text = [NSString stringWithFormat:@"%d",score];
    if ([_scoreLable.text isEqualToString:@"300"]) {
        _minusButton.userInteractionEnabled = NO;
        [_minusButton setImage:[UIImage imageNamed:@"icon_minus_disabled"] forState:UIControlStateNormal];
    } else {
        _minusButton.userInteractionEnabled = YES;
        [_minusButton setImage:[UIImage imageNamed:@"icon_minus_abled"] forState:UIControlStateNormal];
    }
}

-(void)imagePicker{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    _imageScale = image.size.height / image.size.width;
    NSURL *imageURL = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
    _imageName = [[imageString componentsSeparatedByString:@"="][1] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    _fileData = UIImageJPEGRepresentation(image, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_imagePicker setBackgroundImage:image forState:UIControlStateNormal];
        _imagePicker.frame = CGRectMake(SCREENWIDTH / 2 - 145, 500, 290, 290 * _imageScale);
        _tip.frame = CGRectMake(SCREENWIDTH / 2 - 42, 510 + 290 * _imageScale, 84, 16);
        CGFloat maxHegiht = CGRectGetMaxY(_tip.frame);
        
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht);
    }];
    
    
//    [formData appendPartWithFileData:fileData name:self.nameArray[index] fileName:self.nameArray[index] mimeType:@"image/jpeg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
