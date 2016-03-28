#import "CreateHelpGroupViewController.h"
#import "WBGroupInfoController.h"
#import "WBUnlockViewController.h"

#import "WBPositionList.h"

@interface CreateHelpGroupViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    BOOL        _chooseCity;
    NSNumber    *_provinceId;
    NSNumber    *_cityId;
    UIView      *_selectedView;
}

@property (nonatomic, strong) WBPositionList *positionList;

@end

@implementation CreateHelpGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createSuccess)
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
    }else{
        self.navigationItem.title = @"选择目的地";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    [self setUpTableView];
    
    [self setUpSearchBox];
    
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

-(void)nextStep{
    if (!_cityId) {
        NSLog(@"请选择城市");
        return;
    }
    if (self.fromNextPage) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }if (self.fromSlidePage) {
        WBUnlockViewController *unlockVC = [[WBUnlockViewController alloc] init];
        unlockVC.cityName = [self.positionList cityNameWithCityId:_cityId];
        unlockVC.cityId = _cityId;
        unlockVC.provinceId = _provinceId;
        [self.navigationController pushViewController:unlockVC animated:YES];
    }else{
        WBGroupInfoController *groupInfoVC = [[WBGroupInfoController alloc] init];
        groupInfoVC.dataDic[@"destinationId"] = [NSString stringWithFormat:@"%@",_cityId];
        [self.navigationController pushViewController:groupInfoVC animated:YES];
    }
    
}

-(void)popViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
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

#pragma mark - notification center

-(void)createSuccess{
    self.fromNextPage = NO;
    self.fromSlidePage = NO;
    _chooseCity = NO;
    _cityId = nil;
    [_tableView reloadData];
}

@end
