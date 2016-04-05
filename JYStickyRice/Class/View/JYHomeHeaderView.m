//
//  JYHomeHeaderView.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYHomeHeaderView.h"

const int MJImageCount = 5;

@interface JYHomeHeaderView() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSTimer *timer;

@end


@implementation JYHomeHeaderView

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"JYHomeHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    // 1.添加图片
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width-16;
    CGFloat imageH = imageW*13/30;
    CGFloat imageY = 0;
    for (int index = 1; index <= MJImageCount; index++) {
        CGFloat imageX = (index - 1) * imageW;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"nuomilunboqi_%02d", index]];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置内容尺寸
    self.scrollView.contentSize = CGSizeMake(imageW * MJImageCount, 0);
    self.scrollView.pagingEnabled = YES;
    
    // 3.分页
    self.pageControl.numberOfPages = MJImageCount;
    
    // 4.定时器
    self.timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 5.设置 frame
    self.frame = CGRectMake(0, 0, self.frame.size.width, imageH+_label.frame.size.height-4);
}

- (void)nextImage
{
    // 1.下一页
    if (self.pageControl.currentPage == MJImageCount - 1) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage++;
    }
    
    // 2.设置滚动
    CGPoint offset = CGPointMake(self.scrollView.frame.size.width * self.pageControl.currentPage, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.timer) return;
    self.pageControl.currentPage = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
}

@end

