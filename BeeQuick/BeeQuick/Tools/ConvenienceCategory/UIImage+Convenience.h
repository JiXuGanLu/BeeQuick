//

#import <UIKit/UIKit.h>

@interface UIImage (Convenience)

- (UIImage *)ybzy_tintImageWithColor:(UIColor *)tintColor;

+ (UIImage *)ybzy_imageWithColor:(UIColor *)color;

+ (UIImage *)ybzy_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)ybzy_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor;

@end
