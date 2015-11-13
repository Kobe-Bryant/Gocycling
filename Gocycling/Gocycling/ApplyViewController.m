//
//  ApplyViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "ApplyViewController.h"
#import "Macros.h"
#import "SelectProjectViewController.h"
#import "Result.h"
#import "Member.h"
#import "OrderContestant.h"
#import "CommentSingleClass.h"
#import "Order.h"
#import "TempOrderContestant.h"

@interface ApplyViewController ()
{
    UIScrollView* mainScrollView;
    UITapGestureRecognizer* nextstepTapGesture;
    UITapGestureRecognizer* paperTypeGesture;
    UIImageView* enrollImageView;
    UITextField* placholderField;
    UIImageView* contactImageView;
    BOOL isEnter;
    NSMutableDictionary* bigDic;
}

@property (nonatomic, retain) UITextField* nameTextField;
@property (nonatomic, retain) UITextField *contestantTextField;
@property (nonatomic, retain) UIPickerView *contestantPickerView;
@property (nonatomic, retain) UITextField* genderTextField;
@property (nonatomic, retain) UITextField* mobileTextField;
@property (nonatomic, retain) UITextField* birthdayTextField;
@property (nonatomic, retain) UIDatePicker* birthdayDatePicker;
@property (nonatomic, retain) UITextField* emailTextField;
@property (nonatomic, retain) UILabel* credentialTypeLabel;
@property (nonatomic, retain) UITextField* credentialTypeTextField;
@property (nonatomic, retain) UIPickerView* credentialTypePickerView;
@property (nonatomic, retain) UITextField* credentialNumberTextField;

@property (nonatomic, retain) UITextField* emergencyNameTextField;
@property (nonatomic, retain) UITextField* emergencyContactTextField;

@property (nonatomic, retain) NSArray *contestantArray;
@property (nonatomic, retain) NSArray* credentialTypeArray;
@property (nonatomic) int currentMemberContestantID;


@end

@implementation ApplyViewController

static int count=0;

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

    
    //设置navigationItem的titleView
//    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"报名信息", nil);
//    self.navigationItem.titleView = label;
    self.title = @"报名信息";
    
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
    self.credentialTypeArray = @[@"身份证", @"护照", @"回乡证"];
    
  //用于保存报名的信息
   bigDic = [NSMutableDictionary dictionary];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearDic:)
                                                 name:@"clearApplyViewControllerDic"
                                               object:nil];
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  //  [self clearTextFieldText];

    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }
    
    
    
    //创建ScrollView
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   0.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.delegate = self;
    
    [self.view addSubview:mainScrollView];
    
    
    //navigationbar下面的view
    UIView* downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
    downView.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
    [mainScrollView addSubview:downView];
    
    //downView上的子视图
    UIImage* titleimage = [UIImage imageNamed:@"titleimage.png"];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20,
                                titleimage.size.width, titleimage.size.height)];
    imageView.image = titleimage;
    [downView addSubview:imageView];
    
    
    
    UIImage* selectnameImage = [UIImage imageNamed:@"selectname.png"];
    
    UIImageView* selectnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                                        (10, 90,
                                                     selectnameImage.size.width,
                                                  selectnameImage.size.height)];
    selectnameImageView.image = selectnameImage;
    selectnameImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:selectnameImageView];
    
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 50, 30)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = @"姓名";
    nameLabel.textColor = UIColorFromRGB(149.0, 149.0, 149.0);
    [selectnameImageView addSubview:nameLabel];
    
    
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 0.0, 100.0, selectnameImageView.frame.size.height)];
    self.nameTextField.tag = 1;
    self.nameTextField.delegate = self;
    [selectnameImageView addSubview:self.nameTextField];
    
    
    //选择名单的view
