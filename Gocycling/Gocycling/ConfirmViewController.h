//
//  ConfirmViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmViewControllerDelegate <NSObject>

- (void)toggleClickBackButton:(id)sender;

@end





@interface ConfirmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) int selectCount;
@property(nonatomic,strong) NSDictionary* personInfomationDic;
@property(nonatomic,assign) int activityID;

@property (nonatomic, assign) id<ConfirmViewControllerDelegate>toogleClickDelegate;


@end
