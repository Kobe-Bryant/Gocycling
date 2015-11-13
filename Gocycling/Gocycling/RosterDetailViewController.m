//
//  RosterDetailViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-27.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "RosterDetailViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"


@interface RosterDetailViewController ()
{

    UIButton* editButton ;
    UIButton* cancelButton;
    UITableView* mainTableView;
    UIScrollView* mainScrollView;
    UILabel* nameLabel;
    UILabel* sexLabel;
    UILabel* mobileLabel;
    UILabel* brithLabel;
    UILabel* emailLabel;
    UITextField* nameField;
    UITextField* sexField;
    UITextField* mobileField;
    UITextField* birthField;
    UITextField* emailField;
    UITextField* numberField;
    UIImageView*  lineView;
    UIView*  verticalLineView;
    UIImage* lineImage;
    UILabel* paperLabel;
    NSArray* listArray;
    UIPickerView* pickView ;
    UIImage* tableViewbackImage;
    UIImageView* paperImageView;
    UIImageView* numberImageView;
    BOOL isEnter;
    UIView* verticalView;
    UIButton* deleteButton;
    UIImageView* contactImageView;
    UITextField* relationField;
    UITextField* contactField ;
    UITextField* telephoneField;
    
    

}

//@property(nonatomic, strong) MemberContestant* memberContestant;

@end

@implementation RosterDetailViewController

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

    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButton) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;

    
    //设置navigationItem的titleView