//    UIImage* selectRollImage = [UIImage imageNamed:@"selectimage.png"];
//    UIImageView* selectRollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(225,
//                                                 90, selectRollImage.size.width,
//                                                  selectRollImage.size.height)];
//    selectRollImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer* selectName = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                            action:@selector(selectPerson:)];
//    [selectRollImageView addGestureRecognizer:selectName];
//    selectRollImageView.image = selectRollImage;
//    [mainScrollView addSubview:selectRollImageView];
    UIImage *chooseListButtonImage = [UIImage imageNamed:@"selectimage"];
    UIButton *chooseListButton = [[UIButton alloc] init];
    chooseListButton.frame = CGRectMake(225.0,
                                        90.0,
                                        chooseListButtonImage.size.width,
                                        chooseListButtonImage.size.height);
    [chooseListButton setImage:chooseListButtonImage forState:UIControlStateNormal];
    [chooseListButton addTarget:self action:@selector(selectPerson:)
               forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:chooseListButton];
    
    
    self.contestantPickerView = [[UIPickerView alloc] init];
    self.contestantPickerView.delegate = self;
    self.contestantPickerView.dataSource = self;

    self.contestantTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.contestantTextField.inputView = self.contestantPickerView;
    [mainScrollView addSubview:self.contestantTextField];
    

    
    //填写信息的背景图片
    UIImage* enrollImage = [UIImage imageNamed:@"enrollImage.png"];
    enrollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                        (self.view.frame.size.width-enrollImage.size.width)/2.0,
                                             90+chooseListButtonImage.size.height+10 ,
                                                         enrollImage.size.width,
                                                      enrollImage.size.height)];
    enrollImageView.userInteractionEnabled = YES;
    enrollImageView.image = enrollImage;
    [mainScrollView addSubview:enrollImageView];
    
    
    NSArray* infomationArray = @[@"性别", @"手机", @"生日", @"邮箱"];
    
    NSArray* placeholderArray = @[@"请选择性别", @"请输入手机号码" ,@"请选择出生日期", @"请输入邮箱"];
    
    for (int i = 0; i < 4; i++) {

        
        UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(15,
                                                5+enrollImage.size.height/4.0*i,
                                                                       50, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
        label.text = infomationArray[i];
        [enrollImageView addSubview:label];
        
        
        placholderField = [[UITextField alloc]initWithFrame:CGRectMake(100.0,
                                                5+enrollImage.size.height/4.0*i,
                                                                      200, 30)];
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
        
            placholderField.frame = CGRectMake(100.0,
                                               10+enrollImage.size.height/4.0*i,
                                               200, 30);
        }
        
        placholderField.tag = i+2;
        placholderField.delegate = self;
        placholderField.userInteractionEnabled = YES;
        placholderField.textAlignment = NSTextAlignmentLeft;
        placholderField.placeholder = placeholderArray[i];
        [enrollImageView addSubview:placholderField];
        
    }
    
    
 
    
    UIImage* credentialTypeBackgroundImage = [UIImage imageNamed:@"paperTypebackImage"];
    UIImageView* credentialTypeBackgroundImageView = [[UIImageView alloc] init];
    credentialTypeBackgroundImageView.frame = CGRectMake(10.0,
                                                         310.0,
                                                         credentialTypeBackgroundImage.size.width,
                                                         credentialTypeBackgroundImage.size.height);
    credentialTypeBackgroundImageView.userInteractionEnabled = YES;
    credentialTypeBackgroundImageView.image = credentialTypeBackgroundImage;
    [mainScrollView addSubview:credentialTypeBackgroundImageView];
    
    
    self.credentialTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 60, 20)];
    self.credentialTypeLabel.font = [UIFont systemFontOfSize:15];
    self.credentialTypeLabel.textColor = UIColorFromRGB(149.0, 149.0, 149.0);
    self.credentialTypeLabel.text = @"证件类型";
    [credentialTypeBackgroundImageView addSubview:self.credentialTypeLabel];
    
    
    UIImage* arrowImage = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* credentialTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    credentialTypeButton.frame = CGRectMake(85, 12, arrowImage.size.width, arrowImage.size.height);
    [credentialTypeButton setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [credentialTypeButton addTarget:self
                             action:@selector(clickArrowImageButton:)
                   forControlEvents:UIControlEventTouchUpInside];
    [credentialTypeBackgroundImageView addSubview:credentialTypeButton];
    
    self.credentialTypePickerView = [[UIPickerView alloc] init];
    self.credentialTypePickerView.delegate = self;
    self.credentialTypePickerView.dataSource = self;

    self.credentialTypeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.credentialTypeTextField.inputView = self.credentialTypePickerView;
    [mainScrollView addSubview:self.credentialTypeTextField];

    
    UIView* credentialNumberView = [[UIView alloc] init];
    credentialNumberView.frame = CGRectMake(125.0, 310, 185, credentialTypeBackgroundImage.size.height);
    credentialNumberView.userInteractionEnabled = YES;
    [credentialNumberView.layer setBorderWidth:0.45];
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
       [credentialNumberView.layer setBorderWidth:0.52];
    }
    [credentialNumberView.layer setBorderColor:UIColorFromRGB(191.0, 191.0, 191.0).CGColor];
    [mainScrollView addSubview:credentialNumberView];

    self.credentialNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(10.0, 7, 100, 20)];
    self.credentialNumberTextField.tag = 6;
    self.credentialNumberTextField.delegate = self;
    [credentialNumberView addSubview:self.credentialNumberTextField];
    
    
    
    
    UIImage* contactImage = [UIImage imageNamed:@"contact.png"];
    contactImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                        (self.view.frame.size.width-enrollImage.size.width)/2.0,
      credentialTypeBackgroundImageView.frame.origin.y+ credentialTypeBackgroundImage.size.height+10 ,
                                                        contactImage.size.width,
                                                     contactImage.size.height)];
    contactImageView.userInteractionEnabled = YES;
    contactImageView.image = contactImage;
    [mainScrollView addSubview:contactImageView];
    
    for (int i = 0; i < 2; i++) {
    
        NSArray* labelArray = @[@"紧急联系人",@"电话"];
        
        UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(15,
                                              5+contactImage.size.height/2.0*i,
                                                                       80, 30)];
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
        label.text = labelArray[i];
        
        [contactImageView addSubview:label];
        
        self.emergencyNameTextField = [[UITextField alloc] init];
        self.emergencyNameTextField.frame = CGRectMake(100.0,
                                                       5.0 + contactImage.size.height / 2.0 * i,
                                                       200.0,
                                                       30.0);
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            self.emergencyNameTextField.frame = CGRectMake(100.0,
                                                           8.0 + contactImage.size.height / 2.0 * i,
                                                           200.0,
                                                           30.0);
        }
        self.emergencyNameTextField.tag = 7 + i;
        self.emergencyNameTextField.delegate = self;
        self.emergencyNameTextField.userInteractionEnabled = YES;
        self.emergencyNameTextField.textAlignment = NSTextAlignmentLeft;
        [contactImageView addSubview:self.emergencyNameTextField];
        
        
    }
    
    //下一步的imageView添加手势方法

