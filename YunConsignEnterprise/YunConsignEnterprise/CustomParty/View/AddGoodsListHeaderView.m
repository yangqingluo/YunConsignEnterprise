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

#pragma mark - getter
- (AppGoodsInfo *)data {
    if (!_data) {
        _data = [AppGoodsInfo new];
    }
    return _data;
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
            [cell.inputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.inputView showRightButtonWithImage:[UIImage imageNamed:@"list_icon_common"]];
        }
        cell.inputView.textLabel.text = item[@"title"];
        cell.inputView.textField.placeholder = item[@"subTitle"];
        cell.inputView.textField.text = @"";
        cell.inputView.textField.indexPath = [indexPath copy];
        
        switch (indexPath.row) {
            case 0:{
                if (self.data.goods_name.length) {
                    cell.inputView.textField.text = self.data.goods_name;
                }
            }
                break;
                
            case 1:{
                if (self.data.packge.length) {
                    cell.inputView.textField.text = self.data.packge;
                }
            }
                break;
                
            default:
                break;
        }
        
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
                [cell.inputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [cell.anotherInputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            
            switch (indexPath.row) {
                case 2:{
                    cell.inputView.textField.text = [NSString stringWithFormat:@"%d", self.data.number];
                    cell.anotherInputView.textField.text = [NSString stringWithFormat:@"%lld", self.data.freight];
                }
                    break;
                    
                case 3:{
                    cell.inputView.textField.text = [NSString stringWithFormat:@"%.1f", self.data.weight];
                    cell.anotherInputView.textField.text = [NSString stringWithFormat:@"%.1f", self.data.volume];
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma  mark - TextField
- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        IndexPathTextField *m_textField = (IndexPathTextField *)textField;
        switch (m_textField.indexPath.row) {
            case 0:{
                self.data.goods_name = textField.text;
            }
                break;
                
            case 1:{
                self.data.packge = textField.text;
            }
                break;
                
            case 2:{
                if (textField.tag == 0) {
                    self.data.number = [textField.text intValue];
                }
                else if (textField.tag == 1) {
                    self.data.freight = [textField.text doubleValue];
                }
            }
                break;
                
            case 3:{
                if (textField.tag == 0) {
                    self.data.weight = [textField.text intValue];
                }
                else if (textField.tag == 1) {
                    self.data.volume = [textField.text doubleValue];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger length = kInputLengthMax;
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        IndexPathTextField *m_textField = (IndexPathTextField *)textField;
        switch (m_textField.indexPath.row) {
            case 0:
            case 1:{
                length = kNameLengthMax;
            }
                break;
                
            case 2:{
                if (m_textField.tag == 0) {
                    
                }
                else if (m_textField.tag == 1) {
                    length = kPriceLengthMax;
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return (range.location < length);
}

@end
