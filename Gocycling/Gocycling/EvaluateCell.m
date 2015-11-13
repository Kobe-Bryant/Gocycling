//
//  EvaluateCell.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "EvaluateCell.h"
#import "RatingView.h"
#import "Macros.h"
#import "Member.h"
#import "ProductComment.h"

@implementation EvaluateCell

@synthesize timeLable,titleLable,textView,ratingView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 15)];
        
        titleLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
        
        titleLable.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:titleLable];
        
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 37, 300, 55)];
  
        textView.textColor = [UIColor colorWithCGColor:UIColorFromRGB(104.0, 104.0, 104.0).CGColor];

        if (IOS_VERSION_GREATER_THAN(@"7.0")) {
            
            textView.selectable = NO;

        }else {
            
            textView.clearsOnInsertion = YES;
            textView.editable = NO;
        }
        
        textView.font = [UIFont systemFontOfSize:12];

        [self.contentView addSubview:textView];
        
        
        UIImage* image = [UIImage imageNamed:@"gray.png"];
 
        ratingView = [[RatingView alloc]initWithFrame:CGRectMake(20, 102, 200,image.size.height) andFloat:4 starStyle:0];
        
        ratingView.style = 0;
        
        [self.contentView addSubview:ratingView];
        
        timeLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 106, 200, 9)];
        
        timeLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(104.0, 104.0, 104.0).CGColor];

        timeLable.font = [UIFont systemFontOfSize:12];

        [self.contentView addSubview:timeLable];
        
}
    return self;
}

- (void)setCellInformation:(ProductComment *)commentList
{

    titleLable.text = commentList.productName;
    textView.text = commentList.message;
    ratingView.ratingfloat= commentList.ratingFloat;
    timeLable.text = commentList.dateString;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
