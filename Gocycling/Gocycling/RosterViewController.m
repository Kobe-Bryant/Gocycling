//
//  RosterViewController.m
//

//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "RosterViewController.h"
#import "Macros.h"
#import "RosterDetailViewController.h"
#import "Member.h"


@interface RosterViewController ()
{
   
    NSMutableArray* personArray;
    UITableView* mainTableView;
    BOOL isOpen;
    BOOL isEnter;

    
}
@end

@implementation RosterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        personArray = [NSMutableArray array];
        
}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //设置navigationItem的titleView
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = NSLocalizedString(@"我的名单", nil);
    self.navigationItem.titleView = lable;
    
    
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
    
    self.tabBarController.tabBar.hidden = YES;
    
     [mainTableView deselectRowAtIndexPath:
     [mainTableView indexPathForSelectedRow] animated:YES];
    
    [self getWebServiceData];
    
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
    mainTableView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                             (255.0, 255.0, 255.0).CGColor];
    mainTableView.sectionFooterHeight = 5.0;
    mainTableView.delegate = self;
    mainTableView .dataSource = self;
    [self.view addSubview:mainTableView];
    
}

#pragma mark UITableviewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    return 60.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    
    return personArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    static NSString *CellId = @"Cellid";

    UITableViewCell *cell = (UITableViewCell*)[tableView
                                      dequeueReusableCellWithIdentifier:CellId];

    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellId];
     
        
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake
                                                              (20, 25, 70, 20)];
        nameLabel.tag = 100;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (71.0, 71.0, 71.0).CGColor];
        [cell.contentView addSubview:nameLabel];
        
        
        UILabel* telephoneLable = [[UILabel alloc]initWithFrame:CGRectMake
                                                             (100, 30, 170, 10)];
        telephoneLable.tag = 101;
        telephoneLable.backgroundColor = [UIColor clearColor];
        telephoneLable.font = [UIFont systemFontOfSize:12];
        telephoneLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (195.0, 195.0, 195.0).CGColor];
        [cell.contentView addSubview:telephoneLable];
    }
    
    
    MemberContestant* memberList =personArray[indexPath.row];
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:100];
    UILabel* telephoneLabel = (UILabel*)[cell.contentView viewWithTag:101];

    
    nameLabel.text = memberList.name;
    telephoneLabel.text = memberList.mobile;
    UIImage* idicatorImage = [UIImage imageNamed:@"indicator.png"];
    UIImageView* idicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                       (245, 20,
                                                       idicatorImage.size.width,
                                                     idicatorImage.size.height)];
    idicatorImageView.image = idicatorImage;
    cell.accessoryView = idicatorImageView;
    
    return cell;
    
    
}

-(void)getWebServiceData
{
       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
      dispatch_async(queue, ^{
        
        
        Result* result = [[Member sharedMember] contestantList];
        
         dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result.isSuccess) {
                
                personArray = (NSMutableArray*)result.data;
                
                
                NSLog(@"%d",personArray.count);
                
                [mainTableView reloadData];
                
                
            }else {
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription]
                                                                   message:nil delegate:nil
                                                         cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
           }
            
            
        });
        
    });
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RosterDetailViewController* rosterDetail = [[RosterDetailViewController alloc]init];
    rosterDetail.hidesBottomBarWhenPushed = YES;
    rosterDetail.memberContestant = personArray[indexPath.row];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        rosterDetail.edgesForExtendedLayout = NO;
  
    }
    [self.navigationController pushViewController:rosterDetail animated:YES];
    
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
