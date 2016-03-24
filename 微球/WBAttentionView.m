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


@interface WBAttentionView ()<UITableViewDataSource,UITableViewDelegate>
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
    self.navigationItem.title =@"关注";
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

    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/relationship/concernsList?userId=%@&showUserId=%@",@"29",@"29"];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"result = %@",result);
            _dataArray = [WBFansModel mj_objectArrayWithKeyValuesArray:result[@"concernsList"]];
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

    static NSString *ConcernsCellID = @"ConcernsListCell";
    WBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConcernsCellID];
    if (cell == nil)
    {   cell = [[WBAttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConcernsCellID ];
        
    }
    [cell setModel:_dataArray[indexPath.row]];
    
    return cell;
}




-(void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
}



@end
