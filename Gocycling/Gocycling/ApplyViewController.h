//
//  ApplyViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) int currentEventID;
@property (nonatomic, assign) int currentCompetitionID;

@end
