//
//  ArticleModel.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

@property (nonatomic,copy) NSString *author;
@property (nonatomic,assign) long createDate;
@property (nonatomic,copy) NSString *horizontalPath;
@property (nonatomic,assign) long articleId;
@property (nonatomic,assign) long modifyDate;
@property (nonatomic,copy) NSString *notePath;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *seoDescription;
@property (nonatomic,copy) NSString *title;

+ (NSArray *)articlesFromArray:(NSArray *)array;

@end
