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
#import <RongIMKit/RongIMKit.h>



@interface WBHelpGroupsDetailViewController ()
{

    UIImageView *_mainImageView;
    UIView *_backGroungViewOne;
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIButton *_ageButton;
    NSString *_dataStr;
    UIButton *_cancelBtn;
    UIButton *_ensureBtn;

}
@end

@implementation WBHelpGroupsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    [self checkInGroup];
    [self createUI];
}

-(void)checkInGroup{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/hg/checkIn?userId=%@&groupId=%ld",[WBUserDefaults userId],self.model.groupId] whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"false"]) {
            [_ensureBtn setTitle:@"确认加入" forState:UIControlStateNormal];
            _ensureBtn.backgroundColor = [UIColor initWithGreen];
            [_ensureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
       
    } andFailure:^(NSString *error) {
        
    }];
}

-(void)createUI{
    
    if(_imageHeight>300){
        _imageHeight = 300;
        
    
    }
    
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, _imageHeight)];
    [self.view addSubview:_mainImageView];
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_model.dir]];
    _mainImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    
    
    
    _headImageView = [[UIImageView alloc]init];
    [self.view addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    [self.view addSubview:_nameLabel];
    
    _timeLabel= [[UILabel alloc]init];
    [self.view addSubview:_timeLabel];
    
    _ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_ageButton];
    _headImageView.frame = CGRectMake(4, 20+_imageHeight+5, 30, 30);
    _nameLabel.frame = CGRectMake(40, 20+_imageHeight+10, 80, 10);
    _timeLabel.frame = CGRectMake(40, 20+_imageHeight+10+15, 80, 10);
    _ageButton.frame = CGRectMake(130, 20+_imageHeight+10, 20, 10);

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
    [_ageButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
    [_ageButton setTitle:[NSString stringWithFormat:@"%ld",_model.tblUser.age]  forState:UIControlStateNormal];
    _ageButton.backgroundColor = [UIColor initWithGreen];
    _ageButton.titleLabel.font = SMALLFONTSIZE;

    [self createGroupOne];
}

-(void)createGroupOne{
    NSArray *imageNameArray = @[@"icon_destination.png",@"icon_cuttime.png",@"icon_traveldate.png",@"icon_tag2.png",@"icon_grouplimit.png",@"icon_qiupiao2.png"];
    NSArray *labelNameArray = @[@"目的地",@"闭团日期",@"行程日起",@"标签",@"闭团团员人数限制",@"悬赏球币"];
    
    NSArray *cellHeightyArray = @[@13,@51,@89,@131,@173,@211];
    
   // NSLog(@"model. = %@",_model.theme);
    if (!_model.planBegin||!_model.planEnd) {
        _dataStr = @"未填写";
    }else{
        _dataStr =[NSString stringWithFormat:@"%@至%@",_model.planBegin,_model.planEnd];
    }
    
    
    NSArray *rightLabelNameArray = @[_model.tblUser.position,_model.endTime, _dataStr,[NSString stringWithFormat:@"%@",_model.groupSign],[NSString stringWithFormat:@"%ld人",_model.maxMembers],[NSString stringWithFormat:@"%ld球币",_model.rewardIntegral]];
    
    
    
    for (NSInteger i=0; i<6; i++) {
        UIImageView  *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(22, _imageHeight+55+[cellHeightyArray[i] integerValue], 13, 16)];
        headImage.image = [UIImage imageNamed:imageNameArray[i]];
        [self.view addSubview:headImage];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(50, _imageHeight+55+[cellHeightyArray[i] integerValue], 150, 16)];
        [self.view addSubview:labelName];
        labelName.text = labelNameArray[i];
        labelName.font = MAINFONTSIZE;
        labelName.textColor = [UIColor initWithLightGray];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, _imageHeight+55+[cellHeightyArray[i] integerValue], SCREENWIDTH-150-20, 16)];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:rightLabel];
        rightLabel.text = rightLabelNameArray[i];
        rightLabel.font = MAINFONTSIZE;
        rightLabel.textColor = [UIColor initWithLightGray];
    }

}



-(void)createButton{
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, SCREENWIDTH/2, 49)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _cancelBtn.backgroundColor = [UIColor initWithBackgroundGray];
    _cancelBtn.tag = 100;
    [_cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, self.view.frame.size.height-49, SCREENWIDTH/2, 49)];
    [_ensureBtn setTitle:@"已加入" forState:UIControlStateNormal];
    [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ensureBtn.backgroundColor = [UIColor initWithNormalGray];
    _ensureBtn.tag = 101;
    
    [self.view addSubview:_cancelBtn];
    [self.view addSubview:_ensureBtn];
}

// 加入帮帮团
-(void)btnClicked:(UIButton *)btn{

    if (btn.tag ==100) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
    
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/hg/jion?groupId=%ld&userId=%@",_model.groupId,[WBUserDefaults userId]] whenSuccess:^(id representData) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } andFailure:^(NSString *error) {
            
        }];
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