//    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    lable.textColor = [UIColor whiteColor];
//    lable.backgroundColor = [UIColor clearColor];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = NSLocalizedString(@"我的名单", nil);
//    self.navigationItem.titleView = lable;
    
    
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:
                        [NSArray arrayWithObjects:[UIColor whiteColor],
                         [UIFont boldSystemFontOfSize:18],
                         [UIColor clearColor],nil]
                                    forKeys:[NSArray arrayWithObjects:
                                                UITextAttributeTextColor,
                    UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.title = NSLocalizedString(@"我的名单", nil);;
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        verticalView = [[UIView alloc]initWithFrame:CGRectMake(250, 13, 1, 18)];
        
        
        
    }else {
        
        verticalView = [[UIView alloc]initWithFrame:CGRectMake(263, 14, 1, 18)];
        
    }
    
    verticalView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                    (137.0, 181.0, 255.0).CGColor];
    [self.navigationController.navigationBar addSubview:verticalView];
    
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(270, 8, 40, 30);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithCGColor:UIColorFromRGB
                                 (255.0, 255.0, 255.0).CGColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonMethod:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:deleteButton];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    

    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
        isEnter = YES;
    }

    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                                              (0, 0, self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    mainScrollView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (235.0, 239.0, 241.0).CGColor];
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.tag = 100;
    mainScrollView.userInteractionEnabled = YES;
   [self.view addSubview:mainScrollView];
    
    tableViewbackImage = [UIImage imageNamed:@"cellbackImage.png"];
    UIImage* paperImage = [UIImage imageNamed:@"papertypeofImage.png"];
    paperImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                 (self.view.frame.size.width-tableViewbackImage.size.width)/2.0,
                                             12+ tableViewbackImage.size.height,
                                                          paperImage.size.width,
                                                       paperImage.size.height)];
    paperImageView.image = paperImage;
    paperImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:paperImageView];
    
    
    paperLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 60, 20)];
    paperLabel.font = [UIFont systemFontOfSize:15];
    paperLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    if ([self.memberContestant.credentialType isEqualToString:@"ID"]) {
        
        paperLabel.text = @"身份证";
        
    }else {
    
        paperLabel.text = @"护照";
    }
    paperImageView.userInteractionEnabled = YES;
    [paperImageView addSubview:paperLabel];
    
    
    UIImage* arrowImage = [UIImage imageNamed:@"arrowofImage.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(85, 12, arrowImage.size.width, arrowImage.size.height);
    [button setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [paperImageView addSubview:button];
    
    
    
    
    UIImage* paperTypeBackImage = [UIImage imageNamed:@"paperTypeBack.png"];
    numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                  9.25+paperImage.size.width+7,
                                             12+ tableViewbackImage.size.height,
                                                  paperTypeBackImage.size.width,
                                               paperTypeBackImage.size.height)];
    numberImageView.image = paperTypeBackImage;
    numberImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:numberImageView];
    
    
    
    
    numberField = [[UITextField alloc]initWithFrame:CGRectMake(10, 12, 160, 15)];
    numberField.placeholder = @"请输入证件号码";
    numberField.text = self.memberContestant.credentialNumber;
    numberField.delegate = self;
    numberField.tag = 6;
    numberField.font = [UIFont systemFontOfSize:15];
    numberField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
    numberField.borderStyle = UITextBorderStyleNone;
    [numberImageView addSubview:numberField];
    
  
    
    UIImage* saveImage = [UIImage imageNamed:@"saveImage"];
    UIImageView* sureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                        (self.view.frame.size.width-saveImage.size.width)/2.0,
                20+ tableViewbackImage.size.height+ paperImage.size.height+90,
                                                        saveImage.size.width,
                                                        saveImage.size.height)];
    sureImageView.image = saveImage;
    sureImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:sureImageView];
    
    
    UITapGestureRecognizer* sureTapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(save:)];
    [sureImageView addGestureRecognizer:sureTapGesture];
    
    
    listArray = @[@"身份证",@"护照"];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(9.25, 7,
                                                                 tableViewbackImage.size.width,
                                                                 tableViewbackImage.size.height)
                                                style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.separatorColor = [UIColor clearColor];
    mainTableView .dataSource = self;
    mainTableView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                     (255.0, 255.0, 255.0).CGColor];
    [mainScrollView addSubview:mainTableView];
    [self.view addSubview:mainScrollView];

    
    UIImage* contactImage = [UIImage imageNamed:@"contact.png"];
    contactImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                    10.0,20+ tableViewbackImage.size.height+ paperImage.size.height ,
                                                                    300,80)];
    
    contactImageView.userInteractionEnabled = YES;
    contactImageView.image = contactImage;
    [mainScrollView addSubview:contactImageView];
    
    for (int i = 0; i < 2; i++) {
        
        NSArray* labelArray = @[@"紧急联系人",@"电话"];
        
        UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(15,
                                                                 5+contactImage.size.height/2.0*i,80, 30)];
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                           (149.0, 149.0, 149.0).CGColor];
        label.text = labelArray[i];
        
        [contactImageView addSubview:label];
        
        relationField = [[UITextField alloc]initWithFrame:CGRectMake(100.0,
                                                                     5+contactImage.size.height/2.0*i,200, 30)];
        
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            
            relationField.frame = CGRectMake(100.0,
                                             8+contactImage.size.height/2.0*i,200, 30);
            
        }
        relationField.tag = 7+i;
        relationField.delegate = self;
        relationField.userInteractionEnabled = YES;
        relationField.textAlignment = NSTextAlignmentLeft;
        [contactImageView addSubview:relationField];
        relationField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                              (119.0, 119.0, 119.0).CGColor];
        if (relationField.tag == 7) {
            
            relationField.text = self.memberContestant.emergencyName;
            
        }else {
            
            relationField.text = self.memberContestant.emergencyContact;

        
        }
        
    }
    

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [verticalView removeFromSuperview];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
                    (NSIndexPath *)indexPath
{
    
    return 40.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
    
    
    static NSString* cellidenty = @"cellid";
    
    UITableViewCell* Cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (Cell==nil) {
        
        
     
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellidenty];
    }
    

    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Cell.contentView.frame = CGRectMake(0.0, 0.0, Cell.frame.size.width,
                                                       Cell.frame.size.height);
    
    
    
  switch (indexPath.row) {
        case 0:
 
          
          nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 15)];
          nameLabel.text = @"姓名";
          nameLabel.font = [UIFont systemFontOfSize:15];
          nameLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
        [Cell.contentView addSubview:nameLabel];
        
 
          if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              
              nameField = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 180, 15)];
   
          }else {
              
              nameField = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, 180, 17)];
          }
          
         nameField.text = self.memberContestant.name;
         nameField.delegate = self;
         nameField.tag = 1;
         nameField.font = [UIFont systemFontOfSize:15];
         nameField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
         nameField.borderStyle = UITextBorderStyleNone;
        [Cell.contentView addSubview:nameField];
            
        break;
        case 1:
     
          sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 15)];
          sexLabel.text = @"性别";
          sexLabel.font = [UIFont systemFontOfSize:15];
          sexLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          [Cell.contentView addSubview:sexLabel];
            
          if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              
              sexField = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 180, 15)];
              
          }else {
              
              sexField = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, 180, 17)];
          }
          sexField.tag = 2;
          if (self.memberContestant.gender == 0) {
              
              sexField.text = @"男";
  
          }else {
          
              sexField.text = @"女";

          
          }
          sexField.delegate = self;
          sexField.font = [UIFont systemFontOfSize:15];
          sexField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          sexField.borderStyle = UITextBorderStyleNone;
          [Cell.contentView addSubview:sexField];
        break;
        case 2:
          
          mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 15)];
          mobileLabel.text = @"手机";
          mobileLabel.font = [UIFont systemFontOfSize:15];
          mobileLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
         [Cell.contentView addSubview:mobileLabel];
            
          if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              
              mobileField = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 180, 15)];
              
          }else {
              
              mobileField = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, 180, 17)];
          }
          mobileField.tag = 3;
          mobileField.text = self.memberContestant.mobile;
          mobileField.delegate = self;
          mobileField.font = [UIFont systemFontOfSize:15];
          mobileField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          mobileField.borderStyle = UITextBorderStyleNone;
         [Cell.contentView addSubview:mobileField];
        break;
        case 3:
          
          
          brithLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 15)];
          brithLabel.text = @"生日";
          brithLabel.font = [UIFont systemFontOfSize:15];
          brithLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          [Cell.contentView addSubview:brithLabel];
          
          if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              
              birthField = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 180, 15)];
              
          }else {
              
              birthField = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, 180, 17)];
          }
          birthField.delegate = self;
          birthField.tag = 4;
          birthField.text = self.memberContestant.birthday;
          birthField.font = [UIFont systemFontOfSize:15];
          birthField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          birthField.borderStyle = UITextBorderStyleNone;
          [Cell.contentView addSubview:birthField];
        break;
        case 4:
          emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 15)];
          emailLabel.text = @"邮箱";
          emailLabel.font = [UIFont systemFontOfSize:15];
          emailLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
         [Cell.contentView addSubview:emailLabel];
          
          if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              
              emailField = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 180, 15)];
              
          }else {
              
              emailField = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, 180, 17)];
          }
          emailField.tag = 5;
          emailField.delegate = self;
          emailField.text = self.memberContestant.email;
          emailField.font = [UIFont systemFontOfSize:15];
          emailField.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (119.0, 119.0, 119.0).CGColor];
          emailField.borderStyle = UITextBorderStyleNone;
        [Cell.contentView addSubview:emailField];
        break;
            
        default:
            break;
    }
    
    lineImage = [UIImage imageNamed:@"cell-line.png"];
    lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0,
                                        Cell.contentView.frame.size.height-5.0 ,
                                                           lineImage.size.width,
                                                         lineImage.size.height)];
    lineView.image = lineImage;
    [Cell.contentView addSubview:lineView];

    return Cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}

