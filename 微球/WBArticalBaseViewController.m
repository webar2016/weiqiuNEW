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

-(NSMutableArray *)nameArray{
    if (_nameArray) {
        return _nameArray;
    }
    _nameArray = [NSMutableArray array];
    return _nameArray;
}

-(NSMutableArray *)imageRate{
    if (_imageRate) {
        return _imageRate;
    }
    _imageRate = [NSMutableArray array];
    return _imageRate;
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
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBackAndSave)];
    self.navigationItem.leftBarButtonItem = back;
    
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
    
    if (self.isModified) {
        [self showCurrentDraft];
    }
    
    _textView.selectedRange = NSMakeRange(_textView.textStorage.length,0);
    [_textView becomeFirstResponder];
}

#pragma mark - 创建文本框

-(void)setUpTextView{
    _textView = [[WBAttributeTextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height)];
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
    
    [self.view addSubview:_textView];
}

#pragma mark - operations

-(void)setUpImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _imagePickerController.allowsEditing = NO;
}

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

//有草稿，则显示该草稿

- (void)showCurrentDraft{
    _textView.contentSeparateSign= IMAGE;
    _textView.imageSeparateSign = @";";
    _textView.lineSpacing = MARGINOUTSIDE;
    _textView.paragraphSpacing = MARGINOUTSIDE * 2;
    _textView.fontColor = [UIColor initWithNormalGray];
    _textView.maxSize = CGSizeMake(_textView.textContainer.size.width - MARGINOUTSIDE, 300);
    
    [_textView showDraftWithDraft:self.draft];
}

#pragma mark - release artical

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
    [self.nameArray removeAllObjects];
    [self.imageRate removeAllObjects];
    
    [self setParameters];
    
    [self upLoadArtical];
}

- (void)setParameters{
}

- (void)upLoadArtical{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
    [manager POST:self.url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger count = self.imageArray.count;
        for (NSUInteger index = 0; index < count; index ++) {
            
            
            NSData *fileData = UIImageJPEGRepresentation(self.imageArray[index], 1.0);
            if (fileData.length>500*1024) {
                fileData = UIImageJPEGRepresentation(self.imageArray[index], 500*1024.0/fileData.length);
            }
            
            
            [formData appendPartWithFileData:fileData name:self.nameArray[index] fileName:self.nameArray[index] mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _isSuccess = YES;
        if (self.isModified) {
            [[WBDraftManager openDraft] deleteDraftWithType:self.draft.type contentId:self.draft.contentId userId:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]];
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
            NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@", self.draft.userId,self.draft.type,self.draft.contentId];
            NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:draftPath]){
                [[NSFileManager defaultManager]  removeItemAtPath:draftPath error:nil];
            }
        }
        self.reloadDataBlock();
        [self showHUDComplete:@"发布成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isSuccess = NO;
        [self hideHUD];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络状态不佳,是否保存草稿？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (self.isModified) {
                    [[WBDraftManager openDraft] deleteDraftWithType:self.draft.type contentId:self.draft.contentId userId:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]];
                    
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
                    NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@", self.draft.userId,self.draft.type,self.draft.contentId];
                    NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];
                    
                    if([[NSFileManager defaultManager] fileExistsAtPath:draftPath]){
                        [[NSFileManager defaultManager]  removeItemAtPath:draftPath error:nil];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            action;
        })];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                BOOL saveSuccess = [self saveDraft];
                if (saveSuccess) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
    NSString *imageName = [[[imageString componentsSeparatedByString:@"="][1] substringToIndex:8] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSData *data = UIImageJPEGRepresentation(image, 0.05);
        UIImage *currentImage = [UIImage imageWithData:data];
        
        WBTextAttachment *attacment = [[WBTextAttachment alloc] init];
        attacment.image = currentImage;
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

- (BOOL)saveDraft{
    [self.imageArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.imageRate removeAllObjects];
    NSDictionary *draftDic = [self draftDic];
    
    BOOL saveOK;
    if (self.isModified) {
        saveOK = [[WBDraftManager openDraft] modifiedWithData:[[WBDraftSave alloc] initWithData:draftDic]];
    } else {
        saveOK = [[WBDraftManager openDraft] draftWithData:[[WBDraftSave alloc] initWithData:draftDic]];
    }
    
    if (saveOK) {
        [self showHUDText:@"保存成功"];
    } else {
        [self showHUDText:@"保存失败，请重试"];
    }
    return saveOK;
}

- (NSDictionary *)draftDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

//未发布直接返回
- (void)popBackAndSave{
    if (_isSuccess || _textView.textStorage.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *saveAlertTip = [NSString string];
    if (self.isModified) {
        saveAlertTip = @"不保存则将删除原有草稿";
    } else {
        saveAlertTip = nil;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存草稿？" message:saveAlertTip preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL saveSuccess = [self saveDraft];
            if (saveSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (self.isModified) {
                BOOL isSuccess = [[WBDraftManager openDraft] deleteDraftWithType:self.draft.type contentId:self.draft.contentId userId:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]];
                if (isSuccess) {
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
                    NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@", self.draft.userId,self.draft.type,self.draft.contentId];
                    NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];
                    
                    if([[NSFileManager defaultManager] fileExistsAtPath:draftPath]){
                        [[NSFileManager defaultManager]  removeItemAtPath:draftPath error:nil];
                    }
                    
                } else {
                    [self showHUDText:@"删除失败，请重试"];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MBprogress

-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:1.0];
    if (_isSuccess) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.0];
    }
}

-(void)dismissView{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end