//
//  LoginViewController.m
//  ddddd
//
//  Created by Apple on 14-3-31.
//  Copyright (c) 2014年 doocom. All rights reserved.
//

#import "LoginViewController.h"
#import "Macros.h"
#import "ReginViewController.h"
#import "Result.h"
#import "Member.h"

@interface LoginViewController ()
{
    
    UIScrollView* mainScrollView ;
    BOOL isEnter;
    UITextField* mobileField;
    UITextField* passwordField;
    UITapGestureRecognizer* viewGesture;
    
}
@end

@implementation LoginViewController

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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    //返回的leftBarButtonItem
    UIImage* reginbackImage = [UIImage imageNamed:@"loginbackImage.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, reginbackImage.size.width,
                                           reginbackImage.size.height);
    [backButton setImage:reginbackImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backMethod:) forControlEvents:
                                                   UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:
                                                                   backButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        //设置navigationBar的背景图片
        [self.navigationController.navigationBar setBackgroundImage:
         [UIImage imageNamed:@"navigaback-.png"] forBarMetrics:UIBarMetricsDefault];
    }else  {
        
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigationbar_"];
        [self.navigationController.navigationBar setBackgroundImage:barImage
                                            forBarMetrics:UIBarMetricsDefault];
        
    }
 
    viewGesture = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(closekeyBoard:)];
    [self.view addGestureRecognizer:viewGesture];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    
    
    self.tabBarController.tabBar.hidden = YES;

  
    if (isEnter) {
        
        NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        NSString* password =  [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        
        if (username && password) {
            
            
            mobileField.text = username;
            passwordField.text = password;
            
            
        }
        
        
        return ;
        
        
    }else
    {
    
        isEnter = YES;
        
    }
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                   (0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 560);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.delegate = self;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrollView];
    
    
    
    UIButton* reginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reginButton.frame = CGRectMake(160.0, 17, 170, 14);
    [reginButton setTitle:@"您需要注册吗 ?" forState:UIControlStateNormal];
    [reginButton addTarget:self action:@selector(reginMethod) forControlEvents:
                                                   UIControlEventTouchUpInside];
    [reginButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                     (67.0, 67.0, 67.0).CGColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:reginButton];
    

    
    UIImage* barLineImage = [UIImage imageNamed:@"_barline-.png"];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                320, barLineImage.size.height)];
    imageView.image = barLineImage;
    [self.view addSubview:imageView];
    
    
    UIImage* mobileImage = [UIImage imageNamed:@"mobile-.png"];
    UIImageView* mobileImageView = [[UIImageView alloc]initWithFrame:
             CGRectMake((self.view.frame.size.width-mobileImage.size.width)/2.0,
                                                                             20,
                                                         mobileImage.size.width,
                                                      mobileImage.size.height)];
    mobileImageView.image = mobileImage;
    mobileImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:mobileImageView];
    
    
    mobileField = [[UITextField alloc]initWithFrame:CGRectMake
                                                              (20, 5, 160, 30)];
    mobileField.userInteractionEnabled = YES;
    mobileField.tag = 1;
    mobileField.delegate = self;
    mobileField.placeholder = @"输入您的手机/邮箱";
    mobileField.font = [UIFont systemFontOfSize:15];
    [mobileField setBorderStyle:UITextBorderStyleNone];
    [mobileImageView addSubview:mobileField];
    
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"passwordImage-.png"];
    UIImageView* passwordImageView = [[UIImageView alloc]initWithFrame:
          CGRectMake((self.view.frame.size.width-passwordImage.size.width)/2.0,
                                                25+passwordImage.size.height+5,
                                                      passwordImage.size.width,
                                                    passwordImage.size.height)];
    passwordImageView.image = passwordImage;
    passwordImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:passwordImageView];
    
    
    
    passwordField = [[UITextField alloc]initWithFrame:
                                                    CGRectMake(20, 5, 160, 30)];
    passwordField.userInteractionEnabled = YES;
    passwordField.tag = 2;
    passwordField.delegate = self;
    passwordField.font = [UIFont systemFontOfSize:15];
    passwordField.placeholder = @"输入您的密码";
    [passwordField setBorderStyle:UITextBorderStyleNone];
    passwordField.secureTextEntry = YES;
    [passwordImageView addSubview:passwordField];
    
    
    UIImage* loginImage = [UIImage imageNamed:@"login-.png"];
    UIImageView*  loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                    (10.0,130.0,
                                                          loginImage.size.width,
                                                       loginImage.size.height)];
    loginImageView.image = loginImage;
    loginImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* loginTap = [[UITapGestureRecognizer alloc]
                            initWithTarget:self action:@selector(loginMethod:)];
    [loginImageView addGestureRecognizer:loginTap];
    [mainScrollView addSubview:loginImageView];
    
    
    
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB(67.0, 67.0, 67.0).CGColor]
                                                 forState:UIControlStateNormal];
    [bt setTitle:@"忘记密码 ? " forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(forgetPasswordMethod:) forControlEvents:UIControlEventTouchUpInside];
    bt.frame = CGRectMake(110.0, 185, 120, 12);
    [mainScrollView addSubview:bt];
    
    
    UIImage* boardImage = [UIImage imageNamed:@"border-.png"];
    
    UIImageView* boardImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                   (10.0,373.5,
                                                         boardImage.size.width,
                                                      boardImage.size.height)];
    
    
    boardImageView.image = boardImage;
    boardImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:boardImageView];
    
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 110, 60)];
    label.textColor = [UIColor colorWithCGColor:UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"使用合作网站帐号登录";
    [boardImageView addSubview:label];
    

    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(144,20,1,153/2.0)];
    
    lineView.backgroundColor = [UIColor colorWithCGColor:
                                    UIColorFromRGB(191.0, 191.0, 191.0).CGColor];
    
    
    [lineView.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithCGColor:
                                 UIColorFromRGB(191.0, 191.0, 191.0).CGColor])];
    
    [lineView.layer setBorderWidth:1.0];
    
    [boardImageView addSubview:lineView];

    
    UIImage* sinaImage = [UIImage imageNamed:@"sina-.png"];
    UIImageView* sinaImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                      (163, 22,
                                                          sinaImage.size.width,
                                                        sinaImage.size.height)];
    sinaImageView.image = sinaImage;
    sinaImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* sinaLoginTapGesture = [[UITapGestureRecognizer alloc]
                        initWithTarget:self action:@selector(sinaLoginMethod:)];
    [sinaImageView addGestureRecognizer:sinaLoginTapGesture];
    [boardImageView addSubview:sinaImageView];
    
    
    
    UIImage* qqImage = [UIImage imageNamed:@"qq-.png"];
    UIImageView* qqImageView = [[UIImageView alloc]initWithFrame:CGRectMake(234,
                                                          22,qqImage.size.width,
                                                          qqImage.size.height)];
    qqImageView.image = qqImage;
    qqImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* qqLoginTap = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(qqLoginMethod:)];
    [qqImageView addGestureRecognizer:qqLoginTap];
    [boardImageView addSubview:qqImageView];
    
    
    
    NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString* password =  [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    

    NSLog(@"%@",username);
    NSLog(@"%@",password);

    
    
    if (username && password) {
        
        
        
        mobileField.text = username;
        passwordField.text = password;
        
        
    }
    
    
    
    
    
    
}

