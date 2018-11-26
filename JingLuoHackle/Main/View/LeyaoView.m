//
//  LeyaoView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/27.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LeyaoView.h"
#import "SongListCell.h"
#import "DownloadHandler.h"
#import "ProgressIndicator.h"

@interface LeyaoView()<songListCellDelegate,DownloadHandlerDelegate>

@property (nonatomic,strong) NSMutableArray *historyArr;

@property (nonatomic,strong) UITableView *historyTableView;

@property (nonatomic,assign) NSInteger selectHisIndex;

@property (nonatomic,assign) NSInteger selectCurIndex;
@end

@implementation LeyaoView

- (id)initWithFrame:(CGRect)frame withCurrentArr:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if(self){
       // self.dataArr = arr;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setImage:[UIImage imageNamed:@"listImg"] forState:UIControlStateNormal];
    listBtn.frame = CGRectMake(self.frame.size.width-20-24, 12, 24, 24);
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:listBtn];
    
    NSArray *titaArr = @[LocalString(@"PresentMusic"),LocalString(@"AlreadyListened")];
    for(NSInteger i=0;i<titaArr.count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *textStr = [titaArr objectAtIndex:i];
        CGFloat width = [textStr widthStringwithfontSize:17 andHeight:30];
        btn.frame = CGRectMake(20+(width+20)*i, 9, width, 30);
        [btn setTitle:textStr forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromHex(0x2A8CE2) forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromHex(0xB0B0B0) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(currentAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        if(i == 0){
            btn.selected = YES;
        }
        //btn.hidden = YES;
        btn.tag = 1003+i;
        [self addSubview:btn];
    }
    
    //播放曲目label
//    UILabel *songLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, listY+7, 120, 20)];
//    songLabel.font = [UIFont systemFontOfSize:17];
//    songLabel.tag = 1005;
//    [self addSubview:songLabel];
    
    UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 47, self.frame.size.width, 1)];
    lineV.tag = 24;
    lineV.backgroundColor = UIColorFromHex(0xDADADA);
    [self addSubview:lineV];
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.frame.size.width, 45*3) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.tableView];
    
    
    
    self.historyArr = [NSMutableArray arrayWithCapacity:0];
    [self getAllFile];
    
    self.selectCurIndex = 100;
    self.selectHisIndex = 100;
    
    lineV.hidden = YES;
    self.height = 48;
    self.tableView.height = 0;
    
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.tableView reloadData];
   
}



- (void)currentAction:(UIButton *)btn
{
    if(!btn.selected){
        btn.selected=YES;
    }else{
        return;
    }
    UIButton *btn1 = (UIButton *)[self viewWithTag:1003];
    UIButton *btn2 = (UIButton *)[self viewWithTag:1004];
    if(btn.tag == 1003){
        btn2.selected = NO;
        self.historyOrCur = NO;
        self.historyTableView.hidden = YES;
        self.tableView.hidden = NO;
    }else{
        btn1.selected = NO;
        self.historyOrCur = YES;
        self.tableView.hidden = YES;
        if(!self.historyTableView){
            self.historyTableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
            self.historyTableView.delegate = self;
            self.historyTableView.dataSource = self;
            self.historyTableView.backgroundColor=[UIColor clearColor];
            self.historyTableView.backgroundView=nil;
            self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.historyTableView.showsVerticalScrollIndicator = NO;
            self.historyTableView.showsHorizontalScrollIndicator = NO;
            [self addSubview:self.historyTableView];
            //self.historyTableView.hidden = YES;
             [self.historyTableView reloadData];
        }else{
            self.historyTableView.hidden = NO;
        }
    }
}

