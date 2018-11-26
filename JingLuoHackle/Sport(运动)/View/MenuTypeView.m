//
//  MenuTypeView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MenuTypeView.h"

#define xmargin 10.0
#define ymargin 10.0

@interface MenuTypeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MenuTypeView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)setMenuArr:(NSArray *)menuArr
{
    if(_menuArr != menuArr){
//        [_menuArr release];
//        [menuArr retain];
        _menuArr = menuArr;
        [self createUI];
    }
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(xmargin, ymargin, self.width-xmargin*2, self.height-ymargin*2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.width, 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    if(_menuArr.count > indexPath.row){
        titleLabel.text = [_menuArr objectAtIndex:indexPath.row];
    }
    [cell.contentView addSubview:titleLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectMenuTypeWithIndex:)]){
        [self.delegate selectMenuTypeWithIndex:indexPath.row];
    }
}

@end
