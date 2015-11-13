//
//  TitleView.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-4-2.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleViewDelegate <NSObject>

- (void)didClickedCloseButton;

@end


@interface TitleView : UIView

@property (nonatomic, assign) id<TitleViewDelegate>delegate;
@property (nonatomic, retain) UISearchBar *searchBar;

- (instancetype)initWithCustomFrame:(CGRect)customFrame;
- (void)setIsZoomSearchBar:(BOOL)isZoomSearchBar;

@end
