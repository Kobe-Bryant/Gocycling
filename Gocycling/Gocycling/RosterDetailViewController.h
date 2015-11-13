//
//  RosterDetailViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-27.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface RosterDetailViewController : UIViewController<UITableViewDataSource,
       UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) MemberContestant* memberContestant;


@end
