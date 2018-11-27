//
//  UIImage+Utils.h
//  SceneDetector
//
//  Created by Silence on 2018/11/27.
//  Copyright © 2018 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

- (UIImage *)scaleToSize:(CGSize)size;
- (CVPixelBufferRef)pixelBufferFromCGImage;
+ (UIImage*) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end

NS_ASSUME_NONNULL_END
