//
//  RecommendReadView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RecommendReadView.h"
#import "RecommendCollectCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "InformationDedailssViewController.h"
#import "UIImageView+WebCache.h"
#import "NSObject+SBJson.h"
#import "WKWebviewController.h"

@interface RecommendReadView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;

@end

@implementation RecommendReadView

@synthesize collectionV;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = UIColorFromHex(0xFFFFFF);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 200, 25)];
    titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = LocalString(@"Suggestedreading");
    [self addSubview:titleLabel];
    
    CGFloat width = (ScreenWidth - 23 - 10)/2.5;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width*0.75+7+40);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(23, 40+10, self.bounds.size.width-23*2, layout.itemSize.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    
    
    
    [collectionV registerClass:[RecommendCollectCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self addSubview:collectionV];
    [self requestArticleData];

}

- (void)requestArticleData{
    NSString *UrlPre=URL_PRE;
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthArticleList.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslisttssError:)];
    [request setDidFinishSelector:@selector(requestResourceslisttssCompleted:)];
    [request startAsynchronous];
}
- (void)requestResourceslisttssError:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    
}

- (void)requestResourceslisttssCompleted:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic = (NSDictionary *)[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue] == 100)
    {
        self.recommendArr = [dic objectForKey:@"data"];
        [collectionV reloadData];
    }
    else
    {
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [avv show];
        
    }
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recommendArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    RecommendCollectCell *cell = (RecommendCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageV.hidden = NO;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[self.recommendArr[indexPath.row]objectForKey:@"picture"]]];
    cell.titleLabel.text = [self.recommendArr[indexPath.row]objectForKey:@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //InformationDedailssViewController *vc = [[InformationDedailssViewController alloc] init];
    WKWebviewController *vc = [[WKWebviewController alloc] init];
    vc.titleStr = [self.recommendArr[indexPath.row] objectForKey:@"title"];
    vc.dataStr = [self.recommendArr[indexPath.row] objectForKey:@"path"];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    
}

@end
