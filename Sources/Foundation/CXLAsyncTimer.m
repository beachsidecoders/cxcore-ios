/**
 *    File: CXLAsyncTimer.m
 *
 *    Description:
 *          GCD based async timer.
 *
 *    Copyright (c) 2014 - 2015, Beachside Coders LLC
 *    All rights reserved.
 *
 *    Redistribution and use in source and binary forms, with or without
 *    modification, are permitted provided that the following conditions are met:
 *
 *      1. Redistributions of source code must retain the above copyright notice, this
 *        list of conditions and the following disclaimer.
 *
 *      2. Redistributions in binary form must reproduce the above copyright notice,
 *        this list of conditions and the following disclaimer in the documentation
 *        and/or other materials provided with the distribution.
 *
 *      3. Neither the name of the copyright holder nor the names of its
 *        contributors may be used to endorse or promote products derived from
 *        this software without specific prior written permission.
 *
 *    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 *    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 *    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 *    IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 *    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 *    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 *    OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 *    OF SUCH DAMAGE.
 *
 */
#import "CXLAsyncTimer.h"


@interface CXLAsyncTimer()

@property (nonatomic, strong) dispatch_source_t gcdTimer;

@end

@implementation CXLAsyncTimer
{

}

- (void)dealloc
{
    [self cancelTimer];
}

#pragma mark CXLAsyncTimer (Public)

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    if (!self.gcdTimer) {
        self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        if (self.gcdTimer) {
            dispatch_source_set_timer(self.gcdTimer, dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), timeInterval * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(self.gcdTimer, block);
            dispatch_resume(self.gcdTimer);
        }
    }
}

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(dispatch_block_t)block
{
    [self startTimerWithTimeInterval:timeInterval
                               queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                               block:block];
}

- (void)cancelTimer
{
    if (self.gcdTimer) {
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}

@end
