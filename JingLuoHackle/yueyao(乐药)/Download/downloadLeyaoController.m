//
//  downloadLeyaoController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "downloadLeyaoController.h"
#import "DownloadLeyaoCell.h"
//#import "GoodsSureController.h"

@interface downloadLeyaoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *mutableArr;
@end

@implementation downloadLeyaoController

- (id) initWithDataArr:(NSArray *)arr
{
    self = [super init];
    if(self){
        self.dataArr = arr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupBottom];
    
    self.price = 1.90;
    
    self.mutableArr = [NSMutableArray arrayWithCapacity:0];
    
   // [self requestLeyaoList];
}

- (void)setupNav2
{
    // 设置导航默认标题的颜色及字体大小
    UILabel  *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 43)];
    navTitleLabel.text = @"下载乐药";
    navTitleLabel.font = [UIFont systemFontOfSize:18];
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navTitleLabel;
    
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn sizeToFit];
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    preBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [preBtn setTitle:LocalString(@"return") forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [preBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:preBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0X4FAEFE);
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
}

- (void)setupUI
{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,kStatusBarHeight+kNavHeight, ScreenWidth, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 50)];
    titleLabel.text = @"根据您的评估结果为您推荐";
    titleLabel.textColor = UIColorFromHex(0xDADADA);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [topView addSubview:titleLabel];
    
    UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom-1, ScreenWidth, 1)];
    lineV.alpha = 0.5;
    lineV.backgroundColor = UIColorFromHex(0xDADADA);
    [topView addSubview:lineV];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bottom, ScreenWidth, ScreenHeight-topView.bottom-45) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.editing = YES;
    self.tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
}

- (void)setupBottom
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-45, ScreenWidth, 45)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(10, 13, 20, 20);
    [allSelectBtn setImage:[UIImage imageNamed:@"leyaoNormal"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"leyaoSelect"] forState:UIControlStateSelected];
    [allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:allSelectBtn];
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(allSelectBtn.right+5, allSelectBtn.top, 40, 20)];
    allLabel.text = @"全选";
    allLabel.textColor = UIColorFromHex(0xDADADA);
    allLabel.font = [UIFont systemFontOfSize:15];
    [self.bottomView addSubview:allLabel];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(ScreenWidth-90, 0, 90, self.bottomView.height);
    [chooseBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:200/255.0 blue:62/255.0 alpha:1.0]];
    [chooseBtn setTitle:@"选好了" forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chooseBtn addTarget:self action:@selector(chooseFinish:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chooseBtn];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-chooseBtn.width-15-100, 10, 100, 25)];
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.text = @"总计:￥0.00";
    priceLabel.tag = 1001;
    [self.bottomView addSubview:priceLabel];
    
}

- (void)chooseFinish:(UIButton *)btn
{
    if(self.mutableArr.count == 0){
        [self showAlertWarmMessage:@"请去添加商品"];
        return;
    }
    
    NSString *idStr = @"";
    if(self.mutableArr.count == 1){
        NSDictionary *dic = [self.mutableArr objectAtIndex:0];
        idStr = [dic objectForKey:@"id"];
    }else{
        for(NSInteger i=0;i<self.mutableArr.count;i++){
            NSDictionary *dic = [self.mutableArr objectAtIndex:i];
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic objectForKey:@"id"]]];
        }
        if(idStr.length>0){
            idStr = [idStr substringToIndex:idStr.length - 1];
        }
    }
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/reserve.jhtml?memberId=%@&ids=%@",URL_PRE,g_userInfo.uid,idStr];
    
    __block typeof(self) bself = self;
    
    [[NetWorkSharedInstance sharedInstance] networkWithRequestUrlStr:aUrlle RequestMethod:@"GET" PostDictionay:nil headDictionay:nil Success:^(id result, int flag) {
        id status=[result objectForKey:@"status"];
        if(status!=nil){
            if([status intValue] == 100){
//                NSString *idString = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"data"] objectForKey:@"order"]objectForKey:@"id"]];
//                GoodsSureController *vc = [[GoodsSureController alloc] init];
//                vc.allPrice = self.allPrice;
//                vc.dataArr = self.mutableArr;
//                vc.idStr = idString;
//                vc.pricetr = @"0";
//                [bself.navigationController pushViewController:vc animated:YES];
            }else if ([status intValue]==44) {
                [bself showAlertWarmMessage:@"登录超时，请重新登录"];
            }else{
                [bself showAlertWarmMessage:[result objectForKey:@"data"]];
            }
        }
        
    } Fail:^(id error, int flag) {
        [bself showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    }];
    
    
   
}

