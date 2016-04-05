//
//  JYDropdownMenu.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/25.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#define PI 3.1415926

#import "JYDropdownMenu.h"
#import "JYDropdownTitleButton.h"

const int cellHeight = 30;

@interface JYDropdownMenu()

@property (strong, nonatomic) NSMutableArray *menuTitleBtnArray;
@property (strong, nonatomic) NSMutableArray *arrowArray;

@property (strong, nonatomic) UITableView *dropdownMenu1;
@property (strong, nonatomic) UITableView *dropdownMenu21;
@property (strong, nonatomic) UITableView *dropdownMenu22;

@property (strong, nonatomic) NSMutableArray *menuTitleArray;
@property (strong, nonatomic) NSMutableArray *firstArr;
@property (strong, nonatomic) NSMutableArray *secondArr;
@property (strong, nonatomic) NSMutableArray *thirdArr;

@property (strong, nonatomic) NSMutableArray *menu1;
@property (strong, nonatomic) NSMutableArray *menu21;
@property (strong, nonatomic) NSMutableArray *menu22;

@property (assign, nonatomic) NSInteger firstIndex;

@end

@implementation JYDropdownMenu

- (instancetype)init {
    if(self = [super init]) {
        self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, cellHeight);
        self.menuTitleBtnArray = [NSMutableArray array];
        self.arrowArray = [NSMutableArray array];
    }
    return self;
}

- (void)createThreeMenuTitleArray:(NSArray *)menuTitleArray
                         FirstArr:(NSArray *)firstArr
                        SecondArr:(NSArray *)secondArr
                         thirdArr:(NSArray *)thirdArr {
    self.menuTitleArray = [NSMutableArray arrayWithArray:menuTitleArray];
    self.firstArr = [NSMutableArray arrayWithArray:firstArr];
    self.secondArr = [NSMutableArray arrayWithArray:secondArr];
    self.thirdArr = [NSMutableArray arrayWithArray:thirdArr];
    int BtnWith = [UIScreen mainScreen].bounds.size.width/3;
    int tableHeight = [UIScreen mainScreen].bounds.size.height/2;
    int tableWith = [UIScreen mainScreen].bounds.size.width/2;
    for (int i = 0; i < 3; i++) {
        JYDropdownTitleButton *menuTitleBtn = [[JYDropdownTitleButton alloc]initWithFrame:CGRectMake(BtnWith*i, 0, BtnWith, cellHeight)];
        menuTitleBtn.open = NO;
        menuTitleBtn.tag = i;
        NSString *title = _menuTitleArray[i];
        [menuTitleBtn setTitle:title forState:UIControlStateNormal];
        menuTitleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [menuTitleBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        //menuTitleBtn.titleLabel.textColor = [UIColor blackColor];
        //[menuTitleBtn setTitle:menuTitleArray[i] forState:UIControlStateNormal];
        [menuTitleBtn addTarget:self action:@selector(menuTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuTitleBtnArray addObject:menuTitleBtn];
        CGRect rect = menuTitleBtn.bounds;
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width-18, 10, 10, 10)];
        arrow.image = [UIImage imageNamed:@"arrow"];
        [self.arrowArray addObject:arrow];
        [menuTitleBtn addSubview:arrow];
        [self addSubview:menuTitleBtn];
    }
    //创建tableView
    self.dropdownMenu1 = [[UITableView alloc]initWithFrame:CGRectMake(0, cellHeight, tableWith*2, tableHeight)];
    self.dropdownMenu1.tag = 1;
    self.dropdownMenu1.delegate = self;
    self.dropdownMenu1.dataSource = self;
    self.dropdownMenu1.hidden = YES;
    self.dropdownMenu1.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.dropdownMenu1];
    self.dropdownMenu21 = [[UITableView alloc]initWithFrame:CGRectMake(0, cellHeight, tableWith, tableHeight)];
    self.dropdownMenu21.tag = 21;
    self.dropdownMenu21.delegate = self;
    self.dropdownMenu21.dataSource = self;
    self.dropdownMenu21.hidden = YES;
    self.dropdownMenu21.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.dropdownMenu21];
    self.dropdownMenu22 = [[UITableView alloc]initWithFrame:CGRectMake(tableWith, cellHeight, tableWith, tableHeight)];
    self.dropdownMenu22.tag = 22;
    self.dropdownMenu22.delegate = self;
    self.dropdownMenu22.dataSource = self;
    self.dropdownMenu22.hidden = YES;
    self.dropdownMenu22.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.dropdownMenu22];
    //用UILabel划线
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    label1.backgroundColor = [UIColor blackColor];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, [UIScreen mainScreen].bounds.size.width, 1)];
    label2.backgroundColor = [UIColor blackColor];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 4, 1, 22)];
    label3.backgroundColor = [UIColor blackColor];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*2, 4, 1, 22)];
    label4.backgroundColor = [UIColor blackColor];
    [self addSubview:label1];
    [self addSubview:label2];
    [self addSubview:label3];
    [self addSubview:label4];
}

