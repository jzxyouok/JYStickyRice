//
//  JYHome.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYHome.h"

@implementation JYHome

+ (instancetype)homeWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.storeDescription = [NSString stringWithString:dict[@"description"]];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"description"]) {
        ;
    }
}

@end
