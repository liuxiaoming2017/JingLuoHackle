//
//  InformationViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/22.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "InformationViewController.h"
#import "HYSegmentedControl.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "InformationDedailssViewController.h"
#import "LoginViewControllerViewController.h"
#import "UIImageView+WebCache.h"

@interface InformationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,MBProgressHUDDelegate,HYSegmentedControlDelegate>
{
    MBProgressHUD* progress_;
    
}
@property (nonatomic,retain)  HYSegmentedControl *BaoGaosegment;
@property (nonatomic ,retain) UITableView *hotTableView;
@property (nonatomic ,retain) UITableView *healthTableView;
@property (nonatomic,retain) UIScrollView* BaoGaoScroll;
@property (nonatomic,retain) UIView * BaoGaoview;
@property (nonatomic ,retain) NSMutableArray *hotArray;
@property (nonatomic ,retain) NSMutableArray *healthArray;
@property (nonatomic ,retain) NSMutableArray *idArray;
@end

@implementation InformationViewController
- (void)dealloc{
    [super dealloc];
    [_BaoGaosegment release];
    [_hotTableView release];
    [_healthArray release];
    [_BaoGaoScroll release];
    [_BaoGaoview release];
    [_hotArray release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _idArray = [[NSMutableArray alloc]init];
    [self setNaviBarTitle:LocalString(@"meridians")];
    self.hotArray = [[NSMutableArray alloc]init];
    self.healthArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self huoquwenzhangCanshu];

}
- (void)huoquwenzhangCanshu{
    NSString *UrlPre=URL_PRE;
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/ healthCategoryList.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestwenzhangResourceslisttssError:)];
    [request setDidFinishSelector:@selector(requestwenzhangResourceslisttssCompleted:)];
    [request startAsynchronous];
}
- (void)requestwenzhangResourceslisttssError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}

- (void)requestwenzhangResourceslisttssCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue] == 100)
    {
        NSArray *array = [dic objectForKey:@"data"];
        NSMutableArray *daArray = [[NSMutableArray alloc]init];
        [_idArray addObject:@"hot"];
        if([[ShareOnce shareOnce].languageStr isEqualToString:@"_en"]){
            [daArray addObject:LocalString(@"hotproblems")];
        }else{
            [daArray addObject:@"热点"];
        }
        
        for (NSDictionary *Dic in array) {
            if([[ShareOnce shareOnce].languageStr isEqualToString:@"_en"]){
                if([[Dic objectForKey:@"name"] isEqualToString:@"养生之道"]){
                    [daArray addObject:LocalString(@"healthPreservation")];
                }else if ([[Dic objectForKey:@"name"] isEqualToString:@"节气养生"]){
                    [daArray addObject:LocalString(@"solarterms")];
                }else if ([[Dic objectForKey:@"name"] isEqualToString:@"经络知识"]){
                    [daArray addObject:LocalString(@"meridians")];
                }
            }else{
                [daArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"name"]]];
            }
            
            [_idArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"id"]]];
        }
        
        [self huoquwenzhang:daArray];
    }
    else
    {
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [avv show];
        [avv release];
    }
}

