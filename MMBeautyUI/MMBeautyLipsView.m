//
//  MMBeautyLipsView.m
//  MMBeautySample
//
//  Created by Zzz on 2021/9/22.
//

#import "MMBeautyLipsView.h"
#import "MMBeautyLipsCell.h"

@interface MMBeautyLipsView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIButton *lipsBtn;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *models;
@property (nonatomic , assign) BOOL clickLipsBtn;
@property (nonatomic , assign) CGAffineTransform lipTransform;

@end

@implementation MMBeautyLipsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.models = @[@"水润",@"雾面",@"镜面",@"亮闪"].mutableCopy;
        [self tableView];
        [self lipsBtn];
        self.clickLipsBtn = NO;
        [self.lipsBtn addTarget:self action:@selector(lipsBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        self.tableView.hidden = YES;
        self.lipsBtn.hidden = NO;
    }
    return self;
}

- (void)lipsBtnClick{
    [self showLipsBtnChangeAnim:self.clickLipsBtn];
    [self changeBtnAnim:self.clickLipsBtn];
    [self.tableView reloadData];
    self.clickLipsBtn = !self.clickLipsBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:(UITableViewStylePlain)];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 12.5;
        _tableView.layer.masksToBounds = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = 32; 
        _tableView.bounces = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[MMBeautyLipsCell class] forCellReuseIdentifier:@"MMBeautyLipsCell"];
        [self addSubview:_tableView];
        [_tableView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_tableView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [_tableView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    }
    return _tableView;
}

- (UIButton *)lipsBtn{
    if (!_lipsBtn) {
        _lipsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lipsBtn setTitle:@"水润" forState:UIControlStateNormal];
        _lipsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _lipsBtn.layer.cornerRadius = 12.5;
        [_lipsBtn setImage:[UIImage imageNamed:@"MMBeautyUI.bundle/lip-newC@2x.png"] forState:(UIControlStateNormal)];
        _lipsBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _lipsBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _lipsBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 0, 0);
        _lipsBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, -63);
        self.lipTransform = _lipsBtn.imageView.transform;
        [self addSubview:_lipsBtn];
        [_lipsBtn.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [_lipsBtn.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [_lipsBtn.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_lipsBtn.heightAnchor constraintEqualToConstant:32].active = YES;
    }
    return  _lipsBtn;
}


- (void)showLipsBtnChangeAnim:(BOOL)status{
    if (status) {
        [UIView transitionWithView:self.lipsBtn duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        } completion:^(BOOL finished) {
            self.lipsBtn.hidden = status;
            self.tableView.hidden = !status;
            [self changeBtnAnim:status];
        }];
    } else{
        [UIView transitionWithView:self.tableView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        } completion:^(BOOL finished) {
            self.tableView.hidden = !status;
            self.lipsBtn.hidden = status;
            [self changeBtnAnim:status];
        }];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.models) {
        MMBeautyLipsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.selectedView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        }
        NSString *str = [self.models objectAtIndex:indexPath.row];
        [self.lipsBtn setTitle:str forState:UIControlStateNormal];
        self.clickLipsBtn = YES;
        [self showLipsBtnChangeAnim:NO];
        self.lipsCallback ? self.lipsCallback(indexPath.row) : nil;
    }
}

- (void)changeBtnAnim:(BOOL)anim{
    // yes  箭头向右 no 箭头向下
    if (anim) {
        CGAffineTransform tempTransform = self.lipTransform;
        tempTransform = CGAffineTransformRotate(tempTransform, M_PI_2);
        self.lipsBtn.imageView.transform = tempTransform;
    } else {
        CGAffineTransform tempTransform = self.lipTransform;
        tempTransform = CGAffineTransformRotate(tempTransform, 0);
        self.lipsBtn.imageView.transform = tempTransform;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMBeautyLipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMBeautyLipsCell"];
    if (!cell) {
        cell = [[MMBeautyLipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MMBeautyLipsCell"];
    }
    NSString *title = [self.models objectAtIndex:indexPath.row];
    if (title) {
        [cell configCellWithName:title];
    }
    if ([title isEqualToString:self.lipsBtn.titleLabel.text]) {
        cell.selectedView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    } else {
        cell.selectedView.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == self.models.count - 1) {
        cell.iconImg.hidden = NO;
    } else {
        cell.iconImg.hidden = YES;
    }
    return cell;
}

@end
