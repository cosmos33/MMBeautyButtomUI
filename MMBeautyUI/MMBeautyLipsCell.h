//
//  MMBeautyLipsCell.h
//  MMBeautySample
//
//  Created by Zzz on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBeautyLipsCell : UITableViewCell

@property (nonatomic , strong) UIView * selectedView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIImageView *iconImg;
@property (nonatomic , strong) NSLayoutConstraint * titleLeft;

- (void)configCellWithName:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
