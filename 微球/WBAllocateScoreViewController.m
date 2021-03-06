//
//  WBAllocateScoreViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAllocateScoreViewController.h"
#import "MyDownLoadManager.h"
#import "WBAllocateScoreModel.h"
#import "WBAllocateScoreTableViewCell.h"
#import "MyDownLoadManager.h"
#import "RCIMClient.h"

#import "MJExtension.h"

#define ScoreUrl @"http://app.weiqiu.me/hg/hgUsersQNum?groupId=%@"

@interface WBAllocateScoreViewController ()<UITableViewDataSource,UITableViewDelegate,ScoreClickedEnent>
{

    UITableView *_tableView;
    UIView *_bottomView;
    UIButton *_allocateButton;
    UILabel *_tipLabel;
    UILabel *_surplusScore;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_cellScoreArray;
    NSInteger _totalQum;
    NSInteger _surplus;
    
    NSMutableDictionary *_data;
}
@end

@implementation WBAllocateScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _cellScoreArray = [NSMutableArray array];
    
    _data = [NSMutableDictionary dictionary];
    [_data setObject:[WBUserDefaults userId] forKey:@"userId"];
    [_data setObject:self.groupId forKey:@"groupId"];
    _totalQum = 0;
    [self creatNavi];
    [self loadData];
}

-(void)creatNavi{
    self.navigationItem.title = @"分配打赏";
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createTableView{
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 113)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [self createBottomView];
    [_bottomView addSubview:_surplusScore];
    [self.view addSubview:_bottomView];
}

-(void)createBottomView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 49 - 64, SCREENWIDTH, 49)];
    _bottomView.backgroundColor = [UIColor initWithBackgroundGray];
    
    _allocateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 138, 49)];
    _allocateButton.backgroundColor = [UIColor initWithGreen];
    _allocateButton.titleLabel.font = BIGFONTSIZE;
    [_allocateButton setTitle:@"确   认" forState:UIControlStateNormal];
    [_allocateButton addTarget:self action:@selector(allocate) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 170, 49)];
    _tipLabel.font = MAINFONTSIZE;
    _tipLabel.textColor = [UIColor initWithNormalGray];
    _tipLabel.text = [NSString stringWithFormat:@"共%@积分，剩余",self.rewardIntegral];
    
    _surplusScore = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, 4.5, 40, 40)];
    _surplusScore.backgroundColor = [UIColor initWithGreen];
    _surplusScore.textColor = [UIColor whiteColor];
    _surplusScore.font = MAINFONTSIZE;
    _surplusScore.textAlignment = NSTextAlignmentCenter;
    _surplusScore.layer.masksToBounds = YES;
    _surplusScore.layer.cornerRadius = 20;
    
    [_bottomView addSubview:_allocateButton];
    [_bottomView addSubview:_tipLabel];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:ScoreUrl,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"users"]];
            
            _dataArray =[WBAllocateScoreModel mj_objectArrayWithKeyValuesArray:arrayList];
            
            NSUInteger count = _dataArray.count;
            if (count == 0) {
                UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noanswer"]];
                background.center = CGPointMake(SCREENWIDTH / 2, 200);
                [self.view addSubview:background];
                [self createBottomView];
                [self.view addSubview:_bottomView];
                _tipLabel.textAlignment = NSTextAlignmentCenter;
                _tipLabel.text = @"悬赏球币将全部返还！";
            } else {
                [self createTableView];
                for (NSUInteger i = 0; i < count; i ++) {
                    _totalQum = _totalQum +((WBAllocateScoreModel *)_dataArray[i]).qNum;
                }
                
                
                for (NSUInteger i = 0; i < count; i ++) {
                    [_cellScoreArray addObject:[NSString stringWithFormat:@"%f",floor((((WBAllocateScoreModel *)_dataArray[i]).qNum)*100.0f/_totalQum)]];
                   
                }
                _surplus = 100;
                for (NSUInteger i = 0; i < count; i ++) {
                    _surplus = _surplus - [_cellScoreArray[i] integerValue];
                }
                _surplusScore.text = [NSString stringWithFormat:@"%ld%@",(long)_surplus,@"%"];
            }
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

#pragma mark -------tableView delegate-----


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ScoreCell = @"ScoreCellID";
    WBAllocateScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCell];
    if (cell == nil)
    {   cell = [[WBAllocateScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ScoreCell];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_dataArray[indexPath.row] cellScore:_cellScoreArray[indexPath.row] indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark -----Cell delegate------积分分配
- (void)buttonClickedEvent:(UIButton *)btn{

    if (btn.tag%10 == 1) {
        UILabel *label = [self.view viewWithTag:btn.tag-1];
        if ([label.text integerValue]>0) {
            label.text = [NSString stringWithFormat:@"%d",[label.text intValue]-1];
            _surplus++;
            _surplusScore.text = [NSString stringWithFormat:@"%ld%@",(long)_surplus,@"%"];
        }
    }else{
        UILabel *label = [self.view viewWithTag:btn.tag-2];
        if (_surplus>0) {
            label.text = [NSString stringWithFormat:@"%d",[label.text intValue]+1];
            _surplus--;
            _surplusScore.text = [NSString stringWithFormat:@"%ld%@",(long)_surplus,@"%"];
        }
    }

}

-(void)allocate{
    if (_surplus > 0 && _dataArray.count > 0) {
        [self showHUDText:@"请将球币分配完毕"];
        return;
    } else if (_surplus == 0 && _dataArray.count > 0) {
//        _data[@"integral"]
        NSMutableDictionary *integral = [NSMutableDictionary dictionary];
        
        NSString  *str= [NSString string];
        
        [str stringByAppendingString:@"sssssss"];
        for (NSInteger i = 0;i<_dataArray.count;i++) {
            
            UILabel *label = (UILabel *)[self.view viewWithTag:100+10*i];
            [integral setObject:label.text forKey:[NSString stringWithFormat:@"%ld",(long)((WBAllocateScoreModel *)_dataArray[i]).userId]];
//            [str stringByAppendingString:[NSString stringWithFormat:@"%ld",((WBAllocateScoreModel *)_dataArray[i]).userId]];
//            [str stringByAppendingString:@":"];
//            [str stringByAppendingString:label.text];
            if (i ==_dataArray.count-1 ) {
                
            }else{
                [str stringByAppendingString:@","];
            }
        }
        str = [self dictionaryToJson:integral];
        NSLog(@"_data %@",str);
        [_data setObject:str forKey:@"integral"];
       
       // [_data setObject:integral forKey:@"integral"];
    }
    NSLog(@"_data%@",_data);
    //@"http://app.weiqiu.me/hg/closeGroup"
    [MyDownLoadManager postUrl:@"http://app.weiqiu.me/hg/closeGroup" withParameters:_data whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.groupId];
        [self.navigationController popToRootViewControllerAnimated:NO];
    } andFailure:^(NSString *error) {
        [self showHUDText:@"网络状态不佳，请稍后再试！"];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
