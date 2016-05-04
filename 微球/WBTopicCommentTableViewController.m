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
#import "WBHomepageViewController.h"


#define commentURL @"%@/tq/getTopicCommentDetil?commentId=%ld"

@interface WBTopicCommentTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextInputTraits,CommentTapIconDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_cellHeightArray;
    UITextField *_commentTextView;
    UIButton *_rightBtn;
    UILabel *_placeHolder;
    UIView *_textBgView;
    UIImageView *_background;
    
    NSString *_typeFlag;
    NSString *_toUserId;
}

@end

@implementation WBTopicCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    _cellHeightArray = [NSMutableArray array];
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _background.center = CGPointMake(SCREENWIDTH / 2, 200);
    _typeFlag = @"0";
    _toUserId = self.userId;
    [self createNavi];
    [self createUI];
    [self registerForKeyboardNotifications];
    [self createTextView];
    [self showHUDIndicator];
    [self loadData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
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
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height-64-50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor initWithBackgroundGray];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _textBgView = [[UIView alloc]initWithFrame:CGRectZero];
    _textBgView.backgroundColor = [UIColor clearColor];
    _textBgView.alpha = 0.1;
    _textBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClicked)];
    [_textBgView addGestureRecognizer:tap];
}

-(void)createTextView{
    _commentTextView = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - 50 , SCREENWIDTH, 50)];
    _commentTextView.layer.masksToBounds = YES;
    _commentTextView.font = MAINFONTSIZE;
    _commentTextView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _commentTextView.leftViewMode = UITextFieldViewModeAlways;
    _commentTextView.textColor = [UIColor initWithLightGray];
    _commentTextView.delegate = self;
    _commentTextView.layer.borderColor = [UIColor initWithBackgroundGray].CGColor;
    _commentTextView.backgroundColor = [UIColor whiteColor];
    _commentTextView.layer.borderWidth = 5;
    _commentTextView.returnKeyType = UIReturnKeySend;
    _commentTextView.placeholder = @"快发表你的神评论！";
    [self.view addSubview:_commentTextView];
}

-(void)viewClicked{
    [_commentTextView resignFirstResponder];
    _commentTextView.placeholder = @"快发表你的神评论！";
    _typeFlag = @"0";
    _toUserId = self.userId;
}


- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    _background.hidden = YES;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _textBgView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 50 - 64 - keyboardSize.height);
    [self.view addSubview:_textBgView];
    NSNumber *animationTime = [info objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    [UIView animateWithDuration:[animationTime doubleValue] animations:^{
        _commentTextView.frame = CGRectMake(0, self.view.frame.size.height - 50 - keyboardSize.height, SCREENWIDTH, 50);
    } completion:nil];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    _background.hidden = NO;
    [_textBgView removeFromSuperview];
    _commentTextView.frame =CGRectMake(0, self.view.frame.size.height - 50, SCREENWIDTH, 50);
}

- (void) keyboardWillChangeFrame:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat endKeyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSNumber *animationTime = [info objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    [UIView animateWithDuration:[animationTime doubleValue] animations:^{
        _commentTextView.frame =CGRectMake(0, self.view.frame.size.height - 50 - endKeyboardHeight, SCREENWIDTH, 50);
    } completion:nil];
    
}

-(void)textViewClicked{
    if (_commentTextView.text.length == 0) {
        return;
    }
    
    [self showHUD:@"评论中" isDim:YES];
    NSDictionary *paramter = @{@"userId":[WBUserDefaults userId],@"toUserId":_toUserId,@"commentId":[NSString stringWithFormat:@"%ld",(long)_commentId],@"comment":_commentTextView.text,@"typeFlag":_typeFlag};
    [MyDownLoadManager postUrl:[NSString stringWithFormat: @"%@/tq/setCommentDetil",WEBAR_IP] withParameters:paramter whenProgress:^(NSProgress *FieldDataBlock) {
        
    } andSuccess:^(id representData) {
//        [self showHUDComplete:@"评论成功"];
        [self loadData];
        _commentTextView.text = @"";
        [_commentTextView resignFirstResponder];
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"评论失败，请稍后再试"];
    }];
    
    
}

#pragma mark ------textView delegate data source-----

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self textViewClicked];
    return NO;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    if (![_commentTextView isExclusiveTouch]) {
        [_commentTextView resignFirstResponder];
    }
}

//加载数据
-(void) loadData{
    NSString *url = [NSString stringWithFormat:commentURL,WEBAR_IP,(long)_commentId];
    
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:result[@"pagination"]];
            NSString *titleNumber =[dic objectForKey:@"totalCount"];
            self.navigationItem.title = [NSString stringWithFormat:@"%@条评论",titleNumber];
            _dataArray = [WBtopicCommentDetilListModel mj_objectArrayWithKeyValuesArray:result[@"topicCommentDetilList"]];
            if (_dataArray.count == 0) {
                [self.view addSubview:_background];
            } else {
                [_background removeFromSuperview];
            }
            [_cellHeightArray removeAllObjects];
            for (NSInteger j =0; j<_dataArray.count; j++) {
                NSDictionary *attributes = @{NSFontAttributeName: MAINFONTSIZE};
                CGRect rect = [((WBtopicCommentDetilListModel *)_dataArray[j]).comment
                               boundingRectWithSize:CGSizeMake(SCREENWIDTH-20-65, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                               context:nil];
                [_cellHeightArray addObject:[NSString stringWithFormat:@"%f",rect.size.height]];
            }
            
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [self hideHUD];
        }
    } andFailure:^(NSString *error) {
        [_tableView.mj_header endRefreshing];
        [self hideHUD];
        NSLog(@"%@------",error);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [_cellHeightArray[indexPath.row] floatValue]+70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    WBtopicCommentDetilListModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.tag = model.userId;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBtopicCommentDetilListModel *model = _dataArray[indexPath.row];
    [_commentTextView becomeFirstResponder];
    _commentTextView.placeholder = [NSString stringWithFormat:@"回复 %@",model.userInfo.nickname];
    _typeFlag = @"1";
    _toUserId = [NSString stringWithFormat:@"%ld",(long)model.userInfo.userId];
    
}

-(void)headIconTap:(WBTopicCommentTableViewCell *)cell{
    WBHomepageViewController *homePage = [[WBHomepageViewController alloc] init];
    homePage.userId = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    [self.navigationController pushViewController:homePage animated:YES];
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return   UITableViewCellEditingStyleDelete;
//}

/*改变删除按钮的title*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}

/*删除用到的函数*/
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle ==UITableViewCellEditingStyleDelete)
//    {
//        [_dataArray   removeObjectAtIndex:indexPath.row];  //删除数组里的数据
//        [_tableView   deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
//    }
//}

@end
