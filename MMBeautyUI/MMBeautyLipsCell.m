//
//  MMBeautyLipsCell.m
//  MMBeautySample
//
//  Created by Zzz on 2021/9/22.
//

#import "MMBeautyLipsCell.h"

@implementation MMBeautyLipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpViews];
    }
    return self;
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
}

- (void)setUpViews{
    [self selectedView];
    [self titleLabel];
    [self iconImg];
}

- (void)configCellWithName:(NSString *)title{
    if (!title) {
        return;
    }
    self.titleLabel.text = title;
}

- (UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedView.backgroundColor = [UIColor clearColor];
        _selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_selectedView];
        [_selectedView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [_selectedView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_selectedView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_selectedView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    }
    return _selectedView;
}

- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MMBeautyUI.bundle/lip-newC@2x.png"]];
        CGAffineTransform transform = _iconImg.transform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        _iconImg.transform = transform;
        _iconImg.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_iconImg];
        [_iconImg.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-5].active = YES;
        [_iconImg.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
        [_iconImg.widthAnchor constraintEqualToConstant:16].active = YES;
        [_iconImg.heightAnchor constraintEqualToConstant:16].active = YES;
    }
    return _iconImg;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [_titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        if (self.imageView.hidden) {
            [_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        } else {
            [_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-4].active = YES;
        }
        [_titleLabel.widthAnchor constraintEqualToConstant:24].active = YES;
        [_titleLabel.heightAnchor constraintEqualToConstant:33/2.0].active = YES;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
