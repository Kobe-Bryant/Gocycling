//
//  PasswordViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-19.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "PasswordViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"

@interface PasswordViewController ()
{
    UITextField* passwordField;
    UITextField* againPasswordField;
    UITextField* surePasswordField ;
}
@end

@implementation PasswordViewController

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
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = NSLocalizedString(@"修改密码", nil);
    lable.textAlignment = NSTextAlignmentCenter;
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

    [super viewWillAppear: animated];
    
    
    NSLog(@"PasswordViewController viewWillAppear");
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
  
    self.tabBarController.tabBar.hidden = YES;

    
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"password_.png"];
    
    
    UIImageView* passwordImageView = [[UIImageView alloc]initWithFrame:
          CGRectMake((self.view.frame.size.width-passwordImage.size.width)/2.0,
                                                   10,passwordImage.size.width,
                                                   passwordImage.size.height)];
    

    
    
    passwordImageView.image = passwordImage;
    passwordImageView.userInteractionEnabled = YES;
    [self.view addSubview:passwordImageView];
    
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(85, 7, 200, 30)];
    passwordField.userInteractionEnabled = YES;
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    passwordField.tag = 1;
    passwordField.placeholder = @"请输入原密码";
    [passwordField setBorderStyle:UITextBorderStyleNone];
    [passwordImageView addSubview:passwordField];
    
    
    againPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(85,
                                                5+passwordImage.size.height/3.0,
                                                                      200, 30)];
    againPasswordField.userInteractionEnabled = YES;
    againPasswordField.secureTextEntry = YES;
    againPasswordField.placeholder = @"请输入新密码";
    againPasswordField.delegate = self;
    againPasswordField.tag = 2;
    [againPasswordField setBorderStyle:UITextBorderStyleNone];
    [passwordImageView addSubview:againPasswordField];
    
    
    surePasswordField = [[UITextField alloc]initWithFrame:CGRectMake(85,
                                             5+passwordImage.size.height/3.0*2,
                                                                      200, 30)];
    surePasswordField.userInteractionEnabled = YES;
    surePasswordField.delegate = self;
    surePasswordField.secureTextEntry = YES;
    surePasswordField.tag = 3;
    surePasswordField.placeholder = @"请再次输入密码";
    [surePasswordField setBorderStyle:UITextBorderStyleNone];
    [passwordImageView addSubview:surePasswordField];
    
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
        
        
        passwordField.frame =  CGRectMake(85, 9, 200, 30);
    
        againPasswordField.frame = CGRectMake(85,9+passwordImage.size.height/3.0,
                                                                        200, 30);
        surePasswordField.frame = CGRectMake(85,9+passwordImage.size.height/3.0*2,
                                                                         200, 30);
    }
    
    
    UIImage* saveImage = [UIImage imageNamed:@"saveImage"];
    UIImageView* sureImageView = [[UIImageView alloc]initWithFrame:
           CGRectMake((self.view.frame.size.width-passwordImage.size.width)/2.0,
                passwordImageView.frame.origin.y+passwordImage.size.height+10 ,
                                                          saveImage.size.width,
                                                        saveImage.size.height)];
    sureImageView.image = saveImage;
    sureImageView.userInteractionEnabled = YES;
    [self.view addSubview:sureImageView];
    
    
    UITapGestureRecognizer* sureTapGesture = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(save:)];
    [sureImageView addGestureRecognizer:sureTapGesture];


}


- (void)save:(UITapGestureRecognizer*)sureTapGesture
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [[Member sharedMember] updatePasswordWithOldpassword:[Member sharedMember].loginPassword
                                                                  newPassword:surePasswordField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"密码修改成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
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
    
    NSLog(@"save");
}

-(void)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    

}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
      return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
      return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 1) {
        
        [passwordField resignFirstResponder];
        
        [againPasswordField becomeFirstResponder];
        
    }
    if (textField.tag == 2) {
        
        [againPasswordField resignFirstResponder];
        
        [surePasswordField becomeFirstResponder];
        
        
    }
    if (textField.tag == 3) {
        
        [surePasswordField resignFirstResponder];
        
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
