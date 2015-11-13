//
//  EnrollCell.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "EnrollCell.h"
#import "Macros.h"
#import "Member.h"
#import "Order.h"

@implementation EnrollCell


@synthesize enrollLableText,enrollTimeLable,enrollTimeLableText;
@synthesize stausLable,stausLableText,totalPriceLable,totalPriceLableText;
@synthesize enrollLable,enrollcountLable,enrollcountLableText,lineImageView,titleLabel;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setNumberOfLines:2];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
        [self.contentView addSubview:titleLabel];
        
        
        lineImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:lineImageView];
        
        
        enrollLable = [[UILabel alloc]initWithFrame:CGRectZero];
        enrollLable.font = [UIFont systemFontOfSize:12];
        enrollLable.backgroundColor = [UIColor clearColor];
        enrollLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:enrollLable];
        
        
        stausLable = [[UILabel alloc]initWithFrame:CGRectZero];
        stausLable.font = [UIFont systemFontOfSize:12];
        stausLable.backgroundColor = [UIColor clearColor];
        stausLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:stausLable];
        
        
        totalPriceLable = [[UILabel alloc]initWithFrame:CGRectZero];
        totalPriceLable.font = [UIFont systemFontOfSize:12];
        totalPriceLable.backgroundColor = [UIColor clearColor];
        totalPriceLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:totalPriceLable];
        
        
        enrollTimeLable = [[UILabel alloc]initWithFrame:CGRectZero];
        enrollTimeLable.font = [UIFont systemFontOfSize:12];
        enrollTimeLable.backgroundColor = [UIColor clearColor];
        enrollTimeLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:enrollTimeLable];
        
        
        enrollcountLable = [[UILabel alloc]initWithFrame:CGRectZero];
        enrollcountLable.font = [UIFont systemFontOfSize:12];
        enrollcountLable.backgroundColor = [UIColor clearColor];
        enrollcountLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:enrollcountLable];
        
        
        
        enrollLableText = [[UILabel alloc]initWithFrame:CGRectZero];
        enrollLableText.font = [UIFont systemFontOfSize:12];
        enrollLableText.backgroundColor = [UIColor clearColor];
        enrollLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB(230.0, 0, 18.0).CGColor];
        [self.contentView addSubview:enrollLableText];
        
        
        
        stausLableText = [[UILabel alloc]initWithFrame:CGRectZero];
        stausLableText.backgroundColor = [UIColor clearColor];
        stausLableText.font = [UIFont systemFontOfSize:12];
        stausLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB(230.0, 0, 18.0).CGColor];
        [self.contentView addSubview:stausLableText];
        
        
        totalPriceLableText = [[UILabel alloc]initWithFrame:CGRectZero];
        totalPriceLableText.font = [UIFont systemFontOfSize:12];
        totalPriceLableText.backgroundColor = [UIColor clearColor];
        totalPriceLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB(230.0, 0, 18.0).CGColor];
        [self.contentView addSubview:totalPriceLableText];
        
        
        enrollTimeLableText = [[UILabel alloc]initWithFrame:CGRectZero];
        enrollTimeLableText.font = [UIFont systemFontOfSize:12];
        enrollTimeLableText.backgroundColor = [UIColor clearColor];
        enrollTimeLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB(192.0, 192.0, 192.0).CGColor];
        [self.contentView addSubview:enrollTimeLableText];
        enrollcountLableText = [[UILabel alloc]initWithFrame:CGRectZero];
        
       
        enrollcountLableText.font = [UIFont systemFontOfSize:12];
        enrollcountLableText.backgroundColor = [UIColor clearColor];
        enrollcountLableText.textColor = [UIColor colorWithCGColor:UIColorFromRGB(230.0, 0, 18.0).CGColor];
        [self.contentView addSubview:enrollcountLableText];
        
        
        
    }
    return self;
}

-(void)layoutSubviews{


    [super layoutSubviews];
    
    
    titleLabel.frame = CGRectMake(15, 5, 270, 60);
    
    UIImage* image = [UIImage imageNamed:@"cellcontentline.png"];
    
    lineImageView.image = image;
    lineImageView.frame = CGRectMake(0, 70,image.size.width,image.size.height);
    
    enrollLable.frame = CGRectMake(23, 85, 57, 12);
    enrollLable.text = @"报名编号 :";
    
    stausLable.frame = CGRectMake(165, 85, 56, 12);
    stausLable.text = @"状       态 :";
    
    totalPriceLable.frame = CGRectMake(23, 105, 57, 12);
    totalPriceLable.text = @"总       价 :";
    
    enrollTimeLable.frame = CGRectMake(165, 105, 56, 12);
    enrollTimeLable.text = @"报名时间 :";
    
    enrollcountLable.frame = CGRectMake(23, 125, 57, 12);
    enrollcountLable.text = @"报名人数 :";
    
    enrollLableText.frame = CGRectMake(85, 85, 100, 12);
    
    stausLableText.frame = CGRectMake(226, 85, 65, 12);
    
    totalPriceLableText.frame = CGRectMake(85, 105, 60, 12);
    
    enrollTimeLableText.frame = CGRectMake(226,105 , 100, 12);
    
    enrollcountLableText.frame = CGRectMake(85, 125, 60, 12);
    
    
    
}

-(void)setcellInfo:(Order*)list
{

    NSLog(@"%f",list.matchPrice);
    
    titleLabel.text = list.matchTitleString;
    
    enrollLableText.text = list.orderNumber;
    
    stausLableText.text = list.status;
    
    totalPriceLableText.text = [NSString stringWithFormat:@"%0.f",list.matchPrice];
    
    enrollTimeLableText.text = list.singupTime;
    
    enrollcountLableText.text = [NSString stringWithFormat:@"%d人",list.competitionQuantity];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
