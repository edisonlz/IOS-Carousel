//
//  CarouselView.h
//  Carousel
//
//  Created by liu zheng on 15/8/3.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark dataSource
@protocol CarouselDelegete <NSObject>

/**
 * The content for any tab. Return a view controller and ViewPager will use its view to show as content.
 *
 * @param viewPager The viewPager that's subject to
 * @param index The index of the content whose view is asked
 *
 * @return A viewController whose view will be shown as content
 */
- (void) tapOnViewAtIndex:(NSUInteger)index;

@end


@interface CarouselView : UIView


@property (weak,nonatomic) id<CarouselDelegete> carouselDelegete;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imagesData  titles:(NSArray *) imagesTitleData;

@end
