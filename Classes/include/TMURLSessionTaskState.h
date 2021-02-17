//
//  TMURLSessionTaskState.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/25/16.
//
//

/**
 *  Defines the state a sesion task is in.
 */
typedef NS_ENUM(NSInteger, TMURLSessionTaskState) {
    /**
     *  Unknown state.
     */
    TMURLSessionTaskStateUnknown = 0,
    /**
     *  The task is running.
     */
    TMURLSessionTaskStateRunning = 1,
    /**
     *  The task has stopped.
     */
    TMURLSessionTaskStateStopped = 2,
    /**
     *  The task has stopped without ever starting.
     */
    TMURLSessionTaskStateStoppedWithoutEverRunning = 3,

    /**
     *  The task has stopped - and it is now safe to stop observing its @c state property.
     *  This is used internally to ensure that a crash like this does not happen http://www.openradar.appspot.com/18419882 - https://devforums.apple.com/message/920269#920269
     *  This can be safely ignored by clients.
     */
    TMURLSessionTaskStateStoppedAndSafeToStopObserving = 100,
} NS_ENUM_AVAILABLE(NSURLSESSION_AVAILABLE, 7_0);
