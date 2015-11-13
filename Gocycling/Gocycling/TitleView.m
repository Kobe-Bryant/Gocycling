//
//  TitleView.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-4-2.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "TitleView.h"

@interface TitleView ()

@property (nonatomic) CGRect customFrame;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIButton *cancelButton;
//@property (nonatomic, readwrite) BOOL isLoaded;

@end

@implementation TitleView

@synthesize searchBar;

- (instancetype)initWithCustomFrame:(CGRect)customFrame
{
    self = [super initWithFrame:customFrame];
    if (self) {
        self.customFrame = customFrame;
        
        UIImage *logoImage = [UIImage imageNamed:@"tabbar.png"];
        self.logoImageView = [[UIImageView alloc] init];
        self.logoImageView.frame = CGRectMake(6.0,
                                              (self.customFrame.size.height - self.logoImageView.image.size.height) / 2.0,
                                              self.logoImageView.image.size.width,
                                              self.logoImageView.image.size.height);
        self.logoImageView.image = logoImage;
        [self addSubview:self.logoImageView];
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.frame = CGRectMake(105.0,
                                          (self.customFrame.size.height - 35.0) / 2.0,
                                          204.0,
                                          35.0);
        self.searchBar.backgroundColor = [UIColor clearColor];
        UIImage* searchBarImage = [UIImage imageNamed:@"navigationshadowImage"];
        self.searchBar.backgroundImage = searchBarImage;
        self.searchBar.placeholder = @"请输入搜索的关键字";
        self.searchBar.userInteractionEnabled = YES;
        [self addSubview:self.searchBar];

        
        
        UIImage* cancelImage = [UIImage imageNamed:@"cancel_.png"];
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(self.customFrame.size.width - cancelImage.size.width - 20.0,
                                             (self.customFrame.size.height - cancelImage.size.height) / 2.0 - 1.0,
                                             cancelImage.size.width,
                                             cancelImage.size.height);
        self.cancelButton.hidden = YES;
        [self.cancelButton addTarget:self
                              action:@selector(cancel:)
                    forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.userInteractionEnabled = YES;
        [self addSubview:self.cancelButton];

    }
    return self;
}

-(void)layoutSubviews
{

    [super layoutSubviews];
    

    
//    if (self.isLoaded) {
//        return;
//    } else {
//        self.isLoaded = YES;
//    }
    
//    if (self.frame.size.width != self.customFrame.size.width
//        || self.frame.size.height != self.customFrame.size.height) {
//        self.frame = self.customFrame;
//    }
  
    
    self.logoImageView.frame = CGRectMake(6.0,
                                          (self.customFrame.size.height - self.logoImageView.image.size.height) / 2.0,
                                          self.logoImageView.image.size.width,
                                          self.logoImageView.image.size.height);

//    if (self.logoImageView.hidden) {
//        self.searchBar.frame = CGRectMake(9.0,
//                                          (self.customFrame.size.height - 35.0) / 2.0,
//                                          244.0,
//                                          35.0);
//    } else {
//        self.searchBar.frame = CGRectMake(110.0,
//                                          (self.customFrame.size.height - 35.0) / 2.0,
//                                          204.0,
//                                          35.0);
//    }

    self.cancelButton.frame = CGRectMake(self.customFrame.size.width - self.cancelButton.frame.size.width - 20.0,
                                         (self.customFrame.size.height - self.cancelButton.frame.size.height) / 2.0 - 1.0,
                                         self.cancelButton.frame.size.width,
                                         self.cancelButton.frame.size.height);
//
//    
}

- (void)setIsZoomSearchBar:(BOOL)isZoomSearchBar
{
    if (isZoomSearchBar) {
        self.cancelButton.alpha = 0.0;
        self.cancelButton.hidden = NO;

        [UIView animateWithDuration:0.25 animations:^{
            self.logoImageView.alpha = 0.0;
            self.searchBar.frame = CGRectMake(0.0,
                                              (self.customFrame.size.height - 35.0) / 2.0,
                                              244.0,
                                              35.0);
            self.cancelButton.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.logoImageView.hidden = YES;
            }
        }];
    } else {
        self.logoImageView.hidden = NO;
        self.searchBar.text = @"";
        [self.searchBar resignFirstResponder];

        [UIView animateWithDuration:0.25 animations:^{
            self.logoImageView.alpha = 1.0;
            self.searchBar.frame = CGRectMake(105.0,
                                              (self.customFrame.size.height - 35.0) / 2.0,
                                              204.0,
                                              35.0);
            self.cancelButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.cancelButton.hidden = YES;
            }
        }];
    }
}

- (void)cancel:(UIButton *)button
{
    NSLog(@"cancel %@", button);
    [self setIsZoomSearchBar:NO];
    [self.delegate didClickedCloseButton];
}


@end
