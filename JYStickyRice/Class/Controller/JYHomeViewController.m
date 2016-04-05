//
//  JYHomeViewController.m
//  JYStickyRice
//
//  Created by mac mini on 16/3/14.
//  Copyright © 2016年 JYStudio. All rights reserved.
//

#import "JYHomeViewController.h"
#import "JYHomeHeaderView.h"
#import "JYHomeFooterView.h"
#import "JYHomeCell.h"
#import "JYHome.h"
#import "JYDropdownMenu.h"
#import "JYDetailViewController.h"

@interface JYHomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, JYMenuDelegate, JYHomeFooterViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homes;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *districtsArray;
@property (strong, nonatomic) NSMutableArray *cellDataArray;

@property (strong, nonatomic) NSNumber *city_id;
@property (strong, nonatomic) NSString *cat_ids;
@property (strong, nonatomic) NSString *subcat_ids;
@property (strong, nonatomic) NSString *district_ids;
@property (strong, nonatomic) NSString *bizarea_ids;
@property (strong, nonatomic) NSNumber *sort;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSNumber *page;

@property (strong, nonatomic) JYDropdownMenu *menu;
@property (strong, nonatomic) UIView *noAnswerView;

@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
    [self setNoAnswer];
    [self setMenu];
    [self setSearch];
    // 设置每一行cell的高度
    self.tableView.rowHeight = 88;
    // 设置headerView
    self.tableView.tableHeaderView = [JYHomeHeaderView headerView];
    
    JYHomeFooterView *homeFooterView = [JYHomeFooterView footerView];
    homeFooterView.delegate = self;
    self.tableView.tableFooterView = homeFooterView;
    
    self.tableView.opaque = YES;
    
    [self categoriesRequest];
    [self districtsRequest];
    [self cellDataRequest];
    _keyword = [NSString stringWithFormat:@""];
    _subcat_ids = [NSString stringWithFormat:@""];
    _bizarea_ids = [NSString stringWithFormat:@""];
    _sort = [NSNumber numberWithInt:0];
    _page = [NSNumber numberWithInt:1];
}

- (void)cellDataRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchdeals";
    NSString *httpArg = @"city_id=1000010000";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%d", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *cellDataDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   self.cellDataArray = [NSMutableArray arrayWithArray:cellDataDicWithNSJSON[@"data"][@"deals"]];
                                   //NSLog(@"%@",_cellDataArray);
                                   self.homes = [NSMutableArray array];
                                   for (NSDictionary *dict in _cellDataArray) {
                                       // 1.创建模型对象
                                       JYHome *home = [JYHome homeWithDict:dict];
                                       // 2.添加模型对象到数组中
                                       [self.homes addObject:home];
                                   }
                                   //NSLog(@"%@",_homes);
                                   [_tableView reloadData];
                               }
                           }];
}

- (void)cellDataSearchRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchdeals";
    NSString *httpArg = [NSString stringWithFormat:@"city_id=1000010000&keyword=%@&subcat_ids=%@&bizarea_ids=%@&sort=%@&page=1&page_size=10",_keyword,_subcat_ids,_bizarea_ids,_sort];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *cellDataDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   //NSLog(@"%@",cellDataDicWithNSJSON);
                                   if([cellDataDicWithNSJSON[@"errno"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                       self.noAnswerView.hidden = YES;
                                       self.cellDataArray = [NSMutableArray arrayWithArray:cellDataDicWithNSJSON[@"data"][@"deals"]];
                                       //NSLog(@"%@",_cellDataArray);
                                       self.page = [NSNumber numberWithInt:1];
                                       self.homes = [NSMutableArray array];
                                       for (NSDictionary *dict in _cellDataArray) {
                                           // 1.创建模型对象
                                           JYHome *home = [JYHome homeWithDict:dict];
                                           // 2.添加模型对象到数组中
                                           [self.homes addObject:home];
                                       }
                                       //NSLog(@"%@",_homes);
                                       [_tableView reloadData];
                                   }else {
                                       self.noAnswerView.hidden = NO;
                                   }
                               }
                           }];
}

