//
//  WBTopicCommentTableViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicCommentTableViewController.h"
#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBtopicCommentDetilListModel.h"
#import "WBTopicCommentTableViewCell.h"


#define commentURL @"http://121.40.132.44:92/tq/getTopicCommentDetil?commentId=%ld"

@interface WBTopicCommentTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_cellHeightArray;
    NSInteger _page;
    UITextView *_commentTextView;
    UIButton *_rightBtn;
}


@end

@implementation WBTopicCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //缓冲标志
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    _cellHeightArray = [NSMutableArray array];
    [self createNavi];
    [self createUI];
    [self registerForKeyboardNotifications];
    [self createTextView];
    [self showHUD:@"正在努力加载" isDim:NO];
    [self loadData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //NSLog(@"进入刷新状态后会自动调用这个block1");
        _page=1;
        [self loadData];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer =[ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //  NSLog(@"进入刷新状态后会自动调用这个block2");
        _page++;
        [self loadData];
        
    }];
    
    
}

-(void) createNavi{
    //设置标题
    self.navigationItem.title = @"0条评论";
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+9, SCREENWIDTH, self.view.frame.size.height-64-9)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor initWithBackgroundGray];


}

-(void)createTextView{
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0  , SCREENHEIGHT-64-50 , SCREENWIDTH-50, 50)];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(SCREENWIDTH-50,SCREENHEIGHT-64-50, 50, 50);
    _rightBtn.backgroundColor = [UIColor greenColor];
    [_rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(textViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
    
    [self.view addSubview:_commentTextView];

}

//输入框
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _commentTextView.frame =CGRectMake(0  , SCREENHEIGHT-64-50 -keyboardSize.height, SCREENWIDTH-50, 50);
    _rightBtn.frame = CGRectMake(SCREENWIDTH-50,SCREENHEIGHT-64-50-keyboardSize.height, 50, 50);
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
     _commentTextView.frame =CGRectMake(0  , SCREENHEIGHT-64-50, SCREENWIDTH-50, 50);
    _rightBtn.frame = CGRectMake(SCREENWIDTH-50,SCREENHEIGHT-64-50, 50, 50);
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}
-(void)textViewClicked{
    [self showHUD:@"正在上传" isDim:YES];
   
    
    
    NSDictionary *paramter = @{@"userId":[WBUserDefaults userId],@"toUserId":_userId,@"commentId":[NSString stringWithFormat:@"%ld",_commentId],@"comment":_commentTextView.text};
    [MyDownLoadManager postUrl:@"http://121.40.132.44:92/tq/setCommentDetil" withParameters:paramter whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
        [self showHUDComplete:@"保存成功"];
        [self loadData];
        [_commentTextView resignFirstResponder];
    } andFailure:^(NSString *error) {
        
    }];
    
    
}

#pragma mark ------textView delegate-----
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [_commentTextView resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"000000");
    if (![_commentTextView isExclusiveTouch]) {
        [_commentTextView resignFirstResponder];
    }
}
//加载数据
-(void) loadData{
    NSString *url = [NSString stringWithFormat:commentURL,(long)_commentId]; //TopicCommentURL
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_dataArray removeAllObjects];
            [_cellHeightArray removeAllObjects];
        }
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [_cellHeightArray removeAllObjects];
            [_dataArray removeAllObjects];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:result[@"pagination"]];
            NSString *titleNumber =[dic objectForKey:@"totalCount"];
            self.navigationItem.title = [NSString stringWithFormat:@"%@条评论",titleNumber];
            //NSLog(@"number = %@",titleNumber);
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topicCommentDetilList"]];
            NSArray *tempArray = [WBtopicCommentDetilListModel mj_objectArrayWithKeyValuesArray:arrayList];
            for (NSInteger j =0; j<tempArray.count; j++) {
                NSDictionary *attributes = @{NSFontAttributeName: MAINFONTSIZE};
                // NSString class method: boundingRectWithSize:options:attributes:context is
                // available only on ios7.0 sdk.
                CGRect rect = [((WBtopicCommentDetilListModel *)tempArray[j]).comment
                               boundingRectWithSize:CGSizeMake(SCREENWIDTH-20-65, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
     //           NSLog(@"recxt = %f   tit = %f",rect.size.height,titleSize.height);
                
                [_cellHeightArray addObject:[NSString stringWithFormat:@"%f",rect.size.height]];
                [_dataArray addObject:tempArray[j]];
                
            }
            
            
            [self.tableView reloadData];
            
            if (_page ==1 ) {
                [self.tableView.mj_header endRefreshing];
                [self hideHUD];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"%f",[_cellHeightArray[indexPath.row] floatValue]+70);
    return  [_cellHeightArray[indexPath.row] floatValue]+70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellID = @"CommentCellId";
    WBTopicCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
    if (cell == nil)
    {
        cell = [[WBTopicCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID cellHeight:[_cellHeightArray[indexPath.row] floatValue]];
    }
    WBtopicCommentDetilListModel *model = _dataArray[indexPath.row];
   // NSLog(@"asasasa = %f",[_cellHeightArray[indexPath.row] floatValue]);
    [cell setModel:model];
    return cell;
}

#pragma mark - 键盘 改变通知 弹键盘

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
