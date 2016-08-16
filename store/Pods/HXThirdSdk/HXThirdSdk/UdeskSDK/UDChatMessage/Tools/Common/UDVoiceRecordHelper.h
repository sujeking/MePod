//
//  UDVoiceRecordHelper.h
//  UdeskSDK
//
//  Created by xuchen on 16/1/18.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^UDPrepareRecorderCompletion)();
typedef void(^UDStartRecorderCompletion)();
typedef void(^UDStopRecorderCompletion)();
typedef void(^UDPauseRecorderCompletion)();
typedef void(^UDResumeRecorderCompletion)();
typedef void(^UDCancellRecorderDeleteFileCompletion)();
typedef void(^UDRecordProgress)(float progress);
typedef void(^UDPeakPowerForChannel)(float peakPowerForChannel);


@interface UDVoiceRecordHelper : NSObject
/**
 *  录音到最大时长callback结束录音
 */
@property (nonatomic, copy) UDStopRecorderCompletion maxTimeStopRecorderCompletion;
/**
 *  录音进度callback
 */
@property (nonatomic, copy) UDRecordProgress recordProgress;
/**
 *  分贝
 */
@property (nonatomic, copy) UDPeakPowerForChannel peakPowerForChannel;
/**
 *  语音文件地址
 */
@property (nonatomic, copy, readonly) NSString *recordPath;
/**
 *  语音时长
 */
@property (nonatomic, copy) NSString *recordDuration;
/**
 *  语音最长时间 默认60秒最大
 */
@property (nonatomic) float maxRecordTime;
/**
 *  当前语音时间
 */
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

/**
 *  准备录音
 *
 *  @param completion 准备完成callback
 */
- (void)prepareRecordingCompletion:(UDPrepareRecorderCompletion)completion;
/**
 *  录音开始
 *
 *  @param startRecorderCompletion 录音开始callback
 */
- (void)startRecordingWithStartRecorderCompletion:(UDStartRecorderCompletion)startRecorderCompletion;
/**
 *  暂停录音
 *
 *  @param pauseRecorderCompletion 暂停callback
 */
- (void)pauseRecordingWithPauseRecorderCompletion:(UDPauseRecorderCompletion)pauseRecorderCompletion;
/**
 *  恢复录音
 *
 *  @param resumeRecorderCompletion 恢复callback
 */
- (void)resumeRecordingWithResumeRecorderCompletion:(UDResumeRecorderCompletion)resumeRecorderCompletion;
/**
 *  停止录音
 *
 *  @param stopRecorderCompletion 停止callback
 */
- (void)stopRecordingWithStopRecorderCompletion:(UDStopRecorderCompletion)stopRecorderCompletion;
/**
 *  取消录音
 *
 *  @param cancelledDeleteCompletion 取消callback
 */
- (void)cancelledDeleteWithCompletion:(UDCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
