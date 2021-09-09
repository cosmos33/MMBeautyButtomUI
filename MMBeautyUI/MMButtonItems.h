//
//  MMButtonItems.h
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMButtonItems : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;

- (void)selectIndex:(NSInteger)index;

@property (nonatomic, copy) void(^buttonItemClicked)(NSInteger);

@end

NS_ASSUME_NONNULL_END
