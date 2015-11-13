//
//  EnrollCell.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetOrderList;

@interface EnrollCell : UITableViewCell

@property(nonatomic,strong) UILabel* titleLabel;

@property(nonatomic,strong) UIImageView* lineImageView;



@property (nonatomic,strong) UILabel* enrollLable;
@property(nonatomic,strong) UILabel* stausLable;
@property(nonatomic,strong) UILabel* totalPriceLable;
@property(nonatomic,strong) UILabel* enrollTimeLable;
@property(nonatomic,strong) UILabel* enrollcountLable;


@property (nonatomic,strong) UILabel* enrollLableText;
@property(nonatomic,strong) UILabel* stausLableText;
@property(nonatomic,strong) UILabel* totalPriceLableText;
@property(nonatomic,strong) UILabel* enrollTimeLableText;
@property(nonatomic,strong) UILabel* enrollcountLableText;

-(void)setcellInfo:(GetOrderList*)list;


@end
