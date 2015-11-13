//
//  PersonInfoViewController.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"

@interface PersonInfoViewController ()
{

    NSArray* listArray;
    UIScrollView* scrollView;
    UILabel* paperLabel;
    UITextField* nameField ;
    UITextField* nicknameField ;
    UITextField* sexField;
    UITextField* emailField;
    UITextField* birthField;
    UITextField* placeField;
    UITextField* mobileField;
    UITextField* paperField;
    BOOL isVisible;
    UIPickerView* pickView ;
    BOOL isEnter;
    
}
@end

@implementation PersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.navigationItem.hidesBackButton = YES;
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
    label.text = NSLocalizedString(@"个人信息", nil);
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
    
    self.tabBarController.tabBar.hidden = YES;

    [self getMemberInfomationMethod];
    
    
    //判断是否进入
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }

    NSLog(@"PersonInfoViewController viewWillAppear");
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    

   
   
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0.0,0.0,self.view.frame.size.width,
                                          self.view.frame.size.height);
    scrollView.contentSize = CGSizeMake(320, 600);
    scrollView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (235.0, 239.0, 241.0).CGColor];
    scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
  

    
    UIImage* nameImage = [UIImage imageNamed:@"nameback.png"];
    UIImageView* nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                          (self.view.frame.size.width-nameImage.size.width)/2.0,
                                                       18, nameImage.size.width,
                                                        nameImage.size.height)];
    nameImageView.userInteractionEnabled = YES;
    nameImageView.image = nameImage;
    [scrollView addSubview:nameImageView];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (149.0, 149.0, 149.0).CGColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = NSLocalizedString(@"姓名", nil);
    [nameImageView addSubview:label];
    
    
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, 200, 30)];
    nameField.userInteractionEnabled = YES;
    nameField.tag = 1;
    nameField.delegate = self;
    nameField.placeholder = @"输入姓名";
    [nameField setBorderStyle:UITextBorderStyleNone];
    [nameImageView addSubview:nameField];
    
    
    UILabel* nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                         10+nameImage.size.height/2.0, 40, 20)];
    nicknameLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.text = NSLocalizedString(@"昵称", nil);
    [nameImageView addSubview:nicknameLabel];
    
    
    nicknameField = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                         5+nameImage.size.height/2.0, 200, 30)];
    nicknameField.userInteractionEnabled = YES;
    nicknameField.placeholder = @"输入呢称";
    nicknameField.tag = 2;
    nicknameField.delegate = self;
    [nicknameField setBorderStyle:UITextBorderStyleNone];
    [nameImageView addSubview:nicknameField];
    
    UIImage* telephoneImage = [UIImage imageNamed:@"telephone.png"];
    UIImageView* moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                        (self.view.frame.size.width-nameImage.size.width)/2.0,
                                                107, telephoneImage.size.width,
                                                  telephoneImage.size.height)];
    moreImageView.userInteractionEnabled = YES;
    moreImageView.image = telephoneImage;
    [scrollView addSubview:moreImageView];
    
    
    UILabel* sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    sexLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    sexLabel.font = [UIFont systemFontOfSize:15];
    sexLabel.textAlignment = NSTextAlignmentLeft;
    sexLabel.text = NSLocalizedString(@"性别", nil);
    [moreImageView addSubview:sexLabel];
    
    sexField = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, 200, 30)];
    sexField.userInteractionEnabled = YES;
    sexField.delegate = self;
    sexField.tag = 3;
    sexField.placeholder = @"输入性别";
    [sexField setBorderStyle:UITextBorderStyleNone];
    [moreImageView addSubview:sexField];
    
    
    
    UILabel* mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                     10+telephoneImage.size.height/5.0, 40, 20)];
    mobileLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    mobileLabel.font = [UIFont systemFontOfSize:15];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    mobileLabel.text = NSLocalizedString(@"手机", nil);
    [moreImageView addSubview:mobileLabel];
    
    mobileField = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                    5+telephoneImage.size.height/5.0, 200, 30)];
    mobileField.userInteractionEnabled = YES;
    mobileField.delegate = self;
    mobileField.tag = 4;
    mobileField.placeholder = @"输入手机号";
    [mobileField setBorderStyle:UITextBorderStyleNone];
    [moreImageView addSubview:mobileField];
    
    
    
    UILabel* emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                  10+telephoneImage.size.height/5.0*2, 40, 20)];
    emailLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    emailLabel.font = [UIFont systemFontOfSize:15];
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.text = NSLocalizedString(@"邮箱", nil);
    [moreImageView addSubview:emailLabel];
    
    
    emailField = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                  5+telephoneImage.size.height/5.0*2, 200, 30)];
    emailField.userInteractionEnabled = YES;
    emailField.delegate = self;
    emailField.tag = 5;
    emailField.placeholder = @"输入邮箱";
    [emailField setBorderStyle:UITextBorderStyleNone];
    [moreImageView addSubview:emailField];
    
    
    
    UILabel* birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                  10+telephoneImage.size.height/5.0*3, 60, 20)];
    birthLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    birthLabel.font = [UIFont systemFontOfSize:15];
    birthLabel.textAlignment = NSTextAlignmentLeft;
    birthLabel.text = NSLocalizedString(@"出生日期", nil);
    [moreImageView addSubview:birthLabel];
    
    
    birthField = [[UITextField alloc]initWithFrame:CGRectMake(80,
                                  5+telephoneImage.size.height/5.0*3, 200, 30)];
    birthField.userInteractionEnabled = YES;
    birthField.delegate = self;
    birthField.tag = 6;
    birthField.placeholder = @"输入出生日期";
    [birthField setBorderStyle:UITextBorderStyleNone];
    [moreImageView addSubview:birthField];
    
    
    UILabel* placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                  10+telephoneImage.size.height/5.0*4, 60, 20)];
    placeLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textAlignment = NSTextAlignmentLeft;
    placeLabel.text = NSLocalizedString(@"常居地", nil);
    [moreImageView addSubview:placeLabel];
    
    
    placeField = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                  5+telephoneImage.size.height/5.0*4, 200, 30)];
    placeField.userInteractionEnabled = YES;
    placeField.delegate = self;
    placeField.tag = 7;
    placeField.placeholder = @"输入常居地";
    [placeField setBorderStyle:UITextBorderStyleNone];
    [moreImageView addSubview:placeField];
    
    
    UIImage* paperTypeBackgroundImage = [UIImage imageNamed:@"paperTypeBackgroundImage.png"];
    UIImageView* paperTypeBackgroundImageView = [[UIImageView alloc]initWithFrame:
                                 CGRectMake(10, 107+telephoneImage.size.height+5,
                                             paperTypeBackgroundImage.size.width,
                                         paperTypeBackgroundImage.size.height)];
    paperTypeBackgroundImageView.userInteractionEnabled = YES;
    paperTypeBackgroundImageView.image = paperTypeBackgroundImage;
    [scrollView addSubview:paperTypeBackgroundImageView];
    
    
    paperLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 60, 20)];
    paperLabel.font = [UIFont systemFontOfSize:15];
    paperLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    paperLabel.text = @"证件类型";
    [paperTypeBackgroundImageView addSubview:paperLabel];
    
    
    UIImage* arrowImage = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(85, 12, arrowImage.size.width, arrowImage.size.height);
    [button setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:
                                                    UIControlEventTouchUpInside];
    [paperTypeBackgroundImageView addSubview:button];
    
    
    
    
    UIImage* paperTypeImage = [UIImage imageNamed:@"leixing.png"];
    UIImageView* paperTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                    (10+paperTypeBackgroundImage.size.width+5,
                                              107+telephoneImage.size.height+5,
                                                           paperTypeImage.size.width,
                                                         paperTypeImage.size.height)];
    paperTypeImageView.userInteractionEnabled = YES;
    paperTypeImageView.image = paperTypeImage;
    [scrollView addSubview:paperTypeImageView];
    paperField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
    paperField.userInteractionEnabled = YES;
    paperField.tag = 8;
    paperField.placeholder = @"输入证件号码";
    paperField.delegate = self;
    [paperField setBorderStyle:UITextBorderStyleNone];
    [paperTypeImageView addSubview:paperField];
    
    
    
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
   
        
        nameField.frame = CGRectMake(60, 8, 200, 30);
        
        nicknameField.frame = CGRectMake(60,8+nameImage.size.height/2.0, 200, 30);
        
        sexField.frame = CGRectMake(60, 8, 200, 30);

        mobileField.frame = CGRectMake(60,8+telephoneImage.size.height/5.0, 200, 30);

        emailField.frame = CGRectMake(60,8+telephoneImage.size.height/5.0*2, 200, 30);
        
        birthField.frame = CGRectMake(80,8+telephoneImage.size.height/5.0*3, 200, 30);
        
        placeField.frame = CGRectMake(60,8+telephoneImage.size.height/5.0*4, 200, 30);
        
        paperField.frame = CGRectMake(20, 8, 200, 30);
        
    }
   
    
    UIImage* saveImage = [UIImage imageNamed:@"saveImage"];
    UIImageView* sureImageView = [[UIImageView alloc]initWithFrame:
         CGRectMake(10, 107+telephoneImage.size.height+5+paperTypeImage.size.height+5,
                                                           saveImage.size.width,
                                                        saveImage.size.height)];
    
    UITapGestureRecognizer* sureTapGesture = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(sureMethod:)];
    [sureImageView addGestureRecognizer:sureTapGesture];
    
    
    sureImageView.image = saveImage;
    sureImageView.userInteractionEnabled = YES;
    [scrollView addSubview:sureImageView];
    
    listArray = @[@"身份证",@"护照"];
    
    
   
}
-(void)getMemberInfomationMethod
{
    
   
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
   
        
        Result* result = [[Member sharedMember] profile];
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
            
        if (result.isSuccess) {
                
          
            Member* personInfoMation =(Member*) result.data;
            
    
            
            

            
            nameField.text = personInfoMation.realName;
            nicknameField.text = personInfoMation.nickname;
            mobileField.text = personInfoMation.mobile;
            emailField.text = personInfoMation.email;
            birthField.text = personInfoMation.birthdayString;
            placeField.text = personInfoMation.address;
            paperField.text = personInfoMation.credentialNumber;
            
            if (personInfoMation.gender ==0) {
                
             sexField.text = @"男";
                
            }else {
            
                sexField.text = @"女";
            }
            if ([personInfoMation.credentialType isEqualToString:@"ID"]) {
                
                paperLabel.text = @"身份证";
                
            }else {
                
                paperLabel.text = @"护照";
                
                
            }
         
        }else {
        
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
        
        
        }
            
            
        
        });
        

        
        
    
    });
    
    
    


}

