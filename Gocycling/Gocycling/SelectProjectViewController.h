//
//  SelectProjectViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmViewController.h"

@interface SelectProjectViewController: UIViewController<UITableViewDataSource, UITableViewDelegate, ConfirmViewControllerDelegate>

@property (nonatomic, assign) int eventID;
@property (nonatomic, strong) NSDictionary* personInfomationDic;
@property (nonatomic, assign) int memberContestantId;

@end
