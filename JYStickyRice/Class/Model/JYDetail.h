//
//  JYDetail.h
//  JYStickyRice
//
//  Created by mac mini on 16/3/22.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYDetail : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *long_title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *consumer_tips;
@property (strong, nonatomic) NSString *buy_details;
@property (strong, nonatomic) NSNumber *market_price;
@property (strong, nonatomic) NSNumber *current_price;
@property (strong, nonatomic) NSNumber *sale_num;

+ (instancetype)detailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
