//
//  WBPostVideoViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/31.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostVideoViewController.h"
#import "MyDownLoadManager.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WBPostVideoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UILabel *_placeHoldLabel;
    UITextView *_textView;
    
    UIImagePickerController *_imagePickerController;
    
    
    //选照片界面
    UIView *_imageBackgroungView;
    //预留选择图片控制器
    UIImageView *_placeHoldImageView;
    
    NSURL *_sourceURL ;
}
@end

@implementation WBPostVideoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createUI];
    [self createImagePicker];
}

-(void) createNav{
    //设置标题
    self.navigationItem.title = @"视频";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor initWithDarkGray]}];

    UIButton *rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtton.frame = CGRectMake(0, 0, 48, 22) ;
    rightBtton.backgroundColor = [UIColor initWithGreen];
    rightBtton.titleLabel.font = MAINFONTSIZE;
    rightBtton.layer.cornerRadius = 5;
    [rightBtton setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtton addTarget: self action:@selector(rightBtnclicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}


-(void)createImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = YES;
}


#pragma mark ----点击事件-------
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)createUI{

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 170)];
    _textView.font = MAINFONTSIZE;
    _textView.delegate = self;
    _textView.keyboardType = UIKeyboardTypeDefault;
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoPickClick)];
    [_placeHoldImageView addGestureRecognizer:tap ];



}

-(void)videoPickClick{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:photo];
    [alertController addAction:camera];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];



}


#pragma mark ----点击发布视频-----

-(void)rightBtnclicked{
    [self showHUD:@"正在上传视频" isDim:YES];
    NSData  *fileData = [NSData dataWithContentsOfFile:_sourceURL.path];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [parameters setObject:@"2" forKey:@"newsType"];
    [parameters setObject:_textView.text forKey:@"comment"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",_topicID] forKey:@"topicId"];
    
    [MyDownLoadManager postUserInfoUrl:@"http://121.40.132.44:92/tq/setComment" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"1234" fileName:@"video1.mov" mimeType:@"video/quicktime"];
        
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        [self showHUDComplete:@"上传视频成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"上传视频失败"];
    }];



}


#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
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
    if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
        //如果是视频
        
        _sourceURL = info[UIImagePickerControllerMediaURL];
        
        
        
        
        
    }else{
        
       // UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:<#(UIAlertControllerStyle)#>]
        
        //压缩图片
        
//        NSData *fileData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1.0);
//
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 本体添加图片



#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

#pragma mark ---获取视屏大小----
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}//此方法可以获取视频文件的时长。

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
