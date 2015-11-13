//
//  ProductImage.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>

@interface ProductImage : NSObject

@property(nonatomic,assign) int productImageID;
@property(nonatomic,strong) NSString* imageURLString;
@property(nonatomic,strong) NSString* title;

@end
