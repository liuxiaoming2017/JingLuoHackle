//
//  MySportController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MySportController.h"
#import "MySportCell.h"
#import "MenuTypeView.h"

@interface MySportController ()<UICollectionViewDataSource,UICollectionViewDelegate,MenuTypeDelegate>
{
    NSInteger _index;
    BOOL _isScrol;
    NSInteger _lastSelect;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,assign) NSInteger titleIndex;
@end

@implementation MySportController

@synthesize collectionV;

- (id)initWithSportType:(NSInteger)index
{
    self = [super init];
    if(self){
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
        NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
        self.imageArr = [fileArr objectAtIndex:index];
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sportImageText%@",[ShareOnce shareOnce].languageStr] ofType:@"plist"];
        
        
        NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
        self.titleArr = [fileArr2 objectAtIndex:index];
        self.titleIndex = index;
    }
    return self;
}

- (id)initWithAllSport
{
    self = [super init];
    if(self){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
        NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr.count;i++){
            NSArray *arr = [fileArr objectAtIndex:i];
            for(NSString *str in arr){
                [mutableArr addObject:str];
            }
        }
        self.imageArr = [mutableArr copy];
        
       NSString *filePath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sportImageText%@",[ShareOnce shareOnce].languageStr] ofType:@"plist"];
        NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
        NSMutableArray *mutableArr2 = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr2.count;i++){
            NSArray *arr2 = [fileArr2 objectAtIndex:i];
            for(NSString *str in arr2){
                [mutableArr2 addObject:str];
            }
        }
        self.titleArr = [mutableArr2 copy];
        self.titleIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)createUI
{
    self.navTitleLabel.text = LocalString(@"和畅行运动");
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight-kNavBarHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, layout.itemSize.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.pagingEnabled = YES;
    
    [collectionV registerClass:[MySportCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:collectionV];
    [collectionV reloadData];
    
    UIImageView *countImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, collectionV.top+5, 50.4, 64.8)];
    if([[ShareOnce shareOnce].languageStr isEqualToString:@"_en"]){
        countImageV.width = 60.4;
    }
    countImageV.userInteractionEnabled = YES;
    countImageV.tag = 2001;
    countImageV.image = [UIImage imageNamed:@"YD_Type"];
    [self.view addSubview:countImageV];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3+4, countImageV.width, 15)];
    label1.text = [GlobalCommon getSportNameWithIndex:self.titleIndex+1];
    label1.tag = 2002;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor whiteColor];
    [countImageV addSubview:label1];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom+6, countImageV.width, label1.height)];
    label2.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArr.count];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor whiteColor];
    label2.tag = 2003;
    [countImageV addSubview:label2];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((countImageV.width-8)/2, label2.bottom+6, 8, 5)];
    imgV.image = [UIImage imageNamed:@"DownImg"];
    [countImageV addSubview:imgV];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [countImageV addGestureRecognizer:tap];
    
     [self startTimer];
    
//    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
//    self.bottomView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.bottomView];
//    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, ScreenWidth - 10, self.bottomView.height - 6)];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.bottomView addSubview:self.titleLabel];
    
}

- (void)countImgV
{
    UIImageView *countV = (UIImageView *)[self.view viewWithTag:2001];
    UILabel *label2 = (UILabel *)[countV viewWithTag:2003];
    label2.text = [NSString stringWithFormat:@"%ld/%lu",(long)_index+1,(unsigned long)_imageArr.count];
}

- (void)countImgV2WithIndex:(NSInteger )index
{
    UIImageView *countV = (UIImageView *)[self.view viewWithTag:2001];
    UILabel *label1 = (UILabel *)[countV viewWithTag:2002];
    if(index == 0){
        label1.text = LocalString(@"全部");
    }else{
        label1.text = [GlobalCommon getSportNameWithIndex:index];
    }
    UILabel *label2 = (UILabel *)[countV viewWithTag:2003];
    label2.text = [NSString stringWithFormat:@"%ld/%lu",(long)_index+1,(unsigned long)_imageArr.count];
}


- (void)tapAction:(UIGestureRecognizer *)tap
{
    NSArray *arr = [NSArray arrayWithObjects:LocalString(@"all"),LocalString(@"Prepare"),LocalString(@"FirstMode"),LocalString(@"SecondMode"),LocalString(@"ThirdMove"),LocalString(@"FourthMode"),LocalString(@"FifthMode"),LocalString(@"SixthMode"),LocalString(@"SeventhMode"),LocalString(@"EighthMede"), nil];
    MenuTypeView *menuView = [[MenuTypeView alloc] initWithFrame:CGRectMake(10, kNavBarHeight, 220, 320)];
    menuView.menuArr = arr;
    menuView.delegate = self;

    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenuView:)];
    [maskView addGestureRecognizer:tap2];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    maskView.tag = 1001;
    menuView.tag = 1002;

    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
}

- (void)removeMenuView:(UIGestureRecognizer *)tap
{
    MenuTypeView *menuView = (MenuTypeView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    [menuView removeFromSuperview];
    
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    [maskView removeFromSuperview];
}

- (void)selectMenuTypeWithIndex:(NSInteger)index
{
    MenuTypeView *menuView = (MenuTypeView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    [menuView removeFromSuperview];
    
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    [maskView removeFromSuperview];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
    NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sportImageText%@",[ShareOnce shareOnce].languageStr] ofType:@"plist"];
    NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
    if(index==0){
        if(self.imageArr.count==35){
            return;
        }
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr.count;i++){
            NSArray *arr = [fileArr objectAtIndex:i];
            for(NSString *str in arr){
                [mutableArr addObject:str];
            }
        }
        self.imageArr = [mutableArr copy];
        
        NSMutableArray *mutableArr2 = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr2.count;i++){
            NSArray *arr2 = [fileArr2 objectAtIndex:i];
            for(NSString *str in arr2){
                [mutableArr2 addObject:str];
            }
        }
        self.titleArr = [mutableArr2 copy];
        
    }else{
        self.imageArr = [fileArr objectAtIndex:index - 1];
        self.titleArr = [fileArr2 objectAtIndex:index - 1];
    }
    _index = 0;
    [self stopTimer];
    [self countImgV2WithIndex:index];
    [self.collectionV reloadData];
    [self.collectionV setContentOffset:CGPointMake(0, 1)];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MySportCell *cell = (MySportCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imageArr objectAtIndex:indexPath.row]]];
    NSString *titleStr = [self.titleArr objectAtIndex:indexPath.row];
    if(titleStr == nil || [titleStr isEqualToString:@""]){
        cell.bottomView.hidden = YES;
    }else{
        cell.bottomView.hidden = NO;
        [cell titleHeightWithStr:titleStr];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:2.0
                                                   target:self
                                                 selector:@selector(timerRefreshed:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerRefreshed:(id)sender {
    if (_index == [self.imageArr count]) {
        [self stopTimer];
        
    }else
    {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self countImgV];
        _index += 1;
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_isScrol) {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _isScrol = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    currentPage = currentPage % self.imageArr.count;
    _index = currentPage;
    [self countImgV];
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
