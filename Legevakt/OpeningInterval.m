//
//  OpeningInterval.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "OpeningInterval.h"

@interface OpeningInterval ()

@property int start;
@property int stop;

@property (strong, nonatomic) NSCalendar *calendar;

@end

#define MINUTES_PER_DAY 1440
#define MINUTES_PER_HOUR 60
#define DAYS_PER_WEEK 7
#define WEEK_DAY_NAMES @[@"Mandag", @"Tirsdag", @"Onsdag", @"Torsdag", @"Fredag", @"Lørdag", @"Søndag"]
#define ALL_DAYS @"Alle dager"
#define OPEN_ALL_DAYS @"Åpent alle dager"
#define OPEN_WEEKENDS @"Åpent helg"
#define MINUTES_TO_THURSDAY_AT_3_PM 6660
#define MINUTES_TO_THURSDAY_AT_MIDNIGHT 7200
#define MINUTES_TO_SUNDAY_AT_MIDNIGHT 10079

@implementation OpeningInterval

@synthesize calendar = _calendar;

- (id)initWithInterval:(NSString *)interval
{
    self = [super init];
    
    NSArray *tokenizedInterval = [interval componentsSeparatedByString:@"-"];
    
    self.start = [tokenizedInterval[0] intValue];
    self.stop = [tokenizedInterval[1] intValue];
    
    return self;
}

- (NSString *)description
{
    NSString *returnString = @"";
    
    if ([self isAlwaysOpen])
    {
        returnString = OPEN_ALL_DAYS;
    }
    
    else if ([self isWeekendInterval])
    {
        returnString = OPEN_WEEKENDS;
    }
    
    else if ([self startAndStopWeekdayAreEqual] || [self startWeekdayIsTheDayBeforeStopWeekday])
    {
        returnString = [NSString stringWithFormat:@"%@: %@-%@",
                        [self startDayOfWeek],
                        [OpeningInterval timeStringFromHours:[self startHours] andMinutes:[self startMinutes]],
                        [OpeningInterval timeStringFromHours:[self stopHours] andMinutes:[self stopMinutes]]];
        
    }
    
    else
    {
        returnString = [NSString stringWithFormat:@"%@: %@ - %@: %@",
                        [self startDayOfWeek],
                        [OpeningInterval timeStringFromHours:[self startHours] andMinutes:[self startMinutes]],
                        [[self stopDayOfWeek] lowercaseString],
                        [OpeningInterval timeStringFromHours:[self stopHours] andMinutes:[self stopMinutes]]];
        
    }
    
    return returnString;
}

#pragma mark -
#pragma mark dateIsInInterval with private helpers

// consider moving this to a helper class
- (BOOL)dateIsInInterval:(NSDate *)date
{
    BOOL open = NO;
    
    int datesWeekday = [self weekdayNumberFromDate:date];
    int datesHour = [self hourFromDate:date];
    int datesMinute = [self minuteFromDate:date];
    
    // always open
    if ([self isAlwaysOpen]) {
        open = YES;
    }

    // or open on weekends
    else if ([self isWeekendInterval]) {
        
        // date's weekday is thursday (but only after 3pm), or friday-sunday
        if ((datesWeekday == 4
            && datesHour >= 15)
            || datesWeekday == 5
            || datesWeekday == 6
            || datesWeekday == 7) {

            open = YES;
        }
    }
    
    // same opening hours every day, or interval starts and stops on date's week day
    else if ([self isValidForAllWeekdays]
             || [self startAndStopWeekdayEqualsWeekdayOfDateWeekday:datesWeekday]) {
        
        if (datesHour >= [self startHours]
            && datesMinute >= [self startMinutes]
            && datesHour <= [self stopHours]
            && ([self stopMinutes] == 0 || datesMinute < [self stopMinutes])) {
            
            open = YES;
        }
    }
    
    // date's week day is on the first day of a multiple day interval
    else if ([self datesWeekdayIsOnTheFirstDayOfMultipleDayInterval:datesWeekday]) {
        
        if (datesHour >= [self startHours]
            && datesMinute >= [self startMinutes]) {
            
            open = YES;
        }
    }
    
    // date's week day is on the last day of a multiple day interval
    else if ([self datesWeekdayIsOnTheLastDayOfMultipleDayInterval:datesWeekday]) {
        
        if(datesHour <= [self stopHours]
           && datesMinute < [self stopMinutes]) {
            
            open = YES;
        }
    }
    
    return open;
}


