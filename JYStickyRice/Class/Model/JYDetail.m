//
//  JYDetail.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/22.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYDetail.h"

@implementation JYDetail

+ (instancetype)detailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.long_title = dict[@"long_title"];
        self.image = dict[@"image"];
        self.consumer_tips = dict[@"consumer_tips"];
        self.buy_details = dict[@"buy_details"];
        self.market_price = dict[@"market_price"];
        self.current_price = dict[@"current_price"];
        self.sale_num = dict[@"sale_num"];
        //NSLog(@"%@",dict);
        //[self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
