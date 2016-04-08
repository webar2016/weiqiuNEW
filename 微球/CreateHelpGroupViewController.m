#import "CreateHelpGroupViewController.h"
#import "WBGroupInfoController.h"
#import "WBUnlockViewController.h"
#import "WBMyUnlockViewController.h"

#import "WBPositionList.h"
#import "WBPositionModel.h"
#import "MyDBmanager.h"

@interface CreateHelpGroupViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    UITableView *_tableView;
    NSNumber    *_provinceId;
    NSNumber    *_cityId;
    NSArray     *_searchCityInfos;
    UIView      *_selectedView;
    UISearchBar *_searchBox;
    UIView      *_overlay;
    
    BOOL        _chooseCity;
    
    BOOL        _isUnlock;
}

@property (nonatomic, strong) WBPositionList *positionList;

@end

@implementation CreateHelpGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createSuccess:)
                                                 name:@"createSuccess"
                                               object:nil];
    
    self.positionList = [[WBPositionList alloc] init];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    if (self.fromNextPage) {
        self.navigationItem.title = @"选择始发地";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else if (self.fromSlidePage) {
        self.navigationItem.title = @"解锁城市";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.leftBarButtonItem = leftButton;
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.backBarButtonItem = back;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"我的解锁信息" style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyUnlockView)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else{
        self.navigationItem.title = @"选择目的地";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    [self setUpTableView];
    
//    [self setUpSearchBox];
    
    [self selectedView];
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
    if (self.fromSlidePage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (((WBMainTabBarController *)self.parentViewController.parentViewController).isGroup) {
        self.tabBarController.selectedIndex = 2;
    }else{
        self.tabBarController.selectedIndex = 0;
    }
}

-(void)gotoMyUnlockView{
    if (self.fromSlidePage) {
        WBMyUnlockViewController *MVC = [[WBMyUnlockViewController alloc]init];
        [self.navigationController pushViewController:MVC animated:YES];
    }
}

-(void)nextStep{
    if (!_cityId) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择城市" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.fromNextPage) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }if (self.fromSlidePage) {
        
        _isUnlock = NO;
        [self isUnlock];
        if (!_isUnlock) {
            WBUnlockViewController *unlockVC = [[WBUnlockViewController alloc] init];
            unlockVC.cityName = [self.positionList cityNameWithCityId:_cityId];
            unlockVC.cityId = _cityId;
            unlockVC.provinceId = _provinceId;
            [self.navigationController pushViewController:unlockVC animated:YES];
        }
       
    }else{
        WBGroupInfoController *groupInfoVC = [[WBGroupInfoController alloc] init];
        groupInfoVC.dataDic[@"destinationId"] = [NSString stringWithFormat:@"%@",_cityId];
        [self.navigationController pushViewController:groupInfoVC animated:YES];
    }
    
}


-(void)isUnlock{
    
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
    if ([manager isAddedItemsID:[NSString stringWithFormat:@"%@",_cityId]]) {
        //已经存在unlock
        [manager closeFBDM];
        _isUnlock = YES;
        [self showHUD:nil isDim:NO];
        [self showHUDComplete:@"这个城市已经解锁"];
        
    }
    [manager closeFBDM];
    
    
    MyDBmanager *manager2 = [[MyDBmanager alloc]initWithStyle:Tbl_unlocking_city];
    if ([manager2 isAddedItemsID:[NSString stringWithFormat:@"%@",_cityId]]) {
        [manager2 closeFBDM];
        _isUnlock = YES;
         [self showHUD:nil isDim:NO];
        [self showHUDComplete:@"这个城市正在等待审核中"];
    }
    [manager2 closeFBDM];

    
}


-(void)popViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height)];
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
    _searchBox = [[UISearchBar alloc] initWithFrame:CGRectMake(viewSize * 0.01, 5, searchBoxWidth, 30)];
    _searchBox.placeholder = @"搜索城市";
    _searchBox.searchBarStyle = UISearchBarStyleMinimal;
    _searchBox.barTintColor = [UIColor whiteColor];
    _searchBox.delegate = self;
    [searchView addSubview:_searchBox];
    _tableView.tableHeaderView = searchView;
}

-(void)selectedView{
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    UIImageView *nike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_markcross"]];
    nike.center = CGPointMake(SCREENWIDTH - 40, 22);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREENWIDTH, 0.5)];
    topLine.backgroundColor = [UIColor initWithBackgroundGray];
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, SCREENWIDTH, 0.5)];
    underLine.backgroundColor = [UIColor initWithBackgroundGray];
    [_selectedView addSubview:nike];
    [_selectedView addSubview:topLine];
    [_selectedView addSubview:underLine];
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
        if (self.fromNextPage) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"choosePlace" object:self userInfo:@{@"startPlaceId":[NSString stringWithFormat:@"%@",_cityId]}];
        }
        return;
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

#pragma mark - search box delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _tableView.scrollEnabled = NO;
    _tableView.scrollsToTop = YES;
    if (!_overlay) {
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT - 104)];
        _overlay.backgroundColor = [UIColor blackColor];
        _overlay.alpha = 0.2;
    }
    [self.view addSubview:_overlay];
    UITapGestureRecognizer *searchCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchCancel)];
    [_overlay addGestureRecognizer:searchCancel];
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *cityName = _searchBox.text;
    _searchCityInfos = [self.positionList searchCityWithCithName:cityName];
    for (int i = 0; i < _searchCityInfos.count; i ++) {
        UIButton *cityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * i + 1, SCREENWIDTH, 44)];
        cityButton.backgroundColor = [UIColor whiteColor];
        cityButton.tag = i;
        [cityButton setTitle:((WBCityModel *)_searchCityInfos[i]).cityName forState:UIControlStateNormal];
        if (i != _searchCityInfos.count) {
            UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, SCREENWIDTH, 0.5)];
            underLine.backgroundColor = [UIColor initWithBackgroundGray];
            [cityButton addSubview:underLine];
        }
        [cityButton addTarget:self action:@selector(searchNextStep:) forControlEvents:UIControlEventTouchUpInside];
        [_overlay addSubview:cityButton];
    }
}

-(void)searchCancel{
    _tableView.scrollEnabled = YES;
    [_searchBox resignFirstResponder];
    [_overlay removeFromSuperview];
}

-(void)searchNextStep:(UIButton *)sender{
    _cityId = ((WBCityModel *)_searchCityInfos[sender.tag]).cityId;
    if (self.fromNextPage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"choosePlace" object:self userInfo:@{@"startPlaceId":[NSString stringWithFormat:@"%@",_cityId]}];
    }
    [self nextStep];
}

#pragma mark - notification center

-(void)createSuccess:(NSNotification *)sender{
    self.fromNextPage = NO;
    self.fromSlidePage = NO;
    _chooseCity = NO;
    _cityId = nil;
    [_tableView reloadData];
}

@end
