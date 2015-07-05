#import <Foundation/Foundation.h>

@interface NSString (OpenSSL)

- (NSString *)md5;
- (NSString *)sha256;
- (NSString *)base64EncodeWithNewlines:(BOOL)encodeWithNewlines;

@end
