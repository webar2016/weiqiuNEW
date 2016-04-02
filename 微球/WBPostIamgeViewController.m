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

@interface WBPostIamgeViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
    self.navigationItem.title = @"照片";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor initWithDarkGray]}];
    //设置返回按钮
 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_cancel_post.png"] forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = MAINFONTSIZE;
    [button setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 50, 50);
    
    UIBarButtonItem *leftBtuuon = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtuuon;
   //[self.navigationController.navigationBar.topItem setBackBarButtonItem:leftBtuuon];
    
    
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
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
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        
        //添加
        [self addImageInSelf:info[UIImagePickerControllerEditedImage]];
        //压缩图片
        _selectPic =info[UIImagePickerControllerEditedImage];
      //  _picData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.4);
        
       
        
        
        
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 本体添加图片

-(void)addImageInSelf:(UIImage *)image{
    
    _placeHoldImageView.image = image;

//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:_placeHoldImageView.frame];
//    imageView.image = image;
//   
//    [_imageBackgroungView addSubview:imageView];
//    
//    if (_placeHoldImageView.frame.origin.x==15+(SCREENWIDTH-20)/3*2) {
//       _placeHoldImageView.frame  = CGRectMake(5, imageView.frame.origin.y+(5+(SCREENWIDTH-20)/3), (SCREENWIDTH-20)/3, (SCREENWIDTH-20)/3);
//    }else{
//    
//     _placeHoldImageView.frame= CGRectMake(_placeHoldImageView.frame.origin.x+(SCREENWIDTH-20)/3+5, _placeHoldImageView.frame.origin.y, (SCREENWIDTH-20)/3, (SCREENWIDTH-20)/3);
//    }

}

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

#pragma mark -------textView delegate ------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
 
    [_textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [_textView resignFirstResponder];

}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    [_textView resignFirstResponder];
    return YES;

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
#pragma mark ====textviewdelegate====




#pragma mark ------btn ----
-(void)cancelBtnClick{
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)saveBtnClicked{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [parameters setObject:@"1" forKey:@"newsType"];
    [parameters setObject:_textView.text forKey:@"comment"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",_topicID] forKey:@"topicId"];
     CGFloat rate =_selectPic.size.height/_selectPic.size.width;
   [parameters setObject:[NSString stringWithFormat:@"%f",rate] forKey:@"imgRate"];
    NSData *fileData = UIImageJPEGRepresentation(_selectPic, 0.4);
    
    
    
    [MyDownLoadManager postUserInfoUrl:@"http://121.40.132.44:92/tq/setComment" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData name:@"asd" fileName:@"asd.jpg" mimeType:@"image/jpeg"];
        }
        
    } whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        
    } andFailure:^(NSString *error) {
        
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
