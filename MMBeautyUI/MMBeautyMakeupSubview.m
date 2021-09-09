//
//  MMBeautyMakeupSubview.m
//  MMBeautySample
//
//  Created by sunfei on 2021/1/26.
//

#import "MMBeautyMakeupSubview.h"
#import "MMBeautyTabCollectionViewCell.h"
#import "MMBottomViewModel.h"

@interface MMBeautyMakeupSubview () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation MMBeautyMakeupSubview

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *backButton = [[UIView alloc] initWithFrame:CGRectZero];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:backButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked)];
        [backButton addGestureRecognizer:tap];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MMBeautyUI.bundle/icon-back@2x.png"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeCenter;
        [backButton addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont boldSystemFontOfSize:11];
        titleLabel.textColor = UIColor.whiteColor;
        _titleLabel = titleLabel;
        [backButton addSubview:titleLabel];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 95);
        layout.minimumInteritemSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        [collectionView registerClass:[MMBeautyTabCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView = collectionView;
        
        [imageView.topAnchor constraintEqualToAnchor:backButton.topAnchor].active = YES;
        [imageView.centerXAnchor constraintEqualToAnchor:backButton.centerXAnchor].active = YES;
        [imageView.heightAnchor constraintEqualToConstant:60].active = YES;
        [imageView.widthAnchor constraintEqualToAnchor:backButton.widthAnchor].active = YES;
        
        [titleLabel.bottomAnchor constraintEqualToAnchor:backButton.bottomAnchor constant:-15].active = YES;
        [titleLabel.centerXAnchor constraintEqualToAnchor:backButton.centerXAnchor].active = YES;
        [titleLabel.widthAnchor constraintEqualToAnchor:backButton.widthAnchor].active = YES;
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[backButton, _collectionView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.spacing = 20;
        [self addSubview:stackView];
        
        [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20].active = YES;
        [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        
        [backButton.widthAnchor constraintEqualToConstant:40].active = YES;
    }
    return self;
}

- (void)backButtonClicked {
    self.selectItem  ? self.selectItem(self.model, self.selectIndexPath) : nil;
    self.backButtonClickedBlock ? self.backButtonClickedBlock() : nil;
}

- (void)setModel:(MMBottomViewModel *)model {
    _model = model;
    [_model.contents enumerateObjectsUsingBlock:^(MMBottomViewModelItem *item, NSUInteger idx, BOOL * stop) {
        if (item.selected == YES) {
            self.selectIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            *stop = YES;
        }
    }];
    self.titleLabel.text = model.name;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.contents.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMBeautyTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MMBottomViewModelItem *item = self.model.contents[indexPath.row];
    if (indexPath.row == 0 || [item.type isEqualToString:@"beauty_redden"] || [item.type isEqualToString:@"beauty_white"]) {
        cell.imageView.image = [UIImage imageNamed:item.icon];
        cell.imageView.contentMode = UIViewContentModeCenter;
    } else {
        NSString *path = [NSBundle.mainBundle pathForResource:@"makeup" ofType:@"bundle"];
        NSString *filename = [[path stringByAppendingPathComponent:item.highlight] stringByAppendingPathComponent:item.icon];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filename]];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.layer.borderWidth = 1.0;
    cell.imageView.layer.borderColor = item.selected ? [[UIColor colorWithRed:50.0 / 255 green:194.0 / 255 blue:210.0 / 255 alpha:1.0] CGColor] : [UIColor.clearColor CGColor];
    cell.titleLabel.text = item.title;
    if ([item.title isEqualToString:@"无"] || [item.title isEqualToString:@"关闭"]|| [item.title isEqualToString:@"原图"]) {
        cell.valueLabel.text = @" ";
    } else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [NSNumber numberWithDouble:item.curPos * 100];
        formatter.numberStyle = kCFNumberFormatterNoStyle;
        NSString *str = [formatter stringFromNumber:number];
        cell.valueLabel.text = [NSString stringWithFormat:@"%@", str];
    }
    
    
    return cell;
}


#pragma mark - UICollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MMBottomViewModelItem *selectedItem = self.model.contents.firstObject;
    for (MMBottomViewModelItem *item in self.model.contents) {
        if (item.selected) {
            selectedItem = item;
        }
    }
    selectedItem.selected = NO;
    MMBottomViewModelItem *item = self.model.contents[indexPath.row];
    item.selected = YES;
    self.selectIndexPath = indexPath;
    [self.collectionView reloadData];
    self.selectItem  ? self.selectItem(self.model, indexPath) : nil;
}
- (void)updateLabel:(CGFloat)curPos{
    if (self.selectIndexPath.row <= self.model.contents.count) {
        MMBottomViewModelItem *item = self.model.contents[self.selectIndexPath.row];
        item.curPos = curPos;
        MMBeautyTabCollectionViewCell *cell = (MMBeautyTabCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [NSNumber numberWithDouble:item.curPos * 100];
        formatter.numberStyle = kCFNumberFormatterNoStyle;
        NSString *str = [formatter stringFromNumber:number];
        if ([item.title isEqualToString:@"无"] || [item.title isEqualToString:@"原图"] || [item.title isEqualToString:@"关闭"]) {
            cell.valueLabel.text = @" ";
        } else {
            cell.valueLabel.text = [NSString stringWithFormat:@"%@", str];
        }
    }
}

@end
