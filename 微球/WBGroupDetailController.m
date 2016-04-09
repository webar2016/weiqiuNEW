//
//  WBGroupDetailController.m
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupDetailController.h"
#import "LoadViewController.h"

#import "AFHTTPSessionManager.h"
#import <RongIMKit/RongIMKit.h>

#import "NSString+string.h"

#define SCORE_STEP 50
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
    
    BOOL        _imageFromAlbum;
    BOOL        _isSuccess;
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
    if (![WBUserDefaults userId]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你还没有登陆，先去登陆吧！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LoadViewController *loadView = [[LoadViewController alloc]init];
                [self presentViewController:loadView animated:YES completion:nil];
            }];
            action;
        })];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    if (!_fileData) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你还没有上传照片" message:@"快点上传照片\n吸引更多的小伙伴加入你的帮帮团！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:alert completion:nil];
            }];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self showHUD:@"正在努力上传" isDim:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.dataDic[@"beginTime"] = _currentDate;
    self.dataDic[@"endTime"] = _closeDate;
    self.dataDic[@"maxMembers"] = _memberNumber.text;
    self.dataDic[@"imgRate"] = [NSString stringWithFormat:@"%.2f",_imageScale];
    self.dataDic[@"rewardIntegral"] = _scoreLable.text;
    self.dataDic[@"userId"] = [WBUserDefaults userId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/createHG"];
    [manager POST:url parameters:self.dataDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:_fileData name:_imageName fileName:_imageName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _isSuccess = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showNewGroup" object:self];
        [self showHUDComplete:@"创建成功，可在【我创建的】查看"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createSuccess" object:self];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isSuccess = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self showHUDComplete:@"创建失败，请稍后重试"];
    }];
}

-(void)dismissView{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI

-(void)setUpUI{
    UILabel *titleOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 44, 64, 16)];
    titleOne.font = FONTSIZE16;
    titleOne.textColor = [UIColor initWithNormalGray];
    titleOne.text = @"悬赏球币";
    
    _scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 90, 80, 180, 60)];
    _scoreLable.backgroundColor = [UIColor whiteColor];
    _scoreLable.textColor = [UIColor initWithNormalGray];
    _scoreLable.font = FONTSIZE16;
    _scoreLable.textAlignment = NSTextAlignmentCenter;
    _scoreLable.text = @"1000";
    
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
    [_imagePicker addTarget:self action:@selector(imagePickerAlert) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht + 40);
}

#pragma mark - score and member operations

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
    } else if ([_scoreLable.text isEqualToString:@"5000"]) {
        _plusbutton.userInteractionEnabled = NO;
        [_plusbutton setImage:[UIImage imageNamed:@"icon_add_dis"] forState:UIControlStateNormal];
    } else {
        _minusButton.userInteractionEnabled = YES;
        [_minusButton setImage:[UIImage imageNamed:@"icon_minus_abled"] forState:UIControlStateNormal];
        _plusbutton.userInteractionEnabled = YES;
        [_plusbutton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    }
    [self checkMaxMember];
}

-(void)checkMaxMember{
    int score = [_scoreLable.text intValue];
    if (score <= 500) {
        _memberNumber.text = @"4";
    } else if ( score > 500 && score <= 1000) {
        _memberNumber.text = @"8";
    } else if ( score > 1000 && score <= 2000) {
        _memberNumber.text = @"16";
    } else if ( score > 2000 && score <= 3000) {
        _memberNumber.text = @"20";
    } else if ( score > 3000 && score <= 4000) {
        _memberNumber.text = @"24";
    } else if ( score > 4000 && score < 5000) {
        _memberNumber.text = @"32";
    } else {
        _memberNumber.text = @"36";
    }
}

#pragma mark - image operations

-(void)setUpImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = NO;
}

-(void)imagePickerAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _imageFromAlbum = YES;
            [self imagePicker];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _imageFromAlbum = NO;
            [self imagePicker];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }];
        action;
    })];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)imagePicker{
    if (_imageFromAlbum) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _imageScale = image.size.height / image.size.width;
    _fileData = UIImageJPEGRepresentation(image, 0.2);
    
    if (!_imageFromAlbum) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        _imageName = [[NSString ret32bitString] stringByAppendingString:@".JPG"];
    } else {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
        _imageName = [[imageString componentsSeparatedByString:@"="][1] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    }

    [picker dismissViewControllerAnimated:YES completion:^{
        [_imagePicker setBackgroundImage:image forState:UIControlStateNormal];
        _imagePicker.frame = CGRectMake(SCREENWIDTH / 2 - 145, 500, 290, 290 * _imageScale);
        _tip.frame = CGRectMake(SCREENWIDTH / 2 - 42, 510 + 290 * _imageScale, 84, 16);
        CGFloat maxHegiht = CGRectGetMaxY(_tip.frame);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, maxHegiht + 40);
    }];
}

- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    NSLog(@"图片保存完毕");
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
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:2];
    if (_isSuccess) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0f];
    }
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
