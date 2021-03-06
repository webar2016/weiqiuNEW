//
//  WBAttentionView.m
//  微球
//
//  Created by 贾玉斌 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAttentionView.h"
#import "MyDownLoadManager.h"
#import "WBFansModel.h"
#import "MJExtension.h"

#import "WBAttentionTableViewCell.h"
#import "WBHomepageViewController.h"


@interface WBAttentionView ()<UITableViewDataSource,UITableViewDelegate,progressState>
{
    UITableView *_tableView;

    NSMutableArray *_dataArray;

}
@end
@implementation WBAttentionView

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavi];
    [self createTableView];
    [self loadData];

}

-(void)createNavi{
    self.navigationItem.title =@"关注列表";
}


-(void)createTableView{
    
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    

}


-(void)loadData{
    [self showHUDIndicator];
    NSString *url = [NSString stringWithFormat:@"http://app.weiqiu.me/relationship/concernsList?userId=%@&showUserId=%@",[WBUserDefaults userId],_showUserId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"result = %@",result);
            _dataArray = [WBFansModel mj_objectArrayWithKeyValuesArray:result[@"concernsList"]];
            [_tableView reloadData];
        }
        [self hideHUD];
    } andFailure:^(NSString *error) {
        [self hideHUD];
        NSLog(@"%@------",error);
    }];


}


#pragma mark  -------tableView delegate -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ConcernsCellID = @"ConcernsListCell";
    WBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConcernsCellID];
    if (cell == nil)
    {   cell = [[WBAttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConcernsCellID ];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel: (WBFansModel *)_dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBFansModel *model = _dataArray[indexPath.row];
    WBHomepageViewController *homepage = [[WBHomepageViewController alloc] init];
    homepage.userId = model.fansId;
    [self.navigationController pushViewController:homepage animated:YES];
}




-(void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
}

@end
