//
//  CarouselView.m
//  Carousel
//
//  Created by liu zheng on 15/8/3.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "CarouselView.h"
#import "TAPageControl.h"

@interface CarouselView() <UIScrollViewDelegate,UIGestureRecognizerDelegate, TAPageControlDelegate>
@property (strong, nonatomic) TAPageControl *customerPageController;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *imagesData;
@property (nonatomic) NSInteger layoutCount;
@property (strong, nonatomic) NSArray *imagesTitleData;
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end


@implementation CarouselView


- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imagesData  titles:(NSArray *) imagesTitleData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imagesData = imagesData;
        self.imagesTitleData = imagesTitleData;
        self.layoutCount = imagesData.count + 2;
        
        [self setupView:frame];
    }
    return self;
}


- (void) setupView:(CGRect) scollViewFrame {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:scollViewFrame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    
    [self addSubview: self.scrollView];
    
    [self setupScrollViewImages];
    
    NSInteger titleHeight = 22;
    NSInteger pageWidth = 100;
    
    CGRect backFrame = CGRectMake(0, self.scrollView.frame.size.height - titleHeight, self.frame.size.width, titleHeight);
    
    UIView *backgroudTitle = [[UIView alloc]initWithFrame:backFrame];
    backgroudTitle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview: backgroudTitle];
    
    NSInteger titleWidth = self.frame.size.width -  pageWidth - 8;
    CGRect titleFrame = CGRectMake(8, self.scrollView.frame.size.height - titleHeight, titleWidth, titleHeight);
    _titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
    _titleLabel.text = [_imagesTitleData objectAtIndex:0];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    
    CGRect pagerFrame = CGRectMake(self.scrollView.frame.size.width - pageWidth, self.scrollView.frame.size.height - titleHeight, pageWidth, titleHeight);
    
    self.customerPageController = [[TAPageControl alloc] initWithFrame:pagerFrame];
    self.customerPageController.delegate = self;
    self.customerPageController.numberOfPages = self.imagesData.count;
    self.customerPageController.dotSize  = CGSizeMake(2, 2);
    [self addSubview: self.customerPageController];
    
}

-(void) layoutSubviews
{
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * self.layoutCount, CGRectGetHeight(_scrollView.frame));
    
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame), 0) animated:NO];
    
    [self timerScroller];
    
}

#pragma mark - Timer ScrollView

-(void) timerScroller {

    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
    }
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
}

- (void)handleScrollTimer:(NSTimer *)timer
{
    NSInteger count = self.imagesData.count;
    if (count == 0) {
        return;
    }
    
    NSInteger currentPage = self.customerPageController.currentPage;
    NSInteger nextPage = (currentPage + 1) % (count+1);
    
    
    BOOL animated = YES;
    if (nextPage == 0) {
        animated = YES;
    }
    
    CGRect frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) * (nextPage+1), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    [self.scrollView scrollRectToVisible:frame animated:animated];
}


- (void)stopTimer
{
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}


#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    [self timerScroller];
    
    float offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (offset>0&&offset<1) {
        offset = 1;
    }
    
    NSInteger pageIndex = (NSInteger)(offset) % self.layoutCount;
    
    pageIndex--;
    
    NSInteger last = self.imagesData.count-1;
    NSInteger first = 0;
    if (pageIndex >= 0 && pageIndex<=last) {
            //nil normal
    }else if(pageIndex<0) {
        //left to end
        pageIndex = last;
        NSInteger width = CGRectGetWidth(_scrollView.frame) * (last+1);
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        
    }else if (pageIndex >= self.imagesData.count){
        //right to first
        pageIndex = first;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame),0) animated:NO];
    }
    
    self.customerPageController.currentPage = pageIndex;
    _titleLabel.text = [_imagesTitleData objectAtIndex:pageIndex];
    
}


// Example of use of delegate for second scroll view to respond to bullet touch event
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    NSLog(@"Bullet index %ld", (long)index);
    

    CGRect frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) * (index+1), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


#pragma mark - Utils

- (void)setupScrollViewImages
{

    NSMutableArray *imagesdata = [[NSMutableArray alloc]initWithArray:self.imagesData];
    
    [imagesdata insertObject:self.imagesData.lastObject atIndex:0];
    [imagesdata addObject:self.imagesData.firstObject];
    
    
    [imagesdata enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        
        CGRect frame = CGRectMake(CGRectGetWidth(_scrollView.frame) * idx, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:imageName];
    
        [_scrollView addSubview:imageView];
    }];
}

#pragma mark - IBAction
- (void)handleTapGesture:(id) sender {

    NSInteger pageIndex = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    if([self.carouselDelegete respondsToSelector:@selector(tapOnViewAtIndex:)]){
        [self.carouselDelegete tapOnViewAtIndex:pageIndex];
    }
}

@end
