//
//  ReginViewController.m
//  ddddd
//
//  Created by Apple on 14-3-31.
//  Copyright (c) 2014年 doocom. All rights reserved.
//

#import "ReginViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"


@interface ReginViewController ()
{
    BOOL isEnter;
    UITextField* mobileField;
    UITextField* passwordField;
    UITapGestureRecognizer* viewGesture;
    
    
}
@end

@implementation ReginViewController

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
    

    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"_leftbutton-.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //右ButtonMethod
    UIButton* reginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reginButton.frame = CGRectMake(160.0, 17, 170, 14);
    [reginButton setTitle:@"您需要登录吗 ?" forState:UIControlStateNormal];
    [reginButton addTarget:self action:@selector(loginMethod)
                                  forControlEvents:UIControlEventTouchUpInside];
    [reginButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                     (67.0, 67.0, 67.0).CGColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:reginButton];
    
    viewGesture = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(closekeyBoard:)];
    [self.view addGestureRecognizer:viewGesture];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    UIImage* barlineImage = [UIImage imageNamed:@"_barline-.png"];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                320, barlineImage.size.height)];
    imageView.image = barlineImage;
    [self.view addSubview:imageView];
    
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        //设置navigationBar的背景图片
     
        [self.navigationController.navigationBar setBackgroundImage:
        [UIImage imageNamed:@"navigaback-.png"] forBarMetrics:UIBarMetricsDefault];
     
     }  else {
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigationbar_"];
            [self.navigationController.navigationBar setBackgroundImage:barImage
                                             forBarMetrics:UIBarMetricsDefault];
    }
        
        
        UIImage* mobileImage = [UIImage imageNamed:@"mobile-.png"];
        
        UIImageView* mobileImageView = [[UIImageView alloc]initWithFrame:
             CGRectMake((self.view.frame.size.width-mobileImage.size.width)/2.0,
                                                      16, mobileImage.size.width,
                                                       mobileImage.size.height)];
        mobileImageView.userInteractionEnabled = YES;
        mobileImageView.image = mobileImage;
        [self.view addSubview:mobileImageView];
    
        mobileField = [[UITextField alloc]initWithFrame:
                                                    CGRectMake(20, 5, 160, 30)];
        mobileField.userInteractionEnabled = YES;
        mobileField.tag = 1;
        mobileField.delegate = self;
        mobileField.placeholder = @"输入您的手机/邮箱";
        mobileField.font = [UIFont systemFontOfSize:15];
        [mobileField setBorderStyle:UITextBorderStyleNone];
        [mobileImageView addSubview:mobileField];
        
        
        UIImage* passwordImage = [UIImage imageNamed:@"passwordImage-.png"];
        UIImageView* passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                     ((self.view.frame.size.width-passwordImage.size.width)/2.0,
                                                 16+passwordImage.size.height+5,
                                                       passwordImage.size.width,
                                                    passwordImage.size.height)];
        passwordImageView.userInteractionEnabled = YES;
        passwordImageView.image = passwordImage;
        [self.view addSubview:passwordImageView];
        
        
        
        passwordField = [[UITextField alloc]initWithFrame:
                                                    CGRectMake(20, 5, 160, 30)];
        passwordField.userInteractionEnabled = YES;
        passwordField.tag = 2;
        passwordField.delegate = self;
        passwordField.font = [UIFont systemFontOfSize:15];
        passwordField.placeholder = @"输入您的密码";
        [passwordField setBorderStyle:UITextBorderStyleNone];
        [passwordImageView addSubview:passwordField];
        
        
    
        
        UIImage* reginImage = [UIImage imageNamed:@"reginImage--.png"];
        UIImageView*  reginImageView = [[UIImageView alloc]initWithFrame:
                                                     CGRectMake(10.0,265.0-104.0-40,
                                                          reginImage.size.width,
                                                       reginImage.size.height)];
        reginImageView.image = reginImage;
        reginImageView.userInteractionEnabled = YES;
    
    
        UITapGestureRecognizer* reginTapGesture = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(reginMethod:)];
        [reginImageView addGestureRecognizer:reginTapGesture];
        [self.view addSubview:reginImageView];
  
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"textFieldShouldBeginEditing %@", textField);
    
    if (textField.tag ==1) {
        
    }
    if (textField.tag == 2) {
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
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
        
    }
    
    if (textField.tag == 2) {
        
        if (![passwordField.text length]) {
            
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空?"
            message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            return NO;

        }else
        {
        
            [passwordField resignFirstResponder];
            
        
        }
        
        
    }
    

    return YES;
    
    
}

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

        }else   {
        
        
            [mobileField resignFirstResponder];
            [passwordField becomeFirstResponder];
        }
        
    }
    if (textField.tag == 2) {
        
        
        if (![passwordField.text length]) {
                
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空?"
                            message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
            return NO;
            
        }else {
        
            [passwordField resignFirstResponder];
        }
            
    }
 
        
    return YES;
    

}

-(void)closekeyBoard:(UITapGestureRecognizer*)tap
{
    if (tap == viewGesture) {
        [mobileField resignFirstResponder];
        [passwordField resignFirstResponder];
    }
}

- (void)loginMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reginMethod:(UITapGestureRecognizer*)reginTapGesture
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result *result = [Member registerWithLoginUsername:mobileField.text
                                             loginPassword:passwordField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"注册成功"
                                                                   message:nil
                                                                  delegate:nil
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:result.error.localizedDescription
                                                                   message:nil
                                                                  delegate:nil
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
    });
}

- (void)backButtonMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
