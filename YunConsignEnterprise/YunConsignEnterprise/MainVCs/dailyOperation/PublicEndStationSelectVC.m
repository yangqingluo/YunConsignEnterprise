//
//  PublicEndStationSelectVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicEndStationSelectVC.h"

#import "BlockActionSheet.h"
#import "EndServiceCell.h"

@interface PublicEndStationSelectVC ()

@property (strong, nonatomic) NSMutableArray *cityArray;
//@property (strong, nonatomic) NSArray *serviceArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (strong, nonatomic) UITableView *secondaryTableView;

@end

@implementation PublicEndStationSelectVC

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.secondaryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.secondaryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.secondaryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.secondaryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.width = 120;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self showCityAction];
    
    [self.view addSubview:self.secondaryTableView];
}

- (void)setupNav {
    [self createNavWithTitle:@"选择终点站" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction ) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)cancelButtonAction  {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBackWithDone:(BOOL)done{
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction{
    if (self.doneBlock) {
        self.doneBlock(self.selectedArray);
    }
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    if (self.selectedArray.count) {
        [self goBackWithDone:YES];
    }
    else {
        [self showHint:@"请选择终点站信息"];
    }
}

- (void)removeButtonAction:(UIButton *)button {
    if (button.tag <= self.selectedArray.count - 1) {
        [self.selectedArray removeObjectAtIndex:button.tag];
        [self.secondaryTableView reloadData];
    }
}

- (void)pullCityArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryOpenCityList" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            NSArray *m_array = [AppCityInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
            if (m_array.count) {
                [self showCityAction];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullServiceArrayFunctionForCode:(NSString *)open_city_id selectionInIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = @{@"open_city_id" : open_city_id};
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryServiceListByCityId" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            [[UserPublic getInstance].dataMapDic setObject:m_array forKey:serviceDataMapKeyForCity(open_city_id)];
            if (m_array.count) {
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)showCityAction {
    NSString *key = @"end_station_city";
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        [self.cityArray removeAllObjects];
        [self.cityArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
    }
    else {
        [self pullCityArrayFunctionForCode:key selectionInIndexPath:nil];
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCityInfo *city = self.cityArray[indexPath.row];
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:serviceDataMapKeyForCity(city.open_city_id)];
    if (dataArray.count) {
        [self.selectedArray addObject:[dataArray[0] copy]];
        [self.secondaryTableView reloadData];
    }
    else {
        [self pullServiceArrayFunctionForCode:city.open_city_id selectionInIndexPath:indexPath];
    }
}

#pragma mark - getter
- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray new];
    }
    return _cityArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}

- (UITableView *)secondaryTableView {
    if (!_secondaryTableView) {
        _secondaryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.tableView.right, STATUS_BAR_HEIGHT, self.view.width - self.tableView.right, self.view.height - STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _secondaryTableView.separatorColor = baseSeparatorColor;
        _secondaryTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _secondaryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleBottomMargin;
        _secondaryTableView.delegate = self;
        _secondaryTableView.dataSource = self;
        _secondaryTableView.backgroundColor = [UIColor clearColor];
    }
    return _secondaryTableView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.secondaryTableView]) {
        return self.selectedArray.count;
    }
    return self.cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    if ([tableView isEqual:self.secondaryTableView]) {
        return [EndServiceCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.secondaryTableView]) {
        static NSString *CellIdentifier = @"end_station_service_cell";
        EndServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[EndServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.removeBtn addTarget:self action:@selector(removeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        AppServiceInfo *service = self.selectedArray[indexPath.row];
        cell.indexLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@", service.open_city_name, service.service_name];
        cell.removeBtn.tag = indexPath.row;
        return cell;
    }
    static NSString *CellIdentifier = @"end_station_city_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.textLabel.textColor = secondaryTextColor;
    }
    AppCityInfo *city = self.cityArray[indexPath.row];
    cell.textLabel.text = city.open_city_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:self.secondaryTableView]) {
        AppServiceInfo *service = self.selectedArray[indexPath.row];
        AppCityInfo *city = nil;
        for (AppCityInfo *m_city in self.cityArray) {
            if ([m_city.open_city_id isEqualToString:service.open_city_id]) {
                city = m_city;
                break;
            }
        }
        if (city) {
            NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:serviceDataMapKeyForCity(city.open_city_id)];
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppServiceInfo *m_data in dataArray) {
                [m_array addObject:[NSString stringWithFormat:@"%@-%@", m_data.open_city_name, m_data.service_name]];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"选择站点" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppServiceInfo *m_service = [dataArray[buttonIndex - 1] copy];
                    [weakself.selectedArray replaceObjectAtIndex:indexPath.row withObject:m_service];
                    [weakself.secondaryTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
    }
    else {
        [self selectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

@end
