//
//  ActivityRegisterCell.h
//  Gocycling
//
//  Created by Apple on 14-4-14.
//
//

#import <UIKit/UIKit.h>
@class EventList;

@interface ActivityRegisterCell : UITableViewCell

@property(nonatomic,strong) UILabel* mainLable;
@property(nonatomic,strong) UILabel* subLable;
@property(nonatomic,strong) UIImageView* imageView;
@property(nonatomic,strong) UIImageView* smallImageView;

-(void)setCellInfo:(EventList*)model;
@end
