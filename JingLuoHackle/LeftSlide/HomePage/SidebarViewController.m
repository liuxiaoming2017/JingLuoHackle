//
//  SidebarViewController.m
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "SidebarViewController.h"
#import "SlideLeftCell.h"
#import "FeedbackViewController.h"
#import "AboutWeViewController.h"
#import "PersonalInformationViewController.h"
#import "InformationController.h"
#import "HelpViewController.h"

@interface SidebarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView* menuTableView;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;
//@property (nonatomic, copy) NSString *imageStr;
@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 列表
    self.menuTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuTableView.backgroundColor = [UIColor whiteColor];
    self.titleArr = @[LocalString(@"发现"),LocalString(@"Help"),LocalString(@"Feedback"),LocalString(@"About")];
    self.imageArr = @[@"发现",@"帮助",@"反馈",@"关于我们"];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.contentView addSubview:self.menuTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableViewData
{
    [self.menuTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 100;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";
    
    SlideLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!leftCell){
        leftCell = [[SlideLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier];
        leftCell.backgroundColor = [UIColor clearColor];
    }
    if(indexPath.row == 0){
        if (g_userInfo.Name == nil || [g_userInfo.Name isKindOfClass:[NSNull class]]) {
            if(g_userInfo.memberImage != nil && ![g_userInfo.memberImage isKindOfClass:[NSNull class]]){
                [leftCell initCellWithTitleStr:g_userInfo.UserName imageUrl:g_userInfo.memberImage];
            }else{
                [leftCell initCellWithTitleStr:g_userInfo.UserName imageUrl:@"我的"];
            }
        }
        else
        {
            if(g_userInfo.memberImage != nil && ![g_userInfo.memberImage isKindOfClass:[NSNull class]]){
                [leftCell initCellWithTitleStr:g_userInfo.Name imageUrl:g_userInfo.memberImage];
            }else{
                [leftCell initCellWithTitleStr:g_userInfo.Name imageUrl:@"我的"];
            }
        }
        
    }else{
        [leftCell initCellWithTitleStr:[self.titleArr objectAtIndex:indexPath.row-1] imageUrl:[self.imageArr objectAtIndex:indexPath.row-1]];
    }
    
    return leftCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if(indexPath.row == 0){
        PersonalInformationViewController * PersonInfoView=[[PersonalInformationViewController alloc] init];
        [nav pushViewController:PersonInfoView animated:YES];
       // [controller.navigationController pushViewController:PersonInfoView animated:YES];
        
    }
    else if(indexPath.row == 1){
        InformationController *informationVC = [[InformationController alloc] init];
        [nav pushViewController:informationVC animated:YES];
        
    }
    else if(indexPath.row == 2){
        HelpViewController *informationVC = [[HelpViewController alloc] initWithBackgroundImage:self.snapImageView.image];
        [nav pushViewController:informationVC animated:YES];
       
    }
    else if(indexPath.row == 3){
        FeedbackViewController *feed = [[FeedbackViewController alloc]init];
        [nav pushViewController:feed animated:YES];
       
    }else if (indexPath.row == 4){
        AboutWeViewController *aboutMe=[[AboutWeViewController alloc] init];
        [nav pushViewController:aboutMe animated:YES];
        
    }
    
    [self showHideSidebar];
}

@end
