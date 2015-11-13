//
//  ActivityCell.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell


@property(nonatomic,strong) UIImageView* imageView;

@property(nonatomic,strong) UILabel* titleLable;

@property(nonatomic,strong) UILabel* quoteLable;
@property(nonatomic,strong) UILabel* momenyLable;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,assign) BOOL isDisabled;

@property(nonatomic,strong) UILabel* quotanumberLable;


@property(nonatomic,strong) UILabel* priceLable;

- (void)setContestantListArray:(NSArray *)contestantListArray;


@end
