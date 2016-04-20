//
//  WBMyDraftViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/18.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMyDraftViewController.h"
#import "WBDraftManager.h"
#import "WBDraftSave.h"
#import "WBImage.h"
#import "NSString+string.h"

@interface WBMyDraftViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_draftArray;
    UIImageView *_background;
}

@end

@implementation WBMyDraftViewController

- (instancetype)init{
    if (self = [super init]) {
        self .view.backgroundColor = [UIColor initWithBackgroundGray];
        self.navigationItem.title = @"我的草稿";
        
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
        _background.center = CGPointMake(SCREENWIDTH / 2, 170);
        
        _draftArray = (NSMutableArray *)[[WBDraftManager openDraft] allDrafts];
        
        for (WBDraftSave *draft in _draftArray) {
            
                const void *buffer = NULL;
                size_t size = 0;
            dispatch_data_t new_data_file = dispatch_data_create_map((dispatch_data_t)draft.imagesArray, &buffer, &size);
                NSData *nsdata = [[NSData alloc] initWithBytes:NULL length:size];
            NSLog(@"%@",nsdata);
//            const void *buffer = NULL;
//            size_t size = dispatch_data_get_size(d);
//            dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &size);
//            NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
//            NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:(dispatch_data_t)draft.imagesArray]);
        }
        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
//        int intbuffer[] = { 1, 2, 3, 4 };
//        char charbuffer[]={"fdafdsafsdfasdfa"};
//        dispatch_data_t data = dispatch_data_create(charbuffer, 4 * sizeof(int), queue, NULL);
//        
//        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//        // Write
//        dispatch_fd_t fd = open("/tmp/data.txt", O_RDWR | O_CREAT | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);
//        
//        printf("FD: %d\n", fd);
//        
//        dispatch_write(fd, data, queue,^(dispatch_data_t d, int e) {
//            printf("Written %zu bytes!\n", dispatch_data_get_size(data) - (d ? dispatch_data_get_size(d) : 0));
//            printf("\tError: %d\n", e);
//            dispatch_semaphore_signal(sem);
//        });
//        
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//        
//        close(fd);
        
        // Read
//        dispatch_fd_t fd = open("/tmp/data.txt", O_RDWR);
//        
//        dispatch_read(fd, 4 * sizeof(int), queue, ^(dispatch_data_t d, int e) {
//            printf("Read %zu bytes!\n", dispatch_data_get_size(d));
//            const void *buffer = NULL;
//            size_t size = dispatch_data_get_size(d);
//            dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &size);
//            NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
//            NSString *s=[[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];
//            NSLog(@"buffer %@",s);
//            printf("\tError: %d\n", e);
//            dispatch_semaphore_signal(sem);
//        });
//        
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//        close(fd);
//        
//        // Exit confirmation
//        getchar();
        
        
        [self setUpTableView];
    }
    return self;
}

- (void)setUpTableView{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
}



#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = _draftArray.count;
    if (count == 0) {
        [self.view addSubview:_background];
    } else {
        [_background removeFromSuperview];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        WBDraftSave *draft = _draftArray[indexPath.row];
        if ([draft.type isEqualToString:@"1"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"【问题】%@",draft.title];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"【话题】%@",draft.title];
        }
        cell.textLabel.textColor = [UIColor initWithLightGray];
        cell.textLabel.font = MAINFONTSIZE;
        cell.detailTextLabel.text = [draft.content replaceImageSign];
        cell.detailTextLabel.textColor = [UIColor initWithNormalGray];
        cell.detailTextLabel.font = FONTSIZE12;
    }
    
    
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
