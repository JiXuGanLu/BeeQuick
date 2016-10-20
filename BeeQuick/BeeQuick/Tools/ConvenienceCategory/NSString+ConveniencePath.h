//

#import <Foundation/Foundation.h>

@interface NSString (ConveniencePath)

/// 获取Documents目录
- (NSString *)ybzy_appendDocumentsPath;

/// 获取Cache目录
- (NSString *)ybzy_appendCachePath;

/// 获取Temp目录
- (NSString *)ybzy_appendTempPath;

@end
