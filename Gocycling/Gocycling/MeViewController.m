//
//  MeViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "MeViewController.h"
#import "PersonInfoViewController.h"
#import "PasswordViewController.h"
#import "EvaluateViewController.h"
#import "MyCollectViewController.h"
#import "EnrollViewController.h"
#import "RosterViewController.h"
#import "LoginViewController.h"
#import "Macros.h"

@interface MeViewController ()
{
   
    UIImageView* personImageView;
    UIImageView* passwordImageView;
    UIImageView* evaluateImageView;
    UIImageView* collectImageView;
    UIImageView* enrollImageView;
    UITableView* mainTableView;
    UIImageView* rosterImageView;
    BOOL islogin;
    UIButton* loginOutButton;
    

}
//创建表示图
-(void)createTableView;
@end

@implementation MeViewController

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
//    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    lable.textColor = [UIColor whiteColor];
//    lable.backgroundColor = [UIColor clearColor];
//    lable.textAlignment = NSTextAlignmentLeft;
//    lable.text = NSLocalizedString(@"我的", nil);
//    self.navigationItem.titleView = lable;
    self.title = @"我的";
    
    
    //设置登陆的状态
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"surelogin"];

    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(280, 0, 40, 30);
    [loginButton addTarget:self action:@selector(loginMethod)
          forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]
                                  initWithCustomView:loginButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createTableView];
    return;
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"]) {
    
    
        
        LoginViewController* loginVC = [[LoginViewController alloc]init];

        UINavigationController* na = [[UINavigationController alloc]
                                            initWithRootViewController:loginVC];
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            loginVC.edgesForExtendedLayout = NO;
        }
      [self presentViewController:na animated:YES completion:nil];
        
     } else {
    

         
 
         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] && [[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
             
             self.navigationItem.rightBarButtonItem = nil;
             
             
             loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
             loginOutButton.tag = 100;
             [loginOutButton setTitle:@"退出" forState:UIControlStateNormal];
             loginOutButton.frame = CGRectMake(260, 5, 40, 30);
             [loginOutButton addTarget:self action:@selector(loginOut)
                   forControlEvents: UIControlEventTouchUpInside];
             UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]
                                           initWithCustomView:loginOutButton];
             self.navigationItem.rightBarButtonItem = rightItem;
           [self createTableView];
        
             
  
         }else {
         
             UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
             [loginButton setTitle:@"登录" forState:UIControlStateNormal];
             loginButton.frame = CGRectMake(280, 0, 40, 30);
             [loginButton addTarget:self action:@selector(loginMethod)
                   forControlEvents: UIControlEventTouchUpInside];
             UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]
                                           initWithCustomView:loginButton];
             self.navigationItem.rightBarButtonItem = rightItem;
             [self createTableView];

        }
    }

}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    


}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];

 
}

