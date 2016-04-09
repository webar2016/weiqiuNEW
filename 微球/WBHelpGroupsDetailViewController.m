//
//  WBHelpGroupsDetailViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHelpGroupsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MyDownLoadManager.h"
#import "LoadViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "WBHomepageViewController.h"
#import "MyDBmanager.h"



@interface WBHelpGroupsDetailViewController ()
{
    UIScrollView *_scrollView;

    UIImageView *_mainImageView;
    UIView *_backGroungViewOne;
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIButton *_ageButton;
    NSString *_dataStr;
    UIButton *_cancelBtn;
    UIButton *_ensureBtn;
    BOOL _isSuccess;
}
@end

@implementation WBHelpGroupsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageHeight > SCREENHEIGHT / 3 * 2 ? _imageHeight = SCREENHEIGHT / 3 * 2 : _imageHeight;
    
    [self createUI];
    [self createButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self checkInGroup];
}

-(void)checkInGroup{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/hg/checkIn?userId=%@&groupId=%ld",[WBUserDefaults userId],(long)self.model.groupId] whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"false"]) {
            [_ensureBtn setTitle:@"加入帮帮团" forState:UIControlStateNormal];
            _ensureBtn.backgroundColor = [UIColor initWithGreen];
            [_ensureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [_ensureBtn setTitle:@"已加入" forState:UIControlStateNormal];
            _ensureBtn.backgroundColor = [UIColor initWithNormalGray];
        }
       
    } andFailure:^(NSString *error) {
        
    }];
}

-(void)createUI{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    // 设置UIScrollView的滚动范围（内容大小）
     _scrollView.contentSize = CGSizeMake(SCREENWIDTH, _imageHeight+350) ;
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _imageHeight)];
    [_scrollView addSubview:_mainImageView];
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_model.dir]];
    _mainImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewer)];
    [_mainImageView addGestureRecognizer:tapImage];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage)];
    [_headImageView addGestureRecognizer:tap];
    [_scrollView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    [_scrollView addSubview:_nameLabel];
    
    _timeLabel= [[UILabel alloc]init];
    [_scrollView addSubview:_timeLabel];
    
    _ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scrollView addSubview:_ageButton];
    _headImageView.frame = CGRectMake(4, 20+_imageHeight+5, 30, 30);
    
    _timeLabel.frame = CGRectMake(40, 20+_imageHeight+10+15, 80, 10);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    CGSize  actualsize =[ _model.tblUser.nickname boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    _nameLabel.frame = CGRectMake(40, 20+_imageHeight+10, actualsize.width, 10);
    _ageButton.frame = CGRectMake(40+actualsize.width+10, 20+_imageHeight+10, 20, 10);

    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.tblUser.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15;
    
    
    _nameLabel.text = _model.tblUser.nickname;
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [UIColor initWithLightGray];
    
    
    _timeLabel.text = _model.beginTime;
    _timeLabel.font = SMALLFONTSIZE;
    _timeLabel.textColor = [UIColor initWithLightGray];
    
    _ageButton.layer.cornerRadius = 3;
    if ([_model.tblUser.sex isEqualToString:@"男"]) {
        [_ageButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
        _ageButton.backgroundColor = [UIColor initWithGreen];
    }else{
        [_ageButton setImage:[UIImage imageNamed:@"icon_female.png"] forState:UIControlStateNormal];
        _ageButton.backgroundColor = [UIColor initWithPink];
    }
    
    [_ageButton setTitle:[NSString stringWithFormat:@"%ld",(long)_model.tblUser.age]  forState:UIControlStateNormal];
    
    _ageButton.titleLabel.font = SMALLFONTSIZE;

    [self createGroupOne];
}

-(void)createGroupOne{
    NSArray *imageNameArray = @[@"icon_destination.png",@"icon_cuttime.png",@"icon_traveldate.png",@"icon_tag2.png",@"icon_grouplimit.png",@"icon_qiupiao2.png"];
    NSArray *labelNameArray = @[@"目的地",@"闭团日期",@"行程日起",@"标签",@"人数上限",@"悬赏球币"];
    
    NSArray *cellHeightyArray = @[@13,@51,@89,@131,@173,@211];
    
   // NSLog(@"model. = %@",_model.theme);
    if (!_model.planBegin||!_model.planEnd) {
        _dataStr = @"未填写";
    }else{
        _dataStr =[NSString stringWithFormat:@"%@至%@",_model.planBegin,_model.planEnd];
    }
    
    
    NSArray *rightLabelNameArray = @[_model.tblUser.position,_model.endTime, _dataStr,[NSString stringWithFormat:@"%@",_model.groupSign],[NSString stringWithFormat:@"%ld人",(long)_model.maxMembers],[NSString stringWithFormat:@"%ld球币",(long)_model.rewardIntegral]];
    
    
    
    for (NSInteger i=0; i<6; i++) {
        UIImageView  *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(22, _imageHeight+55+[cellHeightyArray[i] integerValue], 17, 17)];
        headImage.image = [UIImage imageNamed:imageNameArray[i]];
        [_scrollView addSubview:headImage];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(50, _imageHeight+55+[cellHeightyArray[i] integerValue], 150, 16)];
        [_scrollView addSubview:labelName];
        labelName.text = labelNameArray[i];
        labelName.font = MAINFONTSIZE;
        labelName.textColor = [UIColor initWithLightGray];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, _imageHeight+55+[cellHeightyArray[i] integerValue], SCREENWIDTH-150-20, 16)];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [_scrollView addSubview:rightLabel];
        rightLabel.text = rightLabelNameArray[i];
        rightLabel.font = MAINFONTSIZE;
        rightLabel.textColor = [UIColor initWithLightGray];
    }

}



