//
//  WBMyUnlockViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMyUnlockViewController.h"
#import "MyDBmanager.h"
#import "WBTbl_Unlock_City.h"
#import "WBPositionList.h"

@interface WBMyUnlockViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *_segmentControl;
    UITableView *_tableView;
    NSMutableArray *_unlockArray;
    NSMutableArray *_unlockingArray;
    

}
@property (strong, nonatomic) UIPageViewController *pageController;
@end

@implementation WBMyUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self showHUD:@"正在加载" isDim:YES];
    [self createNavi];
    [self createUI];
    [self showHUDComplete:@"加载完毕"];
    
    
}

-(void)createNavi{
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"已经解锁",@"正在解锁"]];
    self.navigationItem.titleView = _segmentControl;
    [_segmentControl addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectedSegmentIndex = 0;
    
}

//segment点击事件
-(void)changeSegment:(UISegmentedControl *)segmentControl{
    [_tableView reloadData];
}


-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    MyDBmanager *manager1 = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
    _unlockArray = [NSMutableArray arrayWithArray:[manager1 searchAllItems]];
    [manager1 closeFBDM];
    
    MyDBmanager *manager2 = [[MyDBmanager alloc]initWithStyle:Tbl_unlocking_city];
    _unlockingArray= [NSMutableArray arrayWithArray:[manager2 searchAllItems]];
    [manager2 closeFBDM];

}
#pragma mark ------uitableView delegate--------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
     [manager  addItem:model];
     NSLog(@"1 -------%@",[manager searchAllItems]);
     [manager closeFBDM];*/
    if (_segmentControl.selectedSegmentIndex == 0) {
        return _unlockArray.count;
    }else{
        return _unlockingArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        static NSString *cellID = @"unlockID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        WBPositionList *position = [[WBPositionList alloc]init];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[position cityNameWithCityId:[NSNumber numberWithInteger:((WBTbl_Unlock_City *)_unlockArray[indexPath.row]).cityId]]];
        return cell;
    }else{
        static NSString *cellID2 = @"unlockingID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil)
        {   cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        WBPositionList *position = [[WBPositionList alloc]init];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[position cityNameWithCityId:[NSNumber numberWithInteger:[((WBTbl_Unlocking_City *)_unlockingArray[indexPath.row]).cityId integerValue]]]];
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
