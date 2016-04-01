//
//  WBTopicDetailTableViewCell2.m
//  微球
//
//  Created by 贾玉斌 on 16/3/31.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicDetailTableViewCell2.h"

@implementation WBTopicDetailTableViewCell2

{
    UIImageView *_imageView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //   NSLog(@"height = %f,width = %f",imageHeight,labelHeight);
        _backgroungImage = [[UIImageView alloc]init];
        _backgroungImage.backgroundColor = [UIColor initWithBackgroundGray];
        
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_backgroungImage addSubview:_mainView];
        _mainView.layer.cornerRadius = 5.0f;
        
        [self.contentView addSubview:_backgroungImage];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        [_mainView addSubview:_headImageView];
        
        _nickName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 100, 30)];
        _nickName.font =MAINFONTSIZE;
        [_mainView addSubview:_nickName];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 31, 100, 15)];
        _timeLabel.font = SMALLFONTSIZE;
        [_mainView addSubview:_timeLabel];
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.frame = CGRectMake(SCREENWIDTH-70, 14+9, 60, 22) ;
        _attentionButton.titleLabel.font = MAINFONTSIZE;
        _attentionButton.layer.cornerRadius = 5.0f;
        [_attentionButton addTarget:self action:@selector(attentionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionButton];
        
        
        _mainImageView = [[UIImageView alloc]init];
        [_backgroungImage addSubview:_mainImageView];
        _mainImageView.layer.cornerRadius = 5.0f;
        _mainImageView.layer.masksToBounds = YES;
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 41, 41)];
        iconView.image = [UIImage imageNamed:@"icon_broadcast.png"];
        iconView.center = _mainView.center;
        [_backgroungImage addSubview:iconView];
        
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = MAINFONTSIZE;
        [_backgroungImage addSubview:_contentLabel];
        
        
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_backgroungImage addSubview:_footerView];
        
        //分享画面
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.titleLabel.font = MAINFONTSIZE;
        [self.contentView addSubview:_shareButton];
        
        
        //评论页面
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
        
        [_commentButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentButton];
        
        
        _commentButton.titleLabel.font = MAINFONTSIZE;
        [_commentButton addTarget: self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //点赞
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setImage:[UIImage imageNamed:@"icon_like.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_praiseButton];
        [_praiseButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _praiseButton.titleLabel.font = MAINFONTSIZE;
        
        //点赞跳出的提示框
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点赞转积分提示.png"]];
        _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
        [self.contentView addSubview:_imageView];
        _imageView.alpha = 0;
        
    }
    return self;
    
    
    
}





- (void)setModel:(TopicDetailModel *)model  labelHeight:(CGFloat)labelHeight{
    //尺寸设置
    CGFloat imageHeight = [model.imgRate floatValue]*SCREENWIDTH;
    _backgroungImage.frame = CGRectMake(0, 0, SCREENWIDTH, 120+labelHeight+imageHeight);
    
    _mainView.frame = CGRectMake(0, 9, SCREENWIDTH, 60+imageHeight+17+labelHeight+10);
    
    _mainImageView.frame=CGRectMake(0, 60, SCREENWIDTH, imageHeight);
    _contentLabel.frame= CGRectMake(10, 60+imageHeight+17, SCREENWIDTH-20, labelHeight);
    _footerView.frame =CGRectMake(0, 60+imageHeight+17+labelHeight+10+5, SCREENWIDTH, 40);
    _shareButton.frame =CGRectMake(10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    
    _commentButton.frame =CGRectMake(SCREENWIDTH/3+10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    _praiseButton.frame =CGRectMake(SCREENWIDTH-120,  60+imageHeight+17+labelHeight+10+10, 100,16);
    _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    
    _nickName.text =model.tblUser.nickname;
    // NSLog(@"nick = %@",);
    _timeLabel.text = model.timeStr;
    // NSLog(@"model.timeStr = %@",model.timeStr);
    
    if (model.isFriend) {
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor initWithBackgroundGray];
        
    }else{
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor initWithGreen];
    }
    //图片
    if (model.newsType == 1) {
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        
        _contentLabel.text = model.comment;
        
        
        [_commentButton setTitle:[NSString stringWithFormat:@"%ld条评论",model.descussNum] forState:UIControlStateNormal];
        
        [_praiseButton setTitle:[NSString stringWithFormat:@"%ld球币",model.getIntegral] forState:UIControlStateNormal];
        //s视频
    }else if(model.newsType ==2){
        //图文
    }else{
        
        _mainImageView.frame =CGRectMake(10, 60, SCREENWIDTH-20, 175);
        _mainImageView.layer.borderWidth = 2;
        _mainImageView.layer.borderColor =[UIColor colorWithRed:236 green:240 blue:241 alpha:1].CGColor;
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        
        _contentLabel.frame =CGRectMake(10, 60+175+17, SCREENWIDTH-20, _contentLabel.frame.size.height);
        _contentLabel.text = model.comment;
        
        
        _shareButton.frame = CGRectMake(10, 60+175+17+20+_contentLabel.frame.size.height, 100, 16);
        _commentButton.frame =CGRectMake(SCREENWIDTH/3+10,60+175+17+20+_contentLabel.frame.size.height, 100, 16);
        [_commentButton setTitle:[NSString stringWithFormat:@"%ld条评论",model.descussNum] forState:UIControlStateNormal];
        _praiseButton.frame =CGRectMake(SCREENWIDTH-120,  60+175+17+20+_contentLabel.frame.size.height, 100,16);
        
        [_praiseButton setTitle:[NSString stringWithFormat:@"%ld球币",model.getIntegral] forState:UIControlStateNormal];
        
    }
    
    
    // NSLog(@"comment id = %ld",model.commentId);
    
    
}



#pragma 点击事件

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

//点赞事件
-(void)praiseBtnClicked{
    
    
    
    
    [self checkoutConfigDetail];
    
    
    [_praiseButton setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        _praiseButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
        _imageView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(hideWindow:) withObject:nil afterDelay:0.5f];
        
    }];
    
    
}

