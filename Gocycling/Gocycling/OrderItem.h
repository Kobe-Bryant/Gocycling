//
//  OrderItem.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject

@property (nonatomic, strong) NSString* categoryTitle;
@property (nonatomic, assign) float singlematchPrice;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) float subtotalPrice;
@property (nonatomic, strong) NSMutableArray* competionArray;

@end
