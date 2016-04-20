//
//  WBArticalBaseViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBArticalBaseViewController.h"

@interface WBArticalBaseViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
    UIButton *_cancelPreview;
    
    NSAttributedString *_breakLine;
    NSMutableParagraphStyle *_paragraphStyle;
    
    BOOL _isSuccess;
}
@end

@implementation WBArticalBaseViewController

-(NSMutableArray *)imageArray{
    if (_imageArray) {
        return _imageArray;
    }
    _imageArray = [NSMutableArray array];
    return _imageArray;
}

-(NSMutableDictionary *)parameters{
    if (_parameters) {
        return _parameters;
    }
    _parameters = [NSMutableDictionary dictionary];
    return _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtton.frame = CGRectMake(0, 0, 48, 22) ;
    rightBtton.backgroundColor = [UIColor initWithGreen];
    rightBtton.titleLabel.font = MAINFONTSIZE;
    rightBtton.layer.cornerRadius = 5;
    [rightBtton setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtton addTarget:self action:@selector(releaseArticle) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _breakLine = [[NSAttributedString alloc] initWithString:@"\n"];
    _paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [self setUpTextView];
    
    [self setUpImagePicker];
}

#pragma mark - 创建文本框

-(void)setUpTextView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height)];
    _textView.textContainerInset = UIEdgeInsetsMake(MARGININSIDE, MARGININSIDE, MARGININSIDE * 4, MARGININSIDE);
    _textView.font = MAINFONTSIZE;
    _textView.delegate = self;
    _textView.keyboardType = UIKeyboardTypeDefault;
    
    //工具条
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    toolbar.backgroundColor = [UIColor whiteColor];
    
    UIButton *imagePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 2 + 1, 40)];
    [imagePicker setImage:[UIImage imageNamed:@"icon_img"] forState:UIControlStateNormal];
    [imagePicker setTitle:@"插入图片" forState:UIControlStateNormal];
    [imagePicker addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    [imagePicker setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    imagePicker.titleLabel.font = MAINFONTSIZE;
    UIView *breakLine = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2, 5, 1, 30)];
    breakLine.backgroundColor = [UIColor initWithBackgroundGray];
    [imagePicker addSubview:breakLine];
    
    UIButton *preview = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2, 0, SCREENWIDTH / 2 - 1, 40)];
    [preview setImage:[UIImage imageNamed:@"icon_overview"] forState:UIControlStateNormal];
    [preview setTitle:@"预览" forState:UIControlStateNormal];
    [preview addTarget:self action:@selector(contentPreview) forControlEvents:UIControlEventTouchUpInside];
    [preview setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    preview.titleLabel.font = MAINFONTSIZE;
    
    UIBarButtonItem *imagePickerButton = [[UIBarButtonItem alloc] initWithCustomView:imagePicker];
    UIBarButtonItem *previewButton = [[UIBarButtonItem alloc] initWithCustomView:preview];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar.items = @[flexSpace,imagePickerButton,flexSpace,previewButton,flexSpace];
    _textView.inputAccessoryView = toolbar;
    
    [_textView becomeFirstResponder];
    
    [self.view addSubview:_textView];
}

-(void)setUpImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = YES;
}

#pragma  mark - 操作

-(void)imagePicker{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)contentPreview{
    if (_textView.textStorage.length == 0) {
        [self showHUDText:@"写点内容再预览吧！"];
        return;
    }
    
    [_textView resignFirstResponder];
    _textView.editable = NO;
    _cancelPreview = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, SCREENHEIGHT - 100, 60, 14)];
    _cancelPreview.titleLabel.font = MAINFONTSIZE;
    _textView.inputAccessoryView.hidden = YES;
    [_cancelPreview setTitle:@"退出预览" forState:UIControlStateNormal];
    [_cancelPreview setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    [_cancelPreview addTarget:self action:@selector(cancelPreview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelPreview];
}

-(void)cancelPreview{
    _textView.editable = YES;
    [_cancelPreview removeFromSuperview];
    _textView.inputAccessoryView.hidden = NO;
    [_textView becomeFirstResponder];
    _textView.selectedRange = NSMakeRange(_textView.textStorage.length,0);
}

-(void)releaseArticle{
    if (_textView.textStorage.length == 0) {
        [self showHUDText:@"写点内容再发布吧"];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHUD:@"正在努力发布" isDim:YES];
    [_textView resignFirstResponder];
    _textView.editable = NO;
    [self.imageArray removeAllObjects];
    
    [self setParameters];
    
    [self upLoadArtical];
}

- (void)setParameters{
}

- (void)upLoadArtical{
    [self saveDraft];
    return;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:self.url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger count = self.imageArray.count;
        for (NSUInteger index = 0; index < count; index ++) {
            NSData *fileData = UIImageJPEGRepresentation(((WBImage *)self.imageArray[index]).image, 0.4);
            [formData appendPartWithFileData:fileData name:((WBImage *)self.imageArray[index]).imageName fileName:((WBImage *)self.imageArray[index]).imageName mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _isSuccess = YES;
        [self showHUDComplete:@"发布成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isSuccess = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络状态不佳,是否保存草稿？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //save draft
                [self saveDraft];
            }];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSURL *imageURL = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
    NSString *imageName = [[imageString componentsSeparatedByString:@"="][1] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        UIImage *currentImage = [UIImage imageWithData:data];
        
        WBTextAttachment *attacment = [[WBTextAttachment alloc] init];
        attacment.image = currentImage;
        attacment.imageRate = [NSString stringWithFormat:@"%.2f",currentImage.size.height / currentImage.size.width];
        attacment.name = imageName;
        attacment.maxSize = CGSizeMake(SCREENWIDTH - MARGININSIDE * 3, 300);
        if (_textView.textStorage.length != 0) {
            [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attacment] atIndex:_textView.selectedRange.location];
            [_textView.textStorage insertAttributedString:_breakLine atIndex:_textView.selectedRange.location + 1];
            _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 2,0);
        }else{
            [_textView.textStorage appendAttributedString:[NSAttributedString attributedStringWithAttachment:attacment]];
            [_textView.textStorage appendAttributedString:_breakLine];
            _textView.selectedRange = NSMakeRange(_textView.textStorage.length,0);
        }
        [_textView becomeFirstResponder];
        
    }];
}

#pragma mark - textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    _textView.frame = CGRectMake(0.0f, 0.0f,SCREENWIDTH,self.view.frame.size.height - 216.0 -100.0);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    _textView.frame = CGRectMake(0.0f, 0.0f,SCREENWIDTH,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textViewDidChange:(UITextView *)textView{
    _textView.textColor = [UIColor initWithNormalGray];
    _paragraphStyle.lineSpacing = MARGINOUTSIDE;
    _paragraphStyle.paragraphSpacing = MARGINOUTSIDE * 2;
    NSDictionary *attributes = @{ NSFontAttributeName:MAINFONTSIZE, NSParagraphStyleAttributeName:_paragraphStyle};
    
    [_textView.textStorage addAttributes:attributes range:NSMakeRange(0, _textView.textStorage.length)];
}

#pragma mark - draft operations

- (void)saveDraft{
    NSDictionary *draftDic = [self draftDic];
    BOOL saveOK = [[WBDraftManager openDraft] draftWithData:[[WBDraftSave alloc] initWithData:draftDic]];
    if (saveOK) {
        [self showHUDText:@"草稿已保存"];
    } else {
        [self showHUDText:@"草稿保存失败"];
    }
}

- (NSDictionary *)draftDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

#pragma mark - MBprogress

-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:2.0];
    if (_isSuccess) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0];
    }
}

-(void)dismissView{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end