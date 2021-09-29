//
//  MMBeautyLipsView.h
//  MMBeautySample
//
//  Created by Zzz on 2021/9/22.
//

#import <UIKit/UIKit.h>

typedef void(^LipSelected)(NSInteger lipsType);

NS_ASSUME_NONNULL_BEGIN

@interface MMBeautyLipsView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic , copy) LipSelected lipsCallback;

- (void)showLipsBtnChangeAnim:(BOOL)status;

@end

NS_ASSUME_NONNULL_END
