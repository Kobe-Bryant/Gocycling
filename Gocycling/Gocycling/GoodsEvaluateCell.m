//
//  GoodsEvaluateCell.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "GoodsEvaluateCell.h"
#import "Macros.h"
#import "RatingView.h"
#import "ProductComment.h"

@implementation GoodsEvaluateCell
@synthesize nameLable,textView,ratingView,timeLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 15)];
        nameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (49.0, 49.0, 49.0).CGColor];
        nameLable.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLable];
        
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(16, 37, 300, 55)];
        textView.editable = NO;
        textView.clearsOnInsertion = YES;
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            textView.selectable = NO;
            
        }
        textView.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
        textView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:textView];
        
        timeLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 106, 200, 9)];
        timeLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (104.0, 104.0, 104.0).CGColor];
        timeLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeLable];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setCellInformation:(ProductComment*)productEvaluate
{
    
    ratingView = [[RatingView alloc]initWithFrame:CGRectMake(20, 102, 200,
                          0) andFloat: productEvaluate.ratingFloat starStyle:0];
    [self.contentView addSubview:ratingView];

    nameLable.text = productEvaluate.memberName;
    textView.text = productEvaluate.message;
    ratingView.ratingfloat= productEvaluate.ratingFloat;
    timeLable.text = productEvaluate.dateString;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