- (void)listAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    UIView *lineV = [self viewWithTag:24];
    if(!btn.selected){
        lineV.hidden = YES;
        self.height = 48;
        self.tableView.height = 0;
        self.historyTableView.height = 0;
    }else{
        lineV.hidden = NO;
        self.height = 48+45*3+10;
        self.tableView.height = 45*3;
        self.historyTableView.height = 45*3;
    }
    if([self.delegate respondsToSelector:@selector(listBtnAction:)]){
        [self.delegate listBtnAction:btn];
    }
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView){
        return self.dataArr.count;
    }else{
        return self.historyArr.count;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.historyTableView){
//        if(indexPath.row == 3){
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
//            if(!cell){
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2.0-100, 0, 200, 45)];
//            label.text = @"加载更多";
//            label.font = [UIFont systemFontOfSize:15];
//            label.textAlignment = NSTextAlignmentCenter;
//
//            UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45-1, self.width, 1)];
//            lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
//            [cell.contentView addSubview:label];
//            [cell.contentView addSubview:lineImageV];
//            return cell;
//        }else{
            SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songListCell1"];
            if(cell == nil){
                cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"songListCell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            if(self.historyArr.count>indexPath.row){
                NSString *fileName = [self.historyArr objectAtIndex:indexPath.row];
                fileName = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
                cell.titleLabel.text = fileName;
                [cell setDownLoadButton:YES];
            }
            
            return cell;
       // }
    }else{
        SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songListCell"];
        if(cell == nil){
            cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"songListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(self.dataArr.count>0){
            NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
            cell.titleLabel.text = LocalString([dic objectForKey:@"name"]);
            //cell.titleLabel.text = [dic objectForKey:@"name"];
            cell.delegate = self;
            NSString* filepath=[GlobalCommon Createfilepath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
      //      NSString* NewFileName=[[[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
//            NSArray *urlArray=[NewFileName componentsSeparatedByString:@"/"];
//            NSString *urlpathname= [urlArray objectAtIndex:urlArray.count-1];
            NSString *urlPathName = [NSString stringWithFormat:@"%@.mp3",[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", urlPathName]];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if(fileExists){ //如果本地存在 则是可以播放 不存在则显示下载按钮
                [cell setDownLoadButton:YES];
                if([self.historyArr containsObject:urlPathName]){
                    [self.historyArr removeObject:urlPathName];
                }
            }else{
                [cell setDownLoadButton:NO];
            }
            
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(!cell.downloadBtn.hidden){
        return;
    }
    if(tableView == self.tableView){
        self.selectCurIndex = indexPath.row;
        if(self.selectHisIndex != 100){
            NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:self.selectHisIndex inSection:0];
            NSLog(@"row:%ld",(long)myIndexPath.row);
            [self.historyTableView deselectRowAtIndexPath:myIndexPath animated:NO];
             SongListCell *historycell = (SongListCell *)[self.historyTableView cellForRowAtIndexPath:myIndexPath];
            [historycell setTitleColor:UIColorFromHex(0xB0B0B0)];
            self.selectHisIndex = 100;
        }
    }else if (tableView == self.historyTableView){
        self.selectHisIndex = indexPath.row;
        if(self.selectCurIndex != 100){
            NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:self.selectCurIndex inSection:0];
            NSLog(@"row:%ld",(long)myIndexPath.row);
            [self.tableView deselectRowAtIndexPath:myIndexPath animated:NO];
            SongListCell *curcell = (SongListCell *)[self.tableView cellForRowAtIndexPath:myIndexPath];
            [curcell setTitleColor:UIColorFromHex(0xB0B0B0)];
            self.selectCurIndex = 100;
        }
    }
    
    [cell setTitleColor:UIColorFromHex(0X4FAEFE)];
    if([self.delegate respondsToSelector:@selector(playMusicAction:)]){
        if(!self.historyOrCur){
            NSString *fileName = [NSString stringWithFormat:@"%@.mp3",[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
            [self.delegate playMusicAction:fileName];
        }else{
            NSString *fileName = [self.historyArr objectAtIndex:indexPath.row];
            
            [self.delegate playMusicAction:fileName];
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setTitleColor:UIColorFromHex(0xB0B0B0)];
    
}

#pragma mark - 下载按钮的代理事件
- (void)downLoadButton:(UIButton *)btn
{
   
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    
    NSString* NewFileName=[[[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"]; //leyaoPath
    //NSArray *urlArray=[NewFileName componentsSeparatedByString:@"/"];
    //NSString *urlPathName= [urlArray objectAtIndex:urlArray.count-1]; //otherPath
    
    NSString *urlPathName = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    DownloadHandler *downhander = [DownloadHandler sharedInstance];
    [downhander.downloadingDic setValue:@"downloading" forKey: [NSString stringWithFormat:@"%@",urlPathName]];
    NSString *aurl = [NewFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ProgressIndicator *progress = [[ProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
    downhander.name = [NSString stringWithFormat:@"%@",urlPathName];
    [btn setImage:nil forState:UIControlStateNormal];
    
    btn.tag = 100 + indexPath.row;
    progress.frame=btn.bounds;
    [btn addSubview:progress];
    downhander.url = aurl;
    [downhander setButton:btn];
    downhander.downdelegate = self;
    downhander.fileType =@"mp3";
    downhander.savePath = [GlobalCommon Createfilepath];
    
    [downhander setProgress:progress] ;
    [downhander start];
}

#pragma mark 下载完成代理回调
- (void)DownloadHandlerSelectAtIndex:(NSInteger)index
{
    NSLog(@"index:%ld",index);
    NSString *nameStr = [[self.dataArr objectAtIndex:index] objectForKey:@"name"];
    [GlobalCommon showMessage:[NSString stringWithFormat:@"%@下载完成",nameStr] duration:2];
    SongListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.downloadBtn.hidden = YES;
}

#pragma mark 下载失败代理回调
- (void)DoenloadHandlerFailWithIndex:(NSInteger)index
{
    NSString *nameStr = [[self.dataArr objectAtIndex:index] objectForKey:@"name"];
    [GlobalCommon showMessage:[NSString stringWithFormat:@"%@下载失败",nameStr] duration:2];
//    SongListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    cell.downloadBtn.hidden = NO;
    
}

#pragma mark - 获取目录下的所有文件
- (void)getAllFile
{
    NSString* filepath=[GlobalCommon Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:filepath];
    NSMutableArray *allFileArr = [NSMutableArray arrayWithCapacity:0];
    for(NSString *fileName in enumerator){
        
        if(![fileName isEqualToString:@".DS_Store"]){
            [allFileArr addObject:fileName];
            [self.historyArr addObject:fileName];
        }
    }
    
//    NSMutableArray *localTypeArr = [NSMutableArray arrayWithCapacity:0];
//    for(NSDictionary *dic in self.dataArr){
//        [localTypeArr addObject:[dic objectForKey:@"name"]];
//    }
//
//    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",localTypeArr];
//
//    NSArray * filter = [allFileArr filteredArrayUsingPredicate:filterPredicate];
//    NSLog(@"%@",filter);
    
}

@end
