//
//  EnlistDetailViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-31.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlistDetailViewController : UIViewController<UITableViewDataSource,
                                                          UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,assign) int orderCompetionId;

@end