- (void)cellDataMoreRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchdeals";
    NSString *httpArg = [NSString stringWithFormat:@"city_id=1000010000&keyword=%@&subcat_ids=%@&bizarea_ids=%@&sort=%@&page=%@&page_size=10",_keyword,_subcat_ids,_bizarea_ids,_sort,_page];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *cellDataDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   //NSLog(@"%@",cellDataDicWithNSJSON);
                                   if([cellDataDicWithNSJSON[@"errno"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                       self.cellDataArray = [NSMutableArray arrayWithArray:cellDataDicWithNSJSON[@"data"][@"deals"]];
                                       //NSLog(@"%@",_cellDataArray);
                                       for (NSDictionary *dict in _cellDataArray) {
                                           // 1.创建模型对象
                                           JYHome *home = [JYHome homeWithDict:dict];
                                           // 2.添加模型对象到数组中
                                           [self.homes addObject:home];
                                       }
                                       //NSLog(@"%@",_homes);
                                       [_tableView reloadData];
                                   }
                               }
                           }];
}

- (void)categoriesRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/categories";
    NSString *httpArg = @"";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSDictionary *categoriesDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   self.categoriesArray = [NSMutableArray arrayWithArray:categoriesDicWithNSJSON[@"categories"]];
                                   NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *path = [pathArray objectAtIndex:0];
                                   NSString *filePatch = [path stringByAppendingPathComponent:@"categories.plist"];
                                   [_categoriesArray writeToFile:filePatch atomically:YES];
                                   //NSLog(@"%@",_categoriesArray);
                               }
                           }];
}

- (void)districtsRequest {
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/districts";
    NSString *httpArg = @"city_id=1000010000";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b68b91dc303a15a2509ed57f0c00bb66" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSDictionary *districtsDicWithNSJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   self.districtsArray = [NSMutableArray arrayWithArray:districtsDicWithNSJSON[@"districts"]];
                                   NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *path = [pathArray objectAtIndex:0];
                                   NSString *filePatch = [path stringByAppendingPathComponent:@"districts.plist"];
                                   [_districtsArray writeToFile:filePatch atomically:YES];
                                   //NSLog(@"%@",_districtsArray);
                               }
                           }];
}

- (void)setTable{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y = rect.origin.y+94;
    rect.size.height = rect.size.height-94;
    self.tableView = [[UITableView alloc]initWithFrame:rect];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)setNoAnswer {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.noAnswerView = [[UIView alloc]initWithFrame:rect];
    UILabel *noAnswer = [[UILabel alloc]initWithFrame:rect];
    noAnswer.text = @"未搜索到数据";
    noAnswer.textAlignment = NSTextAlignmentCenter;
    noAnswer.backgroundColor = [UIColor whiteColor];
    [self.noAnswerView addSubview:noAnswer];
    [self.view addSubview:_noAnswerView];
    self.noAnswerView.hidden = YES;
}