//检查积分配置信息

-(void)checkoutConfigDetail{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/integral/getIntegralConfigDetil?typeFlag=5"] whenSuccess:^(id representData) {
        
        NSString *str = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        // NSLog(@"getIntegral = %ld",_model.getIntegral);
        [self checkoutIntegral:str];
        
    } andFailure:^(NSString *error) {
        
    }];
    
}

//检查用户积分是否够用
-(void)checkoutIntegral:(NSString *)config{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/integral/checkIntegral?userId=29&updateNum=5"] whenSuccess:^(id representData) {
        
        BOOL isEnough = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        
        
        if (isEnough) {
            [self uploadInformation];
            //  NSLog(@"cxzczxc123");
            
        }else{
            
            //  NSLog(@"cxzczxc123567");
            
        }
        
        
    } andFailure:^(NSString *error) {
        
    }];
    
}


//UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"not enough " message:@"sadsa" preferredStyle:UIAlertControllerStyleAlert];
//UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"zxczxc" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
//
//}];
//[alertController addAction:cancelAction];

//上传信息
-(void)uploadInformation{
    
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/tq/topicPraise?commentId=1&userId=29&toUserId=636"] whenSuccess:^(id representData) {
        
        [self.delegate changeGetIntegralValue:123 indexPath:_indexPath];
        // NSLog(@"daili");
        
    } andFailure:^(NSString *error) {
        
    }];
    
    
}

//点赞事件动画消失

- (void)hideWindow:(id)object

{
    
    
    [UIView animateWithDuration:0.5f animations:^{
        _praiseButton.transform = CGAffineTransformMakeScale(1    ,1);
        _imageView.alpha = 0;
        
    }];
    
}

//
-(void)attentionBtnClicked{
    if ([_attentionButton.titleLabel.text isEqualToString:@"关注"]) {
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_attentionButton setTintColor:[UIColor initWithBackgroundGray]];
    }else{
        
        
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
