//
//  ViewController.h
//  BLHeliMac
//
//  Created by Kolb Norbert on 18.01.16.
//  Copyright © 2016 Kolb Norbert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
// import IOKit headers
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>

// Eeprom-Adresses
#define ADRESS_MAIN_VERSION             0x1A00
#define ADRESS_SUB_VERSION              0x1A01
#define ADRESS_EEPROM_LAYOUT            0x1A02
#define ADRESS_P_GAIN                   0x1A03
#define ADRESS_I_GAIN                   0x1A04
#define ADRESS_GOVERNOR_MODE            0x1A05
#define ADRESS_LOW_VOLTAGE_LIMIT        0x1A06
#define ADRESS_GAIN                     0x1A07
#define ADRESS_MOTOR_IDLE_SPEED         0x1A08
#define ADRESS_STARTUP_POWER            0x1A09
#define ADRESS_PWM_FREQUENCY            0x1A0A
#define ADRESS_MOTOR_DIRECTION          0x1A0B
#define ADRESS_INPUT_PWM_POLARITY       0x1A0C
#define ADRESS_MODE                     0x1A0D
#define ADRESS_PROGRAMMING_BY_TX        0x1A0F
#define ADRESS_REARM_AT_START           0x1A10
#define ADRESS_GOVERNOR_SETUP_TARGET    0x1A11
#define ADRESS_STARTUP_RPM              0x1A12
#define ADRESS_STARTUP_ACCELERATION     0x1A13
#define ADRESS_VOLT_COMP                0x1A14
#define ADRESS_COMMUTATION_TIMING       0x1A15
#define ADRESS_DAMPING_FORCE            0x1A16
#define ADRESS_GOVERNOR_RANGE           0x1A17
#define ADRESS_STARTUP_METHOD           0x1A18
#define ADRESS_MIN_THROTTLE             0x1A19
#define ADRESS_MAX_THROTTLE             0x1A1A
#define ADRESS_BEEP_STRENGTH            0x1A1B
#define ADRESS_BEACON_STRENGTH          0x1A1C
#define ADRESS_BEACON_DELAY             0x1A1D
#define ADRESS_THROTTLE_RATE            0x1A1E
#define ADRESS_DEMAG_COMPENSATION       0x1A1F
#define ADRESS_BEC_VOLTAGE              0x1A20
#define ADRESS_CENTER_THROTTLE          0x1A21
#define ADRESS_SPOOLUP_TIME             0x1A22
#define ADRESS_TEMPERATURE_PROTECTION   0x1A23
#define ADRESS_LOW_RPM_POWER_PROTECTION 0x1A24
#define ADRESS_PWM_INPUT                0x1A25
#define ADRESS_PWM_DITHER               0x1A26
#define ADRESS_BESC                     0x1A40
#define ADRESS_MCU                      0x1A50
#define ADRESS_NAME                     0x1A60

// Eeporm sizes
#define SIZE_MAIN_VERSION               1
#define SIZE_SUB_VERSION                1
#define SIZE_EEPROM_LAYOUT              1
#define SIZE_P_GAIN                     1
#define SIZE_I_GAIN                     1
#define SIZE_GOVERNOR_MODE              1
#define SIZE_LOW_VOLTAGE_LIMT           1
#define SIZE_GAIN                       1
#define SIZE_MOTOR_IDLE_SPEED           1
#define SIZE_STARTUP_POWER              1
#define SIZE_PWM_FREQUENCY              1
#define SIZE_MOTOR_DIRECTION            1
#define SIZE_INPUT_PWM_POLARITY         1
#define SIZE_MODE                       2
#define SIZE_PROGRAMMING_BY_TX          1
#define SIZE_REARM_AT_START             1
#define SIZE_GOVERNOR_SETUP_TARGET      1
#define SIZE_STARTUP_RPM                1
#define SIZE_STARTUP_ACCELERATION       1
#define SIZE_VOLT_COMP                  1
#define SIZE_COMMUTATION_TIMING         1
#define SIZE_DAMPING_FORCE              1
#define SIZE_GOVERNOR_RANGE             1
#define SIZE_STARTUP_METHOD             1
#define SIZE_MIN_THROTTLE               1
#define SIZE_MAX_THROTTLE               1
#define SIZE_BEEP_STRENGTH              1
#define SIZE_BEACON_STRENGTH            1
#define SIZE_BEACON_DELAY               1
#define SIZE_THROTTLE_RATE              1
#define SIZE_DEMAG_COMPENSATION         1
#define SIZE_BEC_VOLTAGE                1
#define SIZE_CENTER_THROTTLE            1
#define SIZE_SPOOLUP_TIME               1
#define SIZE_TEMPERATURE_PROTECTION     1
#define SIZE_LOW_RPM_POWER_PROTECTION   1
#define SIZE_PWM_INPUT                  1
#define SIZE_PWM_DITHER                 1
#define SIZE_BESC                       16
#define SIZE_MCU                        16
#define SIZE_NAME                       16