-(void)clickButton:(UIButton*)sender
{
    
    if (pickView == nil) {
        
        pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 300,
                                                self.view.frame.size.width, 0)];
        
        pickView.delegate= self;
        pickView.dataSource =self;
        pickView.showsSelectionIndicator = YES;
        
    }else
    {
    
        pickView.hidden = NO;
        
    }
    
   [mainScrollView addSubview:pickView];
    
    mainScrollView.contentOffset = CGPointMake(0, 200);

}
#pragma mark UIPickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:
                        (NSInteger)component
{
    
    return 2;
    
}

#pragma mark UIPickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    
    NSString* title = [listArray objectAtIndex:row];
    return title;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
                                               inComponent:(NSInteger)component
{
    
    
    NSInteger selectRow  = [pickerView selectedRowInComponent:0];
    
    paperLabel.text = [listArray objectAtIndex:selectRow];
    
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    pickView.hidden = YES;

    if (textField.tag == 1) {
        

        mainScrollView.contentOffset = CGPointMake(0, 15);
        
    }
    if (textField.tag == 2) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 45);
        
    }
    if (textField.tag == 3) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 85);
        
    }
    if (textField.tag == 4) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 125);
        
    }
    if (textField.tag == 5) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 165);
        
    }
    if (textField.tag == 6) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 200);
        
    }
    if (textField.tag == 7) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 110);
        
    }
    if (textField.tag == 8) {
        
        
        mainScrollView.contentOffset = CGPointMake(0, 110);
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    contactField =(UITextField*)[contactImageView viewWithTag:7];
    telephoneField =(UITextField*)[contactImageView viewWithTag:8];
    if (textField.tag == 1) {
        
        [nameField resignFirstResponder];
        [sexField becomeFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0, 45);

        
    }
    if (textField.tag == 2) {
        
        [sexField resignFirstResponder];
        [mobileField becomeFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0, 85);


    }
    if (textField.tag == 3) {
        
        [mobileField resignFirstResponder];
        
        [birthField becomeFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0, 125);

        
    }
    if (textField.tag == 4) {
        
        [birthField resignFirstResponder];
        
        [emailField becomeFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0, 165);

        
    }
    if (textField.tag == 5) {
        
        [emailField resignFirstResponder];
        [numberField becomeFirstResponder];
        
    }
    
    if (textField.tag ==6) {
        
        
        [numberField resignFirstResponder];
        [contactField becomeFirstResponder];
        
        pickView.hidden = YES;
        mainScrollView.contentOffset = CGPointMake(0, 165);
        
    }
    if (textField.tag ==7) {
        
        
        [contactField resignFirstResponder];
        [telephoneField becomeFirstResponder];
        
        pickView.hidden = YES;
        mainScrollView.contentOffset = CGPointMake(0, 110);
        
    }
    if (textField.tag ==8) {
        
        
        [telephoneField resignFirstResponder];
        pickView.hidden = YES;
        mainScrollView.contentOffset = CGPointMake(0, 0);
        
    }
    return YES;
    
}

