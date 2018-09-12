//
//  TMGZIPEncodedRequestBody.m
//  TMTumblrSDK
//
//  Created by Michael Benedict on 2/9/18.
//

#import "TMGZIPEncodedRequestBody.h"
#include <zlib.h>
#define CHUNKSIZE (1024*4)

@interface TMGZIPEncodedRequestBody ()

@property (nonatomic, nonnull, readonly) id<TMRequestBody> originalBody;
@property (nonatomic, nullable, readonly) NSData *compressedBodyData;

@end

@implementation TMGZIPEncodedRequestBody

- (nonnull instancetype)initWithRequestBody:(nonnull id<TMRequestBody>)body {
    NSParameterAssert(body);
    self = [super init];
    
    if (self) {
        _originalBody = body;
        _compressedBodyData = [self compressedBody:[body bodyData]];
    }
    
    return self;
}

- (nonnull NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, originalBody=%@>", NSStringFromClass([self class]), self, self.originalBody];
}

#pragma mark - TMRequestBody

- (nullable NSString *)contentType {
    return [_originalBody contentType];
}

- (nullable NSString *)contentEncoding {
    if (!_compressedBodyData ) {
        return nil;
    }
    else {
        return @"gzip";
    }
}


- (nullable NSData *)bodyData {
    if (!_compressedBodyData) {
        return [_originalBody bodyData];
    }
    else {
        return _compressedBodyData;
    }
}

- (nonnull NSDictionary *)parameters {
    return [_originalBody parameters];
}

- (BOOL)encodeParameters {
    return [_originalBody encodeParameters];
}

- (NSData *)compressedBody:(NSData *)data {
    z_stream strm;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = (unsigned int)[data length];
    
    /* windowBits (15+16) - Base two logarithm of the maximum window size (the size of the history buffer). It should be in the range 8..15.
     Add 16 to windowBits to write a simple gzip header and trailer around the compressed data instead of a zlib wrapper. The gzip header
     will have no file name, no extra data, no comment, no modification time (set to zero), no header crc, and the
     operating system will be set to 255 (unknown).
     
     15+16 - will give gzip compatible output
     
     memLevel  - The memLevel parameter specifies how much memory should be allocated for the internal compression state.
     memLevel=1 uses minimum memory but is slow and reduces compression ratio; memLevel=9 uses maximum memory for
     optimal speed.  The default value is 8.  See zconf.h for total memory usage as a function of windowBits and memLevel.
     */
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        
        // 16K chunks for expansion
        NSMutableData *compressed = [[NSMutableData alloc] initWithLength:CHUNKSIZE];
        
        do {
            if (strm.total_out >= [compressed length]) {
                [compressed increaseLengthBy:CHUNKSIZE];
            }
            
            strm.next_out = [compressed mutableBytes] + strm.total_out;
            strm.avail_out = (unsigned int)([compressed length] - strm.total_out);
            
            if (Z_STREAM_ERROR == deflate(&strm, Z_FINISH)) {
                return nil;
            }
            
        } while (strm.avail_out == 0);
        
        if (deflateEnd(&strm) != Z_OK) {
            return nil;
        }
        
        [compressed setLength: strm.total_out];
        
        return compressed;
    }
    else {
        return nil;
    }
}

@end
