//
//  RatingView.h
//  fdfdfdf
//
//  Created by Apple on 14-3-18.
//  Copyright (c) 2014年 doocom. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef  enum starStyle  {
    ksmallStyle = 0,
    knomalSsyle = 1

}starStyle ;


@interface RatingView : UIView

{
    NSMutableArray* smallyellowArray;
    UIView* baseView;
    NSMutableArray* smallgrayArray;
    NSMutableArray* bigyellowArray;
    NSMutableArray* biggaryArray;
    
}
@property CGFloat ratingfloat;
@property   UILabel* lable;
@property(nonatomic,assign)  starStyle style;

- (id)initWithFrame:(CGRect)frame andFloat:(CGFloat)scorefloat starStyle:(NSInteger)style;


@end