- (void)setSearch {
    self.searchBar = [[UISearchBar alloc]
                                initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    self.searchBar.delegate = self;
    [[[[self.searchBar.subviews objectAtIndex:0]subviews]objectAtIndex:0] removeFromSuperview];
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    //self.searchBar.showsCancelButton = NO;
    //self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.placeholder=@"搜索";
    //self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    [self.view addSubview:self.searchBar];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.keyword = self.searchBar.text;
    [self cellDataSearchRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    //[self.navigationController setNavigationBarHidden:NO];
}

- (void)setMenu {
    self.menu = [[JYDropdownMenu alloc]init];
    [self.view addSubview:_menu];
    self.menu.delegate = self;
    //plist转模型
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePatch = [path stringByAppendingPathComponent:@"categories.plist"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePatch];
    self.categoriesArray = [NSMutableArray arrayWithArray:dataArray];
    filePatch = [path stringByAppendingPathComponent:@"districts.plist"];
    dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePatch];
    self.districtsArray = [NSMutableArray arrayWithArray:dataArray];
    //  如果是有导航栏请清除自动适应设置
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *threeMenuTitleArray =  @[@"分类",@"地区",@"排序"];
    
    //  创建第一个菜单的first数据second数据
    NSMutableArray *catNameArray = [NSMutableArray array];
    for (NSDictionary *categories in _categoriesArray) {
        [catNameArray addObject:categories[@"cat_name"]];
    }

    NSMutableArray *subCatNameArrays = [NSMutableArray array];
    for (NSDictionary *categories in _categoriesArray) {
        NSMutableArray *subCatNameArray = [NSMutableArray array];
        for (NSDictionary *subCategories in categories[@"subcategories"]) {
            [subCatNameArray addObject:subCategories[@"subcat_name"]];
        }
        [subCatNameArrays addObject:subCatNameArray];
    }
    //NSLog(@"asd%@",subCatNameArrays);
    NSArray *firstArrOne = catNameArray;
    NSArray *secondArrOne = subCatNameArrays;
    NSArray *firstMenu = [NSArray arrayWithObjects:firstArrOne,secondArrOne, nil];
    
    //  创建第二个菜单的first数据second数据
    NSMutableArray *districtNameArray = [NSMutableArray array];
    for (NSDictionary *district in _districtsArray) {
        [districtNameArray addObject:district[@"district_name"]];
    }
    
    NSMutableArray *bizAreaNameArrays = [NSMutableArray array];
    for (NSDictionary *district in _districtsArray) {
        NSMutableArray *bizAreaNameArray = [NSMutableArray array];
        for (NSDictionary *bizArea in district[@"biz_areas"]) {
            [bizAreaNameArray addObject:bizArea[@"biz_area_name"]];
        }
        [bizAreaNameArrays addObject:bizAreaNameArray];
    }
    NSArray *firstArrTwo = districtNameArray;
    NSArray *secondArrTwo = bizAreaNameArrays;
    NSArray *secondMenu = [NSArray arrayWithObjects:firstArrTwo,secondArrTwo, nil];
    
    //  创建第三个菜单的first数据second数据
    NSArray *firstArrThree = [NSArray arrayWithObjects:@"综合排序", @"价格低优先", @"价格高优先", @"折扣高优先", @"销量高优先", @"用户坐标距离近优先", @"最新发布优先", @"用户评分高优先", nil];
    NSArray *threeMenu = [NSArray arrayWithObjects:firstArrThree, nil];
    
    // 三组菜单调用方法
    [self.menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstMenu SecondArr:secondMenu thirdArr:threeMenu];
}
#pragma mark -- 代理方法返回点击时对应的index
- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex andSecondIndex:(NSInteger)secondIndex {
    if(MenuTitleIndex == 0) {
        self.subcat_ids = _categoriesArray[firstIndex][@"subcategories"][secondIndex][@"subcat_id"];
    }else if(MenuTitleIndex == 1) {
        self.bizarea_ids = _districtsArray[firstIndex][@"biz_areas"][secondIndex][@"biz_area_id"];
    }else if(MenuTitleIndex == 2) {
        if(firstIndex == 7)
            firstIndex = 8;
        self.sort = [NSNumber numberWithInteger:firstIndex];
    }
    //NSLog(@"%@",_subcat_ids);
    [self cellDataSearchRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"home";
    JYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [JYHomeCell cellWithTableView:tableView];
    }
    // 1.创建cell

    // 2.给cell传递模型数据
    cell.home = self.homes[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    JYHome *home = self.homes[indexPath.row];
    JYDetailViewController *detailViewController = [[JYDetailViewController alloc]initWithDealId:home.deal_id];
    NSLog(@"row = %ld,dealid = %@",(long)indexPath.row,home.deal_id);
    //JYDetailViewController *detailViewController = [[JYDetailViewController alloc]init];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - FooterView delegate

- (void)homeFooterViewDidClickedLoadBtn:(JYHomeFooterView *)homeFooterView {
    int page = [self.page intValue];
    page = page+1;
    self.page = [NSNumber numberWithInt:page];
    [self cellDataMoreRequest];
}

@end
