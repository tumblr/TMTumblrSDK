//
//  TMAuthenticationCallback.h
//  Pods
//
//  Created by Tyler Tape on 4/12/17.
//
//

@class TMAPIUserCredentials;

// Alias for callbacks on network requests that return user credentials
typedef void (^TMAuthenticationCallback)(TMAPIUserCredentials * _Nullable, NSError * _Nullable);
