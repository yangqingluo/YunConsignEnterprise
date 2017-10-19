//
//  SearchQuantityVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityVC.h"
#import "SearchQuantityResultVC.h"

#import "BlockActionSheet.h"
#import "SingleInputCell.h"
#import "PublicDatePickerView.h"

@interface SearchQuantityVC ()

@property (strong, nonatomic) AppQueryConditionInfo *condition;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSMutableArray *cityArray;

@property (strong, nonatomic) UIView *footerView;

@end

@implementation SearchQuantityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.tableFooterView = self.footerView;
    
    [self initializeData];
    [self pullCityArrayFunction];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化数据
- (void)initializeData{
    _showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择"},
                   @{@"title":@"结束时间",@"subTitle":@"必填，请选择"},
                   @{@"title":@"始发站",@"subTitle":@"请选择"},
                   @{@"title":@"终点站",@"subTitle":@"请选择"}];
}

- (void)pullCityArrayFunction {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryOpenCityList" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [weakself.cityArray removeAllObjects];
            [weakself.cityArray addObjectsFromArray:[AppCityInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
            [weakself.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)searchButtonAction {
    SearchQuantityResultVC *vc = [SearchQuantityResultVC new];
    vc.condition = self.condition;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray new];
    }
    return _cityArray;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 60)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kEdge, kEdgeMiddle, _footerView.width - 2 * kEdge, _footerView.height - kEdgeMiddle)];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"立即查询" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        
        [AppPublic roundCornerRadius:btn cornerRadius:kButtonCornerRadius];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        rowHeight += kEdge;
    }
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.showArray[indexPath.row];
    
    static NSString *CellIdentifier = @"select_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseView.textField.enabled = NO;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:{
            cell.baseView.textField.text = self.condition.showStartTimeString;
        }
            break;
            
        case 1:{
            cell.baseView.textField.text = self.condition.showEndTimeString;
        }
            break;
            
        case 2:{
            cell.baseView.textField.text = self.condition.start_station_city.open_city_name;
        }
            break;
            
        case 3:{
            cell.baseView.textField.text = self.condition.end_station_city.open_city_name;
        }
            break;
            
        default:
            break;
    }
    
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:{
            NSDictionary *m_dic = self.showArray[indexPath.row];
            QKWEAKSELF;
            PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    weakself.condition.start_time = pickerView.datePicker.date;
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            if (self.condition.start_time) {
                view.datePicker.date = self.condition.start_time;
            }
            if (self.condition.end_time) {
                view.datePicker.maximumDate = self.condition.end_time;
            }
            [view show];
        }
            break;
            
        case 1:{
            NSDictionary *m_dic = self.showArray[indexPath.row];
            QKWEAKSELF;
            PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    weakself.condition.end_time = pickerView.datePicker.date;
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            view.datePicker.maximumDate = [NSDate date];
            if (self.condition.end_time) {
                view.datePicker.date = self.condition.end_time;
            }
            [view show];
        }
            break;
            
        case 2:{
            if (self.cityArray.count) {
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.cityArray.count];
                for (AppCityInfo *item in self.cityArray) {
                    [m_array addObject:item.open_city_name];
                }
                NSDictionary *m_dic = self.showArray[indexPath.row];
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < weakself.cityArray.count) {
                        weakself.condition.start_station_city = weakself.cityArray[buttonIndex - 1];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else {
                [self pullCityArrayFunction];
            }
        }
            break;
            
        case 3:{
            if (self.cityArray.count) {
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.cityArray.count];
                for (AppCityInfo *item in self.cityArray) {
                    [m_array addObject:item.open_city_name];
                }
                NSDictionary *m_dic = self.showArray[indexPath.row];
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < weakself.cityArray.count) {
                        weakself.condition.end_station_city = weakself.cityArray[buttonIndex - 1];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else {
                [self pullCityArrayFunction];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
