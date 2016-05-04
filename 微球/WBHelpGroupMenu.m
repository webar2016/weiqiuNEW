//
//  WBHelpGroupMenu.m
//  微球
//
//  Created by 贾玉斌 on 16/5/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHelpGroupMenu.h"



@interface WBHelpGroupMenu()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;


@property (nonatomic,copy)NSArray *dataArray;

@end





@implementation WBHelpGroupMenu

-(instancetype)initWithHeight:(CGFloat)Height{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WBHelpGroupMenu" owner:nil options:nil] firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.dataArray = [NSArray arrayWithObjects:@"全部帮帮团",@"我可加入的帮帮团", nil];
        self.contentHeight.constant = Height;
        _bgHeight.constant = Height;
        [self layoutIfNeeded];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        
        
    }
    return self;
}

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    
}

- (void)hide{
    [UIView animateWithDuration:0.0 animations:^{
        self.alpha = 0;
        self.contentHeight.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.colseBlock();
    }];
    
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];

}


#pragma mark ------tableView delegate-------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"tableViewID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
   
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    label.font = MAINFONTSIZE;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _dataArray[indexPath.row];
    label.center = CGPointMake(SCREENWIDTH/2, 20);
    label.textColor = [UIColor initWithLightGray];
    [cell.contentView addSubview:label];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        self.block(YES);
    }else{
        self.block(NO);
    }
    
    
    [self hide];
}


@end
