//
//  WBFansView.m
//  微球
//
//  Created by 贾玉斌 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFansView.h"
#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBFansModel.h"
#import "WBFansViewTableViewCell.h"


@interface WBFansView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
}
@end

@implementation WBFansView

-(void)viewDidLoad{
    [super viewDidLoad];
    [self createNavi];
    [self createTableView];
    [self loadData];
}

-(void)createNavi{
    self.navigationItem.title =@"粉丝";
    //设置标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
}

-(void)createTableView{
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/relationship/fansList?userId=%@&showUserId=%@",@"29",@"29"];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"result = %@",result);
            _dataArray = [WBFansModel mj_objectArrayWithKeyValuesArray:result[@"fansList"]];
            [_tableView reloadData];
        }
    } andFailure:^(NSString *error) {
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
    
    static NSString *FansCellID = @"fansListCell";
    WBFansViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FansCellID];
    if (cell == nil)
    {   cell = [[WBFansViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FansCellID ];
        
    }
    [cell setModel:_dataArray[indexPath.row]];
    
    return cell;
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
