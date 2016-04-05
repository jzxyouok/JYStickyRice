//
//  JYDropdownMenu.h
//  JYStickyRice
//
//  Created by mac mini on 16/3/25.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYMenuDelegate <NSObject>

/**
 * 代理方法返回 菜单标题index:MenuTitleIndex  一级菜单index:firstIndex  二级菜单index:secondIndex
 */
- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex andSecondIndex:(NSInteger)secondIndex;

///**
// * 代理方法返回 菜单标题:MenuTitle  一级菜单内容:firstContent  二级菜单内容:secondContent
// */
//- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent andSecondContent:(NSString *)secondContent;

@end

@interface JYDropdownMenu : UIView <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) id <JYMenuDelegate> delegate;

//- (void)createOneMenuTitleArray:(NSArray *)menuTitleArray FirstArray:(NSArray *)FirstArray;

//- (void)createTwoMenuTitleArray:(NSArray *)menuTitleArray FirstArr:(NSArray *)firstArr SecondArr:(NSArray *)secondArr;

//- (void)createThreeMenuTitleArray:(NSArray *)menuTitleArray FirstArr:(NSArray *)firstArr SecondArr:(NSArray *)secondArr threeArr:(NSArray *)threeArr;

//- (void)createFourMenuTitleArray:(NSArray *)menuTitleArray FirstArr:(NSArray *)firstArr SecondArr:(NSArray *)secondArr threeArr:(NSArray *)threeArr fourArr:(NSArray *)fourArr;

- (void)createThreeMenuTitleArray:(NSArray *)menuTitleArray
                         FirstArr:(NSArray *)firstArr
                        SecondArr:(NSArray *)secondArr
                         thirdArr:(NSArray *)thirdArr;

@end
