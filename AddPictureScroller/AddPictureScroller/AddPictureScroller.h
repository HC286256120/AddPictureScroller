//
//  AddPictureScroller.h
//  HorizontalScrollViewDemo
//
//  Created by lei xue on 14-5-27.
//  Copyright (c) 2014 lei xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddPictureScrollerDelegate<NSObject>
@required
-(void)startAddPicture;
-(void)pictureTapped:(UIImageView *)tappedImageView;
@end

@interface AddPictureScroller : NSObject
@property(weak, nonatomic)id<AddPictureScrollerDelegate> delegate;
@property(readonly, strong, nonatomic) NSMutableArray *imageViewArray;
@property(assign, nonatomic) int maxImageCount;

-(id)initWithFrame:(CGRect)frame inView:(UIView *)view;
-(void)addPicture:(UIImage *)image;
-(void)removeAllImageView;
-(void)removeImageView:(UIImageView *)imageView;
@end