-(void)sureMethod:(UITapGestureRecognizer*)sureTapGesture
{

   
    
    int gender;
    
        if ([sexField.text isEqualToString:@"男"]) {
        
            gender = 0;
        }else
        {
            gender = 1;

         
        
        }
   
    NSString* type;
    
    if ([paperLabel.text isEqualToString:@"身份证"]) {
        
        type = @"ID";
        
      
        
    }else
    {
        type = @"PASSPORT";

     
    }
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [[Member sharedMember] updateProfileWithName:nameField.text
                                                             nickname:nicknameField.text
                                                               gender:gender
                                                               mobile:mobileField.text
                                                                email:emailField.text
                                                       credentialType:type
                                                     credentialNumber:paperField.text
                                                             brithday:birthField.text
                                                              address:placeField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"信息保存成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }else{
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
    [nameField resignFirstResponder];
    [nicknameField resignFirstResponder];
    [sexField resignFirstResponder];
    [mobileField  resignFirstResponder];
    [emailField resignFirstResponder];
    [birthField resignFirstResponder];
    [placeField resignFirstResponder];
    [paperField resignFirstResponder];
    scrollView.contentOffset = CGPointMake(0, 0);


}
-(void)clickButton:(UIButton*)sender
{

    NSLog(@"sender");
    
    
    if (pickView  == nil) {
        
        pickView = [[UIPickerView alloc]initWithFrame:CGRectMake
                                     (10, 90, self.view.frame.size.width, 0)];
        pickView.delegate= self;
        pickView.dataSource =self;
        pickView.showsSelectionIndicator = YES;
        [self.view addSubview:pickView];
        
    }else
    {
    
        pickView.hidden = NO;
    }

    
    scrollView.contentOffset = CGPointMake(0, 270);

}


#pragma mark UIPickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 1;
    
    

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return 2;
    

}

