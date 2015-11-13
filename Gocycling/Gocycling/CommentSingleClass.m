//
//  CommentSingleClass.m
//  L14_single_01
//
//  Created by TheClass on 13-10-8.
//  Copyright (c) 2013年 TheClass. All rights reserved.
//

#import "CommentSingleClass.h"
static CommentSingleClass* instance = nil;
@interface CommentSingleClass()
{
    NSString* info;
    
}
@end
@implementation CommentSingleClass
//第一步，让new和init失效。
-(id)init
{
//    NSAssert叫做断言。
//    当断言的第一个参数是NO的时候，断言打印出第二个参数制定的信息。
    NSAssert(NO, @"Do not use this function");
    return nil;
}
//第二步写一个静态方法来初始化并返回唯一的实例。
+(CommentSingleClass*)getSingle
{
//    声明一个全局的静态变量。
    if (instance!=nil) {
        return instance;
    }
//    使用一个全局的线程锁，这个线程锁，保证同时只有一个线程在调用初始化过程。
    static dispatch_once_t lock;
//    使用线程锁创建实例。
    dispatch_once(&lock, ^{
        
        
        
        instance = [[self alloc]initSingle];
     
    });
    return instance;
}
//真正的初始化方法，这个方法不能在头文件中声明。
//命名时要注意，不要让对方可以轻易的猜出你的初始化方法。
-(id)initSingle
{
    if (self = [super init]) {
        info = @"single";
        self.competionIDArray= [NSMutableArray array];
        self.competionNameArray= [NSMutableArray array];

 
    }
    return self;
}

@end






















