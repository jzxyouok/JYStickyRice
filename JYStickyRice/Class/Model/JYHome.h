//
//  JYHome.h
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//
//deal_id			团单id				int
//image			图片链接			string
//tiny_image		小图链接			string
//title			商户标题			string
//description		商户描述			string
//market_price	市场价格，单位是分	int
//current_price	售卖价格，单位是分	int
//promotion_price	活动价格，单位是分	int
//sale_num		已售团单数量		int
//score			用户评分			float
//comment_num		用户评论个数 		int
//deal_url		Pc团单详情页		string
//deal_murl		Wap团详情页			string

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYHome : NSObject

//团单id
@property (strong, nonatomic) NSNumber *deal_id;
//小图链接
@property (strong, nonatomic) NSString *tiny_image;
//商户标题
@property (strong, nonatomic) NSString *min_title;
//商户描述
@property (strong, nonatomic) NSString *storeDescription;
//市场价格，单位是分
@property (strong, nonatomic) NSNumber *market_price;
//售卖价格，单位是分
@property (strong, nonatomic) NSNumber *current_price;
//用户评分
@property (strong, nonatomic) NSNumber *score;
//距离
@property (strong, nonatomic) NSString *distance;

+ (instancetype)homeWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