//    UIImage* nextstepImage = [UIImage imageNamed:@"nextstepImage.png"];
//
//    UIImageView* nextstepImageView = [[UIImageView alloc]initWithFrame:
//                                 CGRectMake(10,  435+20,
//                                                     nextstepImage.size.width,
//                                                    nextstepImage.size.height)];
//    nextstepImageView.userInteractionEnabled = YES;
//    nextstepImageView.image = nextstepImage;
//    [mainScrollView addSubview:nextstepImageView];
    
//    nextstepTapGesture = [[UITapGestureRecognizer alloc]
//                          initWithTarget:self action:@selector(nextstepGesture:)];
//    [nextstepImageView addGestureRecognizer:nextstepTapGesture];
    
    UIImage *nextStepButtonImage = [UIImage imageNamed:@"nextstepImage"];
    UIButton *nextStepButton = [[UIButton alloc] init];
    nextStepButton.frame = CGRectMake(10.0,
                                      435.0 + 20.0,
                                      nextStepButtonImage.size.width,
                                      nextStepButtonImage.size.height);
    [nextStepButton setImage:nextStepButtonImage forState:UIControlStateNormal];
    [nextStepButton addTarget:self
                       action:@selector(nextstepGesture:)
             forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:nextStepButton];
    
    
    self.genderTextField = (UITextField*)[enrollImageView viewWithTag:2];
    self.mobileTextField = (UITextField*)[enrollImageView viewWithTag:3];
    self.birthdayTextField = (UITextField*)[enrollImageView viewWithTag:4];
    self.emailTextField = (UITextField*)[enrollImageView viewWithTag:5];
    self.emergencyNameTextField = (UITextField*)[contactImageView viewWithTag:7];
    self.emergencyContactTextField = (UITextField*)[contactImageView viewWithTag:8];
    
    self.birthdayDatePicker = [[UIDatePicker alloc] init];
