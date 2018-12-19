//
//  ImageScrollView.m
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "ImageScrollView.h"
#import "TiledImageView.h"

@interface ImageScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, strong) TiledImageView *tiledView;
@end

@implementation ImageScrollView

-(id)initWithFrame:(CGRect)frame image:(UIImage*)img {
    if((self = [super initWithFrame:frame])) {
        // Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:0.4f green:0.2f blue:0.2f alpha:1.0f];
        
        // 根据图片实际尺寸和屏幕尺寸计算图片视图的尺寸
        self.image = img;
        CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(self.image.CGImage),CGImageGetHeight(self.image.CGImage));
        _imageScale = self.frame.size.width/imageRect.size.width;
        imageRect.size = CGSizeMake(
                                    imageRect.size.width*_imageScale,
                                    imageRect.size.height*_imageScale);
        //根据图片的缩放计算scrollview的缩放级别
        // 图片相对于视图放大了1/imageScale倍，所以用log2(1/imageScale)得出缩放次数，
        // 然后通过pow得出缩放倍数，至于为什么要加1，
        // 是希望图片在放大到原图比例时，还可以继续放大一次（即2倍），可以看的更清晰
        int level = ceil(log2(1/_imageScale))+1;
        CGFloat zoomOutLevels = 1;
        CGFloat zoomInLevels = pow(2, level);
        
        self.maximumZoomScale =zoomInLevels;
        self.minimumZoomScale = zoomOutLevels;
        
        self.tiledView = [[TiledImageView alloc] initWithFrame:imageRect image:self.image scale:self.imageScale];
        [self addSubview:self.tiledView];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.tiledView;
}

// We use layoutSubviews to center the image in the view
- (void)layoutSubviews {
    [super layoutSubviews];
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.tiledView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    self.tiledView.frame = frameToCenter;
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    self.tiledView.contentScaleFactor = 1.0;
}

@end