// supported modes
#define MODE_MAIN                       0
#define MODE_TAIL                       1
#define MODE_MULTI                      2

@interface ViewController : NSViewController {
    int mode;
    int eepromLayout;
    
    IBOutlet NSPopUpButton *_ports;
    IBOutlet NSButton *_connectioButton;
    IBOutlet NSButton *_readButton;
    IBOutlet NSButton *_defaultsButton;
    IBOutlet NSButton *_writeButton;
    IBOutlet NSTextField *_versionLabel;
    IBOutlet NSTextField *_version;
    IBOutlet NSTextField *_MCULabel;
    IBOutlet NSTextField *_MCU;
    IBOutlet NSTextField *_BESCLabel;
    IBOutlet NSTextField *_BESC;
    IBOutlet NSTextField *_nameLabel;
    IBOutlet NSTextField *_name;
    IBOutlet NSTextField *_modeLabel;
    IBOutlet NSSegmentedControl *_mode;
    IBOutlet NSTextField *_motorDirectionLabel;
    IBOutlet NSSegmentedControl *_motorDirection;
    IBOutlet NSTextField *_commutationTimingLabel;
    IBOutlet NSSegmentedControl *_commutationTiming;
    IBOutlet NSTextField *_inputPWMPolarityLabel;
    IBOutlet NSSegmentedControl *_inputPWMPolarity;
    IBOutlet NSTextField *_BECVoltageLabel;
    IBOutlet NSSegmentedControl *_BECVoltage;
    IBOutlet NSTextField *_PWMFrequencyLabel;
    IBOutlet NSSegmentedControl *_PWMFrequency;
    IBOutlet NSTextField *_beepStrengthLabel;
    IBOutlet NSTextField *_beepStrength;
    IBOutlet NSTextField *_beaconStrengthLabel;
    IBOutlet NSTextField *_beaconStrength;
    IBOutlet NSButton *_beaconDelay;
    IBOutlet NSSegmentedControl *_beaconDelaySelect;
    IBOutlet NSTextField *_throttleMinLabel;
    IBOutlet NSTextField *_throttleMin;
    IBOutlet NSTextField *_throttleRateLabel;
    IBOutlet NSSlider *_throttleRate;
    IBOutlet NSTextField *_throttleMaxLabel;
    IBOutlet NSTextField *_throttleMax;
    IBOutlet NSTextField *_governorRangeLabel;
    IBOutlet NSSegmentedControl *_governorRange;
    IBOutlet NSTextField *_pGainLabel;
    IBOutlet NSSlider *_pGain;
    IBOutlet NSTextField *_iGainLabel;
    IBOutlet NSSlider *_iGain;
    IBOutlet NSTextField *_startupPowerLabel;
    IBOutlet NSSlider *_startupPower;
    IBOutlet NSButton *_rearmingEveryStart;
    IBOutlet NSButton *_programmingByTX;
    IBOutlet NSButton *_thermalProtection;
    IBOutlet NSButton *_governorMode;
    IBOutlet NSSegmentedControl *_governorModeSelect;
    IBOutlet NSButton *_lowVoltageLimit;
    IBOutlet NSSegmentedControl *_lowVoltageLimitSelect;
    IBOutlet NSButton *_demagCompensation;
    IBOutlet NSSegmentedControl *_demagCompensationSelect;
    IBOutlet NSButton *_pwmDither;
    IBOutlet NSSegmentedControl *_pwmDitherSelect;
    IBOutlet NSTextField *_gainLabel;
    IBOutlet NSSlider *_gain;
    IBOutlet NSButton *_lowRPMPowerProtection;
    IBOutlet NSButton *_pwmInput;
    IBOutlet NSTextField *_centerThrottleLabel;
    IBOutlet NSTextField *_centerThrottle;
   
    int _serialFileDescriptor; // file handle to the serial port
    struct termios _gOriginalTTYAttrs; // Hold the original termios attributes so we can reset them on quit ( best practice )
}

- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)connectButtonClicked:(id)sender;
- (IBAction)readButtonClicked:(id)sender;
- (IBAction)defaultsButtonClicked:(id)sender;
- (IBAction)writeButtonClicked:(id)sender;

- (NSString*)readLine;
- (NSString*)readFromAdress:(long)adress :(int)size;
- (NSString*)readValue:(NSString*)key;
- (NSString*)writeStringToAdress:(long)adress :(int)size :(NSString*)string;
- (NSString*)writeIntegerToAdress:(long)adress :(int)size :(int)integer;
- (NSString*)writeValue:(NSString*)key :(NSString*)value;
- (unsigned int)intFromHexString:(NSString*)hexStr;
- (NSString*)stringFromHexString:(NSString*)hexStr;
- (NSString*)stringToHexString:(NSString*)string;

@end

