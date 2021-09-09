//
//  MMBeautyMakeupSubview.h
//  MMBeautySample
//
//  Created by sunfei on 2021/1/26.
//

#import <UIKit/UIKit.h>

@class MMBottomViewModel;
@class MMBottomViewModelItem;

NS_ASSUME_NONNULL_BEGIN

@interface MMBeautyMakeupSubview : UIView

@property (nonatomic, copy) void(^selectItem)(MMBottomViewModel *model, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^backButtonClickedBlock)(void);

@property (nonatomic, copy) MMBottomViewModel *model;

- (void)updateLabel:(CGFloat)curPos;

@end

NS_ASSUME_NONNULL_END