-(void)createButton{
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, SCREENWIDTH/2, 49)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _cancelBtn.tag = 100;
    _cancelBtn.backgroundColor = [UIColor initWithBackgroundGray];
    [_cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, self.view.frame.size.height-49, SCREENWIDTH/2, 49)];
    if ([WBUserDefaults userId]) {
        _ensureBtn.backgroundColor = [UIColor initWithNormalGray];
        [_ensureBtn setTitle:@"已加入" forState:UIControlStateNormal];
    } else {
        _ensureBtn.backgroundColor = [UIColor initWithGreen];
        [_ensureBtn setTitle:@"登陆加入帮帮团" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(loginWebar) forControlEvents:UIControlEventTouchUpInside];
    }
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ensureBtn.tag = 101;
    
    [self.view addSubview:_cancelBtn];
    [self.view addSubview:_ensureBtn];
}

-(void)loginWebar{
    LoadViewController *loadView = [[LoadViewController alloc]init];
    [self presentViewController:loadView animated:YES completion:nil];
}

// 加入帮帮团
-(void)btnClicked:(UIButton *)btn{
    

    if (btn.tag ==100) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        btn.enabled = NO;
        [self showHUD:@"正在加入" isDim:YES];
        
        MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
        if ([manager  isAddedItemsID:[NSString stringWithFormat:@"%ld",_model.tblUser.cityNum]]) {
            
            
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/hg/jion?groupId=%ld&userId=%@",(long)_model.groupId,[WBUserDefaults userId]] whenSuccess:^(id representData) {
                _isSuccess = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showNewGroup" object:self];
                [self showHUDComplete:@"加入成功，可在【我加入的】查看"];
                UIButton *btn = (UIButton *)[self.view viewWithTag:101];
                [btn setEnabled:NO];
                btn.userInteractionEnabled = NO;
                [_ensureBtn setTitle:@"已加入" forState:UIControlStateNormal];
                [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _ensureBtn.backgroundColor = [UIColor initWithNormalGray];
                
            } andFailure:^(NSString *error) {
                _isSuccess = NO;
                btn.enabled = YES;
                [self showHUDText:@"加入失败，请稍后重试"];
            }];
        }else{
            btn.enabled = YES;
            [self showHUDText:@"你还没有解锁这个城市，请先解锁后再加入"];
        }
        
        
        
       
    }
}


//进入个人主页
-(void)goHomePage{
    
    WBHomepageViewController *HVC = [[WBHomepageViewController alloc]init];
    HVC.userId = [NSString stringWithFormat:@"%ld",(long)_model.userId];
    
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:HVC animated:YES];
    
}

-(void)showImageViewer{
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithImage:_mainImageView.image];
    [self presentViewController:viewer animated:YES completion:nil];
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MBprogress
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    self.hud.opacity = 0.7;
    [self.hud hide:YES afterDelay:2];
    if (_isSuccess) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0f];
    }
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
