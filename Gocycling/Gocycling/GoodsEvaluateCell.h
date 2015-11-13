//
//  GoodsEvaluateCell.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class getProductEvaluate;

@class RatingView;
@interface GoodsEvaluateCell : UITableViewCell


@property(nonatomic,strong) UILabel* nameLable;

@property(nonatomic,strong) UITextView* textView;

@property(nonatomic,strong) RatingView* ratingView;

@property (nonatomic,strong) UILabel* timeLable;


-(void)setCellInformation:(getProductEvaluate*)evaluateModel;
@end