- (void)allSelectAction:(UIButton *)btn
{
    UILabel *priceL = (UILabel *)[self.bottomView viewWithTag:1001];
    btn.selected = !btn.selected;
    self.allPrice = 0.0;
    if(btn.selected){
        for(NSInteger i=0;i<self.dataArr.count;i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            DownloadLeyaoCell *cell = (DownloadLeyaoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectImgV.image = [UIImage imageNamed:@"leyaoSelect"];

        }
        self.allPrice = self.price * self.dataArr.count;
        priceL.text = [NSString stringWithFormat:@"共计:￥%.2f",self.allPrice];
        [self.mutableArr removeAllObjects];
        self.mutableArr = [self.dataArr mutableCopy];
    }else{
        for(NSInteger i=0;i<self.dataArr.count;i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            DownloadLeyaoCell *cell = (DownloadLeyaoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectImgV.image = [UIImage imageNamed:@"leyaoNormal"];
        }
        self.allPrice = 0.0;
        priceL.text = @"共计:￥0.00";
        [self.mutableArr removeAllObjects];
    }
}

#pragma mark - 获取乐药列表
- (void)requestLeyaoList
{
    NSString *UrlPre=URL_PRE;
    NSString *subjectSn = [GlobalCommon getSubjectSnFrom:self.leyaoType];
    if (subjectSn == nil) {
        return ;
    }
    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/listBySubject.jhtml?subjectSn=%@&mediaType=%@",UrlPre,subjectSn,@"audio"];
    
    [[NetWorkSharedInstance sharedInstance] networkWithRequestUrlStr:aUrlle RequestMethod:@"GET" PostDictionay:nil headDictionay:nil  Success:^(id result, int flag) {
        
        id status=[result objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100)
            {
                NSLog(@"线上环境");
                
                NSArray *arr = [result objectForKey:@"data"];
                NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
                for(NSDictionary *dic in arr){
                    if(![[dic objectForKey:@"status"] isKindOfClass:[NSNull class]] && [dic objectForKey:@"status"] != nil){
                        if([[dic objectForKey:@"status"] isEqualToString:@"unpaid"]){
                            [arr2 addObject:dic];
                        }
                    }
                }
                
                self.dataArr = [arr2 copy];
                
                [self.tableView reloadData];
                return;
                
            }
            else if ([status intValue]==44)
            {
                [self showAlertWarmMessage:@"登录超时，请重新登录"];
                return;
            }else{
                NSString *str = [result objectForKey:@"data"];
                [self showAlertWarmMessage:str];
                return;
            }
        }
        
    } Fail:^(id error, int flag) {
        [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    }];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        DownloadLeyaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadLeyaoCell"];
        if(cell == nil){
            cell = [[DownloadLeyaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownloadLeyaoCell"];
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = view;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    if(self.dataArr.count>0){
       cell.titleLabel.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadLeyaoCell *cell = (DownloadLeyaoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectImgV.image = [UIImage imageNamed:@"leyaoSelect"];
    
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    [self.mutableArr addObject:dic];
    CGFloat currentPrice = [[dic objectForKey:@"price"] floatValue];
    self.allPrice += currentPrice;
    UILabel *priceL = (UILabel *)[self.bottomView viewWithTag:1001];
    priceL.text = [NSString stringWithFormat:@"共计:￥%.2f",self.allPrice];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadLeyaoCell *cell = (DownloadLeyaoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //cell.downloadBtn.selected = NO;
    cell.selectImgV.image = [UIImage imageNamed:@"leyaoNormal"];
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat currentPrice = [[dic objectForKey:@"price"] floatValue];
    [self.mutableArr removeObject:dic];
    self.allPrice -= currentPrice;
    if(self.allPrice<0){
        self.allPrice = 0.0;
    }
    UILabel *priceL = (UILabel *)[self.bottomView viewWithTag:1001];
    priceL.text = [NSString stringWithFormat:@"共计:￥%.2f",self.allPrice];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
