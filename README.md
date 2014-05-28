AddPictureScroller
==================
Horizontal scroller contains AddButton to add image, or tap image to change or remove it with excellent animation.

## Preview
![AddPictureScroller Screenshot](https://raw.githubusercontent.com/azureatom/AddPictureScroller/master/AddPictureScroller/AddPictureScroller/ScreenShots/screenshot1.png)

## Requirements
- iOS 5.0 and greater
- ARC

## Get Start：
  1. Add all files under `AddPictureScroller/AddPictureScroller` to your project
  2. Add `QuartzCore.framework` to your project
  
## Usage:
It's just bloody easy to use this kit. Before present the cropper view controller, you should implement the protocol
  `AddPictureScrollerDelegate` and your own code in method：
    `-(void)startAddPicture;`
    `-(void)pictureTapped:(UIImageView *)tappedImageView;`
  Then in viewDidLoad of your view controller, instantiate a AddPictureScroller object and set its delegate:
  ```objc
  - (void)viewDidLoad
  {
    [super viewDidLoad];
    AddPictureScroller *addPictureScroller = [[AddPictureScroller alloc] initWithFrame:CGRectMake(0, 100, 320, 100) inView:self.view];
    addPictureScroller.delegate = self;
    addPictureScroller.maxImageCount = 4;//default is max integer.
  }
  ```
  It will do all the other jobs for you. Enjoy its convenience!

## License
AddPictureScroller is available under the MIT license. See the LICENSE file for more info.
