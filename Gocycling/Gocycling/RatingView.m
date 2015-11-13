//
//  RatingView.m
//  fdfdfdf
//
//  Created by Apple on 14-3-18.
//  Copyright (c) 2014年 doocom. All rights reserved.
//

#import "RatingView.h"

#define ksmallYellowStarWidth 15
#define ksmallYellowStarHeight 14
#define  ksmallGaryStarWidth 15
#define ksmallGaryStarHeight 14

#define kbigYellowStarWidth 39
#define kbigYellowStarHeight 37
#define  kbigGaryStarWidth 39
#define kbigGaryStarHeight 37


@implementation RatingView
@synthesize lable;
- (id)initWithFrame:(CGRect)frame andFloat:(CGFloat)scorefloat starStyle:(NSInteger)style
{
    self = [super initWithFrame:frame ];
    if (self) {

        self.style =style;
        
         self.ratingfloat = scorefloat;
        
        [self initLable];
        [self initGraystar];
        [self initYellowstar];
     
        
    }
    return self;
}
-(void)initLable
{

    
    if (self.style == 0) {
        
        lable = [[UILabel alloc]initWithFrame:CGRectMake(80, -3, 50, 20)];
        lable.textColor = [UIColor grayColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = [NSString stringWithFormat:@"%0.f分",self.ratingfloat];
       [self addSubview:lable];
    }
    else
    {
       lable = [[UILabel alloc]initWithFrame:CGRectMake(210,15, 50, 20)];
        lable.textColor = [UIColor grayColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = [NSString stringWithFormat:@"%0.f分",self.ratingfloat];
        [self addSubview:lable];
    
    }
   
 
   
    
}


-(void)initGraystar
{
    
    
    
    smallgrayArray = [ NSMutableArray array];
    biggaryArray = [NSMutableArray array];
    
    for (int i = 0; i < 5;i++) {
        
        UIImageView* samllGaryimageView = [[UIImageView alloc]initWithFrame:CGRectZero];
       samllGaryimageView.image = [UIImage imageNamed:@"smallgrayStar.png"];
        [self addSubview:samllGaryimageView];
        [smallgrayArray addObject:samllGaryimageView];
        UIImageView* bigGrayimageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        bigGrayimageView.image = [UIImage imageNamed:@"biggrayStar.png"];
       [self addSubview:bigGrayimageView];
       [biggaryArray addObject:bigGrayimageView];
   }
    
    
}
-(void)initYellowstar
{
    
    smallyellowArray = [NSMutableArray arrayWithCapacity:5];
    bigyellowArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        
        UIImageView* samllYellowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        samllYellowImageView.image = [UIImage imageNamed:@"smallyellowStar.png"];
        [smallyellowArray addObject:samllYellowImageView];
        UIImageView* bigYellowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        bigYellowImageView.image = [UIImage imageNamed:@"bigyellowStar.png"];
        [bigyellowArray addObject:bigYellowImageView];
        
    }
}


-(void)layoutSubviews
{

    [super layoutSubviews];

    int index = 0;
    for (int i = 0; i < 5; i++) {
    
        
        if (self.style==ksmallStyle) {
            
            UIImageView* imageview = smallgrayArray[i];
            
            imageview.frame = CGRectMake(0+index, 0, ksmallGaryStarWidth, ksmallGaryStarHeight);
            
            index+=ksmallGaryStarWidth;
            
            [self addSubview:imageview];
            
            baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,75*(self.ratingfloat/5)
                                                             ,ksmallYellowStarHeight)];
            baseView.clipsToBounds = YES;
            
            int X = 0;
            for (int j =0; j < 5; j++) {
                
                UIImageView* imageview2 = smallyellowArray[j];
                imageview2.frame = CGRectMake(X, 0, ksmallYellowStarWidth, ksmallYellowStarHeight);
                X+=ksmallYellowStarWidth;
                [baseView addSubview:imageview2];
 }
            
            [self addSubview:baseView];
            
        }else {
        
       
            UIImageView* imageview = smallgrayArray[i];
            imageview.frame = CGRectMake(0+index, 0, kbigGaryStarWidth, kbigGaryStarHeight);
            index+=kbigGaryStarWidth;
            
            [self addSubview:imageview];
            
            baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,195*(self.ratingfloat/5)
                                                             ,kbigYellowStarHeight)];
            baseView.clipsToBounds = YES;
            
            int X = 0;
            for (int j =0; j < 5; j++) {
                
                UIImageView* imageview2 = smallyellowArray[j];
                
                imageview2.frame = CGRectMake(0+X, 0, kbigYellowStarWidth, kbigYellowStarHeight);
                X+=kbigYellowStarWidth;
               [baseView addSubview:imageview2];
           }
           [self addSubview:baseView];
            
        }
    }
}



@end
