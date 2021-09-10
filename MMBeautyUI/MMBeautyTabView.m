//
//  MMBeautyTabView.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBeautyTabView.h"
#import "MMButtonItems.h"
#import "MMBeautyTabCollectionViewCell.h"
#import "MMBeautyMakeupSubview.h"

@interface MMBeautyTabView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSArray<MMBottomViewModel *> *models;
@property (nonatomic, copy) NSDictionary <NSString *, MMBottomViewModel *> *makeups;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MMBeautyMakeupSubview *makeupView;

@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSIndexPath *lastSelectedOnceIndexpath;
@property (nonatomic, strong) MMButtonItems *buttonItems;
@property (nonatomic, strong) MMBottomViewModel *lastMakeupItem;
@property (nonatomic, assign) NSInteger lastSelectedLookUpIndex;

@property (nonatomic , strong) MMBottomViewBuautyModelItem *onceBeautyModel;
@end

@implementation MMBeautyTabView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray <MMBottomViewModel *> *makeupModels = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"makeupConfig" ofType:@"geojson"]] options:0 error:nil];
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        for (NSDictionary *item in makeupModels) {
            MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:item];
            tmp[model.name] = model;
        }
        _makeups = tmp.copy;
    }
    return self;
}

- (void)setupView {
    _lastSelectedOnceIndexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    _lastSelectedLookUpIndex = 1;
    UIVisualEffectView *bgView = [[UIVisualEffectView alloc] init];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    bgView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [self addSubview:bgView];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (MMBottomViewModel *model in self.models) {
        [titles addObject:model.name];
    }
    MMButtonItems *buttonItems = [[MMButtonItems alloc] initWithFrame:CGRectZero titles:titles];
    [buttonItems selectIndex:0];
    _buttonItems = buttonItems;
    
    __weak typeof(self) wself = self;
    buttonItems.buttonItemClicked = ^(NSInteger index) {
        __strong typeof(self) sself = wself;
        sself.collectionView.hidden = NO;
        sself.makeupView.hidden = YES;
        if ( sself.selectedIndex != nil && sself.selectedIndex.section == 4) {
            if (sself.lastMakeupItem != nil) {
                __block NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:sself.selectedIndex.section];
                [sself.lastMakeupItem.contents enumerateObjectsUsingBlock:^(MMBottomViewModelItem * obj, NSUInteger idx, BOOL * stop) {
                    if (obj.selected) {
                        path = [NSIndexPath indexPathForRow:idx inSection:sself.selectedIndex.section];
                        *stop = YES;
                    }
                }];
              
                sself.makeupView.selectItem(sself.lastMakeupItem, path);
            }
        }
        MMBottomViewModel *tmpModel = sself.models[index];
        if ([tmpModel.type isEqualToString:@"OneClickbeauty"])
        {
            if (sself.onceBeautyModel) {
                if (sself.lastSelectedOnceIndexpath) {
                    sself.selectedIndex = sself.lastSelectedOnceIndexpath;
                }else {
                    sself.selectedIndex = [NSIndexPath indexPathForRow:1 inSection:index];
                }
            } else {
                sself.selectedIndex = [NSIndexPath indexPathForRow:1 inSection:index];
            }
        }
        else {
            NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:0 inSection:index];
            if ([tmpModel.type isEqualToString:@"lookup"]) {
                if ([sself checkMakeupSelected]) {
                    tmpPath = [NSIndexPath indexPathForRow:0 inSection:index];
                } else {
                    tmpPath = [NSIndexPath indexPathForRow:sself.lastSelectedLookUpIndex inSection:index];
                }
            } else {
                for (int i = 0; i < tmpModel.contents.count; ++i) {
                    MMBottomViewModelItem * item = tmpModel.contents[i];
                    if (item.selected) {
                        tmpPath = [NSIndexPath indexPathForRow:i inSection:index];
                        break;
                    }
                }
            }
            sself.selectedIndex = tmpPath;
        }
        // 一键美颜默认值改变时 不需要通知控制器仅通知 UI 修改 slider 展示
        if (index == 0) {
            if (sself.onceBeautyModel) {
                sself.selectedModel ? sself.selectedModel(sself.models, sself.selectedIndex) : nil;
            } else {
                NSIndexPath *path = [NSIndexPath indexPathForRow:-100 inSection:0];
                sself.selectedModel ? sself.selectedModel(sself.models, path) : nil;
            }
        } else {
            sself.selectedModel ? sself.selectedModel(sself.models, sself.selectedIndex) : nil;
        }
    };
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setImage:[UIImage imageNamed:@"MMBeautyUI.bundle/refresh@2x.png"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *hStackView = [[UIStackView alloc] initWithArrangedSubviews:@[buttonItems, button]];
    hStackView.translatesAutoresizingMaskIntoConstraints = NO;
    hStackView.axis = UILayoutConstraintAxisHorizontal;
    hStackView.alignment = UIStackViewAlignmentCenter;
    hStackView.distribution = UIStackViewDistributionEqualSpacing;
    hStackView.spacing = 8;
    [bgView.contentView addSubview:hStackView];
    
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
    collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [collectionView registerClass:[MMBeautyTabCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [bgView.contentView addSubview:collectionView];
    _collectionView = collectionView;
    
    MMBeautyMakeupSubview *makeupView = [[MMBeautyMakeupSubview alloc] init];
    makeupView.translatesAutoresizingMaskIntoConstraints = NO;
    makeupView.hidden = YES;
    makeupView.selectItem = ^(MMBottomViewModel *model, NSIndexPath *indexPath) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:wself.selectedIndex.section];
        MMBottomViewModelItem *viewModel = wself.models[wself.selectedIndex.section].contents[wself.selectedIndex.row];
        for (MMBottomViewModelItem *makeupModel in model.contents) {
            if (makeupModel.selected) {
                viewModel.curPos = makeupModel.curPos;
                break;
            }
        }
        [wself.collectionView reloadData];
        wself.selectedModel ? wself.selectedModel(@[model], path) : nil;
    };
    makeupView.backButtonClickedBlock = ^{
        wself.collectionView.hidden = NO;
        wself.makeupView.hidden = YES;
        NSIndexPath *path =  [NSIndexPath indexPathForRow:-100 inSection:0];
        wself.selectedModel ? wself.selectedModel(wself.models, path) : nil;
    };
    [bgView.contentView addSubview:makeupView];
    _makeupView = makeupView;

    [buttonItems.widthAnchor constraintEqualToAnchor:hStackView.widthAnchor constant:-60].active = YES;
    [buttonItems.heightAnchor constraintEqualToConstant:40].active = YES;
    
    [button.heightAnchor constraintEqualToConstant:40].active = YES;
    
    [hStackView.leadingAnchor constraintEqualToAnchor:bgView.contentView.leadingAnchor constant:5].active = YES;
    [hStackView.trailingAnchor constraintEqualToAnchor:bgView.contentView.trailingAnchor constant:-5].active = YES;
    [hStackView.topAnchor constraintEqualToAnchor:bgView.contentView.topAnchor].active = YES;
    
    [collectionView.centerXAnchor constraintEqualToAnchor:bgView.contentView.centerXAnchor].active = YES;
    [collectionView.widthAnchor constraintEqualToAnchor:bgView.contentView.widthAnchor].active = YES;
    [collectionView.heightAnchor constraintEqualToConstant:95].active = YES;
    [collectionView.topAnchor constraintEqualToAnchor:hStackView.bottomAnchor constant:15].active = YES;
    
    [makeupView.centerXAnchor constraintEqualToAnchor:bgView.contentView.centerXAnchor].active = YES;
    [makeupView.widthAnchor constraintEqualToAnchor:bgView.contentView.widthAnchor].active = YES;
    [makeupView.heightAnchor constraintEqualToConstant:95].active = YES;
    [makeupView.topAnchor constraintEqualToAnchor:hStackView.bottomAnchor constant:15].active = YES;

    [bgView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [bgView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [bgView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [bgView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    UIView *grayLineView = [[UIView alloc] init];
    grayLineView.translatesAutoresizingMaskIntoConstraints = NO;
    grayLineView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    [self addSubview:grayLineView];
    [grayLineView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-10].active = YES;
    [grayLineView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [grayLineView.bottomAnchor constraintEqualToAnchor:hStackView.bottomAnchor].active = YES;
    [grayLineView.heightAnchor constraintEqualToConstant:1].active = YES;
}
extern NSArray * kMMBeautyKitOnceBeuatyArray();
- (void)updateLabel:(CGFloat)sliderValue{
    if (_selectedIndex.section == 0) {
        return;
    }
    MMBottomViewModelItem *curItem = self.models[self.selectedIndex.section].contents[self.selectedIndex.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [NSNumber numberWithDouble:curItem.curPos * 100];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    NSString *str = [formatter stringFromNumber:number];
    if (!self.collectionView.hidden) {
        MMBeautyTabCollectionViewCell *cell = (MMBeautyTabCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.row inSection:0]];
        if ([curItem.title isEqualToString:@"原图"] || [curItem.title isEqualToString:@"无"] || [curItem.title isEqualToString:@"风格妆"]) {
            cell.valueLabel.text = @" ";
        } else {
            cell.valueLabel.text = [NSString stringWithFormat:@"%@", str];
        }
        
    }
    if (!self.makeupView.hidden) {
        [self.makeupView updateLabel:sliderValue];
    }
 
    MMBottomViewModel *curModel = self.models[self.selectedIndex.section];
    if ([curModel.name isEqualToString:@"滤镜"] || [curModel.name isEqualToString:@"风格妆"] || [curModel.name isEqualToString:@"美妆"]) {
        return;
    }
    if (self.onceBeautyModel) {
        NSDictionary *dict = [kMMBeautyKitOnceBeuatyArray() objectAtIndex:self.lastSelectedOnceIndexpath.row];
        MMBottomViewModelItem *item = [curModel.contents objectAtIndex:self.selectedIndex.row];
        for (NSDictionary *d in dict) {
            NSString *name = [d objectForKey:@"title"];
            if ([item.title isEqualToString:name]) {
                NSNumber *number = [d objectForKey:@"value"];
                if (str.floatValue != number.floatValue) {
                    self.onceBeautyModel = nil;
                }
            }
        }
    }
}

- (void)resetButtonClicked:(UIButton *)button {
    MMBottomViewModel *curModel = self.models[self.selectedIndex.section];
    self.onceBeautyModel = nil;
    for (MMBottomViewModelItem *item in curModel.contents) {
        item.curPos = [item.value floatValue];
    }
    if ([curModel.type isEqualToString:@"makeup_layers"]) {
        for (NSString *key in self.makeups) {
            MMBottomViewModel *model = self.makeups[key];
            for (int i = 0; i < model.contents.count; ++ i) {
                [model.contents[i] setSelected:i == 0];
                MMBottomViewModelItem * makeupModel = model.contents[i];
                makeupModel.curPos = makeupModel.value.floatValue;
            }
        }
        self.collectionView.hidden = NO;
        self.makeupView.hidden = YES;
    } else if ([curModel.type isEqualToString:@"beauty"]){
        self.collectionView.hidden = NO;
        self.makeupView.hidden = YES;
        [self resetMakeUpModels];
    }
    for (MMBottomViewModelItem *item in curModel.contents) {
        item.curPos = [item.value floatValue];
    }
    self.resetButtonClicked ? self.resetButtonClicked(self.models, self.selectedIndex) : nil;
    __weak typeof(self) wself = self;
    self.resetButtonClicked ? self.resetButtonClicked(wself.models, wself.selectedIndex) : nil;
    if ([curModel.name isEqualToString:@"滤镜"] || [curModel.name isEqualToString:@"一键美颜"]) {
        if ( [curModel.name isEqualToString:@"一键美颜"]) {
            self.onceBeautyModel = self.models[0].contents[1];
            [self userOnceBeautyModel];
        }
        self.selectedIndex = [NSIndexPath indexPathForRow:1 inSection:self.selectedIndex.section];
    } else {
        self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:self.selectedIndex.section];
    }
    
    self.selectedModel ? self.selectedModel(wself.models, wself.selectedIndex) : nil;
}

- (void)selectTab:(NSInteger)tabIndex {
    MMBottomViewModel *tmpModel = self.models[tabIndex];
    if ([tmpModel.type isEqualToString:@"OneClickbeauty"]) {
        self.selectedIndex = [NSIndexPath indexPathForRow:1 inSection:tabIndex];
        if ([tmpModel.type isEqualToString:@"OneClickbeauty"] ) {
            self.onceBeautyModel = self.models[0].contents[1];
            [self  userOnceBeautyModel];
            self.lastSelectedOnceIndexpath = self.selectedIndex;
        }
    } else {
        [self restModels];
        if ([tmpModel.type isEqualToString:@"lookup"]) {
            self.selectedIndex = [NSIndexPath indexPathForRow:1 inSection:tabIndex];
        } else {
            self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:tabIndex];
        }
        
    }
    [self.buttonItems selectIndex:tabIndex];
}

- (BOOL)checkMakeupSelected{
    NSInteger index = 0;
    for (int i = 0; i < self.models[3].contents.count; ++i) {
        MMBottomViewModelItem *item = self.models[3].contents[i];
        if (item.selected) {
            index = i;
            break;;
        }
    }
    return index == 0 ? NO : YES;
}

- (void)resetMakeUpModels{
    MMBottomViewModel *tmpItem1 = self.makeups[@"美白"];
    MMBottomViewModel *tmpItem2 = self.makeups[@"红润"];
    for (int i = 0; i < tmpItem1.contents.count; ++i) {
        MMBottomViewModelItem *item = tmpItem1.contents[i];
        item.selected = i == 1;
        item.curPos = item.value.floatValue;
    }
    for (int i = 0; i < tmpItem2.contents.count; ++i) {
        MMBottomViewModelItem *item = tmpItem2.contents[i];
        item.selected = i == 1;
        item.curPos = item.value.floatValue;
    }
}
- (void)restModels{
    NSArray<MMBottomViewModelItem *> *beauty1 = self.models[1].contents;
    NSArray<MMBottomViewModelItem *> *beauty2 = self.models[2].contents;
    for (int i = 0; i < beauty1.count; i ++) {
        MMBottomViewModelItem *tmpModel = beauty1[i];
        tmpModel.curPos = tmpModel.value.floatValue;
    }
    for (int i = 0; i < beauty2.count; i ++) {
        MMBottomViewModelItem *tmpModel = beauty2[i];
        tmpModel.curPos = tmpModel.value.floatValue;
    }
}

- (void)setModels:(NSArray<MMBottomViewModel *> *)models {
    _models = models.copy;
    [self setupView];
    __weak typeof(self) wself = self;
    self.selectedModel ? self.selectedModel(wself.models, wself.selectedIndex) : nil;
}

- (void)setSelectedIndex:(NSIndexPath *)selectedIndex {
    if (selectedIndex) {
        for (MMBottomViewModelItem *item in self.models[selectedIndex.section].contents) {
            item.selected = NO;
        }
    }
    _selectedIndex = selectedIndex;
    MMBottomViewModelItem *newItem = self.models[selectedIndex.section].contents[selectedIndex.row];
    if (_selectedIndex.section == 0) {
        newItem.selected = self.onceBeautyModel == nil ? NO : YES;
    } else{
        newItem.selected = YES;
    }
    [self.collectionView reloadData];
}

- (void)userOnceBeautyModel{
    NSArray<MMBottomViewModelItem *> *beauty1 = self.models[1].contents;
    NSArray<MMBottomViewModelItem *> *beauty2 = self.models[2].contents;
    CGFloat whiteValue = 0.0,redValue = 0.0;
    for (int i = 0; i < beauty1.count; i ++) {
        MMBottomViewModelItem *tmpModel = beauty1[i];
        for (int j = 0; j < self.onceBeautyModel.contents.count; j++) {
            MMBottomViewModelItem *onceModel = self.onceBeautyModel.contents[j];
            if ([tmpModel.type isEqualToString:onceModel.type]) {
                if ([onceModel.title isEqualToString:@"美白"]) {
                    whiteValue = onceModel.curPos;
                }
                if ([onceModel.title isEqualToString:@"红润"]) {
                    redValue = onceModel.curPos;
                }
                tmpModel.curPos = onceModel.value.floatValue;
            }
        }
        
    }
    MMBottomViewModel *tmpItem1 = self.makeups[@"美白"]; // 找到模型 并且重置选中状态 并且赋值
    for (int i = 0; i < tmpItem1.contents.count; ++i) {
        MMBottomViewModelItem *item = tmpItem1.contents[i];
        if (i == 1) {
            item.selected = YES;
            item.curPos = whiteValue;
        } else {
            item.selected = NO;
        }
    }
    MMBottomViewModel *tmpItem2 = self.makeups[@"红润"]; // 找到模型 并且重置选中状态 并且赋值
    for (int i = 0; i < tmpItem2.contents.count; ++i) {
        MMBottomViewModelItem *item = tmpItem2.contents[i];
        if (i == 1) {
            item.selected = YES;
            item.curPos = redValue;
        } else {
            item.selected = NO;
        }
    }
    // 微整形
    for (int i = 0; i < beauty2.count; i ++) {
        MMBottomViewModelItem *tmpModel = beauty2[i];
        for (int j = 0; j < self.onceBeautyModel.contents.count; j++) {
            MMBottomViewModelItem *onceModel = self.onceBeautyModel.contents[j];
            if ([tmpModel.type isEqualToString:onceModel.type]) {
                tmpModel.curPos = onceModel.value.floatValue;
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models[self.selectedIndex.section].contents.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMBeautyTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray<MMBottomViewModelItem *> *items = self.models[self.selectedIndex.section].contents;
    MMBottomViewModelItem *item = items[indexPath.row];
    if ([item.type isEqualToString:@"lookup"]) {
        if (![item.identifier isEqualToString:@"-1"]) {
            NSString *path = [NSBundle.mainBundle pathForResource:@"Lookup" ofType:@"bundle"];
            NSString *filename = [[path stringByAppendingPathComponent:item.icon] stringByAppendingPathComponent:@"icon.png"];
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filename]];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"MMBeautyUI.bundle/none@2x.png"];
            cell.imageView.contentMode = UIViewContentModeCenter;
        }
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.layer.masksToBounds = YES;
        if (item.selected) {
            cell.imageView.layer.borderColor = [UIColor colorWithRed:56 / 255.0 green:235 / 255.0 blue:1.0 alpha:1.0].CGColor;
            cell.imageView.layer.borderWidth = 1.0;
        } else {
            cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
            cell.imageView.layer.borderWidth = 1.0;
        }
    } else if ([item.type isEqualToString:@"makeup"]) {
        if (indexPath.row == 0) {
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
        
    } else if ([item.type isEqualToString:@"OneClickbeauty"]){
        cell.imageView.image = [UIImage imageNamed:item.icon];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.layer.cornerRadius = 30;
        cell.imageView.layer.masksToBounds = YES;
        if (item.selected) {
            cell.imageView.layer.borderColor = [UIColor colorWithRed:50 / 255.0 green:235 / 255.0 blue:1.0 alpha:1.0].CGColor;
            cell.imageView.layer.borderWidth = 1;
        } else {
            cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
            cell.imageView.layer.borderWidth = 1;
        }
    } else if ([item.type isEqualToString:@"makeup_layers"]){
        cell.imageView.image = [UIImage imageNamed:item.icon];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.layer.cornerRadius = 30;
        cell.imageView.layer.borderWidth = 1.0;
        cell.imageView.layer.borderColor = item.selected ? [[UIColor colorWithRed:50.0 / 255 green:194.0 / 255 blue:210.0 / 255 alpha:1.0] CGColor] : [UIColor.clearColor CGColor];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:!item.selected ? item.icon : item.highlight];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.layer.cornerRadius = 30;
        cell.imageView.layer.masksToBounds = NO;
        cell.imageView.layer.borderWidth = 1.0;
        cell.imageView.layer.borderColor = [UIColor.clearColor CGColor];
    }
    cell.titleLabel.text = item.title;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [NSNumber numberWithDouble:item.curPos * 100];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    NSString *str = [formatter stringFromNumber:number];
    cell.valueLabel.text = str;
    if ([cell.titleLabel.text isEqualToString:@"原图"] || self.selectedIndex.section == 0 || self.selectedIndex.section == 3) {
        cell.valueLabel.text = @" ";
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectedIndex.section == 0) {
        self.lastSelectedOnceIndexpath = indexPath;
        self.onceBeautyModel = self.models[0].contents[indexPath.row];
        [self userOnceBeautyModel];
    }
    self.selectedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedIndex.section];
    MMBottomViewModel *model = self.models[self.selectedIndex.section];
    // 处理美妆和 风格装的互斥状态
    if ([model.type isEqualToString:@"lookup"]) {
        _lastSelectedLookUpIndex = indexPath.row;
    }
    if ([model.type isEqualToString:@"makeup_layers"]) {
        if (indexPath.row > 0) {
            MMBottomViewModel *model = self.models[3];
            for (int i = 0; i < model.contents.count; ++ i) {
                [model.contents[i] setSelected:i == 0];
            }
            //处理滤镜的选中状态
            MMBottomViewModel *lookupModels = [self.models lastObject];
            for (int i = 0; i < lookupModels.contents.count; ++ i) {
                [lookupModels.contents[i] setSelected:i == _lastSelectedLookUpIndex];
            }
        } else {
            MMBottomViewModel *lookupModels = [self.models lastObject];
            for (int i = 0; i < lookupModels.contents.count; ++ i) {
                [lookupModels.contents[i] setSelected:i == 0];
            }
        }
        
    }
    if ([model.type isEqualToString:@"makeup"] ) {
        if (indexPath.row > 0) {
            MMBottomViewModel *model = self.models[4];
            for (int i = 0; i < model.contents.count; ++ i) {
                MMBottomViewModelItem *item = model.contents[i];
                [item setSelected:i == 0];
                item.curPos = item.value.floatValue;
            }
            for (NSString *key in self.makeups) {
                if ([key isEqualToString:@"美白"] || [key isEqualToString:@"红润"]) {
                    continue;
                }
                MMBottomViewModel *model = self.makeups[key];
                for (int i = 0; i < model.contents.count; ++ i) {
                    MMBottomViewModelItem *tmpModel = model.contents[i];
                    [tmpModel setSelected:i == 0];
                    tmpModel.curPos = tmpModel.value.floatValue;
                }
            }
            //处理滤镜的选中状态
            MMBottomViewModel *lookupModels = [self.models lastObject];
            for (int i = 0; i < lookupModels.contents.count; ++ i) {
                [lookupModels.contents[i] setSelected:i == 0];
            }
        } else {
            //处理滤镜的选中状态
            MMBottomViewModel *lookupModels = [self.models lastObject];
            for (int i = 0; i < lookupModels.contents.count; ++ i) {
                [lookupModels.contents[i] setSelected:i == _lastSelectedLookUpIndex];
            }
        }
       
    }
    if ([model.type isEqualToString:@"makeup_layers"] || [model.type isEqualToString:@"beauty"]) {
        MMBottomViewModelItem *item = model.contents[self.selectedIndex.row];
        if (![item.identifier isEqualToString:@"-1"]) {
            MMBottomViewModel *itemModel = self.makeups[item.title];
            if (itemModel) {
                self.collectionView.hidden = YES;
                self.makeupView.hidden = NO;
                MMBottomViewModel *tmpItem = self.makeups[item.title];
                NSIndexPath *path;
                if ([tmpItem.type isEqualToString:@"makeup_layers"]) {
                    path = [NSIndexPath indexPathForRow:-100 inSection:0];
                } else {
                    MMBottomViewModelItem *tmpModel = tmpItem.contents.firstObject;
                    if (tmpModel.selected) {
                        path = [NSIndexPath indexPathForRow:-100 inSection:0];
                    } else {
                        path = self.selectedIndex;
                    }
                }
                self.makeupView.model = tmpItem;
                self.lastMakeupItem = tmpItem;
                self.selectedModel ? self.selectedModel(self.models, path) : nil;
            } else {
                self.collectionView.hidden = NO;
                self.makeupView.hidden = YES;
                self.selectedModel ? self.selectedModel(self.models, self.selectedIndex) : nil;
            }
        } else {
            self.selectedModel ? self.selectedModel(self.models, self.selectedIndex) : nil;
        }
    } else {
        MMBottomViewModelItem *item = model.contents[indexPath.row];
        item.selected = YES;
        self.selectedModel ? self.selectedModel(self.models, self.selectedIndex) : nil;
    }
}

- (NSArray *)getAllselectedMakeUpItems{
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *key in self.makeups) {
        if ([key isEqualToString:@"美白"] || [key isEqualToString:@"红润"]) {
            continue;
        }
        MMBottomViewModel *model = self.makeups[key];
        for (int i = 0; i < model.contents.count; ++ i) {
            MMBottomViewModelItem *tmpModel = model.contents[i];
            if (tmpModel.selected) {
                if (![tmpModel.title isEqualToString:@"无"]) {
                    [array addObject:tmpModel];
                }
                break;
            }
        }
    }
    return  array;
}

- (void)reloadData{
    if (self.models) {
        [self.collectionView reloadData];
    }
}

@end
