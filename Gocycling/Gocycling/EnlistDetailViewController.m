//
//  EnlistDetailViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-31.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "EnlistDetailViewController.h"
#import "Macros.h"
#import "EnrollDetailCell.h"
#import "Order.h"
#import "Member.h"

@interface EnlistDetailViewController ()
{

    UIView* lineView ;
    UIButton*   deleteButton;
    UITableView* mainTableView;
    NSMutableArray* dataArray;
    NSMutableArray* personArray;
    BOOL isEnter;
    Order* orderDetail;
    UILabel*  enrollcountLableText;
    UILabel* titleLabel ;
    UILabel* enrollLabel;
    UILabel* enrollLableText;
    UILabel* stausLableText ;
    UILabel*  enrollTimeLableText;
    UILabel*  totalPriceLableText;
    UILabel* goPayLabel;
    UIImageView* paymomenyImageview;
    

}

@end

@implementation EnlistDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
  
           self.navigationItem.hidesBackButton=YES;
  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB(255.0, 255.0, 255.0).CGColor];
    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"报名详情", nil);
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
    
    
    //navigationBar上的两个子视图 lineView | deleteButton
 
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(250, 13, 1, 18)];

        
        
    }else {
     
        lineView = [[UIView alloc]initWithFrame:CGRectMake(263, 14, 1, 18)];

    }
    
    lineView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                (137.0, 181.0, 255.0).CGColor];
    [self.navigationController.navigationBar addSubview:lineView];
    
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(270, 8, 40, 30);
    [deleteButton setTitle:@"取消" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                  (255.0, 255.0, 255.0).CGColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(cancelButtonMethod:)
                                  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:deleteButton];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //获取数据
    [self getWebserviceData];
    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
        isEnter = YES;
    }
    
   
    
    dataArray = [NSMutableArray array];
    

    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                self.view.frame.size.width, 150)];
    headView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (235.0, 239.0, 241.0).CGColor];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStyleGrouped];
    
    mainTableView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB(255.0, 255.0, 255.0).CGColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    
 
    
    //headView上的子视图 titleLabel | enrollLabel | stausLabel |
      //                    totalPriceLabel | enrollTimeLabel | enrollcountLabel
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 250, 50)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (49.0, 49.0, 49.0).CGColor];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 2;
    [headView addSubview:titleLabel];
    
    
    enrollLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 83, 67, 12)];
    enrollLabel.backgroundColor = [UIColor clearColor];
    UILabel* stausLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 83, 56, 12)];
    stausLabel.backgroundColor = [UIColor clearColor];
    UILabel* totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 103, 67, 12)];
    totalPriceLabel.backgroundColor = [UIColor clearColor];
    UILabel* enrollTimeLabel = [[UILabel alloc]initWithFrame: CGRectMake(165, 105, 56, 12)];
    enrollTimeLabel.backgroundColor = [UIColor clearColor];
    
    UILabel* enrollcountLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 123, 67, 12)];
    enrollcountLabel.backgroundColor = [UIColor clearColor];

    
    
    enrollLabel.text =     @"报名编号 :";
    totalPriceLabel.text = @"总      价  :";
    enrollcountLabel.text =@"报名人数 :";

    enrollLabel.font = [UIFont systemFontOfSize:12];
    
    enrollLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (98.0, 98.0, 98.0).CGColor];
    totalPriceLabel.font = [UIFont systemFontOfSize:12];
    totalPriceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (98.0, 98.0, 98.0).CGColor];
    enrollcountLabel.font = [UIFont systemFontOfSize:12];
    enrollcountLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (98.0, 98.0, 98.0).CGColor];
    
    stausLabel.text = @"状      态  :";
    stausLabel.font = [UIFont systemFontOfSize:12];
    stausLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (98.0, 98.0, 98.0).CGColor];
    enrollTimeLabel.text = @"报名时间 :";
    enrollTimeLabel.font = [UIFont systemFontOfSize:12];
    enrollTimeLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (98.0, 98.0, 98.0).CGColor];
    
    enrollLableText = [[UILabel alloc]initWithFrame:CGRectMake(85, 83, 100, 12)];
    enrollLableText.backgroundColor = [UIColor clearColor];
    enrollLableText.font = [UIFont systemFontOfSize:12];
    enrollLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (230.0, 0, 18.0).CGColor];
    [headView addSubview:enrollLableText];
    
    
    stausLableText = [[UILabel alloc]initWithFrame:CGRectMake(226, 83, 65, 12)];
    stausLableText.font = [UIFont systemFontOfSize:12];
    stausLableText.backgroundColor = [UIColor clearColor];
    stausLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                     (230.0, 0, 18.0).CGColor];
    [headView addSubview:stausLableText];
    
    
    totalPriceLableText = [[UILabel alloc]initWithFrame:CGRectMake(85, 103, 60, 12)];
    totalPriceLableText.font = [UIFont systemFontOfSize:12];
    totalPriceLableText.backgroundColor = [UIColor clearColor];
    totalPriceLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                      (230.0, 0, 18.0).CGColor];
    [headView addSubview:totalPriceLableText];
    
    enrollTimeLableText = [[UILabel alloc]initWithFrame:CGRectMake(226,105 , 100, 12)];
    enrollTimeLableText.font = [UIFont systemFontOfSize:12];
    enrollTimeLableText.backgroundColor = [UIColor clearColor];
    enrollTimeLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (98.0, 98.0, 98.0).CGColor];
   [headView addSubview:enrollTimeLableText];
    
    enrollcountLableText = [[UILabel alloc]initWithFrame:CGRectMake(85, 123, 60, 12)];
    enrollcountLableText.font = [UIFont systemFontOfSize:12];
    enrollcountLableText.backgroundColor = [UIColor clearColor];
    enrollcountLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                      (230.0, 0, 18.0).CGColor];
    
    [headView addSubview:enrollcountLableText];
    [headView addSubview:enrollLabel];
    [headView addSubview:stausLabel];
    [headView addSubview:totalPriceLabel];
    [headView addSubview:enrollTimeLabel];
    [headView addSubview:enrollcountLabel];

    mainTableView.tableHeaderView = headView;
    
  
    
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                              self.view.frame.size.width, 100)];
    footerView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (255.0, 255.0, 255.0).CGColor];
    mainTableView.tableFooterView = footerView;
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (233.0, 66.0, 75.0).CGColor];
    lable.text = [NSString stringWithFormat:@"您的报名费用合计 : %d",400];
    [footerView addSubview:lable];
    
    UIImage* paymomenyImage = [UIImage imageNamed:@"paymomeny.png"];
    
   paymomenyImageview = [[UIImageView alloc]initWithFrame:
                                       CGRectMake(10, 35,
                                                  paymomenyImage.size.width,
                                                  paymomenyImage.size.height)];
    paymomenyImageview.userInteractionEnabled = YES;
    paymomenyImageview.image = paymomenyImage;
    
    
    UITapGestureRecognizer* paymomenyGesture = [[UITapGestureRecognizer alloc]
                            initWithTarget:self action:@selector(payMonenyMethod:)];
    
    [paymomenyImageview addGestureRecognizer:paymomenyGesture];
    
    
    
    
    [footerView addSubview:paymomenyImageview];
    
    goPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(
                        (paymomenyImage.size.width-80)/2.0+20, 7, 80, 25)];
    goPayLabel.textColor = [UIColor whiteColor];
    goPayLabel.text = @"去付款";
    [paymomenyImageview addSubview:goPayLabel];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    lineView.hidden = YES;
    deleteButton.hidden = YES;
    
}

