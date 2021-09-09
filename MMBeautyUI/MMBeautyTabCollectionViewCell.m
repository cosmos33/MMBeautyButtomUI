//
//  MMBeautyTabCollectionViewCell.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBeautyTabCollectionViewCell.h"

@implementation MMBeautyTabCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
    _imageView = imageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:11];
    _titleLabel = titleLabel;
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    valueLabel.textColor = UIColor.whiteColor;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont boldSystemFontOfSize:9];
    _valueLabel = valueLabel;
    
    UIStackView *vStackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageView, titleLabel, valueLabel]];
    vStackView.translatesAutoresizingMaskIntoConstraints = NO;
    vStackView.axis = UILayoutConstraintAxisVertical;
    vStackView.alignment = UIStackViewAlignmentCenter;
    vStackView.distribution = UIStackViewDistributionEqualSpacing;
    vStackView.spacing = 8;
    [self.contentView addSubview:vStackView];
    
    [vStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [vStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [vStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [vStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    
    [imageView.widthAnchor constraintEqualToConstant:60].active = YES;
    [imageView.heightAnchor constraintEqualToAnchor:imageView.widthAnchor].active = YES;
    
    [titleLabel.widthAnchor constraintEqualToAnchor:vStackView.widthAnchor].active = YES;
    [titleLabel.heightAnchor constraintEqualToConstant:12].active = YES;
    
    [valueLabel.widthAnchor constraintEqualToAnchor:vStackView.widthAnchor].active = YES;
    [valueLabel.heightAnchor constraintEqualToConstant:7].active = YES;
}



@end
