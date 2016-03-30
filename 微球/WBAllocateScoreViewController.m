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

#import "MJExtension.h"

#define ScoreUrl @"http://121.40.132.44:92/hg/hgUsersQNum?groupId=%@"

@interface WBAllocateScoreViewController ()<UITableViewDataSource,UITableViewDelegate,ScoreClickedEnent>
{

    UITableView *_tableView;
    UIView *_bottomView;
    UIButton *_allocateButton;
    UILabel *_tipLabel;
    UILabel *_surplusScore;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_cellScoreArray;
    NSInteger _surplus;
}
@end

@implementation WBAllocateScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    _dataArray = [NSMutableArray array];
    _cellScoreArray = [NSMutableArray array];
    [self creatNavi];
    [self createUI];
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


-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT - 123)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 49 - 64, SCREENWIDTH, 49)];
    _bottomView.backgroundColor = [UIColor initWithBackgroundGray];
    
    _allocateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 138, 49)];
    _allocateButton.backgroundColor = [UIColor initWithGreen];
    _allocateButton.titleLabel.font = BIGFONTSIZE;
    [_allocateButton setTitle:@"确认分配" forState:UIControlStateNormal];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 170, 49)];
    _tipLabel.font = MAINFONTSIZE;
    _tipLabel.textColor = [UIColor initWithNormalGray];
    _tipLabel.text = @"共1000积分，剩余";
    
    _surplusScore = [[UILabel alloc] initWithFrame:CGRectMake(320, 6.5, 36, 36)];
    _surplusScore.backgroundColor = [UIColor initWithGreen];
    _surplusScore.textColor = [UIColor whiteColor];
    _surplusScore.font = MAINFONTSIZE;
    _surplusScore.textAlignment = NSTextAlignmentCenter;
    _surplusScore.layer.masksToBounds = YES;
    _surplusScore.layer.cornerRadius = 18;
    _surplusScore.text = @"0%";
    
    [_bottomView addSubview:_allocateButton];
    [_bottomView addSubview:_tipLabel];
    [_bottomView addSubview:_surplusScore];
    [self.view addSubview:_bottomView];
}


-(void)loadData{
    NSString *url = [NSString stringWithFormat:ScoreUrl,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"result = %@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"users"]];
            
            _dataArray =[WBAllocateScoreModel mj_objectArrayWithKeyValuesArray:arrayList];
            
            
            //计算cell 的初始值
            
            //NSLog(@"%f",floor(100.0f/_dataArray.count)) ;
            
            for (NSInteger i = 0; i<_dataArray.count; i++) {
                [_cellScoreArray addObject:[NSString stringWithFormat:@"%f",floor(100.0f/_dataArray.count)]];
            }
            if (_dataArray.count == 0) {
                _surplus = 100;
                UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.pic.jpg"]];
                background.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENWIDTH);
                [_tableView addSubview:background];
            } else {
                _surplus = 100 -[_cellScoreArray[0] floatValue]*_cellScoreArray.count;
            }
            _surplusScore.text = [NSString stringWithFormat:@"%ld",_surplus];
            
            [_tableView reloadData];
            
            
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

#pragma mark -------tableView delegate-----


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
    [cell setModel:_dataArray[indexPath.row] cellScore:_cellScoreArray[indexPath.row] indexPath:indexPath];
    cell.delegate = self;
    return cell;

}

#pragma mark -----Cell delegate------积分分配
- (void)buttonClickedEvent:(UIButton *)btn{

    if (btn.tag%10 == 1) {
        UILabel *label = [self.view viewWithTag:btn.tag-1];
        if ([label.text integerValue]>0) {
            label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]-1];
            _surplus++;
            _surplusScore.text = [NSString stringWithFormat:@"%ld",_surplus];
        }
       // NSLog(@"-------------");
    }else{
        UILabel *label = [self.view viewWithTag:btn.tag-2];
        if (_surplus>0) {
            label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]+1];
            _surplus--;
            _surplusScore.text = [NSString stringWithFormat:@"%ld",_surplus];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
