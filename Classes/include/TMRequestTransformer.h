//
//  TMRequestTransformer.h
//  Pods
//
//  Created by Tyler Tape on 3/23/17.
//
//
#import "TMRequest.h"

@protocol TMRequestTransformer

- (nonnull id <TMRequest>)transformRequest:(nonnull id <TMRequest>)request;

@end
