//
//  EnrollDetailCell.m
//  Gocycling
//
//  Created by Apple on 14-4-25.
//
//

#import "EnrollDetailCell.h"
#import "Macros.h"
#import "Member.h"
#import "Order.h"

@implementation EnrollDetailCell

@synthesize nameLable,emailLable,telephoneLable,projectnameLable,totalPriceLabel,signalpeojectPriceLabel;

@synthesize priceLabel,otherProjectnameLable,signalpriceLable;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 200,15)];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15];
        
        nameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:nameLable];
        
        
        telephoneLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 200,15)];
        telephoneLable.backgroundColor = [UIColor clearColor];
        telephoneLable.font = [UIFont systemFontOfSize:15];
        
        telephoneLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:telephoneLable];
        
        
        emailLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 280,15)];
        emailLable.backgroundColor = [UIColor clearColor];
        emailLable.font = [UIFont systemFontOfSize:15];
        
        emailLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:emailLable];
        
        
        projectnameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 17, 200,15)];
        projectnameLable.backgroundColor = [UIColor clearColor];
        projectnameLable.font = [UIFont systemFontOfSize:15];
        
        projectnameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:projectnameLable];
        
        
        signalpeojectPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 17, 70,15)];
        signalpeojectPriceLabel.backgroundColor = [UIColor clearColor];
        signalpeojectPriceLabel.font = [UIFont systemFontOfSize:15];
        
        signalpeojectPriceLabel.textColor = [UIColor redColor];
        
        [self.contentView addSubview:signalpeojectPriceLabel];
        
        
        //
        otherProjectnameLable = [[UILabel alloc]initWithFrame:CGRectMake(95, 55, 200, 15)];
        otherProjectnameLable.backgroundColor = [UIColor clearColor];
        otherProjectnameLable.font = [UIFont systemFontOfSize:15];
        otherProjectnameLable.hidden = YES;
        otherProjectnameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:otherProjectnameLable];
        
        signalpriceLable = [[UILabel alloc]initWithFrame:CGRectMake(220, 55, 70, 15)];
        signalpriceLable.backgroundColor = [UIColor clearColor];
        signalpriceLable.font = [UIFont systemFontOfSize:15];
        signalpriceLable.hidden = YES;
        signalpriceLable.textColor = [UIColor redColor];
        
        [self.contentView addSubview:signalpriceLable];
        
        
        
        
        
        totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 17, 280,15)];
        totalPriceLabel.backgroundColor = [UIColor clearColor];
        totalPriceLabel.font = [UIFont systemFontOfSize:15];
        
        totalPriceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:totalPriceLabel];
        
        
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 17, 280,15)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont systemFontOfSize:15];
        
        priceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:priceLabel];
        
    }
    return self;
}

-(void)setCellData:(Order*)orderList indexPath:(NSIndexPath*)path selectCount:(int)selectCount
{
    

    switch (path.row) {
                
               case 0:{
            
                nameLable.text = [NSString stringWithFormat:@"姓名:  %@",orderList.name];
                
               }
                break;
            case 1:
                   
                  telephoneLable.text = [NSString stringWithFormat:@"电话:  %@",orderList.mobile];
                   

                break;
                
            case 2:
              emailLable.text = [NSString stringWithFormat:@"邮箱:  %@",  orderList.email];
                
                break;
                
            case 3:
                
                   
                   projectnameLable.text = [NSString stringWithFormat:@"报名项目:  %@ ",orderList.subTitle];
                   signalpeojectPriceLabel.text = [NSString stringWithFormat:@"￥%0.f",orderList.singlematchPrice];
                
                
                break;
                
               case 4:
        
                   
                   
                       totalPriceLabel.text = [NSString stringWithFormat:@"合计:%0.f",orderList.subtotalPrice];

         
                break;
                
            default:
                break;
        }
        
        
 }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    
    
}

@end