//
//  WBPlaceChooseViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPlaceChooseViewController.h"
#import "WBPositionList.h"

@interface WBPlaceChooseViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    BOOL        _chooseCity;
    NSNumber    *_provinceId;
    NSNumber    *_cityId;
    UIView      *_selectedView;
}
@property (nonatomic, strong) WBPositionList *positionList;

@end

@implementation WBPlaceChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.positionList = [[WBPositionList alloc] init];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    [self createNavi];
    [self createUI];
//    [self setUpSearchBox];
}

-(void)createNavi{
    if (self.fromNextPage) {
        self.navigationItem.title = @"选择始发地";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else{
        self.navigationItem.title = @"选择目的地";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }

}

-(void)createUI{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor initWithBackgroundGray];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:_tableView];
}

-(void)setUpSearchBox{
    CGFloat viewSize = self.view.frame.size.width;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize, 40)];
    CGFloat searchBoxWidth = viewSize * 0.98;
    UISearchBar *searchBox = [[UISearchBar alloc] initWithFrame:CGRectMake(viewSize * 0.01, 5, searchBoxWidth, 30)];
    searchBox.placeholder = @"搜索城市";
    searchBox.searchBarStyle = UISearchBarStyleMinimal;
    searchBox.barTintColor = [UIColor whiteColor];
    [searchView addSubview:searchBox];
    _tableView.tableHeaderView = searchView;
}


#pragma mark - operations

-(void)cancelChoose{
    _chooseCity = NO;
    _cityId = nil;
    self.navigationItem.rightBarButtonItem = nil;
    if (self.fromNextPage) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else{
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    [_tableView reloadData];
}

-(void)backToLastView{
    [self.navigationController popViewControllerAnimated:YES];

}



-(void)nextStep{
    if (!_cityId) {
        NSLog(@"请选择城市");
        return;
    }
    if (self.fromNextPage) {
        [self dismissViewControllerAnimated:YES completion:^{
            //注册父view消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"choosePlace" object:self userInfo:@{@"startPlaceId":[NSString stringWithFormat:@"%@",_cityId]}];
            
        }];
    }else{
//        WBGroupInfoController *groupInfoVC = [[WBGroupInfoController alloc] init];
//        groupInfoVC.dataDic[@"destinationId"] = [NSString stringWithFormat:@"%@",_cityId];
//        [self.navigationController pushViewController:groupInfoVC animated:YES];
    }
    
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}





-(void)selectedView{
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    UIImageView *nike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_markcross"]];
    nike.center = CGPointMake(SCREENWIDTH - 40, 22);
    [_selectedView addSubview:nike];
}

#pragma mark - table view delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_chooseCity) {
        return [self.positionList countOfProvinces];
    }else{
        return [self.positionList getCitiesCountWithProvinceId:_provinceId];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chooseCity) {
        _cityId = [self.positionList getCityIdWithRow:indexPath.row byProvinceId:_provinceId];
        [self.passPositionDelegate setPositionProvinceId:_provinceId andCityId:_cityId];
        [self.navigationController popViewControllerAnimated:YES];
    }
    _provinceId = [self.positionList getProvinceIdWithRow:indexPath.row];
    _chooseCity = YES;
    [_tableView reloadData];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"省份" style:UIBarButtonItemStylePlain target:self action:@selector(cancelChoose)];
    self.navigationItem.leftBarButtonItem = leftButton;
    if (self.fromNextPage) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else{
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectedBackgroundView = _selectedView;
    cell.textLabel.textColor = [UIColor initWithNormalGray];
    if (!_chooseCity) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.positionList getProvinceInfomationAtIndex:indexPath.row][0];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = [self.positionList getCityInfomationAtIndex:indexPath.row WithProvinceId:_provinceId][0];
    }
    
    return cell;
    
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