//注册方法
-(void)reginMethod
{

    
    ReginViewController* reginVC = [[ReginViewController alloc]init];
    UINavigationController* na = [[UINavigationController alloc]
                                            initWithRootViewController:reginVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        reginVC.edgesForExtendedLayout = NO;
    }
    reginVC.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:na animated:YES completion:nil];
    
}

-(void)backMethod:(UIButton*)bt
{

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
-(void)forgetPasswordMethod:(UIButton*)bt
{

    NSLog(@"forgetPasswordMethod ");
}

-(void)loginMethod:(UITapGestureRecognizer*)tap
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [Member loginWithLoginUsername:mobileField.text
                                          loginPassword:passwordField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"surelogin"];
                [[NSUserDefaults standardUserDefaults] setObject:mobileField.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:result.error.localizedDescription
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
    });
}

-(void)refreshImage:(UITapGestureRecognizer*)tap
{


    NSLog(@"refresh");
    
}

-(void)sinaLoginMethod:(UITapGestureRecognizer*)tap
{

    NSLog(@"sina login");
    
}

-(void)qqLoginMethod:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"qqLoginMethod");
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"textFieldShouldBeginEditing %@", textField);
    
    if (textField.tag ==1) {
        
        
        
    }
    if (textField.tag == 2) {
        
        mainScrollView.contentOffset = CGPointMake(0, 18);
        
        
    }
    if (textField.tag == 3) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 36);
        
    }
    
    return YES;
}
/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   // mobileField passwordField captchField
    //手机号以13 17 15 18开头，八个 \d 数字字符
    NSString *loginIphone =  @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|17[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",loginIphone];
    
    NSString *loginEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginEmail];
    
    
       if (![phoneTest evaluateWithObject:mobileField.text] &&
                            ![emailTest evaluateWithObject:mobileField.text]) {
       
       
           UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机或邮箱格式?"
                                                       message:nil delegate:nil
                           cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
           [alertView show];
        }
    
    if (textField.tag == 2) {
        
        if (![passwordField.text length]) {
            
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空?" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
 
    return YES;
    
    

 }
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 1) {
    
        //手机号以13 17 15 18开头，八个 \d 数字字符
        NSString *loginIphone =  @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|17[0-9])\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",loginIphone];
        
        NSString *loginEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginEmail];
        
        
        
        if (![phoneTest evaluateWithObject:mobileField.text] &&
            ![emailTest evaluateWithObject:mobileField.text]) {
            
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机或邮箱格式?"
                                                               message:nil delegate:nil
                                                     cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            return NO;
            
        } else {
            
            [mobileField resignFirstResponder];
            
            [passwordField becomeFirstResponder];
            
            mainScrollView.contentOffset = CGPointMake(0, 10);
        
           }

      }
    if (textField.tag == 2) {
        
        
        if (![passwordField.text length]) {
            
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空?"
                               message:nil delegate:nil cancelButtonTitle:@"取消"
                                                    otherButtonTitles:nil, nil];
            [alertView show];
            return NO;
            
         }else {
        
            mainScrollView.contentOffset = CGPointMake(0, 25);
            [passwordField resignFirstResponder];
        }
    
        
    }
    if (textField.tag == 3) {
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"验证码不能为空?"
                                                           message:nil delegate:nil cancelButtonTitle:@"取消"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }else {
        
        mainScrollView.contentOffset = CGPointMake(0, 0);
        
    }

    return YES;
    

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [passwordField resignFirstResponder];
    [mobileField resignFirstResponder];
    mainScrollView.contentOffset = CGPointMake(0, 0);

}

-(void)closekeyBoard:(UITapGestureRecognizer*)tap
{
    
    if (tap == viewGesture) {
        
        [mobileField resignFirstResponder];
        [passwordField resignFirstResponder];
        
    }
    mainScrollView.contentOffset = CGPointMake(0, 0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}

@end
