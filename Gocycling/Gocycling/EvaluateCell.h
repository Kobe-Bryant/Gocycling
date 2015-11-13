//
//  EvaluateCell.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateModel;

@class RatingView;
@interface EvaluateCell : UITableViewCell



@property(nonatomic,strong) UILabel* titleLable;

@property(nonatomic,strong) UITextView* textView;

@property(nonatomic,strong) RatingView* ratingView;

@property (nonatomic,strong) UILabel* timeLable;


-(void)setCellInformation:(EvaluateModel*)evaluateModel;

@end
