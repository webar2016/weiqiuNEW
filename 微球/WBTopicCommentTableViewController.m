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
#import "TopicDetailModel.h"
#import "WBTopicDetailCell.h"
#import "WBArticalViewController.h"
#import "WBImageViewer.h"
#import "LoadViewController.h"

#define commentURL @"%@/tq/getTopicCommentDetil?commentId=%ld"

@interface WBTopicCommentTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextInputTraits,CommentTapIconDelegate,TransformValue>
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
    
    CGFloat _topRowHeight;
    NSString *_isSelect;
}
@property (nonatomic,strong)TopicDetailModel *TopModel;

@end

@implementation WBTopicCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    _cellHeightArray = [NSMutableArray array];
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _background.center = CGPointMake(SCREENWIDTH / 2, 200);
    _background.alpha = 0;
    _typeFlag = @"0";
    _toUserId = self.userId;
    [self createNavi];
    [self createUI];
    [self registerForKeyboardNotifications];
    [self createTextView];
    [self showHUDIndicator];
   
    [self loadTopData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadTopData];
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
        [self loadTopData];
        _commentTextView.placeholder = @"快发表你的神评论！";
        _typeFlag = @"0";
        _toUserId = self.userId;
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





-(void)loadTopData{

    NSString *url = [NSString stringWithFormat:@"%@/tq/getCommentById?commentId=%ld",WEBAR_IP,(long)_commentId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            _TopModel = [TopicDetailModel mj_objectWithKeyValues:result[@"topicComment"]];
            NSLog(@"%@",_TopModel);
        }
        
        if (_TopModel.newsType == 1) {
            _topRowHeight =136.0 + SCREENWIDTH;
        } else if (_TopModel.newsType == 2) {
            _topRowHeight =110.0 + SCREENWIDTH;
        } else {
            _topRowHeight =285.0;
        }

        [self loadData];
        
        
        
    } andFailure:^(NSString *error) {
        
    }];



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
            
            _tableView.contentOffset = CGPointMake(0,_topRowHeight);
            
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
    if (indexPath.row == 0) {
        return _topRowHeight;
    }else{
    return  [_cellHeightArray[indexPath.row-1] floatValue]+70;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if (_TopModel.newsType == 1) {
            static NSString *cellID1 = @"detailCellID1";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.delegate = self;
            
            [cell setModel:_TopModel withIsSelectState:@"0"];
            return cell;
        } else if (_TopModel.newsType == 2) {
            static NSString *cellID2 = @"detailCellID2";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setModel:_TopModel withIsSelectState:@"0"];
            return cell;
        } else {
            static NSString *cellID3 = @"detailCellID3";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            [cell setModel:_TopModel withIsSelectState:@"0"];
            cell.delegate = self;
            return cell;
        }


        
        
        
    }else{
        static NSString *topCellID = @"CommentCellId";
        WBTopicCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        if (cell == nil)
        {
            cell = [[WBTopicCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID cellHeight:[_cellHeightArray[indexPath.row-1] floatValue]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        WBtopicCommentDetilListModel *model = _dataArray[indexPath.row-1];
        [cell setModel:model];
        cell.tag = model.userId;
        return cell;
    
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        WBtopicCommentDetilListModel *model = _dataArray[indexPath.row-1];
        [_commentTextView becomeFirstResponder];
        _commentTextView.placeholder = [NSString stringWithFormat:@"回复 %@",model.userInfo.nickname];
        _typeFlag = @"1";
        _toUserId = [NSString stringWithFormat:@"%ld",(long)model.userInfo.userId];
    }else{
        if (_TopModel.newsType == 3) {
            WBArticalViewController *articalVC = [[WBArticalViewController alloc] init];
            articalVC.navigationItem.title = self.navigationItem.title;
            articalVC.nickname = _TopModel.tblUser.nickname;
            articalVC.dir = _TopModel.tblUser.dir;
            articalVC.timeStr = _TopModel.timeStr;
            articalVC.commentId = _TopModel.commentId;
            articalVC.userId = _TopModel.userId;
            [self.navigationController pushViewController:articalVC animated:YES];
            return;
        }
    }
}

-(void)headIconTap:(WBTopicCommentTableViewCell *)cell{
    WBHomepageViewController *homePage = [[WBHomepageViewController alloc] init];
    homePage.userId = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    [self.navigationController pushViewController:homePage animated:YES];
}

#pragma mark ---cell delegate----

-(void)unloginAlert{
    [self alertLogin];
}

-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation cancelMessage:(NSString *)cancelMessage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageContent message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (!(cancelMessage == nil || cancelMessage == NULL)) {
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelMessage style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
    }else{
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
    }
    
    if (!(opreation == nil || opreation == NULL)) {
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:opreation style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            action;
        })];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)gotoHomePage:(NSIndexPath *)indexPath{
    WBHomepageViewController *HVC = [[WBHomepageViewController alloc]init];
    HVC.userId = [NSString stringWithFormat:@"%ld",(long)_TopModel.userId ];
    [self.navigationController pushViewController:HVC animated:YES];
}

-(void)showImageViewer:(NSIndexPath *)indexPath{
    TopicDetailModel *model = _TopModel;
    if (!model.dir) {
        [self showHUDText:@"未获取到图片，请重试"];
        return;
    }
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithDir:model.dir andContent:model.comment];
    [self presentViewController:viewer animated:YES completion:nil];
}

-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath{
    _TopModel.getIntegral = _TopModel.getIntegral+5;
    _isSelect = @"1";
    //NSLog(@"%ld",(long)((TopicDetailModel *)_dataArray[indexPath.section]).getIntegral);
}

-(void)commentClickedPushView:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark --------登陆提示----------

-(void)alertLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆后即可进行更多操作！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoadViewController *loginVC = [[LoadViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
