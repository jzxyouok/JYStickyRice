//
//  JYHomeCell.h
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYHome;

@interface JYHomeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) JYHome *home;

@end