//    self.birthdayTextField.frame = CGRectMake(0, 250, 320, 216);
    self.birthdayDatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-24 * 60 * 60 * 365 * 20];
    self.birthdayDatePicker.tag = 100;
//    self.birthdayTextField.hidden = YES;
    self.birthdayDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 365 * 100];
    self.birthdayDatePicker.date = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.birthdayDatePicker addTarget:self
                                action:@selector(birthdayChanged:)
                      forControlEvents:UIControlEventValueChanged];
    
    self.birthdayTextField.inputView = self.birthdayDatePicker;
//    [self.view addSubview:picker];
    

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue,^{
        Result *result = [[Member sharedMember] contestantList];
        if (result.isSuccess) {
            self.contestantArray = (NSArray *)result.data;
        }
    });
}



#pragma mark UIPickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.contestantPickerView) {
        return [self.contestantArray count];
    }

    return [self.credentialTypeArray count];
}

#pragma mark UIPickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.contestantPickerView) {
        MemberContestant *contestant = [self.contestantArray objectAtIndex:row];
        return contestant.name;
    }
    
    return [self.credentialTypeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.contestantPickerView) {
        MemberContestant *contestant = [self.contestantArray objectAtIndex:row];
        self.currentMemberContestantID = contestant.memberContestantID;
        self.nameTextField.text = contestant.name;
        if (contestant.gender == 0) {
            self.genderTextField.text = @"男";
        } else {
            self.genderTextField.text = @"女";
        }
        self.mobileTextField.text = contestant.mobile;
        self.birthdayTextField.text = contestant.birthday;
        self.emailTextField.text = contestant.email;
        if ([contestant.credentialType isEqualToString:@"ID"]) {
            self.credentialTypeLabel.text = @"身份证";
        } else if ([contestant.credentialType isEqualToString:@"PASSPORT"]) {
            self.credentialTypeLabel.text = @"护照";
        } else {
            self.credentialTypeLabel.text = @"回乡证";
        }
        self.credentialNumberTextField.text = contestant.credentialNumber;
        self.emergencyNameTextField.text = contestant.emergencyName;
        self.emergencyContactTextField.text = contestant.emergencyContact;
        
        [self.contestantTextField resignFirstResponder];
    } else {
        self.credentialTypeLabel.text = [self.credentialTypeArray objectAtIndex:row];
        [self.credentialTypeTextField resignFirstResponder];
    }
}


#pragma mark backButtonMethod
-(void)backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickArrowImageButton:(UIButton*)bt
{
    NSLog(@"clickArrowImageButton");
    
    [self.credentialTypeTextField becomeFirstResponder];
    
//    [self.nameTextField resignFirstResponder];
//    [self.credentialNumberTextField resignFirstResponder];
//
//    [self.genderTextField resignFirstResponder];
//
//    [self.birthdayTextField resignFirstResponder];
//    [self.mobileTextField resignFirstResponder];
//
//    [self.emailTextField resignFirstResponder];
//
//
//    [callField resignFirstResponder];

//    if (pickView == nil) {
//        
//        pickView = [[UIPickerView alloc]initWithFrame:CGRectMake
//                    (10, 240, self.view.frame.size.width, 0)];
//        pickView.delegate= self;
//        pickView.dataSource =self;
//        pickView.showsSelectionIndicator = YES;
//        [self.view addSubview:pickView];
//        
//    } else {
//        
//        pickView.hidden = NO;
//    }
    
//    mainScrollView.contentOffset = CGPointMake(0, 210);


}

