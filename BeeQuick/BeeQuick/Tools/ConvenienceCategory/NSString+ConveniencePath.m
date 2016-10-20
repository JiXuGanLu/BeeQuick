//

#import "NSString+ConveniencePath.h"
#import "NSString+ConvenienceHash.h"

@implementation NSString (ConveniencePath)

/// 获取Documents目录
- (NSString *)ybzy_appendDocumentsPath {
    // 获取Documents文件目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 获取图片的名字
    NSString *fileName = [self ybzy_md5String];
    // Documents文件目录拼接图片的名字 == 图片保存到沙盒的路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

/// 获取Cache目录
- (NSString *)ybzy_appendCachePath {
    // 获取Cache文件目录
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 获取图片的名字
    NSString *fileName = [self ybzy_md5String];
    // Cache文件目录拼接图片的名字 == 图片保存到沙盒的路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

/// 获取Temp目录
- (NSString *)ybzy_appendTempPath {
    // 获取Documents文件目录
    NSString *tmpPath = NSTemporaryDirectory();
    // 获取图片的名字
    NSString *fileName = [self ybzy_md5String];
    // Documents文件目录拼接图片的名字 == 图片保存到沙盒的路径
    NSString *filePath = [tmpPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

@end
