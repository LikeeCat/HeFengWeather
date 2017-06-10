//
//  DynamicViewController.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "DynamicViewController.h"
#import "和风天气-Swift.h"

#import "DynamicCell.h"
//#import "Dynamic.h"

@interface DynamicViewController ()
@property (nonatomic,strong) YCInputBar *bar;
@property (nonatomic, strong) NSMutableArray *dynamicData;
@property(nonatomic,strong)NSString *user;
@property(nonatomic,strong)NSIndexPath  *index;
@property(nonatomic,strong)NSString *content;
@property(nonatomic)CGFloat cellHigh;
@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRefreshControl];
    [self loadDynamicData];
    _bar = [[YCInputBar alloc] initBar:self.navigationController.view sendButtonTitle:@"评论" maxTextLength:30 isHideOnBottom:YES buttonColor:nil];
    _bar.placeholder = @"说点什么...";
    _bar.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hello:) name:@"打开键盘" object:nil];
//    self.navigationController.navigationItem.title = [NSString stringWithFormat:@"朋友圈"];
//    [self.navigationController.navigationBar setHidden:NO];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.tableView.frame];
    imageView.image = [UIImage imageNamed:@"bg_fog_day.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.tableView.backgroundView = imageView;
    
}

- (void)configRefreshControl{
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.tintColor = [UIColor greenColor];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    
    [refresh addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    
}
-(void)startRefresh{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *commentUserName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"];

        if (commentUserName == NULL || commentUserName == @"none") {
//            [DiscoverTable getmyAttionUserWithUserName:commentUserName complete:^(NSArray<DiscoverTable *> * obj) {
//                self.dynamicData = [NSMutableArray arrayWithArray:obj];
                [self.refreshControl endRefreshing];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                    
//                });
                
                
//            }];

        }else{
        [DiscoverTable getmyAttionUserWithUserName:commentUserName complete:^(NSArray<DiscoverTable *> * obj) {
            self.dynamicData = [NSMutableArray arrayWithArray:obj];
            [self.refreshControl endRefreshing];
                    dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
            
                        });

            
        }];
        }

        
    });

}

- (void)loadDynamicData
{
    
 //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *data = [Dynamic findAll];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _dynamicData = [[NSMutableArray alloc] initWithArray:data];
//            [self.tableView reloadData];
//        });
//    });
    //    [DiscoverTable findAllObjectWithComplete:^(NSArray<DiscoverTable *> * obj) {
    //
    //        self.dynamicData = [NSArray arrayWithArray:obj];
    //        [self.tableView reloadData];
    //    }];
    //
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSString *commentUserName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"];
    if (commentUserName == NULL) {
            [DiscoverTable findAllObjectWithComplete:^(NSArray<DiscoverTable *> * obj) {
        
                self.dynamicData = [NSMutableArray arrayWithArray:obj];
                [self.tableView reloadData];
            }];
    }else{
    [DiscoverTable getmyAttionUserWithUserName:commentUserName complete:^(NSArray<DiscoverTable *> * obj) {
        self.dynamicData = [NSMutableArray arrayWithArray:obj];
        [self.tableView reloadData];

    }];
    }
    
});

    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dynamicData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"调用 table view  刷新 机制   -----------------");
    DynamicCell * cell = [DynamicCell cellWithTableView:tableView indexPath:indexPath selected:YES];
    
    DiscoverTable *dynamic = [_dynamicData objectAtIndex:indexPath.row];
    cell.dynamic = dynamic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiscoverTable *dynamic = [_dynamicData objectAtIndex:indexPath.row];
//    if (indexPath.row == 0 && !self.index) {
//        return [DynamicCell heightOfCellWithModel:dynamic] + kPadding;
//    }
//    else{
    
//    NSLog(@"now index:%ld,height: %f",indexPath.row,[DynamicCell heightOfCellWithModel:dynamic]);
    return [ DynamicCell heightOfCellWithModel:dynamic];
//    }
}

#pragma mark - YCBar delegate
-(BOOL)sendButtonClick:(UITextView *)textView
{
    if (textView.text.length == 0 && ![textView.text containsString:@"\n"]) {
        return NO;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.content = [NSString stringWithFormat:@"%@",textView.text];
        //评论人
        DynamicCell * cell = [self.tableView cellForRowAtIndexPath:self.index];
        CommentTable *comment = [[CommentTable alloc]init];
        comment.DiscoverID = cell.dynamic;
        //内容
        [UserTable getInformationFromLeancloudWithName:cell.nameLabel.text complete:^(UserTable * user) {
            comment.postUser = user;
            comment.postUserName =  user.userName;
            NSString *commentUserName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"];
            
            [DiscoverTable getmyAttionUserWithUserName:commentUserName complete:^(NSArray<DiscoverTable *> * name) {
            }];
            LCString * str = [[LCString alloc]init:commentUserName];
            comment.commentUserName = str;
            [UserTable getInformationFromLeancloudWithName:commentUserName complete:^(UserTable * CommentUser) {
                comment.commentUser = CommentUser;
                comment.commentContent = [[LCString alloc]init:self.content];
                [DiscoverTable  commentRecordCountWithRecord:cell.dynamic];
                [CommentTable insertCommentWithComment:comment];
                [self loadDynamicData];
            }];
        }];

    });

    return YES;
}

-(void)hello:(id) notice{
    
    NSString * str = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"] ;
    
    if ([str isEqualToString:@"none"]) {
        [self showAlert];
        NSLog(@"user now is %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"]  );
    }
    else{
        NSLog(@"user now is %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"]  );
    [_bar showKeyboard];
    NSNotification *noti = notice;
    NSIndexPath * index = noti.object;
    self.index = index;
    }
    
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
   
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


  
// Override to support conditional editing of the table view.

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -取消关注
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除动态";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUser"] ;

    DynamicCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.nameLabel.text isEqualToString:str]) {
        return YES;
    }
    else{
        return NO;
    }

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSUInteger row = [indexPath row];
            DiscoverTable * record = _dynamicData[indexPath.row];
            [DiscoverTable deleteDiscoverWithRecord:record];
            [_dynamicData removeObject:record];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView reloadData];
        }
    
}
-(void)unfollowUser:(NSString *)attionName from:(NSString *)userName {
    [UserRelationShipTable unfollowUserWithOwn:userName attion:attionName complete:^(BOOL isok) {
        NSLog(@"删除成功");
    }];
    
}


@end
