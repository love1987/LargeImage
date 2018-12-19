//
//  ImageScrollView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageScrollView : UIScrollView
-(id)initWithFrame:(CGRect)frame image:(UIImage*)img;
@end

NS_ASSUME_NONNULL_END
