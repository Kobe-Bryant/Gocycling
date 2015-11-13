//
//  Cell2.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "Cell2.h"
#import "Macros.h"
#import "CustomMarcos.h"

@interface Cell2 ()

@property (nonatomic) BOOL hasPrefix;

@end

@implementation Cell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.type = type;
    
    if (self) {

        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.textColor = UIColorFromRGB(178.0, 178.0, 178.0);
        
        
        UIView* separatorColor = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          self.frame.size.height - 0.5,
                                                                          self.contentView.frame.size.width,
                                                                          0.5)];
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            separatorColor.frame = CGRectMake(0,
                                              self.frame.size.height - 1.0,
                                              self.contentView.frame.size.width,
                                              1.0);
        }
        
        if (self.type == kfiltControllerType) {
            separatorColor.backgroundColor = UIColorFromRGB(83.0, 83.0, 83.0);
        } else {
            separatorColor.backgroundColor = UIColorFromRGB(199.0, 202.0, 204.0);
        }
        
        [self addSubview:separatorColor];
        
        
        // Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showPrefix:)
                                                     name:FILTER_SIDEBAR_FULL_SCREEN_CHANGED_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hidePrefix:)
                                                     name:FILTER_SIDEBAR_NORMAL_SCREEN_CHANGED_NOTIFICATION
                                                   object:nil];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"self.frame %@", NSStringFromCGRect(self.frame));

//    self.textLabel.frame = CGRectMake(37.5,
//                                      (self.frame.size.height - self.textLabel.frame.size.height) / 2.0,
//                                      self.textLabel.frame.size.width,
//                                      self.textLabel.frame.size.height);
//    
//    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 5.0,
//                                            (self.frame.size.height - self.detailTextLabel.frame.size.height) / 2.0,
//                                            self.detailTextLabel.frame.size.width,
//                                            self.detailTextLabel.frame.size.height);
 
    
    if (self.hasPrefix) {
        self.textLabel.frame = CGRectMake(15.0,
                                          0.0,
                                          self.frame.size.width - 15.0 * 2.0,
                                          self.frame.size.height);
    } else {
        self.textLabel.frame = CGRectMake(self.frame.size.width - FILTER_SIDEBAR_WIDTH + 15.0,
                                          0.0,
                                          FILTER_SIDEBAR_WIDTH - 15.0 * 2.0,
                                          self.frame.size.height);
    }

}

- (void)showPrefix:(NSNotification *)notification
{
    NSLog(@"showPrefix %@", notification);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.textLabel.frame = CGRectMake(15.0,
                                          0.0,
                                          self.frame.size.width - 15.0 * 2.0,
                                          self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hasPrefix = YES;
    }];
}

- (void)hidePrefix:(NSNotification *)notification
{
    NSLog(@"hidePrefix %@", notification);
    [UIView animateWithDuration:0.3 animations:^{
        self.textLabel.frame = CGRectMake(self.frame.size.width - FILTER_SIDEBAR_WIDTH + 15.0,
                                          0.0,
                                          FILTER_SIDEBAR_WIDTH - 15.0 * 2.0,
                                          self.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.hasPrefix = NO;
    }];
    
}

@end
