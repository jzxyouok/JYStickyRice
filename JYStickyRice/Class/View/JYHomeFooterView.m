//
//  JYHomeFooterView.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYHomeFooterView.h"

@interface JYHomeFooterView()
- (IBAction)loadBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadInicator;
@end

@implementation JYHomeFooterView

+ (instancetype)footerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"JYHomeFooterView" owner:nil options:nil] lastObject];
}

/**
 *  点击"加载"按钮
 */
- (IBAction)loadBtnClick {
    // 1.隐藏加载按钮
    self.loadBtn.hidden = YES;
    
    // 2.显示"正在加载"
    self.loadInicator.hidden = NO;
    [self.loadInicator startAnimating];//启动
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(homeFooterViewDidClickedLoadBtn:)]) {
        [self.delegate homeFooterViewDidClickedLoadBtn:self];
    }
    
    // 3.显示更多的数据
    // GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 3.0s后执行block里面的代码
        
        // 4.显示加载按钮
        self.loadBtn.hidden = NO;
        
        // 5.隐藏"正在加载"
        self.loadInicator.hidden = YES;
        [self.loadInicator stopAnimating];//停止
    });
}
@end

