//
//  StartViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/10/13.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *yindaoImage = [[UIImageView alloc]init];
    self.view.backgroundColor = [UtilityFunc colorWithHexString:@"#407cea"];
     UIButton *jingruButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (iPhone5) {
//        jingruButton.frame = CGRectMake((self.view.frame.size.width - 164) / 2, self.view.frame.size.height - 77, 164, 35) ;
//        yindaoImage.frame = CGRectMake((self.view.frame.size.width - 300) / 2, 40, 300, 410);
//        yindaoImage.image = [UIImage imageNamed:@"shoucidenglu1136.png"];
//    }else{
//        jingruButton.frame = CGRectMake((self.view.frame.size.width - 164) / 2, self.view.frame.size.height - 57, 164, 35) ;
//        yindaoImage.frame = CGRectMake((self.view.frame.size.width - 300), 40, 274, 370);
//        yindaoImage.image = [UIImage imageNamed:@"shoucidenglu960"];
//    }
    
    jingruButton.frame = CGRectMake((self.view.frame.size.width - 164) / 2, self.view.frame.size.height - 77, 164, 35) ;
    yindaoImage.frame = CGRectMake((self.view.frame.size.width - 300) / 2, SCREEN_HEIGHT * 0.12, 300, 410);
    yindaoImage.image = [UIImage imageNamed:@"shoucidenglu1136.png"];
   
  
    [jingruButton setBackgroundImage:[UIImage imageNamed:@"shoucidenglu.png"] forState:UIControlStateNormal];
    [jingruButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yindaoImage];
    [self.view addSubview:jingruButton];
}
-(void)doBack
{
    //返回上一级页面
    if(self.delegate&&[self.delegate respondsToSelector:@selector(returnMainPage)])
    {
        [self.delegate returnMainPage];
    }
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
