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
#import "WBLocateList.h"
#import "UIImageView+WebCache.h"
#import "WBMyUnlockTableViewCell.h"
#import "WBImageViewer.h"

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
    [self showHUDIndicator];
    [self createNavi];
    [self createUI];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    if (_segmentControl.selectedSegmentIndex == 0) {
        return _unlockArray.count;
    }else{
        return _unlockingArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segmentControl.selectedSegmentIndex == 0) {
        static NSString *cellID = @"MyUnlockId";
        WBMyUnlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[[NSBundle mainBundle]loadNibNamed:@"WBMyUnlockTableViewCell" owner:nil options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:_unlockArray[indexPath.row]];
        return cell;
    }else{
        
        static NSString *cellID = @"MyUnlockId";
        WBMyUnlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[[NSBundle mainBundle]loadNibNamed:@"WBMyUnlockTableViewCell" owner:nil options:nil] lastObject];
          
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUnlockingModel:_unlockingArray[indexPath.row]];
        return cell;
    
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        WBImageViewer *imageView = [[WBImageViewer alloc]initWithDir:((WBTbl_Unlock_City *)_unlockArray[indexPath.row]).dir];
        [self presentViewController:imageView animated:YES completion:nil];
        
    }else{
        
        WBImageViewer *imageView = [[WBImageViewer alloc]initWithDir:((WBTbl_Unlocking_City *)_unlockingArray[indexPath.row]).photoPath];
        [self presentViewController:imageView animated:YES completion:nil];
    }


}

@end
