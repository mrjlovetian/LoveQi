//
//  CitySelectViewController.m
//  LoveQi
//
//  Created by tops on 2018/3/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "CitySelectViewController.h"
#import <BATableView.h>
#import "CityRequest.h"
#import <MJExtension.h>

@interface CitySelectViewController ()<BATableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *searchArray;
}

@property (nonatomic, strong) BATableView *contactTableView;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UISearchDisplayController *searchDisPlayCon;
@property (nonatomic,strong) NSDictionary *DataSource;
@property (nonatomic,strong) NSMutableArray *arrayKeys;

@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headView.titleStr = @"城市选择";
    
    
    CityRequest *request = [[CityRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof MRJ_BaseRequest * _Nonnull request) {
        MRJ_Log(@"-=-=-=-=-=-==-%@", request.responseObject);
         NSArray *arr = [CityModelManger mj_objectArrayWithKeyValuesArray:request.responseObject[@"Data"]];
        [CityModelManger sorterFromArray:arr success:^(NSArray *entryWords, NSDictionary *sorterArray) {
            _arrayKeys = [[NSMutableArray alloc]initWithObjects:@" ",@" ", nil];
            [_arrayKeys addObjectsFromArray:entryWords];
            self.DataSource = sorterArray;
            [self.contactTableView reloadData];
        }];
    } failure:^(__kindof MRJ_BaseRequest * _Nonnull request) {
        MRJ_Log(@"***************%@", request.error.localizedDescription);
    }];
    

    self.contactTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, NavBAR_HEIGHT + 56 , SCREEN_WIDTH, SCREEN_HEIGHT-NavBAR_HEIGHT - 44)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contactTableView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, 28)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索城市";
    UIView *bgdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, _searchBar.height)];
    bgdView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    bgdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_searchBar insertSubview:bgdView atIndex:1];
    _searchBar.tintColor = [UIColor colorWithHexString:@"0091e8"];
    if (@available(iOS 11, *)) {
        UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
        [txfSearchField setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
    }
    [self.view addSubview:_searchBar];
    
    _searchDisPlayCon = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisPlayCon.delegate = self;
    [self setSearchDisPlayCon:_searchDisPlayCon];
    _searchDisPlayCon.searchResultsDataSource = self;
    _searchDisPlayCon.searchResultsDelegate = self;
    searchArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UISearchDisplayController delegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    // 输入框变化
    // Return YES to cause the search result table view to be reloaded.
    MRJ_Log(@"**********%f", ((UITableView *)controller.searchResultsTableView).tableHeaderView.frame.size.height);
    ((UITableView *)controller.searchResultsTableView).separatorStyle = UITableViewCellSeparatorStyleNone;
    //    controller.searchResultsTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    //    controller.searchResultsTableView.backgroundColor = [UIColor orangeColor];
    [self filterContentForSearchText:searchString scope:[self.searchDisplayController.searchBar                                       selectedScopeButtonIndex]];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger )scopeOption
{
    [searchArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    for (NSArray *array in self.DataSource.allValues) {
        for (CityModelManger *city in array) {
            if ([resultPredicate evaluateWithObject:city.regionName]) {
                [searchArray addObject:city];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    
    return _arrayKeys;
}

- (NSString *)titleString:(NSInteger)section
{
    return _arrayKeys[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView] || section == 0) {
        return 0.1;
    }
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView] || section == 0) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    if (section == 0){
        label.text = @"当前位置";
    }
    else if (section == 1) {
        label.text = @"一下城市开通";
    } else
        label.text = [NSString stringWithFormat:@"%@",_arrayKeys[section]];
//    label.edgeInsets = UIEdgeInsetsMake(0.f, Edge, 0.f, 0.f);
    return label;
}

- (CGFloat)tableView:( UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView]) {
        return 1;
    }
    return _arrayKeys.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView]) {
        return searchArray.count;
    }
    if (section == 0)
        return 1;
    if (section == 1) {
        return 0;
    }
    NSArray *array = [self.DataSource objectForKey:_arrayKeys[section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName =@"CityListTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.left = Edge;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Edge, 0, SCREEN_WIDTH, 0.5)];
        lineView.tag = 1000;
        [cell.contentView addSubview:lineView];
    }
    UIView *lineView = [cell viewWithTag:1000];
    lineView.hidden = indexPath.row == 0;
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView]) {
        CityModelManger *city = searchArray[indexPath.row];
        cell.textLabel.text  = city.regionName;
    } else{
        if (indexPath.section == 0) {
            NSString *msg = @"";
//            if (locationDM.locationCity) {
//                //定位到城市
//                NSString *cityName = locationDM.locationCity.showCityName;
//                if(locationDM.locationCity.cityId == 0){
//                    msg = MF_SWF(@"broker_%@ (not open operation)".local_broker, cityName);
//                    cell.userInteractionEnabled = NO;
//                }else{
//                    msg = MF_SWF(@"broker_%@ GPS".local_broker, cityName);
//                    cell.userInteractionEnabled = YES;
//                }
//                NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
//                [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor KK_Gray99] range:NSMakeRange(cityName.length, msg.length - cityName.length)];
//                [aAttributedString addAttribute:NSFontAttributeName value:[UIFont KK_S14] range:NSMakeRange(cityName.length, msg.length - cityName.length)];
//                cell.textLabel.attributedText = aAttributedString;
//            }else{
//                msg = MF_SWF(@"%@", Default_CityName);
//                cell.userInteractionEnabled = YES;
//                cell.textLabel.text = msg;
//            }
            
            
        }
        else if (indexPath.section > 1) {
            cell.imageView.image = nil;
            NSArray *array = [self.DataSource objectForKey:_arrayKeys[indexPath.section]];
            CityModelManger *city = array[indexPath.row];
            cell.textLabel.text  = city.regionName;
            cell.userInteractionEnabled = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Kid  城市id
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityModelManger *city = nil;
    if ([tableView isEqual:_searchDisPlayCon.searchResultsTableView]) {
        city = searchArray[indexPath.row];
    } else{
        if (indexPath.section == 0) {
//            if (locationDM.locationCity) {
//                city = locationDM.locationCity;
//            }else{
//                city = [[CityDTO alloc]init];
//                city.cityId = [Default_CityKid integerValue];
//                city.cityName = Default_CityName;
//            }
        } else if (indexPath.section > 1) {
            NSArray *array = [self.DataSource objectForKey:_arrayKeys[indexPath.section]];
            city = array[indexPath.row];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCityDidResults:)]) {
        [self.delegate selectCityDidResults:city];
//        [self goBack];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
