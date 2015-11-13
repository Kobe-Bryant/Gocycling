//
//  ActivityViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "ActivityViewController.h"
#import "Macros.h"
#import "EventsViewController.h"
#import "ActivityRegisterCell.h"
#import "Activity.h"
#import "Result.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SelectProjectViewController.h"


#define LIMIT 10
#define kPageSize 5;

@interface ActivityViewController ()
{
    
    UITableView* mainTableView;
    BOOL isEnter;
    NSMutableArray* activityArray;
    UIActivityIndicatorView* activityIndicatorView;
    
    
}

@property(nonatomic,strong) NSMutableArray* eventTitleArray;
@property(nonatomic,strong) NSMutableArray* dateArray;
@property(nonatomic,strong) NSMutableArray* imageArray;
@property(nonatomic,strong) NSMutableArray* eventActivityIDArray;
@property(nonatomic,assign) BOOL isLoadingData;
@property(nonatomic,assign) int offset;


//获取网络数据方法
-(void)getWebserviceData;
@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"活动报名";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //取消tableView的选中效果
    [mainTableView deselectRowAtIndexPath:[mainTableView indexPathForSelectedRow] animated:YES];
    
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }
    
    //创建TableView
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.rowHeight = 115.0;
    [self.view addSubview:mainTableView];
    
    //Table footer view
    
    mainTableView.tableFooterView = [[UIView alloc]init];
    
    mainTableView.tableFooterView.frame = CGRectMake(0.0, 0.0,
                                                     self.view.frame.size.width,
                                                     mainTableView.rowHeight);
    
    
    // Reset table attributes
    mainTableView.contentInset = UIEdgeInsetsMake(0.0,
                                                  mainTableView.contentInset.left,
                                                  mainTableView.contentInset.bottom,
                                                  mainTableView.contentInset.right);
    mainTableView.scrollIndicatorInsets = mainTableView.contentInset;
    mainTableView.tableFooterView.hidden = YES;
    
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:
                             UIActivityIndicatorViewStyleGray];
    
    activityIndicatorView.frame = mainTableView.tableFooterView.frame;
    
    activityIndicatorView.center = CGPointMake(mainTableView.tableFooterView.frame.size.width/2.0,
                                               mainTableView.tableFooterView.frame.size.height/2.0);
    [activityIndicatorView startAnimating];
    
    [mainTableView.tableFooterView addSubview:activityIndicatorView];
    
    //获取网络数据过程方法
    [self getWebserviceData];
    
    
}
//获取网络数据过程方法
-(void)getWebserviceData
{
    
    activityArray = [NSMutableArray array];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        Result* result = [Activity requestListWithOffset:self.offset limit:LIMIT];
        
        
        
        if (result.isSuccess) {
            
            
            activityArray = (NSMutableArray*)result.data;
            
            
            
            self.eventTitleArray = [NSMutableArray array];
            self.dateArray = [NSMutableArray array];
            self.imageArray = [NSMutableArray array];
            self.eventActivityIDArray = [NSMutableArray array];
            
            for (Activity* list  in activityArray) {
                
                NSLog(@"%@",list.imageURLString);
                
                [self.eventTitleArray addObject:list.title];
                [self.dateArray addObject:list.dateString];
                [self.imageArray addObject:list.imageURLString];
                [self.eventActivityIDArray addObject:[NSNumber numberWithInt:list.activityID]];
                
            }
            NSLog(@"%d",self.imageArray.count);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [mainTableView reloadData];
            
            
        });
        
        
        
    });
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 115.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return activityArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellidenty = @"cellidenty";
    
    ActivityRegisterCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell==nil) {
        
        cell = [[ActivityRegisterCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellidenty];
        
    }
    cell.imageView.image = nil;
    
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    
    Activity* eventList = activityArray[indexPath.row];
    
    NSLog(@"%@",eventList.imageURLString);
    
    
    if (eventList.imageURLString != nil) {
        
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = CGPointMake(cell.imageView.frame.size.width / 2.0,
                                          cell.imageView.frame.size.height / 2.0);
        [cell.imageView addSubview:progressView];
        
        
        [[SDWebImageManager sharedManager] downloadWithURL:[[NSURL alloc]initWithString:eventList.imageURLString]
                                                   options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       
                                                       [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
                                                       
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                       
                                                       if (finished)
                                                       {
                                                           [progressView setProgress:1.0 animated:YES];
                                                           cell.imageView.image = image;
                                                           [progressView removeFromSuperview];
                                                       }
                                                   }];
        
    }
    
    
    //为cell赋值
    [cell setCellInfo:activityArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //赛事controller
    EventsViewController* eventVC = [[EventsViewController alloc]init];
    eventVC.eventID = [[self.eventActivityIDArray objectAtIndex:indexPath.row] intValue];
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        eventVC.edgesForExtendedLayout = NO;
    }
    
    eventVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:eventVC animated:YES];
}

- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    
    
    float height = mainTableView.rowHeight*activityArray.count;
    
    if (!self.isLoadingData) {
        
        
        if (mainTableView.frame.size.height+mainTableView.contentOffset.y > height) {
            
            self.isLoadingData = YES;
            
            
            CGSize size = scrollView.contentSize;
            
            size.height = mainTableView.tableFooterView.frame.size.height+height;
            
            scrollView.contentSize = size;
            
            if (scrollView.contentOffset.y > 0) {
                
                
                mainTableView.tableFooterView.frame = CGRectMake(0.0, height, mainTableView.bounds.size.width, mainTableView.rowHeight);
                
                
            }else
            {
                
                mainTableView.tableFooterView.frame = CGRectMake(0.0, 0.0, mainTableView.bounds.size.width, mainTableView.rowHeight);
                
            }
            mainTableView.tableFooterView.hidden = NO;
            
            
        }
        
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(UpdateTableView) userInfo:nil repeats:NO];
}

-(void)UpdateTableView
{
    
    if (self.isLoadingData) {
        
        float height = mainTableView.rowHeight * [activityArray count];
        
        CGSize size = mainTableView.contentSize;
        size.height = height + mainTableView.tableFooterView.frame.size.height;
        mainTableView.contentSize = size;
        mainTableView.tableFooterView.frame = CGRectMake(0.0,
                                                         height,
                                                         mainTableView.bounds.size.width,
                                                         mainTableView.rowHeight);
        mainTableView.tableFooterView.hidden = NO;
        self.offset+=kPageSize;
        
        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            
            Result* result = [Activity requestListWithOffset:self.offset limit:LIMIT];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result.isSuccess)
                {
                    NSInteger index = activityArray.count;
                    NSArray* listArray = (NSArray*)result.data;
                    if (listArray.count!= 0)
                    {
                        
                        [mainTableView beginUpdates];
                        [activityArray addObjectsFromArray:listArray];
                        
                        
                        self.eventTitleArray = [NSMutableArray array];
                        self.dateArray = [NSMutableArray array];
                        self.imageArray = [NSMutableArray array];
                        self.eventActivityIDArray = [NSMutableArray array];
                        
                        
                        for (Activity* list  in activityArray)
                        {
                            [self.eventTitleArray addObject:list.title];
                            [self.dateArray addObject:list.dateString];
                            [self.imageArray addObject:list.imageURLString];
                            [self.eventActivityIDArray addObject:[NSNumber numberWithInt:list.activityID]];
                        }
                        
                        
                        
                        for (Activity* list in result.data)
                        {
                            
                            NSIndexPath* path = [NSIndexPath indexPathForItem:index++ inSection:0];
                            
                            [mainTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                                 withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }
                        [mainTableView endUpdates];
                    }
//                    else
//                    {
//                        
//                        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"数据已经加载完成！"
//                                                                           message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//                        [alertView show];
//                        
//                    }
                    
                }
            });
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.isLoadingData = NO;
            
            CGSize size = mainTableView.contentSize;
            size.height = mainTableView.tableHeaderView.frame.size.height + mainTableView.rowHeight * [activityArray count];
            mainTableView.contentSize = size;
            mainTableView.tableFooterView.frame = CGRectMake(0.0,
                                                             mainTableView.rowHeight * [activityArray count],
                                                             mainTableView.bounds.size.width,
                                                             mainTableView.rowHeight);
            mainTableView.tableFooterView.hidden = YES;
            
            
        });
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
