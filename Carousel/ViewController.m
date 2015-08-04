//
//  ViewController.m
//  Carousel
//
//  Created by liu zheng on 15/8/3.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "ViewController.h"
#import "TAPageControl.h"
#import "CarouselView.h"

@interface ViewController ()<UIScrollViewDelegate, TAPageControlDelegate, CarouselDelegete>
@property (strong, nonatomic) NSArray *imagesData;
@property (strong, nonatomic) NSArray *imagesTitleData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
    
    self.imagesTitleData = @[@"白子画爱上谁", @"黄政民腹黑频偷袭刘赫", @"颜王变 扯裤裆 专业户", @"鹿晗与杨幂拍戏爆粗口", @"那些年我们追过的齐天大圣 ", @"蔡春猪《爸爸爱喜禾吗》"];
    
    
    //600 * 338 == 16:9
    float rate = self.view.frame.size.width / 600.0;
    
    CGRect scollViewFrame = CGRectMake(0, 0, self.view.frame.size.width, 338 * rate);
    
    CarouselView *view = [[CarouselView alloc]initWithFrame:scollViewFrame images:self.imagesData titles:self.imagesTitleData];
    
    view.carouselDelegete = self;
    
    [self.view addSubview:view];
}

-(void) tapOnViewAtIndex:(NSUInteger)index
{
    NSLog(@"tap iamge index %ld", (long)index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
