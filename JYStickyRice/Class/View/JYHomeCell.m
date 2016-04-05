//
//  JYHomeCell.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYHomeCell.h"
#import "JYHome.h"

@interface JYHomeCell()

@property (strong, nonatomic) NSString *dealId;//团单id
@property (weak, nonatomic) IBOutlet UIImageView *tinyImage;//小图链接
@property (weak, nonatomic) IBOutlet UILabel *title;//商户标题
@property (weak, nonatomic) IBOutlet UILabel *storeDescription;//商户描述
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;//市场价格，单位是分
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;//售卖价格，单位是分
@property (weak, nonatomic) IBOutlet UILabel *score;//用户评分
@property (weak, nonatomic) IBOutlet UILabel *distance;//距离

@end

@implementation JYHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 从xib中加载cell
    JYHomeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"JYHomeCell" owner:nil options:nil] lastObject];
    
    return cell;
}

- (NSString *)reuseIdentifier {
    return @"home";
}

- (void)setHome:(JYHome *)home
{
    _home = home;
    
    NSURL *url=[NSURL URLWithString:home.tiny_image];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    self.tinyImage.image = image;
    
    self.title.text = home.min_title;
    
    self.storeDescription.text = home.storeDescription;
    
    CGFloat marketPrice = [home.market_price floatValue]/100;
    NSString *string = [NSString stringWithFormat:@"%f", marketPrice];
    int marketPrice2 = [string intValue];
    self.marketPrice.text = [NSString stringWithFormat:@"%d", marketPrice2];
    
    CGFloat currentPrice = [home.current_price floatValue]/100;
    string = [NSString stringWithFormat:@"%f", currentPrice];
    int currentPrice2 = [string intValue];
    self.currentPrice.text = [NSString stringWithFormat:@"￥%d", currentPrice2];
    
    CGFloat score = [home.score floatValue];
    self.score.text = [NSString stringWithFormat:@"%f", score];
    self.score.text = [self.score.text substringToIndex:4];
    self.score.text = [NSString stringWithFormat:@"%@分", self.score.text];
    
    self.distance.text = @"";
}

- (void)awakeFromNib {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
