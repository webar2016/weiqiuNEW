//
//  WBSexViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSexViewController.h"

@interface WBSexViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_nameArray;

}
@end

@implementation WBSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    _nameArray = @[@"男",@"女"];
    [self createNavi];
    [self createUI];
    
}

-(void)createNavi{
    //设置标题
    self.navigationItem.title = @"性别";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
}

-(void)createUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}


#pragma mark -----    tableView delegate --------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SexCellID = @"SexCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SexCellID];
    if (cell == nil)
    {   cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SexCellID ];
        
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 100, 20)];
    label.text = _nameArray[indexPath.row];
    label.font = MAINFONTSIZE;
    label.textColor = [UIColor initWithLightGray];
    [cell.contentView addSubview:label];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        [self.passDelegate setSexValue:@"男"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self.passDelegate setSexValue:@"女"];
        [self.navigationController popViewControllerAnimated:YES];
    
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
