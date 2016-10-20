//

#import "UILabel+Convenience.h"

@implementation UILabel (Convenience)

+ (instancetype)ybzy_labelWithText:(NSString *)text andTextColor:(UIColor *)textColor andFontSize:(CGFloat)fontSize {
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

@end
