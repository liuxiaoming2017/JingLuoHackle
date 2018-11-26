//
//  ArticleModel.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (NSArray *)articlesFromArray:(NSArray *)array
{
    if ([array isKindOfClass:[NSNull class]])
    {
        return [NSArray array];
    }
    NSMutableArray *articles = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dict in array)
    {
        if ([dict isKindOfClass:[NSNull class]])
        {
            continue;
        }
        ArticleModel *model = [[ArticleModel alloc] init];
        model.author = [model isNullOrnilWithDic:dict withStr:@"autor"];
        model.horizontalPath = [dict objectForKey:@"horizontalPath"];
        model.seoDescription = [model isNullOrnilWithDic:dict withStr:@"seoDescription"];
        model.articleId = [[dict objectForKey:@"id"] longValue];
        model.title = [model isNullOrnilWithDic:dict withStr:@"title"];
        
        model.picture = [model isNullOrnilWithDic:dict withStr:@"picture"];
        model.notePath = [dict objectForKey:@"notePath"];
        model.createDate = [[dict objectForKey:@"createDate"] longValue];
        model.path = [model isNullOrnilWithDic:dict withStr:@"path"];
        model.modifyDate = [[dict objectForKey:@"modifyDate"] longValue];
        
        [articles addObject:model];
    }
    return articles;
}


- (NSString *)isNullOrnilWithDic:(NSDictionary *)dict withStr:(NSString *)str
{
    if(![[dict objectForKey:str] isKindOfClass:[NSNull class]] && [dict objectForKey:str] != nil){
        return [dict objectForKey:str];
    }else{
        return @"";
    }
}

@end