#pragma mark UIPickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
              forComponent:(NSInteger)component
{
 
    return  [listArray objectAtIndex:row];

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
                                               inComponent:(NSInteger)component
{

    
    NSInteger selectRow  = [pickerView selectedRowInComponent:0];
    
    paperLabel.text = [listArray objectAtIndex:selectRow];
    
}
#pragma mark backButtonMethod 
-(void)backButton
{

    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark UITextFieldDelegate 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"textFieldShouldBeginEditing %@", textField);
    
    if (textField.tag ==1) {
  
        scrollView.contentOffset = CGPointMake(0, 18);
      
        
    }
    if (textField.tag == 2) {
        
        scrollView.contentOffset = CGPointMake(0, 55);

        
    }
    if (textField.tag == 3) {
        
        
        scrollView.contentOffset = CGPointMake(0, 115);
 
    }
    if (textField.tag == 4) {
        
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            scrollView.contentOffset = CGPointMake(0, 140);
    
            
        }
        
    }
    if (textField.tag == 5) {
        
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            scrollView.contentOffset = CGPointMake(0, 180);
            
            
        }
    }
    if (textField.tag == 6) {
        
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            scrollView.contentOffset = CGPointMake(0, 220);
            
            
        }
    }
    if (textField.tag == 7) {
        
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            scrollView.contentOffset = CGPointMake(0, 260);
            
            
        }
    }
    if (textField.tag == 8) {
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            scrollView.contentOffset = CGPointMake(0, 300);
            
            
        }
    }
    

    
    pickView.hidden = YES;
    
    
    
      return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    return YES;


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 1) {
        
        [nameField resignFirstResponder];
        
        [nicknameField becomeFirstResponder];
        
        scrollView.contentOffset = CGPointMake(0, 55);
        
        
     }
    if (textField.tag == 2) {
     
        scrollView.contentOffset = CGPointMake(0, 55);

        [nicknameField resignFirstResponder];
        
        [sexField becomeFirstResponder];


    }
    if (textField.tag == 3) {
        
        [sexField resignFirstResponder];
        
        [mobileField becomeFirstResponder];
        scrollView.contentOffset = CGPointMake(0, 115);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            scrollView.contentOffset = CGPointMake(0, 130);
            
        }
        
    }   if (textField.tag == 4) {
        
        [mobileField resignFirstResponder];
        
        [emailField becomeFirstResponder];
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            scrollView.contentOffset = CGPointMake(0, 140);
    
        }
        

    }   if (textField.tag == 5) {
        
        [emailField resignFirstResponder];
        
        [birthField becomeFirstResponder];
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            scrollView.contentOffset = CGPointMake(0, 180);
            
        }
        
        
        
    }   if (textField.tag == 6) {
        
        [birthField resignFirstResponder];
        
        [placeField becomeFirstResponder];
        scrollView.contentOffset = CGPointMake(0, 120);

        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            scrollView.contentOffset = CGPointMake(0, 220);
            
        }
    }
    if (textField.tag == 7) {
        
        [placeField resignFirstResponder];
        
        [paperField becomeFirstResponder];
        
        scrollView.contentOffset = CGPointMake(0, 120);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            scrollView.contentOffset = CGPointMake(0, 260);
            
        }
    }
    
    if (textField.tag ==8) {
      
        pickView.hidden = YES;

        [paperField resignFirstResponder];
        
        scrollView.contentOffset = CGPointMake(0, 0);
    
    }
    
    return YES;
    
}



@end
