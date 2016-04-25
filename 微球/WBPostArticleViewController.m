//
//  WBPostArticleViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostArticleViewController.h"
#import "WBTextAttachment.h"
#import "WBDraftSave.h"

#import "AFHTTPSessionManager.h"

#import "NSAttributedString + attributedString.h"

#define POST_URL @"http://app.weiqiu.me/tq/setAnswer?userId=%d&answerText=%@&groupId=%d&questionId=%d"

@interface WBPostArticleViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSKeyedArchiverDelegate>
{
    UITextView *_textView;
    UIImagePickerController *_imagePickerController;
    UIButton *_cancelPreview;
    
    NSAttributedString *_breakLine;
    NSMutableParagraphStyle *_paragraphStyle;
    
    BOOL _isSuccess;
    
//    BOOL _hasDraft;
//    WBDraftSave *_savedDraft;
//    NSString *_draftContentPath;
//    NSString *_draftImagePath;
//    NSString *_draftImgNamePath;
    NSMutableArray *_imageArray;
    NSMutableArray *_nameArray;
    NSMutableArray *_imageRate;
    

}

//@property (nonatomic, strong) NSMutableArray *imageArray;
//@property (nonatomic, strong) NSMutableArray *nameArray;
//@property (nonatomic, strong) NSMutableArray *imageRate;

@end

@implementation WBPostArticleViewController

- (instancetype)initWithTopicId:(NSString *)topicId title:(NSString *)title{
    if (self = [super init]) {
        self.draftTitle = title;
        self.topicID = topicId;
        self.url = @"http://app.weiqiu.me/tq/setComment";
    }
    return self;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setParameters{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray:self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
    
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
    _imagePickerController.allowsEditing = NO;
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
//    _textView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 40);
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
//    _textView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 100 - 270);
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
//    _textView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - MARGINOUTSIDE - 40);
    [self.imageArray removeAllObjects];
    [self.nameArray removeAllObjects];
    
    NSString *plainString = [[NSString alloc] init];
//    if (_hasDraft) {
//        plainString = _savedDraft.content;
//        self.imageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_draftImagePath];
//        self.nameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_draftImgNamePath];
//    } else {
        plainString = [_textView.textStorage getPlainStringWithImageArray: self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
//    }
    
    NSUInteger count = self.imageArray.count;
    
    NSString *rateString = [[NSString alloc] init];
    for (int i = 0; i < count; i ++) {
        if (i == 0) {
            rateString = [rateString stringByAppendingString:self.imageRate[i]];
        } else {
            rateString = [rateString stringByAppendingString:[NSString stringWithFormat:@";%@",self.imageRate[i]]];
        }
    }
    
    [self.parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [self.parameters setObject:rateString forKey:@"imgRate"];
    [self.parameters setObject:self.topicID forKey:@"topicId"];
    [self.parameters setObject:@"3" forKey:@"newsType"];
    [self.parameters setObject:plainString forKey:@"comment"];
}

- (NSDictionary *)draftDic{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray:self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [WBUserDefaults userId];
    dic[@"type"] = @"2";
    dic[@"aim"] = @"3";
    dic[@"contentId"] = self.topicID;
    dic[@"title"] = self.draftTitle;
    dic[@"content"] = plainString;
    dic[@"imagesArray"] = self.imageArray;
    dic[@"nameArray"] = self.nameArray;
    dic[@"imageRate"] = self.imageRate;
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
