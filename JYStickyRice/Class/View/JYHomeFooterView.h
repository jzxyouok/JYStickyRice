//
//  JYHomeFooterView.h
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYHomeFooterView;

@protocol JYHomeFooterViewDelegate <NSObject>

- (void)homeFooterViewDidClickedLoadBtn:(JYHomeFooterView *)homeFooterView;

@end

@interface JYHomeFooterView : UIView

+ (instancetype)footerView;

@property (nonatomic, weak) id<JYHomeFooterViewDelegate> delegate;

@end