-(void)getWebserviceData
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        Result* result = [[Member sharedMember] orderByOrderID:self.orderCompetionId];
        
        
        
        
        if (result.isSuccess) {

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                orderDetail = (Order*)result.data;
   
                titleLabel.text = orderDetail.activityTitle;
                enrollLableText.text = orderDetail.orderNumber;
                stausLableText.text = orderDetail.status;
                if ([orderDetail.status isEqualToString:@"已取消"]) {
                    
                    paymomenyImageview.hidden = YES;
                    deleteButton.userInteractionEnabled = NO;
                    
                }
                totalPriceLableText.text = [NSString stringWithFormat:@"%0.f",orderDetail.headPrice];
                enrollcountLableText.text = [NSString stringWithFormat:@"%d人",orderDetail.competitionQuantity];
                enrollTimeLableText.text = orderDetail.singupTime;
                
                [mainTableView reloadData];
                
        });
            
    }

        
        
    });

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        
        
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
       
            return 0.1;

        }else
        {
        
            return 0.0;

        
        }
        
        

    }
    return 0.0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView* headView;
    
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [deleteButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                  (104.0, 104.0, 104.0).CGColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];

    
    

        
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 72,
                                                self.view.frame.size.width, 25)];
        
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
     
            headView.image = [UIImage imageNamed:@"sectionheadImage.png"];
            deleteButton.frame = CGRectMake(260, 8, 50, 10);

            
        }else {
        
            headView.image = [UIImage imageNamed:@"sectionheadImage.png"];
            deleteButton.frame = CGRectMake(263, 8, 50, 10);

        }

        UILabel* sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 100, 17)];
        headView.userInteractionEnabled = YES;
        sectionTitleLabel.font = [UIFont systemFontOfSize:12];
        sectionTitleLabel.backgroundColor = [UIColor clearColor];
        sectionTitleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (49.0, 49.0, 49.0).CGColor];
        sectionTitleLabel.text = [NSString stringWithFormat:@"报名人员0%d",section+1];
        [headView addSubview:sectionTitleLabel];
       // [headView addSubview:deleteButton];
        
   
    
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                             self.view.frame.size.width, 0.0)];
    return footerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        
//        
//        
//    }else  {
//    
//        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,
//                                              mainTableView.frame.size.height)];
//        view.backgroundColor = [UIColor whiteColor];
//        
//        mainTableView.backgroundView = view;
//        
//        cell.backgroundView = nil;
//        
//        UIView* linebackView = [[UIView alloc]initWithFrame:CGRectMake(3,
//                                            cell.contentView.frame.size.height,
//                                              self.view.frame.size.width-20,0.5)];
//        
//        linebackView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
//                                                 (191.0, 191.0, 191.0).CGColor];
//        
//        [cell.contentView addSubview:linebackView];
//        
//    }
//    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return orderDetail.competionArray.count;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
    
    
    
    EnrollDetailCell* cell = [[EnrollDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
   //为cell复值

    [cell setCellData:orderDetail.competionArray[indexPath.section] indexPath:indexPath selectCount:1];
    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}


-(void)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)cancelButtonMethod:(UIButton*)bt
{
    
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"是否确定取消订单？"
                                                       message:nil delegate:self
                                             cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    
    
 
    
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self cancelEnrollDetail];
        goPayLabel.hidden = YES;
        paymomenyImageview.hidden = YES;
    }
    
}

-(void)cancelEnrollDetail
{

    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        
        
        NSString* password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        
        NSLog(@"username =  %@",username);
        
        NSLog(@"password =  %@",password);
        
        
        
        Result* result = [[Member sharedMember] cancelOrder:self.orderCompetionId];
        
        NSLog(@"result.isSuccess =  %d",result.isSuccess);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
    
            [self getWebserviceData];

        });
        
});

}


-(void)payMonenyMethod:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"payMonenyMethod");
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
