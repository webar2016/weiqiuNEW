//
//  WBHomepageViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHomepageViewController.h"
#import "MyDownLoadManager.h"
#import "WBDataModifiedViewController.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

#import "WBHomeHeadTableViewCell.h"
#import "WBHomeFirstPageTableViewCell.h"
#import "WBHomeSecondTableViewCell.h"

#import "WBFansView.h"
#import "WBAttentionView.h"

#import "TopicDetailModel.h"
#import "WBSingleAnswerModel.h"

@interface WBHomepageViewController ()<UITableViewDataSource,UITableViewDelegate,HeadDelegate,ModefyData,WBHomeSecondTableViewCell>
{
    UITableView *_tableView;
    NSMutableArray *_dataArrayListOne;
    NSMutableArray *_labelHeightArrayOne;
    NSMutableArray *_dataArrayListTwo;
    NSMutableArray *_dataArrayListThree;
    NSMutableArray *_dataSource;
    
    NSDictionary *_userInfo;
    
    BOOL _isSelfHomePage;
    
    NSInteger _selectPage;
    NSInteger _firstViewPage;
    NSInteger _secondViewPage;
    
}
@end

@implementation WBHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    _dataArrayListOne = [NSMutableArray array];
    _labelHeightArrayOne = [NSMutableArray array];
    
    _dataArrayListTwo = [NSMutableArray array];
    _dataArrayListThree = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    
    _userInfo = [NSDictionary dictionary];
    
    _selectPage =1 ;
    
    
    //    NSLog(@"userId = %@",[WBUserDefaults userId]);
    //    NSLog(@"_friendId = %@",_friendId);
    if ([[WBUserDefaults userId] integerValue]==[_friendId integerValue]) {
        _isSelfHomePage = YES;
    }
    
    [self createNavi];
    [self createUI];
    
    [self loadData];
    
    
}

-(void)createNavi{
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 19, 19);
    [rightButton setImage:[UIImage imageNamed:@"icon_share-2.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = button;
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor initWithBackgroundGray];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    
}

#pragma mark -----DownloadData--------
-(void)loadData{
    
    
    NSString *url;
    if (_friendId==nil) {
        url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"],[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]];
    }else{
        url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",_friendId,[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]];
    }
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = [result objectForKey:@"userInfo"];
            _userInfo = userInfo;
            self.navigationItem.title = userInfo[@"nickname"];
            [self loadOtherData];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}


-(void)loadOtherData{
    if (_selectPage==1) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserComment?userId=%@",@"29"];
        [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            _dataArrayListOne = [TopicDetailModel mj_objectArrayWithKeyValuesArray:result[@"topicCommentList"]];
            [_dataSource removeAllObjects];
            _dataSource = _dataArrayListOne;
           // NSLog(@"_dataSource = %@",_dataArrayListOne);
            for (NSInteger i = 0 ; i<_dataSource.count; i++) {
                _labelHeightArrayOne[i] =[NSString stringWithFormat:@"%f",[self calculateStationWidth:((TopicDetailModel *)_dataSource[i]).comment andWithTextWidth:SCREENWIDTH-20 anfont:14]];
            }
             [_tableView reloadData];
            
        } andFailure:^(NSString *error) {
            
        }];
    }else if(_selectPage ==2){
        NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserAnswer?userId=%@",@"29"];
        [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            _dataArrayListTwo = [WBSingleAnswerModel mj_objectArrayWithKeyValuesArray:result[@"answers"]];
            [_dataSource removeAllObjects];
            _dataSource = _dataArrayListTwo;
           // NSLog(@"_dataSource = %@",_dataArrayListOne);
            [_tableView reloadData];
            
        } andFailure:^(NSString *error) {
            
        }];

    
    
    
    
    }
}
-(CGFloat)calculateStationWidth:(NSString *)string andWithTextWidth:(CGFloat)textWidth anfont:(CGFloat)fontSize{
    
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    
    CGSize size =CGSizeMake(textWidth,CGFLOAT_MAX);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height;
    
}

#pragma mark ------uitableViewDelegate-------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count+1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 168+32+20+30+41+20+29+40;
    }else{
        if (_selectPage == 1) {
            if (((TopicDetailModel *)_dataSource[indexPath.row-1]).newsType == 1) {
                return [((TopicDetailModel *)_dataSource[indexPath.row-1]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArrayOne[indexPath.row-1] floatValue]+132;
            }
            
            return 168+32+20+30+41+20+29+40;

        }else if(_selectPage == 2){
        
            UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
        return 0;
        
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *homeTopCell = @"HomeTopCell";
        WBHomeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTopCell];
        if (cell == nil)
        {   cell = [[WBHomeHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeTopCell isSelfHomePage:_isSelfHomePage];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell setUIWithUserInfo:_userInfo];
        return cell;
    }else{
        if (_selectPage == 1) {
            static NSString *FirstPageCell = @"FirstPageCell";
            WBHomeFirstPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstPageCell];
            if (cell == nil)
            {   cell = [[WBHomeFirstPageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstPageCell ];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setModel:_dataSource[indexPath.row-1] withLabelHeight:[_labelHeightArrayOne[indexPath.row-1] floatValue]];
            return cell;
        }else if (_selectPage == 2){
        
            static NSString *SecondPageCell = @"SecondPageCell";
            WBHomeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondPageCell];
            if (cell == nil)
            {
                cell = [[WBHomeSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondPageCell withData:_dataSource[indexPath.row-1]];
            }
            cell.tag = indexPath.row;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _dataSource[indexPath.row-1];

            return cell;
        }
        
    
    
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------headView Delegate ----

- (void)pushViewBtnClicked:(UIButton *)btn{
    //个人修改页面
    if (btn.tag ==400) {
        // NSLog(@"-----btn.tag----");
        WBDataModifiedViewController *DVC = [[WBDataModifiedViewController alloc]init];
        DVC.userInfo = _userInfo;
        DVC.delegate = self;
        [self.navigationController pushViewController:DVC animated:YES];
        //信息页面
    }else if(btn.tag == 401){
        
        
    }else if (btn.tag == 500){//关注页面
        WBAttentionView *AVC = [[WBAttentionView alloc]init];
        [self.navigationController pushViewController:AVC animated:YES];
        
        
    }else{//粉丝页面
        WBFansView *FVC = [[WBFansView alloc]init];
        [self.navigationController pushViewController:FVC animated:YES];
        
        
    }
    
    
    
}


- (void)changeTableViewBody:(NSInteger)Number{
    _selectPage = Number;
    [self loadOtherData];

}

#pragma mark -----DataModifyDelegate------
- (void)ModefyViewDelegate{
    NSLog(@"---ModefyViewDelegate----");
    ((UIImageView *)[self.view viewWithTag:102]).image = [WBUserDefaults headIcon];
    
    ((UILabel *)[self.view viewWithTag:402]).text = [WBUserDefaults nickname];
    
    
}



@end
