//
//  WBUnlockSceneryViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/6/13.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUnlockSceneryViewController.h"
#import "WBMyUnlockTableViewCell.h"
#import "MyDBmanager.h"

@interface WBUnlockSceneryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *_segmentControl;
    NSMutableArray *_unlockDataList;
    NSMutableArray *_unlockingDataList;
}
@end

@implementation WBUnlockSceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _unlockDataList = [NSMutableArray array];
    _unlockingDataList = [NSMutableArray array];
    [self createNavi];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:NSClassFromString(@"WBMyUnlockTableViewCell") forCellReuseIdentifier:@"myCell"];
    
    [self loadData];
}

-(void)createNavi{
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"已经解锁",@"正在解锁"]];
    self.navigationItem.titleView = _segmentControl;
    [_segmentControl addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectedSegmentIndex = 0;
    
}

-(void)changeSegment:(UISegmentedControl *)segment{
    [_tableView reloadData];
}


#pragma mark --loadFromDataBase-

-(void)loadData{
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Unlock_Scenery];
    _unlockDataList = [NSMutableArray arrayWithArray:[manager searchAllItems]];
    [manager closeFBDM];
    
    MyDBmanager *manager1 = [[MyDBmanager alloc]initWithStyle:Unlocking_Scenery];
    _unlockingDataList = [NSMutableArray arrayWithArray:[manager1 searchAllItems]];
    [manager closeFBDM];

    [_tableView reloadData];
}


#pragma mark =---tableView delegate-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_segmentControl.selectedSegmentIndex == 0) {
        return _unlockDataList.count;
    }else{
        return _unlockingDataList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"myCell";
    if (_segmentControl.selectedSegmentIndex == 0) {
        WBMyUnlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[[NSBundle mainBundle]loadNibNamed:@"WBMyUnlockTableViewCell" owner:nil options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.UnlockSceneryModel = _unlockDataList[indexPath.row];
        return cell;
    }else{
        WBMyUnlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[[NSBundle mainBundle]loadNibNamed:@"WBMyUnlockTableViewCell" owner:nil options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.UnlockingSceneryModel = _unlockingDataList[indexPath.row];
        return cell;
    }


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}












/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
