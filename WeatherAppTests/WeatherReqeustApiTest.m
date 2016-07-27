//
//  WeatherReqeustApiTest.m
//  WeatherApp
//
//  Created by Soheil on 13/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiwi.h"
#import <AFNetworking/AFNetworking.h>
@import OHHTTPStubs;



#import "WeatherRequestApi.h"

SPEC_BEGIN(WeatherRequestApiTest)

describe(@"Testing WeatherRequestApi class", ^{
    __block WeatherRequestApi *requestApi;
    __block id responseObject;
    __block NSString *filePath;
    __block NSString *hostURL = @"http://api.worldweatheronline.com/free/v1/weather.ashx";
    
    context(@"Testing Succesful Request with valid datas", ^{
        __block NSString *fixtureName = @"FixtureRequest_OK";
        __block NSString *keyword = @"Singapore, Singapore";      // correct city name
        
        beforeAll(^{
            filePath = [[NSBundle mainBundle] pathForResource:fixtureName ofType:@"json"];
            NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            NSError *error =  nil;
            NSDictionary *jsonResponce = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            responseObject = jsonResponce[@"data"];
            
        });
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                NSString *requestedURL = [NSString stringWithFormat:@"http://%@%@",request.URL.host,request.URL.relativePath];
                return [requestedURL isEqualToString:hostURL];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:filePath
                                                        statusCode:200
                                                           headers:@{@"Content-Type":@"application/json"}];
            }];
        });
        
        it(@"It should return a succesful json result", ^{
            __block id weatherResponse;
            
            requestApi = [[WeatherRequestApi alloc]initWithCallback:^(NSDictionary *dict, NSError *error) {
                weatherResponse = dict;
            } withSearchKeyword:keyword];
            [requestApi execute];
            
            [[expectFutureValue(weatherResponse) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:responseObject];
        });
        
        it(@"It should Fail if request get cancelled", ^{
            __block id weatherResponse;
            __block BOOL isCancelledError = NO;
            
            requestApi = [[WeatherRequestApi alloc]initWithCallback:^(NSDictionary *dict, NSError *error) {
                weatherResponse = dict;
                
                if(error.code ==-999){
                    isCancelledError = YES;
                }
                
            } withSearchKeyword:keyword];
            [requestApi execute];
            [requestApi cancelOperation];
            
            [[expectFutureValue(theValue(isCancelledError)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
            [[expectFutureValue(weatherResponse) shouldEventuallyBeforeTimingOutAfter(5.0)] beNil];
        });

    });
    
    context(@"Testing API with error response with unvalid data", ^{
        __block NSString *fixtureName = @"FixtureRequest_NO";
        __block NSString *keyword = @"randomWrongCity";      // wrong name city
        
        beforeAll(^{
            filePath = [[NSBundle mainBundle] pathForResource:fixtureName ofType:@"json"];
            NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            NSError *error =  nil;
            NSDictionary *jsonResponce = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            responseObject = [[jsonResponce valueForKeyPath:@"data.error.msg"] firstObject];
        });
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                NSString *requestedURL = [NSString stringWithFormat:@"http://%@%@",request.URL.host,request.URL.relativePath];
                return [requestedURL isEqualToString:hostURL];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:filePath
                                                        statusCode:200
                                                           headers:@{@"Content-Type":@"application/json"}];
            }];
        });
        
        it(@"It should return a json with error result", ^{
            __block id weatherResponse;
            __block NSString *errorMessage;
            
            requestApi = [[WeatherRequestApi alloc]initWithCallback:^(NSDictionary *dict, NSError *error) {
                weatherResponse = dict;
                
                if([error.domain isEqualToString:@"WEATHER_CUSTOM_MESSAGE_ERROR"]){
                    errorMessage = error.userInfo[@"message"];
                }
                
            } withSearchKeyword:keyword];
            [requestApi execute];
            
            [[[expectFutureValue(weatherResponse) shouldEventuallyBeforeTimingOutAfter(5.0)] shouldNot] equal:responseObject];
            [[expectFutureValue(errorMessage) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:responseObject];
        });
    });
});

SPEC_END

