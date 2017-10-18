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
@property (strong, nonatomic) NSDictionary *query_column;//查询字段
@property (strong, nonatomic) NSString *query_val;//查询内容

@end

@implementation AppQueryConditionInfo



@end

@interface PublicQueryConditionVC ()<UITextFieldDelegate>{
    NSDictionary *doneDic;
}

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
            self.condition.query_column = [self dictionaryArrayForQueryKey:nil][0];
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
    doneDic = @{@"start_time" : stringFromDate(self.condition.start_time, @"yyyy-MM-dd"),
                @"end_time" : stringFromDate(self.condition.end_time, @"yyyy-MM-dd"),
                @"query_column" : self.condition.query_column[@"key"],
                @"query_val" : self.condition.query_val};
    [self goBackWithDone:YES];
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
        self.doneBlock(doneDic);
    }
}

- (void)editAtIndex:(NSUInteger )row andContent:(NSString *)content {
    NSDictionary *m_dic = self.showArray[row];
    [self.condition setValue:content forKey:m_dic[@"key"]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

- (NSArray *)dictionaryArrayForQueryKey:(NSString *)key {
    NSArray *m_array = @[@{@"name":@"货物编号", @"key":@"goods_number"},
                         @{@"name":@"发货单号", @"key":@"waybill_number"},
                         @{@"name":@"收货人电话", @"key":@"consignee_phone"},
                         @{@"name":@"收货人姓名", @"key":@"consignee_name"},
                         @{@"name":@"发货人电话", @"key":@"shipper_phone"},
                         @{@"name":@"发货人姓名", @"key":@"shipper_name"},
                         @{@"name":@"开单人", @"key":@"user_name"}];
    
    return m_array;
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
        cell.baseView.textField.delegate = self;
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    cell.accessoryType = [self.inputValidSet containsObject:key] ? UITableViewCellAccessoryNone:
    UITableViewCellAccessoryDisclosureIndicator;
    cell.baseView.textField.enabled = [self.inputValidSet containsObject:key];
    if ([key isEqualToString:@"query_column"]) {
        cell.baseView.textField.text = self.condition.query_column[@"name"];
    }
    else {
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
    else if ([key isEqualToString:@"query_column"]) {
        NSArray *dictionaryArray = [self dictionaryArrayForQueryKey:nil];
        if (dictionaryArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dictionaryArray.count];
            for (NSDictionary *dic in dictionaryArray) {
                [m_array addObject:dic[@"name"]];
            }
            NSDictionary *m_dic = self.showArray[indexPath.row];
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dictionaryArray.count) {
                    [weakself.condition setValue:dictionaryArray[buttonIndex - 1] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
    }
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndex:indexPath.row andContent:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
