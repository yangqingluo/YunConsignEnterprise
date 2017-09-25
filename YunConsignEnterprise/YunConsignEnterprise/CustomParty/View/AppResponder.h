//
//  AppResponder.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppResponder : NSObject

@end

@interface IndexPathTextField : UITextField

@property (strong, nonatomic) NSIndexPath *indexPath;

@end


@interface IndexPathButton : UIButton

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@interface IndexPathSwitch : UISwitch

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
