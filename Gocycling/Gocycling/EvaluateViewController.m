//
//  EvaluateViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//


#import "EvaluateViewController.h"
#import "EvaluateCell.h"
#import "Result.h"
#import "Member.h"
#import "ProductComment.h"

#define LIMIT 5
#define kPageSize 5;

@interface EvaluateViewController ()

{

    UITableView* mainTableView;
    BOOL isEnter;
    UIActivityIndicatorView* activityIndicatorView;


}
@property(nonatomic,strong) NSMutableArray* evaluateArray;
@property(nonatomic,assign) BOOL isLoadingData;

@property(nonatomic,assign) int offset;
-(void)getWebServiceData;

@end

@implementation EvaluateViewController

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
   
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"我的评论", nil);
    self.navigationItem.titleView = label;
  
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButton) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getWebServiceData];
    

    
    self.tabBarController.tabBar.hidden = YES;
    
    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
      isEnter = YES;
        
    }
    

    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,
                                                     self.view.frame.size.width,
                                                    self.view.frame.size.height)
                                                   style:UITableViewStylePlain];
    
    mainTableView.delegate = self;
    mainTableView.contentSize = CGSizeMake(self.view.frame.size.width, 540);
    mainTableView .dataSource = self;
    mainTableView.rowHeight = 130.0;
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
    

}

-(void)getWebServiceData
{
   
    
    

    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        Result* result = [[Member sharedMember] productCommentListWithOffset:self.offset limit:LIMIT];
        if (result.isSuccess) {
            self.evaluateArray = [NSMutableArray array];
            self.evaluateArray = (NSMutableArray*)result.data;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [mainTableView reloadData];
            
            
        });
        

        
        
        
    
    });
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 130.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return self.evaluateArray.count;
    
    
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
   
      
      static NSString* cellidenty = @"cellid";
    
    EvaluateCell* evaluateCell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (evaluateCell==nil) {
        
        
        evaluateCell = [[EvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:cellidenty];
        
        
      }
    
     evaluateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [evaluateCell setCellInformation:self.evaluateArray[indexPath.row]];
    
    
    return evaluateCell;
    
  
}
-(void)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    
    
    float height = mainTableView.rowHeight*self.evaluateArray.count;
    
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
        
        float height = mainTableView.rowHeight * [self.evaluateArray count];
        
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
          
            Result* result = [[Member sharedMember] productCommentListWithOffset:self.offset limit:LIMIT];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result.isSuccess)
                {
                    NSInteger index = self.evaluateArray.count;
                    NSArray* listArray = (NSArray*)result.data;
                    if (listArray.count!= 0)
                    {
                        
                        [mainTableView beginUpdates];
                        [self.evaluateArray addObjectsFromArray:listArray];
                        
                        
                    
                        for (ProductComment* list in result.data)
                        {
                            
                            NSIndexPath* path = [NSIndexPath indexPathForItem:index++ inSection:0];
                            
                            [mainTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                                 withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }
                        [mainTableView endUpdates];
                        
                    }else
                    {
                        
                        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"数据已经加载完成！"
                                                                           message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [alertView show];
                        
                    }
                    
                }
            });
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.isLoadingData = NO;
            
            CGSize size = mainTableView.contentSize;
            size.height = mainTableView.tableHeaderView.frame.size.height + mainTableView.rowHeight * [self.evaluateArray count];
            mainTableView.contentSize = size;
            mainTableView.tableFooterView.frame = CGRectMake(0.0,
                                                             mainTableView.rowHeight * [self.evaluateArray count],
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
