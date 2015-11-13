//
//  ConfirmViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "ConfirmViewController.h"
#import "Macros.h"
#import "PersonInfoCell.h"
#import "ApplyViewController.h"
#import "SuccessViewController.h"
#import "Member.h"
#import "Order.h"
#import "ApplyViewController.h"


@interface ConfirmViewController ()
{
    UITableView* mainTableView;
    Order* list;
    BOOL isEnter;
    
}
@property(nonatomic,strong) NSMutableArray* personArray;

//创建tableview的头部视图和底部视图
-(void)createTableViewHeadViewAndFooterView;
@end

@implementation ConfirmViewController

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
    
    
    self.personArray = [NSMutableArray array];
    

    NSLog(@"%d",self.selectCount);
    
    
    NSLog(@"%@",self.personInfomationDic);

   
    NSLog(@"%d",self.personInfomationDic.count);

    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"名单确认", nil);
    self.navigationItem.titleView = label;
    
    
    
    //返回的leftBarButtonItem
    UIImage* backImage = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,backImage.size.width, backImage.size.height);
    [bt setImage:backImage forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
    
    //获取网络数据方法
    [self getWebserviceData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }
    
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,
                self.view.frame.size.width, self.view.frame.size.height)
                                            style:UITableViewStyleGrouped];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    //创建tableview的头部视图和底部视图
    [self createTableViewHeadViewAndFooterView];
    
}

//创建tableview的头部视图和底部视图
-(void)createTableViewHeadViewAndFooterView
{
    
    //tableView的tableHeaderView
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                               self.view.frame.size.width, 72)];
    
    headView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (235.0, 239.0, 241.0).CGColor];
    
    UIImage* titleimage = [UIImage imageNamed:@"confirm.png"];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20,
                                                          titleimage.size.width,
                                                       titleimage.size.height)];
    
    imageView.image = titleimage;
    [headView addSubview:imageView];
    mainTableView.tableHeaderView = headView;
    [self.view addSubview:mainTableView];
    
    
    //tableView的tableFooterView
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                              self.view.frame.size.width, 200)];
    
    footerView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (255.0, 255.0, 255.0).CGColor];
    
    mainTableView.tableFooterView = footerView;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (233.0, 66.0, 75.0).CGColor];
    label.text = [NSString stringWithFormat:@"您的报名费用合计 : %d",800];
    [footerView addSubview:label];
    
    
    UIImage* submitImage = [UIImage imageNamed:@"submitName-.png"];
    UIImage* continueImage = [UIImage imageNamed:@"continueEnroll-.png"];

    UIImageView* continueImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                       (10.0,40,
                                                       continueImage.size.width,
                                                    continueImage.size.height)];
    continueImageView.image = continueImage;
    continueImageView.userInteractionEnabled = YES;
    
    
    UIImageView* submitImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                    (165.0,40,
                                                         submitImage.size.width,
                                                       submitImage.size.height)];
    submitImageView.image = submitImage;
    submitImageView.userInteractionEnabled = YES;
    [footerView addSubview:submitImageView];
    [footerView addSubview:continueImageView];


 
    //为提交名单和继续报名添加手势方法
    UITapGestureRecognizer* submitRollTap = [[UITapGestureRecognizer alloc]initWithTarget:
                                            self action:@selector(submitRoll:)];
    [submitImageView addGestureRecognizer:submitRollTap];
    UITapGestureRecognizer* continueTap = [[UITapGestureRecognizer alloc]initWithTarget:
                                             self action:@selector(continueTap:)];
    [continueImageView addGestureRecognizer:continueTap];
    
    
    [self.view addSubview:mainTableView];
    
    
}
//获取网络数据方法
-(void)getWebserviceData
{
   
}
#pragma mark UITableviewDatasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
                     (NSIndexPath *)indexPath
{
    
    NSString* key = [NSString stringWithFormat:@"key%d",indexPath.section];
    
    NSDictionary* bigdic = [self.personInfomationDic objectForKey:key];

    NSArray* array = [bigdic objectForKey:@"eventName"];

    
    if (indexPath.row == 3) {
        
      
       return 50.0*array.count/2;
        
        
    }
    
    
    
    return 50.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
       UIImageView* headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 72,
                                               self.view.frame.size.width, 25)];
        
        headView.image = [UIImage imageNamed:@"headbackView-.png"];

        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            headView.image = [UIImage imageNamed:@"sectiontitleview.png"];
      
        }

        headView.userInteractionEnabled = YES;
        
        UILabel* applyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 100, 17)];
        applyLabel.backgroundColor = [UIColor clearColor];
        applyLabel.font = [UIFont systemFontOfSize:12];
        
        applyLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (49.0, 49.0, 49.0).CGColor];
        
        applyLabel.text = [NSString stringWithFormat:@"报名人员0%d",section+1];
        [headView addSubview:applyLabel];
        
        
        UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [deleteButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                  (104.0, 104.0, 104.0).CGColor] forState:UIControlStateNormal];
        
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        deleteButton.frame = CGRectMake(260, 8, 50, 10);
        
        [deleteButton addTarget:self action:@selector(deleteCell:)
                                  forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:deleteButton];
      
        
    
        return headView;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 25.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.personInfomationDic.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    
    return 5;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PersonInfoCell* cell = [[PersonInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil count:self.selectCount indexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //为cell复值
    

    
    
    NSLog(@"self.personInfomationDic.count =  %d",self.personInfomationDic.count);
    
    
    NSLog(@"self.personInfomationDic =  %@",self.personInfomationDic);
    
    
    
    [cell setCellData:self.personInfomationDic indexPath:indexPath selectCount:self.selectCount];
    
    return cell;
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        
    }else  {
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 320,
                                            mainTableView.frame.size.height)];
        view.backgroundColor = [UIColor whiteColor];
        
        mainTableView.backgroundView = view;
        
        cell.backgroundView = nil;
        
        UIView* linebackView = [[UIView alloc]initWithFrame:CGRectMake(3,
                                        cell.contentView.frame.size.height-1,
                                           self.view.frame.size.width-20,0.5)];
        
        linebackView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                        (191.0, 191.0, 191.0).CGColor];
        
        [cell addSubview:linebackView];
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
                  (NSIndexPath *)indexPath
{
    
 
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
            editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                      forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)  {
        
        
        
    }
    
    
}

