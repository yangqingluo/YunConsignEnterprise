//
//  AddGoodsListHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AddGoodsListHeaderView.h"

#import "SingleInputCell.h"
#import "DoubleInputCell.h"

@interface AddGoodsListHeaderView ()

@property (strong, nonatomic) NSArray *showArray;

@end

@implementation AddGoodsListHeaderView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 4 * kCellHeightMiddle)];
    if (self) {
        _showArray = @[@{@"title":@"货物名称",@"subTitle":@"请输入"},
                       @{@"title":@"包装类型",@"subTitle":@"请输入"},
                       @[@{@"title":@"件数",@"subTitle":@"请输入"},
                         @{@"title":@"运费",@"subTitle":@"请输入"}],
                       @[@{@"title":@"吨",@"subTitle":@"请输入"},
                         @{@"title":@"方",@"subTitle":@"请输入"}]];
    }
    return self;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeightMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.showArray[indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        static NSString *CellIdentifier = @"single_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.inputView showRightButtonWithImage:[UIImage imageNamed:@"list_icon_common"]];
        }
        cell.inputView.textLabel.text = item[@"title"];
        cell.inputView.textField.placeholder = item[@"subTitle"];
        cell.inputView.textField.text = @"";
        cell.inputView.textField.indexPath = [indexPath copy];
        
        return cell;
    }
    else if ([item isKindOfClass:[NSArray class]]) {
        NSArray *m_array = (NSArray *)item;
        if (m_array.count == 2) {
            static NSString *CellIdentifier = @"double_cell";
            DoubleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[DoubleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSDictionary *m_dic1 = m_array[0];
            NSDictionary *m_dic2 = m_array[1];
            cell.inputView.textLabel.text = m_dic1[@"title"];
            cell.inputView.textField.placeholder = m_dic1[@"subTitle"];
            cell.inputView.textField.text = @"";
            cell.inputView.textField.indexPath = [indexPath copy];
            
            cell.anotherInputView.textLabel.text = m_dic2[@"title"];
            cell.anotherInputView.textField.placeholder = m_dic2[@"subTitle"];
            cell.anotherInputView.textField.text = @"";
            cell.anotherInputView.textField.indexPath = [indexPath copy];
            
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