- (void)huoquwenzhang:(NSMutableArray *)array{
    UILabel* lb=[[UILabel alloc] init];
    lb.frame=CGRectMake(0, 64, SCREEN_WIDTH, 1);
    [self.view addSubview:lb];
    [lb release];
    _BaoGaosegment = [[HYSegmentedControl alloc] initWithOriginY:lb.frame.origin.y Titles:array delegate:self];
    [self.view addSubview:_BaoGaosegment];
    _BaoGaosegment.delegate = self;
    [_BaoGaosegment setBtnorline:array];
    _BaoGaoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 98, self.view.frame.size.width, self.view.frame.size.height - 98)];
    _BaoGaoScroll.pagingEnabled = YES;
    _BaoGaoScroll.delegate = self;
    
    [self.view addSubview:_BaoGaoScroll];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _BaoGaoScroll.contentSize = CGSizeMake(self.view.frame.size.width * _idArray.count, 0);
    _healthTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*_BaoGaosegment.frame.origin.x/(self.view.frame.size.width/self.idArray.count), 0, self.view.frame.size.width, self.view.frame.size.height - 98) style:UITableViewStylePlain];
    _healthTableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _healthTableView.rowHeight = 84;
    _healthTableView.delegate = self;
    _healthTableView.dataSource = self;
    [_BaoGaoScroll addSubview:_healthTableView];

    [self hySegmentedControlSelectAtIndex:0];
}
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    _healthTableView.frame = CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, self.view.frame.size.height - 98);
    _BaoGaoScroll.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
    NSString *idStr = [self.idArray objectAtIndex:index];
    if ([idStr isEqualToString:@"hot"]) {
        [self hotArrayWithView];
    }else{
        [self healthArrayWithView:idStr];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewControllerViewController *loginVC = [[LoginViewControllerViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    [self.healthArray removeAllObjects];
//    [self.healthTableView reloadData];
//    //通过最终得到的偏移量offset值，来确定pageContntrol当前应该显示第几个圆点
//    
//    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
//    
//    [_BaoGaosegment changeSegmentedControlWithIndex:index];
    
}

- (void)hotArrayWithView{
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthArticleList.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    //[request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    //[request setValue:@"50" forKey:@"count"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslisttssError:)];
    [request setDidFinishSelector:@selector(requestResourceslisttssCompleted:)];
    [request startAsynchronous];
}
- (void)requestResourceslisttssError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}

- (void)requestResourceslisttssCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue] == 100)
    {
        [self.healthArray removeAllObjects];
        
        self.healthArray = [dic objectForKey:@"data"];
        NSLog(@"%@",[dic objectForKey:@"data"]);
        [self.healthTableView reloadData];
    }
    else
    {
                NSString *str = [dic objectForKey:@"data"];
                UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                [avv show];
                [avv release];
    }
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}

- (void)healthArrayWithView:(NSString*)string{
    NSString *UrlPre=URL_PRE;
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthListByCategory/%@.jhtml",UrlPre,string];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslisttssErrorsss:)];
    [request setDidFinishSelector:@selector(requestResourceslisttssCompletedsss:)];
    [request startAsynchronous];
}
- (void)requestResourceslisttssErrorsss:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}

- (void)requestResourceslisttssCompletedsss:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue] == 100)
    {
        [self.healthArray removeAllObjects];
        self.healthArray = [dic objectForKey:@"data"];
       // NSLog(@"%@",[dic objectForKey:@"data"]);
        CGSize size;
        size.width=self.healthTableView.frame.size.width;
        size.height=(self.idArray.count)*84;
        [self.healthTableView setContentSize:size];
        [self.healthTableView reloadData];
        
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        [av release];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //av.tag = 100008;
        [av show];
        [av release];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.healthArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LeMedicineCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier]autorelease];
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }

    }
        UIImageView *hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 15, 84, 54)];

        [hotImage sd_setImageWithURL:[NSURL URLWithString:[self.healthArray[indexPath.row]objectForKey:@"picture"]]];
        [cell addSubview:hotImage];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 15, self.view.frame.size.width - 135, 15)];
        titleLabel.textColor = [UtilityFunc colorWithHexString:@"#4b4a4a"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        [cell addSubview:titleLabel];
        
        UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 42, self.view.frame.size.width - 135, 15)];
        hotLabel.font = [UIFont systemFontOfSize:11];
        hotLabel.textColor = [UtilityFunc colorWithHexString:@"#838383"];
        if ([[self.healthArray[indexPath.row]objectForKey:@"seoDescription"]isEqual:[NSNull null]]) {
            hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        }else{
        hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"seoDescription"];
        }
        [cell addSubview:hotLabel];
        NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.healthArray[indexPath.row]objectForKey:@"createDate" ] doubleValue]/1000.00];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        NSString *confromTimespStr = [formatter stringFromDate:data];
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 117, 60, 100, 15)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.text = confromTimespStr;
        [cell addSubview:timeLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cell;
//    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.hotTableView) {
//        InformationDedailssViewController *infortionVC = [[InformationDedailssViewController alloc]init];
//        //infortionVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        infortionVC.titleStr = [self.hotArray[indexPath.row] objectForKey:@"title"];
//        infortionVC.dataStr = [self.hotArray[indexPath.row] objectForKey:@"path"];
//        [self.navigationController pushViewController:infortionVC animated:YES];
//    }else if(tableView == self.healthTableView){
        InformationDedailssViewController *infortionVC = [[InformationDedailssViewController alloc]init];
         //infortionVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        infortionVC.titleStr = [self.healthArray[indexPath.row] objectForKey:@"title"];
        infortionVC.dataStr = [self.healthArray[indexPath.row] objectForKey:@"path"];
        [self.navigationController pushViewController:infortionVC animated:YES];
    //}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
