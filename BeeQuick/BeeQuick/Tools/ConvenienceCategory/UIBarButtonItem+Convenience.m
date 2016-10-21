//

#import "UIBarButtonItem+Convenience.h"
#import "UIView+Convenience.h"

@implementation UIBarButtonItem (Convenience)

+ (instancetype)ybzy_barButtonItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon highlighticon:(NSString *)highlighticon backgroundImage:(UIImage *)backgroundImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlighticon] forState:UIControlStateHighlighted];
    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        button.size = button.currentBackgroundImage.size;
    } else {
        button.size = button.currentImage.size;
    }
    [button addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
