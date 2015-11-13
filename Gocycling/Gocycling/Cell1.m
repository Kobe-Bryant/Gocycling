//
//  Cell1.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "Cell1.h"
#import "Macros.h"
#import "CustomMarcos.h"

@interface Cell1 ()

@property (nonatomic) BOOL hasPrefix;

@end

@implementation Cell1


@synthesize firstArrowImageView, secondArrowImageView, thirdArrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellControllerType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(49.0, 49.0, 49.0);
        self.type = type;
        if (self.type == kfilterControllerType) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                UIView* separatorColor = [[UIView alloc] initWithFrame:CGRectMake(0, 43.0 + 0.5, self.contentView.frame.size.width, 0.5)];
                separatorColor.backgroundColor = UIColorFromRGB(83.0, 83.0, 83.0);
                [self.contentView addSubview:separatorColor];
            } else {
                UIView* linebackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1, 320, 0.5)];
                linebackView.backgroundColor = UIColorFromRGB(83.0, 83.0, 83.0);
                [self addSubview:linebackView];
            }
        } else {
            UIView* separatorColor = [[UIView alloc] initWithFrame:CGRectMake(0, 150.0 - 1.0, self.contentView.frame.size.width, 0.5)];
            if (IOS_VERSION_LESS_THAN(@"7.0")) {
                separatorColor.frame = CGRectMake(0, 150.0 - 1.0, self.contentView.frame.size.width, 1.0);
            }
            separatorColor.backgroundColor = UIColorFromRGB(199.0, 202.0, 204.0);
            [self.contentView addSubview:separatorColor];
        }
        
//        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 40, 25)];
        self.textLabel.textColor = UIColorFromRGB(236.0, 236.0, 236.0);
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
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
    NSLog(@"self.textLabel.frame %@", NSStringFromCGRect(self.textLabel.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        [UIView animateWithDuration:5 animations:^{
            self.firstArrowImageView.image = [UIImage imageNamed:@"cellchange.png"];
            self.secondArrowImageView.image = [UIImage imageNamed:@"cellchange.png"];
            self.thirdArrowImageView.image = [UIImage imageNamed:@"cellchange.png"];
        }];
    } else {
        self.firstArrowImageView.image = [UIImage imageNamed:@"cellimage.png"];
        self.secondArrowImageView.image = [UIImage imageNamed:@"cellimage.png"];
        self.thirdArrowImageView.image = [UIImage imageNamed:@"cellimage.png"];
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