#pragma mark UITextFieldDelegate



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag ==1 ) {
        
     
        mainScrollView.contentOffset =CGPointMake(0.0, 80);

    }
    
    if (textField.tag ==2) {
        
        
        mainScrollView.contentOffset =CGPointMake(0.0, 130);
   
    }
    if (textField.tag ==3) {
        
        mainScrollView.contentOffset =CGPointMake(0.0, 180);
      
    }
    
    if (textField.tag ==4) {
        
        [self.mobileTextField resignFirstResponder];
        [self.birthdayTextField resignFirstResponder];

        
//        picker.hidden = NO;
//        NSDate* date = picker.date;
//        
//        NSDateFormatter* format = [[NSDateFormatter alloc]init];
//        [format setDateFormat:@"YYYY-MM-dd"];
//        
//        NSString* ss = [format stringFromDate:date];
//        
//        self.birthdayTextField.text = ss;
//        
//        
//        
//        mainScrollView.contentOffset =CGPointMake(0.0, 210);
        
    }
    
    if (textField.tag == 8 || textField.tag ==7 || textField.tag == 6 || textField.tag == 5 )  {
       
//        picker.hidden = YES;
        
        
        mainScrollView.contentOffset = CGPointMake(0.0, 210);
//        pickView.hidden = YES;
        
    }
     
    return YES;
    

}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if (textField.tag == 1) {
        
        
        
        [self.nameTextField resignFirstResponder];
        [self.genderTextField becomeFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0.0, 80);
    }
    
    
    
    
    if (textField.tag == 2) {
        
        [self.genderTextField resignFirstResponder];
        
        [self.mobileTextField becomeFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0.0, 130);
        
    }
    
    if (textField.tag == 3) {
        
        [self.mobileTextField resignFirstResponder];
        
        [self.birthdayTextField becomeFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0.0, 150);
    }
    if (textField.tag == 4) {
        
        [self.birthdayTextField resignFirstResponder];
        
        [self.emailTextField becomeFirstResponder];
        //        picker.hidden = YES;
        mainScrollView.contentOffset = CGPointMake(0.0, 205);
        
    }
    
    
    if (textField.tag == 5) {
        
        
        [self.emailTextField resignFirstResponder];
        
        [self.credentialNumberTextField becomeFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0.0, 210);
        
    }
    if (textField.tag == 6) {
        
        [self.credentialNumberTextField resignFirstResponder];
        
        [self.emergencyNameTextField becomeFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0.0, 210);
//        pickView.hidden = YES;
        
    }
    if (textField.tag == 7) {
        
        
        
        
        [self.emergencyNameTextField resignFirstResponder];
        
        [self.emergencyContactTextField becomeFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0.0, 210);
        
    }
    
    if (textField.tag == 8) {
        
        
        [self.emergencyContactTextField  resignFirstResponder];
        
        mainScrollView.contentOffset = CGPointMake(0, 0);
    }
    
    
    return YES;
    
}

//选择名单
- (void)selectPerson:(UITapGestureRecognizer*)tap
{
    [self.contestantTextField becomeFirstResponder];
}


#pragma mark UIScrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.nameTextField resignFirstResponder];
    [self.credentialNumberTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.birthdayTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.emergencyNameTextField resignFirstResponder];
    [self.emergencyContactTextField resignFirstResponder];
    mainScrollView.contentOffset = CGPointMake(0, 0);
    
}

