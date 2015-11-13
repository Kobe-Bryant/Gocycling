//
//  CommentSingleClass.h
//  L14_single_01
//
//  Created by TheClass on 13-10-8.
//  Copyright (c) 2013年 TheClass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentSingleClass : NSObject

@property(nonatomic,strong) NSDictionary* singleDic;
@property(nonatomic,strong) NSMutableArray* competionIDArray;
@property(nonatomic,strong) NSMutableArray* competionNameArray;



+(CommentSingleClass*)getSingle;
@end
