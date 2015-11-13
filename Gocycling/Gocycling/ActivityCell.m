//
//  ActivityCell.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "ActivityCell.h"
#import "Macros.h"
#import "OrderContestant.h"

@interface ActivityCell ()

@property (nonatomic, retain) UIView *contestantListView;

@end

@implementation ActivityCell

@synthesize imageView,titleLable,quotanumberLable,priceLable,quoteLable,momenyLable;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        UIImage* image = [UIImage imageNamed:@"bai.png"];

        imageView = [ [UIImageView alloc]initWithFrame:CGRectMake(20, 17,
                                                    image.size.width, image.size.height)];
        
        [self.contentView addSubview:imageView];
        
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(45, 16, 180, 25)];
        
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        
        
        titleLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:titleLable];
        
        
        quoteLable = [[UILabel alloc]initWithFrame:CGRectMake(240, 15, 30, 10)];
        quoteLable.backgroundColor = [UIColor clearColor];
        quoteLable.font = [UIFont systemFontOfSize:12];
        quoteLable.text = @"名额";
        quoteLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(126.0, 126.0, 126.0).CGColor];

        [self.contentView addSubview:quoteLable];
        
        
        quotanumberLable = [[UILabel alloc]initWithFrame:CGRectMake(265, 15, 55, 10)];
        
        quotanumberLable.font = [UIFont systemFontOfSize:12];
        
        quotanumberLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(75.0, 131.0, 201.0).CGColor];
        quotanumberLable.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:quotanumberLable];
        
        
        momenyLable = [[UILabel alloc]initWithFrame:CGRectMake(240, 30, 70, 15)];
        
        momenyLable.text = @"费用";
        momenyLable.backgroundColor = [UIColor clearColor];
        momenyLable.font = [UIFont systemFontOfSize:12];
        
        momenyLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(126.0, 126.0, 126.0).CGColor];
        
        [self.contentView addSubview:momenyLable];
        
        
        priceLable = [[UILabel alloc]initWithFrame:CGRectMake(265, 30, 55, 15)];
        
        priceLable.backgroundColor = [UIColor clearColor];
        priceLable.font = [UIFont systemFontOfSize:12];
        
        priceLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(230.0, 0, 18.0).CGColor];
        
        [self.contentView addSubview:priceLable];
        
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
    
            quoteLable.frame = CGRectMake(240, 15, 30, 15);
            
            quotanumberLable.frame = CGRectMake(265, 15, 30, 15);

            momenyLable.frame = CGRectMake(240, 32, 30, 15);

            priceLable.frame = CGRectMake(265, 32, 30, 15);

            
        }
        
        
        
        self.contestantListView = [[UIView alloc] init];
        self.contestantListView.frame = CGRectMake(10.0, 60.0, self.frame.size.width - 20.0, 50.0);
        self.contestantListView.backgroundColor = UIColorFromRGB(243.0, 243.0, 243.0);
        [self.contentView addSubview:self.contestantListView];
        
        UILabel *contestantTipsLabel = [[UILabel alloc] init];
        contestantTipsLabel.frame = CGRectMake(0.0, 0.0, 100.0, 50.0);
        contestantTipsLabel.font = [UIFont systemFontOfSize:15.0];
        contestantTipsLabel.textColor = UIColorFromRGB(104.0, 104.0, 104.0);
        contestantTipsLabel.text = @"    您已经报：";
        contestantTipsLabel.backgroundColor = [UIColor clearColor];
        [self.contestantListView addSubview:contestantTipsLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];



}

- (void)setContestantListArray:(NSArray *)contestantListArray
{
    NSUInteger index = 0;
    for (OrderContestant *orderContestant in contestantListArray) {
        CGFloat x = 100.0;
        x += 100.0 * index;
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(x, 0.0, 100.0, 50.0);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:UIColorFromRGB(54.0, 87.0, 201.0) forState:UIControlStateNormal];
        [button setTitle:[[NSString alloc] initWithFormat:@"%i.%@", index + 1, orderContestant.memberContestant.name] forState:UIControlStateNormal];
        [self.contestantListView addSubview:button];
        index++;
    }
}

@end
