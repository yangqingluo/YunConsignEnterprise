//
//  PublicQueryConditionVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicQueryConditionVC.h"

#import "BlockActionSheet.h"
#import "SingleInputCell.h"
#import "PublicDatePickerView.h"

@interface AppQueryConditionInfo : AppType

@property (strong, nonatomic) NSDate *start_time;//开始时间
@property (strong, nonatomic) NSDate *end_time;//结束时间


@end

@implementation AppQueryConditionInfo



@end

@interface PublicQueryConditionVC ()

@property (strong, nonatomic) AppQueryConditionInfo *condition;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *inputValidSet;

@property (strong, nonatomic) UIView *footerView;

@end

@implementation PublicQueryConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.tableFooterView = self.footerView;
    
    [self initializeData];
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"查询" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
    
}

//初始化数据
- (void)initializeData{
    switch (self.type) {
        case QueryConditionType_WaybillQuery:{
            NSDate *date_now = [NSDate date];
            self.condition.start_time = [date_now dateByAddingTimeInterval:defaultAddingTimeInterval];
            self.condition.end_time = date_now;
            _showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                           @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service_id"},
                           @{@"title":@"目的网点",@"subTitle":@"请选择",@"key":@"end_service_id"},
                           @{@"title":@"作废状态",@"subTitle":@"请选择",@"key":@"is_cancel"}];
        }
            break;
            
        default:
            break;
    }
}

- (void)cancelButtonAction{
    [self goBackWithDone:NO];
}

- (void)searchButtonAction {
    
}

- (void)goBackWithDone:(BOOL)done{
    QKWEAKSELF;
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        if (done) {
            [weakself doDoneAction];
        }
    }];
}

- (void)doDoneAction{
    if (self.doneBlock) {
        self.doneBlock(self.condition);
    }
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
}

- (NSSet *)inputValidSet{
    if (!_inputValidSet) {
        _inputValidSet = [NSSet setWithObjects:@"query_val", nil];
    }
    return _inputValidSet;
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
    NSString *key = dic[@"key"];
    
    static NSString *CellIdentifier = @"select_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    cell.accessoryType = [self.inputValidSet containsObject:key] ? UITableViewCellAccessoryNone:
    UITableViewCellAccessoryDisclosureIndicator;
    cell.baseView.textField.enabled = [self.inputValidSet containsObject:key];
    
    if ([AppPublic getVariableWithClass:self.condition.class varName:key]) {
        id value = [self.condition valueForKey:key];
        if (value) {
            if ([key isEqualToString:@"start_time"] || [key isEqualToString:@"end_time"]) {
                cell.baseView.textField.text = stringFromDate(value, @"yyyy-MM-dd");
            }
            else {
                cell.baseView.textField.text = value;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"start_time"] || [key isEqualToString:@"end_time"]) {
        QKWEAKSELF;
        PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakself.condition setValue:pickerView.datePicker.date forKey:key];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        view.datePicker.maximumDate = [NSDate date];
        id value = [self.condition valueForKey:key];
        if (value) {
            view.datePicker.date = value;
        }
        if ([key isEqualToString:@"start_time"]) {
            id end_time = [self.condition valueForKey:@"end_time"];
            if (end_time) {
                view.datePicker.maximumDate = end_time;
            }
        }
        [view show];
    }
    
}
@end
