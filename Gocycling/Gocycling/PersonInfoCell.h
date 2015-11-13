//
//  PersonInfoCell.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PersonInfoCell : UITableViewCell



@property(nonatomic,strong) UILabel* nameLable;

@property(nonatomic,strong) UILabel* telephoneLable;

@property(nonatomic,strong) UILabel* emailLable;

@property(nonatomic,strong) UILabel* enrollProjectLable;
@property(nonatomic,strong) UILabel* projectnameLable;

@property(nonatomic,strong) UILabel* signalpeojectPriceLabel;


@property(nonatomic,strong) UILabel* totalPriceLabel;

@property(nonatomic,strong) UILabel* priceLabel;


//
@property(nonatomic,strong) UILabel* otherProjectnameLable;
@property(nonatomic,strong) UILabel* signalpriceLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(int)selectCount indexPath:(NSIndexPath*)path;




-(void)setCellData:(NSDictionary*)dic indexPath:(NSIndexPath*)path selectCount:(int)selectCount;



@end
