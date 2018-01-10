//
//  WaybillChangeApplyCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/10.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface WaybillChangeApplyCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *changeLabel;//修改内容
@property (strong, nonatomic) UILabel *rejectNoteLabel;//驳回原因

@property (copy, nonatomic) AppWaybillChangeApplyInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath data:(AppWaybillChangeApplyInfo *)data;

@end