-(void)save:(UITapGestureRecognizer*)tap
{
    NSLog(@"save");
    [nameField resignFirstResponder];
    [sexField resignFirstResponder];
    [mobileField resignFirstResponder];
    
    [birthField resignFirstResponder];
    [emailField resignFirstResponder];
    [telephoneField resignFirstResponder];
    [contactField resignFirstResponder];
    [numberField resignFirstResponder];
    mainScrollView.contentOffset = CGPointMake(0, 0);

    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
    
        int gender;
        
        if ([sexField.text isEqualToString:@"男"]) {
           
            gender = 0;
            
        }else{
        
        
            gender = 1;
            
        }
        NSString* type;
        if ([paperLabel.text isEqualToString:@"身份证"]) {
            
            type = @"ID";
            
        }else {
        
            type = @"PASSPORT";
        }
        
        

        UITextField* relationFieldname = (UITextField*)[contactImageView viewWithTag:7];
        UITextField* relationFieldtelephone = (UITextField*)[contactImageView viewWithTag:8];

        Result* result = [[Member sharedMember] updateMemberContestantWithMemberContestantID:self.memberContestant.memberContestantID
                                                                                        name:nameField.text
                                                                                      gender:gender
                                                                                      mobile:mobileField.text
                                                                                       email:emailField.text
                                                                                    birthday:birthField.text
                                                                              credentialType:type
                                                                            credentialNumber:numberField.text
                                                                               emergencyName:relationFieldname.text
                                                                            emergencyContact:relationFieldtelephone.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (result.isSuccess) {
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"信息修改成功" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
                
                
            }else{
            
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
            
            }
            
            
            
        });
        
        
        
        
        
    });
    
    
    
    
    
    

}
#pragma mark backButtonMethod
-(void)backButton
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)deleteButtonMethod:(UIButton*)bt
{
    
    
    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
    
        Result* result = [[Member sharedMember] removeMemberContestant:self.memberContestant.memberContestantID];
                
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
            if (result.isSuccess) {
                
          
                [self.navigationController popViewControllerAnimated:YES];
   
                
                
            } else{
            
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
                
             
            
            }
            
        });
        
        

  });
                   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
