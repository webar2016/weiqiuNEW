//
//  WBTopicXibTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/4/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicXibTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MyDownLoadManager.h"
#import "UIImageView+WebCache.h"

@implementation WBTopicXibTableViewCell


- (void)configModel:(TopicDetailModel *)model indexPath:(NSIndexPath *)indexPath {
    self.contentView.backgroundColor = [UIColor initWithBackgroundGray];
    
    self.model = model;
    self.indexPath = indexPath;
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSelfPage)];
    [_headImageView addGestureRecognizer:headTap];
   


    _nickNameLabel.textColor = [UIColor initWithLightGray];
    _nickNameLabel.text = model.tblUser.nickname;
    
    
    _timeLabel.textColor = [UIColor initWithLightGray];
    _timeLabel.text = model.timeStr;
    
    _attentionButton.layer.masksToBounds = YES;
    _attentionButton.layer.cornerRadius = 2;
    [_attentionButton addTarget:self action:@selector(attentionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if (model.userId ==[[WBUserDefaults userId] integerValue]) {
        _attentionButton.alpha = 0;
        
    }else{
        if (model.isFriend) {
            [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            _attentionButton.backgroundColor = [UIColor initWithBackgroundGray];
        }else{
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            _attentionButton.backgroundColor = [UIColor initWithGreen];
        }
    }

    if (model.newsType == 1) {
        _mainImageView.frame = CGRectMake(0, _mainImageView.frame.origin.y, SCREENWIDTH, [model.imgRate floatValue]*SCREENWIDTH);
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    }else if (model.newsType ==2){
        _mainImageView.frame = CGRectMake(0, _mainImageView.frame.origin.y, SCREENWIDTH, [model.imgRate floatValue]*SCREENWIDTH);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:model.mediaPic] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"显示当前进度");
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSLog(@"下载完成");
           _mainImageView.image =  [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
        }];
        
        
    }else{
        _mainImageView.frame = CGRectMake(10, _mainImageView.frame.origin.y, SCREENWIDTH-10, [model.imgRate floatValue]*(SCREENWIDTH-20));
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    }
    
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, [self calculateLabelHeight:model.comment]);
    _contentLabel.text = model.comment;
    _contentLabel.textColor = [UIColor initWithLightGray];
    
    NSLog(@"1111111  -------%ld",(long)_model.userId);
   
    
}


//计算文字高度
-(CGFloat)calculateLabelHeight:(NSString *)str{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREENWIDTH-20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

#pragma mark -----点击事件-------
#pragma 点击事件

//去个人主页
-(void)gotoSelfPage{
    [self.delegate gotoHomePage:_indexPath];
    
}

//分享事件
-(void)shareBtnClicked{
    
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_unclockmesg.png"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}

//评论点击事件
-(void)commentBtnClicked{
    //  NSLog(@" id = %ld",self.model.commentId);
    [self.delegate commentClickedPushView:self.indexPath];
}

-(void)attentionBtnClicked{
    if ([_attentionButton.titleLabel.text isEqualToString:@"关注"]) {
        NSLog(@"_model.userId%ld",(long)_model.userId);
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/followFriend?userId=%@&friendId=%ld",[WBUserDefaults userId],(long)_model.userId] whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"msg"]isEqualToString:@"关注成功"]) {
                [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                [_attentionButton setBackgroundColor:[UIColor initWithBackgroundGray]];
            }
            
        } andFailure:^(NSString *error) {
            
        }];
        
    }else{
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/cancelFollow?userId=%@&friendId=%ld",[WBUserDefaults userId],(long)_model.userId] whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"msg"]isEqualToString:@"取消关注成功"]) {
                [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
                [_attentionButton setBackgroundColor:[UIColor initWithGreen]];
            }
            
        } andFailure:^(NSString *error) {
            
        }];
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
