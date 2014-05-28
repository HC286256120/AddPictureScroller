//
//  ViewController.m
//  AddPictureScroller
//
//  Created by lei xue on 14-5-27.
//  Copyright (c) 2014年 xl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong, nonatomic)AddPictureScroller *addPictureScroller;
@end

@implementation ViewController
@synthesize addPictureScroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    addPictureScroller = [[AddPictureScroller alloc] initWithFrame:CGRectMake(0, 100, 320, 100) inView:self.view];
    addPictureScroller.delegate = self;
    addPictureScroller.maxImageCount = 4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAddPicture{
    [addPictureScroller addPicture:[UIImage imageNamed:@"chicken.png"]];
}

-(void)pictureTapped:(UIImageView *)tappedImageView{
    [addPictureScroller removeImageView:tappedImageView];
}
@end
