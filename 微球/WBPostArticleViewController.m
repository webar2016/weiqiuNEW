//
//  WBPostArticleViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostArticleViewController.h"
#import "WBTextAttachment.h"

#import "AFHTTPSessionManager.h"

#import "NSAttributedString + attributedString.h"

#define POST_URL @"http://121.40.132.44:92/tq/setAnswer?userId=%d&answerText=%@&groupId=%d&questionId=%d"

@interface WBPostArticleViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView *_textView;
    UIImagePickerController *_imagePickerController;
    UIButton *_cancelPreview;
    
    NSAttributedString *_breakLine;
    NSMutableParagraphStyle *_paragraphStyle;
}

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *nameArray;

@end

@implementation WBPostArticleViewController

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
    // Do any additional setup after loading the view.
}

#pragma mark - 创建文本框

-(void)setUpTextView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 100 - 270)];
    _textView.textContainerInset = UIEdgeInsetsMake(MARGININSIDE, MARGININSIDE, MARGININSIDE * 4, MARGININSIDE);
    _textView.font = MAINFONTSIZE;
    _textView.delegate = self;
    _textView.keyboardType = UIKeyboardTypeDefault;
    
    //工具条
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"bg-11"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIButton *imagePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 2, 40)];
    [imagePicker setImage:[UIImage imageNamed:@"icon_img"] forState:UIControlStateNormal];
    [imagePicker setTitle:@"插入图片" forState:UIControlStateNormal];
    [imagePicker addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    [imagePicker setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    imagePicker.titleLabel.font = MAINFONTSIZE;
    
    UIButton *preview = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2, 0, SCREENWIDTH / 2, 40)];
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
    _imagePickerController.allowsEditing = YES;
}

#pragma  mark - 操作

-(void)imagePicker{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)contentPreview{
    if (_textView.textStorage.length == 0) {
        NSLog(@"写点东西再预览吧！");
        return;
    }
    
    [_textView resignFirstResponder];
    _textView.editable = NO;
    _textView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 40);
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
    _textView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 100 - 270);
    [_cancelPreview removeFromSuperview];
    _textView.inputAccessoryView.hidden = NO;
    [_textView becomeFirstResponder];
    _textView.selectedRange = NSMakeRange(_textView.textStorage.length,0);
}

-(void)releaseArticle{
    if (_textView.textStorage.length == 0) {
        return;
    }
    
    [self.imageArray removeAllObjects];
    [self.nameArray removeAllObjects];
    NSString *plainString = [_textView.textStorage getPlainStringWithImageArray: self.imageArray byNameArray:self.nameArray];
    
    NSUInteger count = self.imageArray.count;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [parameters setObject:plainString forKey:@"answerText"];
    
    if (self.isQuestionAnswer) {
        [parameters setObject:self.groupId forKey:@"groupId"];
        [parameters setObject:self.qusetionId forKey:@"questionId"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/setAnswer"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger index = 0; index < count; index ++) {
            NSData *fileData = UIImageJPEGRepresentation(self.imageArray[index], 1.0);
            [formData appendPartWithFileData:fileData name:self.nameArray[index] fileName:self.nameArray[index] mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
//    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    NSURL *imageURL = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    NSString *imageString = [NSString stringWithFormat:@"%@",imageURL];
    NSString *imageName = [[imageString componentsSeparatedByString:@"="][1] stringByAppendingString:[NSString stringWithFormat:@".%@",[imageString componentsSeparatedByString:@"="].lastObject]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        WBTextAttachment *attacment = [[WBTextAttachment alloc] init];
        attacment.image = image;
        attacment.name = imageName;
        attacment.maxSize = CGSizeMake(SCREENWIDTH - MARGININSIDE * 3, 300);
        if (_textView.textStorage.length != 0) {
//            [_textView.textStorage insertAttributedString:_breakLine atIndex:_textView.selectedRange.location];
            [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attacment] atIndex:_textView.selectedRange.location];//location+1
            [_textView.textStorage insertAttributedString:_breakLine atIndex:_textView.selectedRange.location + 1];//location+2
            _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 2,0);//location+3
        }else{
            [_textView.textStorage appendAttributedString:[NSAttributedString attributedStringWithAttachment:attacment]];
            [_textView.textStorage appendAttributedString:_breakLine];
            _textView.selectedRange = NSMakeRange(_textView.textStorage.length,0);
        }
        
        [_textView becomeFirstResponder];
        
    }];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView{
    _textView.textColor = [UIColor initWithNormalGray];
    _paragraphStyle.lineSpacing = MARGINOUTSIDE;
    _paragraphStyle.paragraphSpacing = MARGINOUTSIDE * 2;
    NSDictionary *attributes = @{ NSFontAttributeName:MAINFONTSIZE, NSParagraphStyleAttributeName:_paragraphStyle};
    
    [_textView.textStorage addAttributes:attributes range:NSMakeRange(0, _textView.textStorage.length)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
