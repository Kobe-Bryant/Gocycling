//
//  EnrollViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "EnrollViewController.h"
#import "EnrollCell.h"
#import "Macros.h"
#import "EnlistDetailViewController.h"
#import "Member.h"
#import "Order.h"

#define kpageSize 5
#define LIMIT 25

@interface EnrollViewController ()
{
    UITableView* mainTableView;
    NSMutableArray* dataArray;
    EnlistDetailViewController* enlistDetailVC;
    BOOL isEnter;
    
}
@property(nonatomic,assign) int offset;
@property(nonatomic,strong) NSMutableArray* orderIdArray;


@end

@implementation EnrollViewController

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

    
    
    self.view.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                 (235.0, 239.0, 241.0).CGColor];

    
    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"我的报名", nil);
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
    
     self.orderIdArray = [NSMutableArray array];
    

    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self getWebServiceData];
    
     [mainTableView deselectRowAtIndexPath:
     [mainTableView indexPathForSelectedRow] animated:YES];
    
    self.tabBarController.tabBar.hidden = YES;

    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
        isEnter = YES;
    }

    
   
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 7,
                                                self.view.frame.size.width-2*5,
                                                    self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                        (235.0, 239.0, 241.0).CGColor];
    mainTableView.delegate = self;
    mainTableView .dataSource = self;
    [self.view addSubview:mainTableView];
    
    

}

-(void)getWebServiceData
{

    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        Result* result = [[Member sharedMember] orderListWithOffset:self.offset limit:LIMIT];
        
        
        
            if (result.isSuccess) {
                
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    dataArray = [NSMutableArray array];

                    dataArray = (NSMutableArray*)result.data;

                    
                
                for (Order* list in dataArray)
                    
                    {
                  
                        [self.orderIdArray addObject:[NSNumber numberWithInt:list.orderID]];

        
                  }
                    
                    [mainTableView reloadData];
                    
                    
                  });
                
            }else {
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription]
                                                                   message:nil delegate:nil
                                                        cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
               [alertView show];
            }
            
            
      
        
    });
    




}
#pragma mark UITableViewDatasoure

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    cell.contentView.backgroundColor = [UIColor whiteColor];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 5.0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 7)];
    footView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                (235.0, 239.0, 241.0).CGColor];

    return footView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return dataArray.count;
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
                    (NSIndexPath *)indexPath
{
    
    return 160.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
                         (NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
    
    
    static NSString* cellidenty = @"cellid";
    
    EnrollCell* enrollCell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (enrollCell==nil) {
        
        
     enrollCell = [[EnrollCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellidenty];
        
    }
    
    
    [enrollCell setcellInfo:dataArray[indexPath.section]];
    
    return enrollCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        enlistDetailVC = [[EnlistDetailViewController alloc]init];
    
     enlistDetailVC.orderCompetionId = [self.orderIdArray[indexPath.section] intValue];
    
    NSLog(@"%d",enlistDetailVC.orderCompetionId);

      if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                enlistDetailVC.edgesForExtendedLayout = NO;
            }
        [self.navigationController pushViewController:enlistDetailVC animated:YES];
            
    }


-(void)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
