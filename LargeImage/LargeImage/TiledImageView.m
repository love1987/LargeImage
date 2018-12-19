//
//  TiledImageView.m
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "TiledImageView.h"

@interface TiledImageView ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGFloat imageScale;
@end

@implementation TiledImageView

+ (Class)layerClass {
    return [CATiledLayer class];
}

-(id)initWithFrame:(CGRect)frame image:(UIImage*)img scale:(CGFloat)scale {
    if ((self = [super initWithFrame:frame])) {
        self.image = img;
        _imageRect = CGRectMake(0.0f, 0.0f,
                                CGImageGetWidth(self.image.CGImage),
                                CGImageGetHeight(self.image.CGImage));
        _imageScale = scale;
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        //根据图片的缩放计算scrollview的缩放次数
        // 图片相对于视图放大了1/imageScale倍，所以用log2(1/imageScale)得出缩放次数，
        // 然后通过pow得出缩放倍数，至于为什么要加1，
        // 是希望图片在放大到原图比例时，还可以继续放大一次（即2倍），可以看的更清晰
        int lev = ceil(log2(1/scale))+1;
        tiledLayer.levelsOfDetail = 1;
        tiledLayer.levelsOfDetailBias = lev;
        //        tiledLayer.tileSize  此处tilesize使用默认的256x256即可
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    @autoreleasepool{
        CGRect imageCutRect = CGRectMake(rect.origin.x / _imageScale,
                                         rect.origin.y / _imageScale,
                                         rect.size.width / _imageScale,
                                         rect.size.height / _imageScale);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, imageCutRect);
        UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect:rect];
        CGImageRelease(imageRef);
        UIGraphicsPopContext();
    }
}

@end