#pragma mark UITableviewDatasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
                    (NSIndexPath *)indexPath
{
    return 80;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
                       (NSInteger)section
{
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
    
    static NSString* cellid = @"cellidenty";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell==nil)  {
  
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                        reuseIdentifier:cellid];
    }
 
    UIImageView* lineImageView;
    
    switch (indexPath.row) {
        
        case 0:
            
            lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 1)];
            [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                               UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
            [mainTableView addSubview:lineImageView];
            cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
            personImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
            personImageView.image = [UIImage imageNamed:@"one.png"];
            [cell.imageView addSubview:personImageView];
            cell.textLabel.text = @"个人信息";
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                        (27.0, 27.0, 27.0).CGColor];
            cell.detailTextLabel.text = @"可以更改和完善你的个人信息";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                              (104.0, 104.0, 104.0).CGColor];
            
       break;
       case 1:
     
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80*2, 320, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                 UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
    [mainTableView addSubview:lineImageView];
    cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
    passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    passwordImageView.image = [UIImage imageNamed:@"two.png"];
    [cell.imageView addSubview:passwordImageView];
    cell.textLabel.text = @"密码修改";
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                     (27.0, 27.0, 27.0).CGColor];
    cell.detailTextLabel.text = @"可以更安全的保护您的密码";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
      break;
      case 2:
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80*3, 320, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                  UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
    [mainTableView addSubview:lineImageView];
    cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
    evaluateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    evaluateImageView.image = [UIImage imageNamed:@"pinImage.png"];
    [cell.imageView addSubview:evaluateImageView];
    cell.textLabel.text = @"我的评论";
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (27.0, 27.0, 27.0).CGColor];
    cell.detailTextLabel.text = @"可以查找我的评论历史";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
      break;
      case 3:
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80*4, 320, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
    [mainTableView addSubview:lineImageView];
    cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
    collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    collectImageView.image = [UIImage imageNamed:@"four1.png"];
    [cell.imageView addSubview:collectImageView];
    cell.textLabel.text = @"我的收藏";
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (27.0, 27.0, 27.0).CGColor];
    cell.detailTextLabel.text = @"可以更便捷的找到我的喜好";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
      break;
      case 4:
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80*5, 320, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                  UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
    [mainTableView addSubview:lineImageView];
    cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
    enrollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    enrollImageView.image = [UIImage imageNamed:@"fiveimage.png"];
    [cell.imageView addSubview:enrollImageView];
    cell.textLabel.text = @"我的报名";
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (27.0, 27.0, 27.0).CGColor];
    cell.detailTextLabel.text = @"可以查看我的报名记录";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
      break;
      case 5:
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80*6, 320, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithCGColor:
                                 UIColorFromRGB(238.0, 231.0, 231.0).CGColor]];
    [mainTableView addSubview:lineImageView];
    cell.imageView.image = [UIImage imageNamed:@"cicle.png"];
    rosterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    rosterImageView.image = [UIImage imageNamed:@"siximage.png"];
    [cell.imageView addSubview:rosterImageView];
    cell.textLabel.text = @"我的名单";
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (27.0, 27.0, 27.0).CGColor];
    cell.detailTextLabel.text = @"可以快速填写报名信息";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                      (104.0, 104.0, 104.0).CGColor];
      break;
      default:
      break;
    }
    
    UIImage* idicatorImage = [UIImage imageNamed:@"indicator.png"];
    
    UIImageView* idicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                (245, 20, idicatorImage.size.width, idicatorImage.size.height)];
    
    idicatorImageView.image = idicatorImage;
    cell.accessoryView = idicatorImageView;
    
    UIImageView* imageViewTwo = [[UIImageView alloc]initWithFrame:
                               CGRectMake(0, 0, 320, 40)];
    imageViewTwo.image = [UIImage imageNamed:@"cellselect.png"];
    cell.selectedBackgroundView = imageViewTwo;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
                 (NSIndexPath *)indexPath
{
    
    

    
    switch (indexPath.row) {
        case 0: {
            
           personImageView.image = [UIImage imageNamed:@"personhighImage.png"];
           PersonInfoViewController* infoController = [[PersonInfoViewController alloc] init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                infoController.edgesForExtendedLayout = NO;
            }
           infoController.hidesBottomBarWhenPushed = YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
                
                [self.navigationController pushViewController:infoController animated:YES];
            }
            else {
            
                [self loginMethod];
            }
            break;
            
        }
        case 1: {
            passwordImageView.image = [UIImage imageNamed:@"passwordhighImage.png"];
            PasswordViewController* passwordController = [[PasswordViewController alloc]init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                passwordController.edgesForExtendedLayout = NO;
                
            }
            passwordController.hidesBottomBarWhenPushed = YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
                
                [self.navigationController pushViewController:passwordController animated:YES];
            }
            else {
                
                [self loginMethod];
            }

            break;
        }
        case 2: {
            evaluateImageView.image = [UIImage imageNamed:@"pinlunhighImage.png"];
            EvaluateViewController* evaluateController = [[EvaluateViewController alloc]init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                evaluateController.edgesForExtendedLayout = NO;
                
            }
            evaluateController.hidesBottomBarWhenPushed  = YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
                
                [self.navigationController pushViewController:evaluateController animated:YES];
            }
            else {
                
                [self loginMethod];
            }
            
            break;
        }
        case 3: {
            
            collectImageView.image = [UIImage imageNamed:@"savehighImage.png"];
            MyCollectViewController* myCollectController = [[MyCollectViewController alloc]init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                myCollectController.edgesForExtendedLayout = NO;
                
            }
            myCollectController.hidesBottomBarWhenPushed  = YES;
//            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
            
                [self.navigationController pushViewController:myCollectController animated:YES];
//            }
//            else {
//                
//                [self loginMethod];
//            }
            
            break;
        }
        case 4: {
            enrollImageView.image = [UIImage imageNamed:@"enrollhighImage.png"];
            EnrollViewController* enrollController = [[EnrollViewController alloc]init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                enrollController.edgesForExtendedLayout = NO;
                
            }
            enrollController.hidesBottomBarWhenPushed  = YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
                
                [self.navigationController pushViewController:enrollController animated:YES];
            }
            else {
                
                [self loginMethod];
            }
            
            break;
        }
            
        case 5: {
            rosterImageView.image = [UIImage imageNamed:@"rosterhighImage.png"];
            RosterViewController* rosterController = [[RosterViewController alloc]init];
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                rosterController.edgesForExtendedLayout = NO;
                
            }
            rosterController.hidesBottomBarWhenPushed  = YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"surelogin"]) {
                
                [self.navigationController pushViewController:rosterController animated:YES];
            }
            else {
                
                [self loginMethod];
            }
            break;
            
        }
      default:
        break;
    }
    
}

//创建表示图
-(void)createTableView
{

    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,
                                                                 0.0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height)
                                                   style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    self.tabBarController.tabBar.hidden = NO;
    
    personImageView.image = [UIImage imageNamed:@"one.png"];
    
    passwordImageView.image = [UIImage imageNamed:@"two.png"];
    
    evaluateImageView.image = [UIImage imageNamed:@"pinImage.png"];
    
    collectImageView.image = [UIImage imageNamed:@"four1.png"];
    
    enrollImageView.image = [UIImage imageNamed:@"fiveimage.png"];
    
    rosterImageView.image = [UIImage imageNamed:@"siximage.png"];


}


-(void)loginMethod
{

    LoginViewController* loginVC = [[LoginViewController alloc]init];
    
    UINavigationController* na = [[UINavigationController alloc]
                                  initWithRootViewController:loginVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        loginVC.edgesForExtendedLayout = NO;
    }
    [self presentViewController:na animated:YES completion:nil];

}
-(void)loginOut
{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"surelogin"];
     LoginViewController* loginVC = [[LoginViewController alloc]init];
    UINavigationController* na = [[UINavigationController alloc]
                                  initWithRootViewController:loginVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        loginVC.edgesForExtendedLayout = NO;
    }
    [self presentViewController:na animated:YES completion:nil];
  
}
-(void)Popupdialog
{
    
  
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"你还没有登陆？"
                          message:nil delegate:self cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