//手势方法
-(void)nextstepGesture:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"ApplyViewController count = %d",count);
    
    
    NSString* key = [NSString stringWithFormat:@"key%d",count];
    
    NSMutableDictionary* smallDic = [NSMutableDictionary dictionary];
    
    [smallDic setObject:self.nameTextField.text forKey:@"name"];
    [smallDic setObject:self.genderTextField.text forKey:@"gender"];
    [smallDic setObject:self.mobileTextField.text forKey:@"mobile"];
    [smallDic setObject:self.birthdayTextField.text forKey:@"birthday"];
    [smallDic setObject:self.emailTextField.text forKey:@"email"];
    [smallDic setObject:self.emergencyNameTextField.text forKey:@"emergencyName"];
    [smallDic setObject:self.emergencyContactTextField.text forKey:@"emergencyContact"];
    [smallDic setObject:self.credentialNumberTextField.text forKey:@"credentialNumber"];
    [smallDic setObject:self.credentialTypeLabel.text forKey:@"credentialType"];
    [bigDic setObject:smallDic forKey:key];
    
    
     NSLog(@"bigDic=  %@",bigDic);
    
    int gender ;
    if ([self.genderTextField.text isEqualToString:@"男"]) {
        gender = 0;
    } else {
        gender = 1;
    }
    
    
    NSString* type;

    if ([self.credentialTypeLabel.text isEqualToString:@"身份证"]) {
        type = @"ID";
    } else if ([self.credentialTypeLabel.text isEqualToString:@"护照"]) {
        type = @"PASSPORT";
    } else {
        type = @"RETURN_PERMIT";
    }
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{       
        Result* result = [Order validateContestantWithActivityID:[NSNumber numberWithInt:self.currentEventID]
                                                   competitionID:[NSNumber numberWithInt:self.currentCompetitionID]
                                                            name:self.nameTextField.text
                                                          gender:gender
                                                          mobile:self.mobileTextField.text
                                                           email:self.emailTextField.text
                                                        birthday:self.birthdayTextField.text
                                                  credentialType:type
                                                credentialNumber:self.credentialNumberTextField.text
                                                   emergencyName:self.emergencyNameTextField.text
                                                emergencyContact:self.emergencyContactTextField.text];


        dispatch_async(dispatch_get_main_queue(), ^{


            if (result.isSuccess) {
                
                OrderContestant *orderContestant = [[OrderContestant alloc] init];
                orderContestant.activityID = self.currentEventID;
                orderContestant.competitionID = self.currentCompetitionID;
                orderContestant.memberContestant = [[MemberContestant alloc] init];
                orderContestant.memberContestant.memberContestantID = self.currentMemberContestantID;
                orderContestant.memberContestant.name = self.nameTextField.text;
                orderContestant.memberContestant.gender = gender;
                orderContestant.memberContestant.mobile = self.mobileTextField.text;
                orderContestant.memberContestant.email = self.emailTextField.text;
                orderContestant.memberContestant.birthday = self.birthdayTextField.text;
                orderContestant.memberContestant.credentialType = type;
                orderContestant.memberContestant.credentialNumber = self.credentialNumberTextField.text;
                orderContestant.memberContestant.emergencyName = self.emergencyNameTextField.text;
                orderContestant.memberContestant.emergencyContact = self.emergencyContactTextField.text;
                [[TempOrderContestant sharedTempOrderContestant] addOrderContestant:orderContestant];
                
                
                
//                count++;
                
                //将数据保存到单利中。
//                CommentSingleClass* mySingle = [CommentSingleClass getSingle];
//                mySingle.singleDic = bigDic;
                
                
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
//                //选择项目的视图控制器
//                SelectProjectViewController* selectProject = [[SelectProjectViewController alloc]init];
//                selectProject.eventID = self.currentEventID;
//                selectProject.personInfomationDic = bigDic;
//                
//                NSLog(@"%@",bigDic);
//                if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//                    
//                    selectProject.edgesForExtendedLayout = NO;
//                }
//                [self.navigationController pushViewController:selectProject animated:YES];
                
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

- (void)clearTextFieldText
{
    self.nameTextField.text = nil;
    self.genderTextField.text = nil;
    self.mobileTextField.text = nil;
    self.birthdayTextField.text = nil;
    self.emailTextField.text = nil;
    self.credentialNumberTextField.text = nil;
    self.emergencyNameTextField.text = nil;
    self.emergencyContactTextField.text = nil;
}

- (void)clearDic:(NSNotification*)notification
{
    bigDic = [NSMutableDictionary dictionary];
    count = 0;
}

- (void)birthdayChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.birthdayTextField.text = [dateFormatter stringFromDate:[datePicker date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