- (int)weekdayNumberFromDate:(NSDate *)date
{
    int weekdayNumber = [[self weekdayComponentsFromDate:date] weekday] - 1;
    
    if (weekdayNumber == 0)
        weekdayNumber = 7;
    return weekdayNumber;
}

- (int)hourFromDate:(NSDate *)date
{
    return [[self hourComponentsFromDate:date] hour];
}

- (int)minuteFromDate:(NSDate *)date
{
    return [[self minuteComponentsFromDate:date] minute];
}

- (NSDateComponents *)weekdayComponentsFromDate:(NSDate *)date
{
    return [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
}

- (NSDateComponents *)hourComponentsFromDate:(NSDate *)date
{
    return [self.calendar components:NSHourCalendarUnit fromDate:date];
}

- (NSDateComponents *)minuteComponentsFromDate:(NSDate *)date
{
    return [self.calendar components:NSMinuteCalendarUnit fromDate:date];
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

#pragma mark -
#pragma what kind of interval are we?

- (BOOL)isAlwaysOpen
{
    BOOL isAlwaysOpen = NO;
    
    if (self.start == 0 && self.stop >= 10079)
        isAlwaysOpen = YES;
    
    return isAlwaysOpen;
}

- (BOOL)isWeekendInterval
{
    BOOL isWeekendInterval = NO;
    
    if (self.start >= MINUTES_TO_THURSDAY_AT_3_PM
        && self.start <= MINUTES_TO_THURSDAY_AT_MIDNIGHT
        && self.stop >= MINUTES_TO_SUNDAY_AT_MIDNIGHT)
        isWeekendInterval = YES;
    
    return isWeekendInterval;
}

- (BOOL)isValidForAllWeekdays
{
    BOOL isValidForAllWeekdays = NO;
    
    if ([self startWeekday] == 0 && [self stopWeekday] == 0)
        isValidForAllWeekdays = YES;
    
    return isValidForAllWeekdays;
}

- (BOOL)startAndStopWeekdayAreEqual
{
    BOOL equals = NO;
    
    if ([self startWeekday] == [self stopWeekday])
        equals = YES;
    
    return equals;
}

- (BOOL)startWeekdayIsTheDayBeforeStopWeekday
{
    BOOL answer = NO;
    
    if ([self startWeekday] + 1 == [self stopWeekday])
        answer = YES;
    
    return answer;
}

- (BOOL)startAndStopWeekdayEqualsWeekdayOfDateWeekday:(int)datesWeekday
{
    BOOL equals = NO;
    
    if ([self startAndStopWeekdayAreEqual] && datesWeekday == [self startWeekday])
        equals = YES;
    
    return equals;
}

- (BOOL)datesWeekdayIsOnTheFirstDayOfMultipleDayInterval:(int)datesWeekday
{
    BOOL answer = NO;
    
    if (datesWeekday == [self startWeekday]
        && datesWeekday != [self stopWeekday])
        answer = YES;
    
    return answer;
}

- (BOOL)datesWeekdayIsOnTheLastDayOfMultipleDayInterval:(int)datesWeekday
{
    BOOL answer = NO;
    
    if (datesWeekday == [self stopWeekday]
        && datesWeekday != [self startWeekday])
        answer = YES;

    return answer;
}

#pragma mark -
#pragma mark Private methods

- (int)startTotalMinutes
{
    return self.start;
}

- (int)stopTotalMinutes
{
    return self.stop;
}

- (NSString *)startDayOfWeek
{
    return [OpeningInterval dayOfWeekFromTime:self.start];
}

- (NSString *)stopDayOfWeek
{
    return [OpeningInterval dayOfWeekFromTime:self.stop];
}

- (int)startHours
{
    return [OpeningInterval hoursFromTime:self.start];
}

- (int)stopHours
{
    return [OpeningInterval hoursFromTime:self.stop];
}

- (int)startMinutes
{
    return [OpeningInterval minutesFromTime:self.start];
}

- (int)stopMinutes
{
    return [OpeningInterval minutesFromTime:self.stop];
}
         
- (int)startWeekday
{
    return [OpeningInterval dayOfWeekNumberFromTime:self.start];
}

- (int)stopWeekday
{
    return [OpeningInterval dayOfWeekNumberFromTime:self.stop];
}

#pragma mark -
#pragma mark Class Methods

#pragma mark Public
// don't use this method unless you're sure you want to
+ (NSString *)timeStringMergedIntervalFromIntervals:(NSArray *)intervals
{
    NSString *timeString = @"";
    
    NSLog(@"number of intervals: %d", intervals.count);
    if (intervals.count == 7) {
        timeString = [timeString stringByAppendingFormat:@"%@: ", ALL_DAYS];
    }
    else {
        timeString = [timeString stringByAppendingFormat:@"%@ - ",[(OpeningInterval *)intervals[0] startDayOfWeek]];
        timeString = [timeString stringByAppendingFormat:@"%@: ", [[(OpeningInterval *)intervals[intervals.count - 1] stopDayOfWeek] lowercaseString]];
        
    }
    
    timeString = [timeString stringByAppendingFormat:@"%@-",[OpeningInterval timeStringFromHours:[(OpeningInterval *)intervals[0] startHours]
                                                                         andMinutes:[(OpeningInterval *)intervals[0] startMinutes]]];
    timeString = [timeString stringByAppendingFormat:@"%@;", [OpeningInterval timeStringFromHours:[(OpeningInterval *)intervals[0] stopHours]
                                                                          andMinutes:[(OpeningInterval *)intervals[0] stopMinutes]]];
    
    return timeString;
}

+ (NSString *)timeStringCombinedFromIntervals:(NSArray *)intervals
{
    NSString *timeString = @"";
    
    for (id obj in intervals) {
        OpeningInterval *interval = (OpeningInterval *)obj;
        timeString = [timeString stringByAppendingFormat:@"%@\n", interval.description];
        
    }

    return timeString;
}

#pragma mark Private
+ (NSString *)dayOfWeekFromTime:(int)time
{
    NSString *dayOfWeekName = @"";
    
    int dayOfWeekNumber = [self dayOfWeekNumberFromTime:time];
    dayOfWeekName = [self dayOfWeekNameFromDayOfWeekNumber:(int)dayOfWeekNumber];
    
    return dayOfWeekName;
}

+ (NSString *)dayOfWeekNameFromDayOfWeekNumber:(int)dayOfWeekNumber
{
    int weekDayIndex = dayOfWeekNumber % DAYS_PER_WEEK;
    return WEEK_DAY_NAMES[weekDayIndex];
}

+ (int)dayOfWeekNumberFromTime:(int)time
{
    return time / MINUTES_PER_DAY;
}

+ (int)hoursFromTime:(int)time
{
    return (time % MINUTES_PER_DAY) / MINUTES_PER_HOUR;
}

+ (int)minutesFromTime:(int)time
{
    return (time % MINUTES_PER_DAY) % MINUTES_PER_HOUR;
}

+ (NSString *)timeStringFromHours:(int)hours andMinutes:(int)minutes
{
    NSString *hoursAsString = [NSString stringWithFormat:@"%d", hours];
    NSString *minutesAsString = [NSString stringWithFormat:@"%d", minutes];
    
    if(hours < 10) {
        hoursAsString = [NSString stringWithFormat:@"0%@", hoursAsString];
    }
    
    if (minutes < 10) {
        minutesAsString = [NSString stringWithFormat:@"0%@", minutesAsString];
    }
    
    return [NSString stringWithFormat:@"%@.%@", hoursAsString, minutesAsString];
}

@end
