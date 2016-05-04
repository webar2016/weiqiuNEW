//
//  WBChatImageViewer.m
//  微球
//
//  Created by 徐亮 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBChatImageViewer.h"

@interface WBChatImageViewer ()

@end

@implementation WBChatImageViewer

-(instancetype)initWithChatModel:(RCMessageModel *)model{
    if (self = [super init]) {
        self.messageModel = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageDownloadDone{
    [self setUpSaveButtonForImage];
}

-(void)setUpSaveButtonForImage{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, 10, 40, 35)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveThisImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

-(void)saveThisImage{
    UIImageWriteToSavedPhotosAlbum(self.originalImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.opacity = 0.7;
    self.hud.dimBackground = NO;
    self.hud.labelText = @"保存成功";
    [self.hud hide:YES afterDelay:1.0];
}

@end
