//
//  EnrollDetailCell.h
//  Gocycling
//
//  Created by Apple on 14-4-25.
//
//

#import <UIKit/UIKit.h>

@class GetOrderDetail;

@interface EnrollDetailCell : UITableViewCell



@property(nonatomic,strong) UILabel* nameLable;

@property(nonatomic,strong) UILabel* telephoneLable;

@property(nonatomic,strong) UILabel* emailLable;

@property(nonatomic,strong) UILabel* projectnameLable;

@property(nonatomic,strong) UILabel* signalpeojectPriceLabel;


@property(nonatomic,strong) UILabel* totalPriceLabel;

@property(nonatomic,strong) UILabel* priceLabel;


//
@property(nonatomic,strong) UILabel* otherProjectnameLable;
@property(nonatomic,strong) UILabel* signalpriceLable;




-(void)setCellData:(GetOrderDetail*)orderList indexPath:(NSIndexPath*)path selectCount:(int)selectCount;



@end