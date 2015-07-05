#import "NSString+OpenSSL.h"
#import <OpenSSL/OpenSSL.h>

@implementation NSString (OpenSSL)

- (NSString *)md5 {
    unsigned char *inStrg = (unsigned char *) [[self dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [self length];
    unsigned char result[MD5_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    MD5(inStrg, lngth, result);

    unsigned int i;
    for (i = 0; i < MD5_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

- (NSString *)sha256 {
    unsigned char *inStrg = (unsigned char *) [[self dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [self length];
    unsigned char result[SHA256_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, inStrg, lngth);
    SHA256_Final(result, &sha256);

    unsigned int i;
    for (i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

- (NSString *)base64EncodeWithNewlines:(BOOL)encodeWithNewlines {
    BIO *mem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());

    if (!encodeWithNewlines) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    mem = BIO_push(b64, mem);

    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = stringData.length;
    void *buffer = (void *) [stringData bytes];
    int bufferSize = (int)MIN(length, INT_MAX);

    NSUInteger count = 0;

    BOOL error = NO;

    // Encode the data
    while (!error && count < length) {
        int result = BIO_write(mem, buffer, bufferSize);
        if (result <= 0) {
            error = YES;
        }
        else {
            count += result;
            buffer = (void *) [stringData bytes] + count;
            bufferSize = (int)MIN((length - count), INT_MAX);
        }
    }

    int flush_result = BIO_flush(mem);
    if (flush_result != 1) {
        return nil;
    }

    char *base64Pointer;
    NSUInteger base64Length = (NSUInteger) BIO_get_mem_data(mem, &base64Pointer);

    NSData *base64data = [NSData dataWithBytesNoCopy:base64Pointer length:base64Length freeWhenDone:NO];
    NSString *base64String = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];

    BIO_free_all(mem);
    return base64String;
}

@end