//返回按钮
-(void)backButtonMethod
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setTableViewBackGround" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)submitRoll:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"%@",self.personInfomationDic);
    

    
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < self.personInfomationDic.count; i++) {
        
        NSString* key = [NSString stringWithFormat:@"key%d",i];
        
        NSMutableDictionary* dic = [self.personInfomationDic objectForKey:key];
        
        [dic removeObjectForKey:@"eventName"];
        
        [dic setObject:[[NSNumber numberWithInt:-1]stringValue] forKey:@"memberContestantId"];
        
        NSString* sex = [dic objectForKey:@"gender"];
        
        if ([sex isEqualToString:@"男"]) {
            
            [dic setObject:[[NSNumber numberWithInt:0] stringValue]forKey:@"gender"];
        }else {
        
            [dic setObject:[[NSNumber numberWithInt:1] stringValue]forKey:@"gender"];

        
        }
        
        NSString* type = [dic objectForKey:@"credentialType"];
        
        if ([type isEqualToString:@"身份证"]) {
            
            [dic setObject:@"ID" forKey:@"credentialType"];
        }else {
            
            [dic setObject:@"PASSPORT" forKey:@"credentialType"];
            
            
        }
        
        [array addObject:dic];
        
    }
     
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString %@",jsonString);
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
       


        Result* result = [[Member sharedMember] createOrderWithActivityID:self.activityID contestantJSONString:jsonString ];
                          
        
           
        if (result.isSuccess) {
            
            
         list = (Order*)result.data;
            
            NSLog(@"%f",list.totalPrice);
            NSLog(@"%d",list.orderID);
            NSLog(@"%@",list.orderSn);
        
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            
            
            //报名成功的视图控制器
            SuccessViewController* successVC = [[SuccessViewController alloc]init];
            successVC.submitList = list;
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                successVC.edgesForExtendedLayout = NO;
            }
   
            [self.navigationController pushViewController:successVC animated:YES];
            self.personInfomationDic = [NSMutableDictionary dictionary];
            [mainTableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clearApplyViewControllerDic" object:nil];
            
            
            
        });
        
});
    

    
}
-(void)continueTap:(UITapGestureRecognizer*)tap
{

  [self.toogleClickDelegate toggleClickBackButton:self];
}

//删除按钮
-(void)deleteCell:(UITapGestureRecognizer*)tap
{

    
    if ([mainTableView isEditing]) {
        
       
        [mainTableView setEditing:NO animated:YES];
        
        
    }else {
    
        [mainTableView setEditing:YES animated:YES];
        
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
