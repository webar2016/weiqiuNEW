//
//  WBPostIamgeViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostIamgeViewController.h"
#import "AFHTTPSessionManager.h"
#import "MyDownLoadManager.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBPostIamgeViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextInputTraits>
{
    UILabel *_placeHoldLabel;
    UITextView *_textView;
   
    UIImagePickerController *_imagePickerController;
    
    
    //选照片界面
    UIView *_imageBackgroungView;
    //预留选择图片控制器
    UIImageView *_placeHoldImageView;
    
    UIImage *_selectPic;
}
@end

@implementation WBPostIamgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createNav];
    [self createUI];
    [self createImagePicker];
}


-(void) createNav{
    //设置标题
    self.navigationItem.title = @"发布照片";
    
    UIButton *rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtton.frame = CGRectMake(0, 0, 48, 22) ;
    rightBtton.backgroundColor = [UIColor initWithGreen];
    rightBtton.titleLabel.font = MAINFONTSIZE;
    rightBtton.layer.cornerRadius = 5;
    [rightBtton setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtton addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}



-(void)createUI{

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 170)];
    _textView.font = MAINFONTSIZE;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [_textView becomeFirstResponder];
  
    [contentView addSubview:_textView];
    
    _placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH, 20)];
    _placeHoldLabel.text = @"说点什么吧";
    _placeHoldLabel.font = BIGFONTSIZE;
    _placeHoldLabel.textColor = [UIColor initWithNormalGray];
    [contentView addSubview:_placeHoldLabel];
    
    _imageBackgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, 218, SCREENWIDTH, SCREENHEIGHT-218)];
    _imageBackgroungView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageBackgroungView];
    
    _placeHoldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, (SCREENWIDTH-20)/3, (SCREENWIDTH-20)/3)];
    _placeHoldImageView.image = [UIImage imageNamed:@"btn_addimg.png"];
    [_imageBackgroungView addSubview:_placeHoldImageView];
    _placeHoldImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePickClicked:)];
    [_placeHoldImageView addGestureRecognizer:tap ];
}


-(void)createImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = YES;
}

-(void)imagePickClicked:(UITapGestureRecognizer *)tap{
    [_textView resignFirstResponder];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:photo];
    [alertController addAction:camera];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


#pragma mark -从相册获取图片或视频
- (void)selectImageFromAlbum
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


#pragma mark -UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        [self addImageInSelf:info[UIImagePickerControllerEditedImage]];
        _selectPic =info[UIImagePickerControllerEditedImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 本体添加图片

-(void)addImageInSelf:(UIImage *)image{
    _placeHoldImageView.image = image;
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
}

#pragma mark -------textView delegate ------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.25f];
//    self.view.frame = CGRectMake(0.0f, -70.0,SCREENWIDTH,self.view.frame.size.height);
//    [UIView commitAnimations];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.25f];
//    self.view.frame = CGRectMake(0.0f, 0,SCREENWIDTH,self.view.frame.size.height);
//    [UIView commitAnimations];
//}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    [_textView resignFirstResponder];
    return YES;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (![text isEqualToString:@""]){
        _placeHoldLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        _placeHoldLabel.hidden = NO;
    }
    
    return YES;
    
}

#pragma mark ------btn ----
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)saveBtnClicked{
    [self showHUD:@"正在上传" isDim:YES];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [parameters setObject:@"1" forKey:@"newsType"];
    [parameters setObject:_textView.text forKey:@"comment"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_topicID] forKey:@"topicId"];
     CGFloat rate =_selectPic.size.height/_selectPic.size.width;
   [parameters setObject:[NSString stringWithFormat:@"%f",rate] forKey:@"imgRate"];
    NSData *fileData = UIImageJPEGRepresentation(_selectPic, 0.4);
    
    
    
    [MyDownLoadManager postUserInfoUrl:@"http://121.40.132.44:92/tq/setComment" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData name:@"asd" fileName:@"asd.jpg" mimeType:@"image/jpeg"];
        }
        
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        [self showHUDComplete:@"上传成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"上传失败"];
    }];

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