- (void)menuTitleBtn:(JYDropdownTitleButton *)sender {
    if(sender.open) {
        //关闭状态
        UIImageView *arrow = _arrowArray[sender.tag];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        arrow.transform=CGAffineTransformMakeRotation(0);
        [UIView commitAnimations];
        self.dropdownMenu1.hidden = YES;
        self.dropdownMenu21.hidden = YES;
        self.dropdownMenu22.hidden = YES;
        [self viewClose];
        sender.open = NO;
    }else {
        //开启状态
        UIImageView *arrow = _arrowArray[sender.tag];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        arrow.transform=CGAffineTransformMakeRotation(PI);
        [UIView commitAnimations];
        if (sender.tag == 2) {
            _menu1 = _thirdArr[0];
            [self.dropdownMenu1 reloadData];
            self.dropdownMenu1.hidden = NO;
            self.dropdownMenu21.hidden = YES;
            self.dropdownMenu22.hidden = YES;
        }else {
            if(sender.tag == 0) {
                _menu21 = _firstArr[0];
            }else if(sender.tag == 1) {
                _menu21 = _secondArr[0];
            }
            [self.dropdownMenu21 reloadData];
            self.dropdownMenu1.hidden = YES;
            self.dropdownMenu21.hidden = NO;
            self.dropdownMenu22.hidden = YES;
        }
        [self viewOpen];
        sender.open = YES;
        //其余状态
        for (int i = 0; i < 3; i++){
            if (i != sender.tag){
                JYDropdownTitleButton *menuTitleBtn = _menuTitleBtnArray[i];
                UIImageView *arrow = _arrowArray[i];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                arrow.transform=CGAffineTransformMakeRotation(0);
                [UIView commitAnimations];
                menuTitleBtn.open = NO;
            }
        }
    }
}

- (void)viewOpen {
    CGRect rect = self.frame;
    rect.size.height = cellHeight+[UIScreen mainScreen].bounds.size.height/2;
    self.frame = rect;
}

- (void)viewClose {
    CGRect rect = self.frame;
    rect.size.height = cellHeight;
    self.frame = rect;
}

#pragma tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = 0;
    switch (tableView.tag) {
        case 1:
        {
            rowNumber = _menu1.count;
        }
            break;
        case 21:
        {
            rowNumber = _menu21.count;
        }
            break;
        case 22:
        {
            rowNumber = _menu22.count;
        }
            break;
        default:
            break;
    }
    return rowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"menu";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    switch (tableView.tag) {
        case 1:
        {
            NSString *text = _menu1[indexPath.row];
            cell.textLabel.text = text;
            cell.textLabel.font = [UIFont systemFontOfSize:10];
        }
            break;
        case 21:
        {
            NSString *text = _menu21[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = text;
            cell.textLabel.font = [UIFont systemFontOfSize:10];
        }
            break;
        case 22:
        {
            NSString *text = _menu22[indexPath.row];
            cell.textLabel.text = text;
            cell.textLabel.font = [UIFont systemFontOfSize:10];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 21) {
        for (JYDropdownTitleButton *btn in _menuTitleBtnArray) {
            if(btn.open) {
                if(btn.tag == 0) {
                    _menu22 = _firstArr[1][indexPath.row];
                }else if(btn.tag == 1) {
                    _menu22 = _secondArr[1][indexPath.row];
                }
            }
        }
        [self.dropdownMenu22 reloadData];
        self.dropdownMenu22.hidden = NO;
        self.firstIndex = indexPath.row;
    }else if(tableView.tag == 22) {
        for (JYDropdownTitleButton *btn in _menuTitleBtnArray) {
            if(btn.open) {
                [_delegate menuCellDidSelected:btn.tag firstIndex:_firstIndex andSecondIndex:indexPath.row];
                [self viewClose];
                btn.open = NO;
                NSString *title = _menu22[indexPath.row];
                [btn setTitle:title forState:UIControlStateNormal];
                UIImageView *arrow = _arrowArray[btn.tag];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                arrow.transform=CGAffineTransformMakeRotation(0);
                [UIView commitAnimations];
            }
        }
        self.dropdownMenu21.hidden = YES;
        self.dropdownMenu22.hidden = YES;
    }else if(tableView.tag == 1) {
        for (JYDropdownTitleButton *btn in _menuTitleBtnArray) {
            if(btn.open) {
                [_delegate menuCellDidSelected:btn.tag firstIndex:indexPath.row andSecondIndex:0];
                [self viewClose];
                btn.open = NO;
                NSString *title = _menu1[indexPath.row];
                [btn setTitle:title forState:UIControlStateNormal];
                UIImageView *arrow = _arrowArray[btn.tag];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                arrow.transform=CGAffineTransformMakeRotation(0);
                [UIView commitAnimations];
            }
        }
        self.dropdownMenu1.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
