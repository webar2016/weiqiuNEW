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
    self.navigationItem.title =@"关注";
    //设置标题
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
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
    [self showHUD:@"正在加载数据" isDim:YES];
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/relationship/concernsList?userId=%@&showUserId=%@",[WBUserDefaults userId],_showUserId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"result = %@",result);
            _dataArray = [WBFansModel mj_objectArrayWithKeyValuesArray:result[@"concernsList"]];
            [_tableView reloadData];
        }
        [self showHUDComplete:@"加载完毕"];
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

#pragma mark - MBprogress
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self hideHUD];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0.3];
}



@end
