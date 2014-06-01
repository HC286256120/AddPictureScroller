//
//  AddPictureScroller.m
//  HorizontalScrollViewDemo
//
//  Created by lei xue on 14-5-27.
//  Copyright (c) 2014 lei xue. All rights reserved.
//

#import "AddPictureScroller.h"
#import <QuartzCore/QuartzCore.h>

@interface AddPictureScroller()
@property(assign, nonatomic) int pictureHeight;
@property(assign, nonatomic) int pictureInset;
@property(strong, nonatomic) NSMutableArray *imageViewArray;
@property(strong, nonatomic) UIScrollView *picScrollView;
@property(strong, nonatomic) UIButton *addButton;

-(CGFloat)imageArrayWidth;
-(CGFloat)imageArrayWidthWithAddButton;
- (void)refreshScrollView;
-(void)handleImageViewTapped:(UIGestureRecognizer*)gestureRecognizer;
-(void)addPicture;
@end

@implementation AddPictureScroller
@synthesize delegate;
@synthesize pictureHeight;
@synthesize pictureInset;
@synthesize imageViewArray;
@synthesize maxImageCount;
@synthesize picScrollView;
@synthesize addButton;

-(id)initWithFrame:(CGRect)frame inView:(UIView *)view{
    self = [super init];
    if (self) {
        pictureHeight = frame.size.height;
        pictureInset = pictureHeight / 10;
        imageViewArray = [NSMutableArray new];
        maxImageCount = INT32_MAX;
        
        picScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [view addSubview:picScrollView];
        
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, pictureHeight, pictureHeight)];
        [addButton setImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [picScrollView addSubview:addButton];
    }
    return self;
}

-(void)addPicture:(UIImage *)image{
    if (imageViewArray.count == maxImageCount - 1) {
        //添加按钮隐藏动画
        CABasicAnimation *opaqueAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        [opaqueAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
        [opaqueAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
        [opaqueAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [opaqueAnimation setDuration:0.25f];
        [addButton.layer addAnimation:opaqueAnimation forKey:nil];
        addButton.hidden = YES;
    }
    else{
        //移动添加按钮
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(addButton.center.x, addButton.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(addButton.center.x + pictureInset + pictureHeight, addButton.center.y)]];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [addButton.layer addAnimation:positionAnim forKey:nil];
        [addButton setCenter:CGPointMake(addButton.center.x + pictureInset + pictureHeight, addButton.center.y)];
    }
    
    //添加图片
    const CGFloat originalWidth = [self imageArrayWidth];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(originalWidth > 0 ? originalWidth + pictureInset : 0, 0, pictureHeight, pictureHeight)];
    aImageView.userInteractionEnabled = YES;
    aImageView.contentMode = UIViewContentModeScaleAspectFit;
    [aImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapped:)]];
    aImageView.image = image;
    [imageViewArray addObject:aImageView];
    [picScrollView addSubview:aImageView];
    //图片渐显动画
    CABasicAnimation *opaqueAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    [opaqueAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [opaqueAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
    [opaqueAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [opaqueAnimation setDuration:0.25f];
    [aImageView.layer addAnimation:opaqueAnimation forKey:nil];
    
    [self refreshScrollView];
}

-(void)removeAllImageView{
    for (UIImageView *imageView in imageViewArray) {
        [imageView removeFromSuperview];
    }
    [imageViewArray removeAllObjects];
    
    addButton.frame = CGRectMake(0, 0, addButton.frame.size.width, addButton.frame.size.height);
    addButton.hidden = NO;
    [self refreshScrollView];
}

-(void)removeImageView:(UIImageView *)imageView{
    NSInteger picIndex = [imageViewArray indexOfObject:imageView];
    if (picIndex == NSNotFound) {
        return;
    }
    
    //图片隐藏动画
    [UIView animateWithDuration:0.15f animations:^{
        imageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        //remove图片
        [imageView removeFromSuperview];
        [imageViewArray removeObjectAtIndex:picIndex];
        
        //右侧图片左移动画
        for (int i = picIndex; i < imageViewArray.count; ++i) {
            UIImageView *img = imageViewArray[i];
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x - pictureInset - pictureHeight, img.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [img.layer addAnimation:positionAnim forKey:nil];
            
            [img setCenter:CGPointMake(img.center.x - pictureInset - pictureHeight, img.center.y)];
        }
        if (imageViewArray.count == maxImageCount - 1) {
            //添加按钮显示动画
            CABasicAnimation *opaqueAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            [opaqueAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
            [opaqueAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
            [opaqueAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [opaqueAnimation setDuration:0.25f];
            [addButton.layer addAnimation:opaqueAnimation forKey:nil];
            addButton.hidden = NO;
        }
        else{
            //左移添加按钮
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(addButton.center.x, addButton.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(addButton.center.x - pictureInset - pictureHeight, addButton.center.y)]];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [addButton.layer addAnimation:positionAnim forKey:nil];
            [addButton setCenter:CGPointMake(addButton.center.x - pictureInset - pictureHeight, addButton.center.y)];
        }
        
        [self refreshScrollView];
        
    }];
}

-(CGFloat)imageArrayWidth{//excluding the add button.
    return pictureHeight * imageViewArray.count + pictureInset * (imageViewArray.count > 1 ? imageViewArray.count - 1 : 0);
}

-(CGFloat)imageArrayWidthWithAddButton{//including the add button.
    return pictureHeight * (imageViewArray.count + 1) + pictureInset * imageViewArray.count;
}

- (void)refreshScrollView
{
    const CGFloat width = (imageViewArray.count == maxImageCount ? [self imageArrayWidth] : [self imageArrayWidthWithAddButton]);
    [picScrollView setContentSize:CGSizeMake(width, pictureHeight)];
    [picScrollView setContentOffset:CGPointMake(width < picScrollView.frame.size.width ? 0 : width - picScrollView.frame.size.width, 0) animated:YES];
}

-(void)handleImageViewTapped:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([delegate respondsToSelector:@selector(pictureTapped:)]) {
            [delegate pictureTapped:(UIImageView *)gestureRecognizer.view];
        }
        else{//default operation is to remove the tapped picture.
            [self removeImageView:(UIImageView *)gestureRecognizer.view];
        }
    }
}

-(void)addPicture{
    if ([delegate respondsToSelector:@selector(startAddPicture)]) {
        [delegate startAddPicture];
    }
    else{//default operation is to add picture plus_icon.png.
        [self addPicture:[UIImage imageNamed:@"plus_icon.png"]];
    }
}

@end
