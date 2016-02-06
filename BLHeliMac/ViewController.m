//
//  ViewController.m
//  BLHeliMac
//
//  Created by Kolb Norbert on 18.01.16.
//  Copyright © 2016 Kolb Norbert. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    mode = -1;
    eepromLayout = 0;

    // Do any additional setup after loading the view.
    [self refreshMachinePortList:@"Select port ..."];
    [_ports setEnabled:YES];
    [_connectioButton setTitle:@"Connect"];
    [_readButton setEnabled:NO];
    [_defaultsButton setEnabled:NO];
    [_writeButton setEnabled:NO];
    
    [_versionLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_MCULabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_BESCLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_nameLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_name setEnabled:NO];
    [_modeLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_mode setEnabled:NO];
    [_motorDirectionLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_motorDirection setEnabled:NO];
    [_commutationTimingLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_commutationTiming setEnabled:NO];
    [_inputPWMPolarityLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_inputPWMPolarity setEnabled:NO];
    [_BECVoltageLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_BECVoltage setEnabled:NO];
    [_PWMFrequencyLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_PWMFrequency setEnabled:NO];
    [_beepStrengthLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_beepStrength setEnabled:NO];
    [_beaconStrengthLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_beaconStrength setEnabled:NO];
    [_beaconDelay setEnabled:NO];
    [_beaconDelaySelect setEnabled:NO];
    [_throttleMinLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_throttleMin setEnabled:NO];
    [_throttleRateLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_throttleRate setEnabled:NO];
    [_throttleMaxLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_throttleMax setEnabled:NO];
    [_governorRangeLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_governorRange setEnabled:NO];
    [_pGainLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_pGain setEnabled:NO];
    [_iGainLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_iGain setEnabled:NO];
    [_gainLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_gain setEnabled:NO];
    [_startupPowerLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_startupPower setEnabled:NO];
    [_rearmingEveryStart setEnabled:NO];
    [_programmingByTX setEnabled:NO];
    [_thermalProtection setEnabled:NO];
    [_governorMode setEnabled:NO];
    [_governorModeSelect setEnabled:NO];
    [_lowVoltageLimit setEnabled:NO];
    [_lowVoltageLimitSelect setEnabled:NO];
    [_demagCompensation setEnabled:NO];
    [_demagCompensationSelect setEnabled:NO];
    [_pwmDither setEnabled:NO];
    [_pwmDitherSelect setEnabled:NO];
    [_lowRPMPowerProtection setEnabled:NO];
    [_pwmInput setEnabled:NO];
    [_centerThrottleLabel setTextColor:[NSColor colorWithCalibratedRed:0.69 green:0.69 blue:0.69 alpha:1.0]];
    [_centerThrottle setEnabled:NO];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)refreshMachinePortList:(NSString *)selectedText {
    io_object_t serialPort;
    io_iterator_t serialPortIterator;
    
    // remove everything from the pull down list
    [_ports removeAllItems];
    
    // ask for all the serial ports
    IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(kIOSerialBSDServiceValue), &serialPortIterator);
    
    // loop through all the serial ports and add them to the array
    while ((serialPort = IOIteratorNext(serialPortIterator))) {
        [_ports addItemWithTitle:(NSString*)CFBridgingRelease(IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIOCalloutDeviceKey),  kCFAllocatorDefault, 0))];
        IOObjectRelease(serialPort);
    }
    
    // add the selected text to the top
    [_ports insertItemWithTitle:selectedText atIndex:0];
    [_ports selectItemAtIndex:0];
    
    IOObjectRelease(serialPortIterator);
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self refreshMachinePortList:@"Select port ..."];
}
- (IBAction)connectButtonClicked:(id)sender {   
    if (_serialFileDescriptor > -1) {
        if (![[_ports titleOfSelectedItem] isEqual: @"Select port ..."]) {
            // open the serial port
            NSString *error =[self connect:[_ports titleOfSelectedItem] :38400];
            
            if(error==nil) {
                // GUI einstellen
                [_ports setEnabled:NO];
                [_connectioButton setTitle:@"Disconnect"];
                [_readButton setEnabled:YES];
                [_writeButton setEnabled:NO];
            }
        }
    } else {
        [self disconnect];
        
        [_ports setEnabled:YES];
        [_connectioButton setTitle:@"Connect"];
        [_readButton setEnabled:NO];
        [_writeButton setEnabled:NO];
    }
}
- (IBAction)readButtonClicked:(id)sender {
    NSString *response = @"";

    [self sendCommand:@"r"];
    response = [self readLine];
    
    [self sendCommand:@"i"];
    response = [self readLine];
    
    [self sendCommand:@"d"];
    response = [self readLine];
    
    // ########################
    // Eeprom Layout
    eepromLayout = [self intFromHexString:[self readFromAdress:ADRESS_EEPROM_LAYOUT :SIZE_EEPROM_LAYOUT]];
    if (eepromLayout != 20) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:@"Please update to version 14.3"];
        [alert setInformativeText:@"Version 20 of eeprom layout not found."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        
        return;
    }
    
    int integerValue;
    
    // ########################
    // Version
    {
        response = [NSString stringWithFormat:@"v%d.%d",
                    [self intFromHexString:[self readFromAdress:ADRESS_MAIN_VERSION :SIZE_MAIN_VERSION]],
                    [self intFromHexString:[self readFromAdress:ADRESS_SUB_VERSION :SIZE_SUB_VERSION]]];
        [_version setStringValue:response];
        [_versionLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // BESC
    {
        response = [self readFromAdress:ADRESS_BESC :SIZE_BESC];
        [_BESC setStringValue:[self stringFromHexString:response]];
        [_BESCLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // MCU
    {
        response = [self readFromAdress:ADRESS_MCU :SIZE_MCU];
        [_MCU setStringValue:[self stringFromHexString:response]];
        [_MCULabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Name
    {
        response = [self readFromAdress:ADRESS_NAME :SIZE_NAME];
        [_name setStringValue:[[self stringFromHexString:response] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [_name setEnabled:YES];
        [_nameLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Mode
    {
        response = [self readFromAdress:ADRESS_MODE :SIZE_MODE];
        if ([response isEqualToString:@"A55A"]) {
            [_mode setSelected:YES forSegment:0];
            [_mode setEnabled:YES forSegment:0];
            [_mode setEnabled:NO forSegment:1];
            [_mode setEnabled:NO forSegment:2];
            mode = MODE_MAIN;
        } else if ([response isEqualToString:@"5AA5"]) {
            [_mode setSelected:YES forSegment:1];
            [_mode setEnabled:NO forSegment:0];
            [_mode setEnabled:YES forSegment:1];
            [_mode setEnabled:NO forSegment:2];
            mode = MODE_TAIL;
        } else if ([response isEqualToString:@"55AA"]) {
            [_mode setSelected:YES forSegment:2];
            [_mode setEnabled:NO forSegment:0];
            [_mode setEnabled:NO forSegment:1];
            [_mode setEnabled:YES forSegment:2];
            mode = MODE_MULTI;
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessageText:@"Unknown BLHeli Mode"];
            [alert setInformativeText:@"Currently only MAIN, TAIL and MULTI are supported. Please update to Version 14.3."];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
            
            return;
        }
        [_mode setEnabled:YES];
        [_modeLabel setTextColor:[NSColor controlTextColor]];
    }

    // ########################
    // P-Gain
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_P_GAIN :SIZE_P_GAIN]];
        if (integerValue >= 1 && integerValue <= 13) {
            [_pGain setDoubleValue:integerValue];
            [_pGain setEnabled:YES];
            [_pGainLabel setTextColor:[NSColor controlTextColor]];
        }
    }
    
    // ########################
    // I-Gain
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_I_GAIN :SIZE_I_GAIN] ];
        if (integerValue >= 1 && integerValue <= 13) {
            [_iGain setDoubleValue:integerValue];
            [_iGain setEnabled:YES];
            [_iGainLabel setTextColor:[NSColor controlTextColor]];
        }
    }
    
    // ########################
    // Governor mode / closed loop mode
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_GOVERNOR_MODE :SIZE_GOVERNOR_MODE]];
        switch (integerValue) {
            case 1:
            case 2:
            case 3:
                [_governorMode setState:NSOnState];
                [_governorModeSelect setSelected:YES forSegment:integerValue-1];
                break;
            case 4:
                [_governorMode setState:NSOffState];
                [_governorModeSelect setSelectedSegment:-1];
                break;
            default:
                [_governorMode setState:NSOffState];
                [_governorModeSelect setSelectedSegment:-1];
                break;
        }
        switch (mode) {
            case MODE_MAIN:
                [_governorMode setTitle:@"Governor mode"];
                [_governorMode setEnabled:YES];
                [_governorModeSelect setLabel:@"TX" forSegment:0];
                [_governorModeSelect setLabel:@"Arm" forSegment:1];
                [_governorModeSelect setLabel:@"Setup" forSegment:2];
                [_governorModeSelect setEnabled:YES];
                break;
            case MODE_MULTI:
                [_governorMode setTitle:@"Closed loop mode"];
                [_governorMode setEnabled:YES];
                [_governorModeSelect setLabel:@"HiRange" forSegment:0];
                [_governorModeSelect setLabel:@"MidRange" forSegment:1];
                [_governorModeSelect setLabel:@"LoRange" forSegment:2];
                [_governorModeSelect setEnabled:YES];
                break;
            default:
                [_governorMode setTitle:@"Governor mode"];
                [_governorModeSelect setLabel:@"HiRange" forSegment:0];
                [_governorModeSelect setLabel:@"MidRange" forSegment:1];
                [_governorModeSelect setLabel:@"LoRange" forSegment:2];
                break;
        }
    }
    
    // ########################
    // Low voltage limit
    {
        response = [self readFromAdress:ADRESS_LOW_VOLTAGE_LIMIT :SIZE_LOW_VOLTAGE_LIMT];
        integerValue = [self intFromHexString:response];
        switch (integerValue) {
            case 1:
                [_lowVoltageLimit setState:NSOffState];
                [_lowVoltageLimitSelect setSelectedSegment:-1];
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                [_lowVoltageLimit setState:NSOnState];
                [_lowVoltageLimitSelect setSelected:YES forSegment:integerValue-2];
                break;
            default:
                [_lowVoltageLimit setState:NSOffState];
                [_lowVoltageLimitSelect setSelectedSegment:-1];
                break;
        }
        switch (mode) {
            case MODE_MAIN:
                [_lowVoltageLimit setEnabled:YES];
                [_lowVoltageLimitSelect setEnabled:YES];
                break;
            default:
                [_lowVoltageLimit setState:NSOffState];
                [_lowVoltageLimitSelect setSelectedSegment:-1];
                break;
        }
    }
    
    // ########################
    // Gain
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_GAIN :SIZE_GAIN] ];
        if (integerValue >= 1 && integerValue <= 13) {
            [_gain setDoubleValue:integerValue];
        }
        switch (mode) {
            case MODE_TAIL:
            case MODE_MULTI:
                [_gain setEnabled:YES];
                [_gainLabel setTextColor:[NSColor controlTextColor]];
                break;
        }
    }

    // ########################
    // Motor idle speed
    {
        response = [self readFromAdress:ADRESS_MOTOR_IDLE_SPEED :SIZE_MOTOR_IDLE_SPEED];
        NSLog(@"FIXME: Motor idle speed: %@", response);
    }

    // ########################
    // Startup power
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_STARTUP_POWER :SIZE_STARTUP_POWER] ];
        if (integerValue >= 1 && integerValue <= 13) {
            [_startupPower setDoubleValue:integerValue];
        } else {
            [_startupPower setDoubleValue:13.0];
        }
        [_startupPower setEnabled:YES];
        [_startupPowerLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // PWM Frequency
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_PWM_FREQUENCY :SIZE_PWM_FREQUENCY]];
        if (integerValue >= 1 && integerValue <= 3) {
            [_PWMFrequency setSelected:YES forSegment:integerValue-1];
        } else {
            [_PWMFrequency setSelectedSegment:-1];
        }
        [_PWMFrequency setEnabled:YES];
        [_PWMFrequencyLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Motor direction
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_MOTOR_DIRECTION :SIZE_MOTOR_DIRECTION]];
        if (integerValue >= 1 && integerValue <= 3) {
            [_motorDirection setSelected:YES forSegment:integerValue-1];
        } else {
            [_motorDirection setSelectedSegment:-1];
        }
        [_motorDirection setEnabled:YES];
        [_motorDirectionLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // input PWM polarity
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_INPUT_PWM_POLARITY :SIZE_INPUT_PWM_POLARITY]];
        if (integerValue >= 1 && integerValue <= 2) {
            [_inputPWMPolarity setSelected:YES forSegment:integerValue-1];
        } else {
            [_inputPWMPolarity setSelectedSegment:-1];
        }
        [_inputPWMPolarity setEnabled:YES];
        [_inputPWMPolarityLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Programming by TX
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_PROGRAMMING_BY_TX :SIZE_PROGRAMMING_BY_TX]];
        if (integerValue == 1) {
            [_programmingByTX setState:NSOnState];
        } else {
            [_programmingByTX setState:NSOffState];
        }
        [_programmingByTX setEnabled:YES];
    }
    
    // ########################
    // Rearm at start
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_REARM_AT_START :SIZE_REARM_AT_START]];
        if (integerValue == 1) {
            [_rearmingEveryStart setState:NSOnState];
        } else {
            [_rearmingEveryStart setState:NSOffState];
        }
        switch (mode) {
            case MODE_MAIN:
                [_rearmingEveryStart setEnabled:YES];
                break;
        }
    }
    
    // ########################
    // Governor setup target
    {
        response = [self readFromAdress:ADRESS_GOVERNOR_SETUP_TARGET :SIZE_GOVERNOR_SETUP_TARGET];
        NSLog(@"FIXME: Governor setup target: %@", response);
    }
    
    // ########################
    // Startup RPM
    {
        response = [self readFromAdress:ADRESS_STARTUP_RPM :SIZE_STARTUP_RPM];
        NSLog(@"FIXME: Startup RPM: %@", response);
    }
    
    // ########################
    // Startup Acceleration
    {
        response = [self readFromAdress:ADRESS_STARTUP_ACCELERATION :SIZE_STARTUP_ACCELERATION];
        NSLog(@"FIXME: Startup Acceleration: %@", response);
    }
    
    // ########################
    // Volt comp
    {
        response = [self readFromAdress:ADRESS_VOLT_COMP :SIZE_VOLT_COMP];
        NSLog(@"FIXME: Volt comp: %@", response);
    }
    
    // ########################
    // Commutation timing
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_COMMUTATION_TIMING :SIZE_COMMUTATION_TIMING]];
        if (integerValue >= 1 && integerValue <= 5) {
            [_commutationTiming setSelected:YES forSegment:integerValue-1];
        } else {
            [_commutationTiming setSelected:YES forSegment:2];
        }
        [_commutationTiming setEnabled:YES];
        [_commutationTimingLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Damping force
    {
        response = [self readFromAdress:ADRESS_DAMPING_FORCE :SIZE_DAMPING_FORCE];
        NSLog(@"FIXME: Damping force: %@", response);
    }
    
    // ########################
    // Governor range
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_GOVERNOR_RANGE :SIZE_GOVERNOR_RANGE]];
        if (integerValue >= 1 && integerValue <= 3) {
            [_governorRange setSelected:YES forSegment:integerValue-1];
        } else {
            if (mode == MODE_MAIN) {
                [_governorRange setSelected:YES forSegment:0];
            }
        }
        switch (mode) {
            case MODE_MAIN:
                [_governorRange setEnabled:YES];
                [_governorRangeLabel setTextColor:[NSColor controlTextColor]];
                break;
        }
    }
    
    // ########################
    // Startup method
    {
        response = [self readFromAdress:ADRESS_STARTUP_METHOD :SIZE_STARTUP_METHOD];
        NSLog(@"FIXME: Startup method: %@", response);
    }
    
    // ########################
    // min. throttle
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_MIN_THROTTLE :SIZE_MIN_THROTTLE]];
        [_throttleMin setIntegerValue:(4*integerValue+1000)];
        [_throttleMin setEnabled:YES];
        [_throttleMinLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // max. throttle
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_MAX_THROTTLE :SIZE_MAX_THROTTLE]];
        [_throttleMax setIntegerValue:(4*integerValue+1000)];
        [_throttleMax setEnabled:YES];
        [_throttleMaxLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // beep strength
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_BEEP_STRENGTH :SIZE_BEEP_STRENGTH]];
        [_beepStrength setIntegerValue:integerValue];
        [_beepStrength setEnabled:YES];
        [_beepStrengthLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // beacon strength
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_BEACON_STRENGTH :SIZE_BEACON_STRENGTH]];
        [_beaconStrength setIntegerValue:integerValue];
        [_beaconStrength setEnabled:YES];
        [_beaconStrengthLabel setTextColor:[NSColor controlTextColor]];
    }

    // ########################
    // beacon delay
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_BEACON_DELAY :SIZE_BEACON_DELAY]];
        switch (integerValue) {
            case 1:
            case 2:
            case 3:
            case 4:
                [_beaconDelay setState:NSOnState];
                [_beaconDelaySelect setSelected:YES forSegment:integerValue-1];
                break;
            case 5:
                [_beaconDelay setState:NSOffState];
                [_beaconDelaySelect setSelectedSegment:-1];
                break;
            default:
                [_beaconDelay setState:NSOnState];
                [_beaconDelaySelect setSelected:YES forSegment:3];
                break;
        }
        [_beaconDelay setEnabled:YES];
        [_beaconDelaySelect setEnabled:YES];
    }
    
    // ########################
    // throttle rate
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_THROTTLE_RATE :SIZE_THROTTLE_RATE]];
        [_throttleRate setDoubleValue:255.0];
/*
        [_throttleRate setDoubleValue:integerValue*1.0];
        [_throttleRate setEnabled:YES];
        [_throttleRateLabel setTextColor:[NSColor controlTextColor]];
 */
    }
    
    // ########################
    // demag compensation
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_DEMAG_COMPENSATION :SIZE_DEMAG_COMPENSATION]];
        switch (integerValue) {
            case 1:
                [_demagCompensation setState:NSOffState];
                [_demagCompensationSelect setSelectedSegment:-1];
                break;
            case 2:
            case 3:
                [_demagCompensation setState:NSOnState];
                [_demagCompensationSelect setSelected:YES forSegment:integerValue-2];
                break;
            default:
                break;
        }
        switch (mode) {
            case MODE_MAIN:
            case MODE_TAIL:
                [_demagCompensation setState:NSOffState];
                [_demagCompensationSelect setSelectedSegment:-1];
                break;
            case MODE_MULTI:
                [_demagCompensation setEnabled:YES];
                [_demagCompensationSelect setEnabled:YES];
                break;
        }
    }
    
    // ########################
    // BEC Voltage
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_BEC_VOLTAGE :SIZE_BEC_VOLTAGE]];
        if (integerValue == 0) {
            [_BECVoltage setSelected:YES forSegment:0];
        } else {
            [_BECVoltage setSelected:YES forSegment:1];
        }
        [_BECVoltage setEnabled:YES];
        [_BECVoltageLabel setTextColor:[NSColor controlTextColor]];
    }

    // ########################
    // Center throttle
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_CENTER_THROTTLE :SIZE_CENTER_THROTTLE]];
        [_centerThrottle setIntegerValue:(4*integerValue+1000)];
        [_centerThrottle setEnabled:YES];
        [_centerThrottleLabel setTextColor:[NSColor controlTextColor]];
    }
    
    // ########################
    // Spoolup time
    {
        response = [self readFromAdress:ADRESS_SPOOLUP_TIME :SIZE_SPOOLUP_TIME];
        NSLog(@"FIXME: Spoolup time: %@", response);
    }
    
    // ########################
    // temperature protection
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_TEMPERATURE_PROTECTION :SIZE_TEMPERATURE_PROTECTION]];
        if (integerValue == 1) {
            [_thermalProtection setState:NSOnState];
        } else {
            [_thermalProtection setState:NSOffState];
        }
        [_thermalProtection setEnabled:YES];
    }
    
    // ########################
    // low rpm power protection
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_LOW_RPM_POWER_PROTECTION :SIZE_LOW_RPM_POWER_PROTECTION]];
        if (integerValue == 1) {
            [_lowRPMPowerProtection setState:NSOnState];
        } else {
            [_lowRPMPowerProtection setState:NSOffState];
        }
        [_lowRPMPowerProtection setEnabled:YES];
    }
    
    // ########################
    // pwm input
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_PWM_INPUT :SIZE_PWM_INPUT]];
        if (integerValue == 1) {
            [_pwmInput setState:NSOnState];
        } else {
            [_pwmInput setState:NSOffState];
        }
        [_pwmInput setEnabled:YES];
    }
    
    // ########################
    // PWM Dither
    {
        integerValue = [self intFromHexString:[self readFromAdress:ADRESS_PWM_DITHER :SIZE_PWM_DITHER]];
        switch (integerValue) {
            case 1:
                [_pwmDither setState:NSOffState];
                [_pwmDitherSelect setSelectedSegment:-1];
                break;
            case 2:
            case 3:
            case 4:
            case 5:
                [_pwmDither setState:NSOnState];
                [_pwmDitherSelect setSelected:YES forSegment:integerValue-2];
                break;
            default:
                [_pwmDither setState:NSOnState];
                [_pwmDitherSelect setSelectedSegment:1];
                break;
        }
        switch (mode) {
            case MODE_TAIL:
            case MODE_MULTI:
                [_pwmDither setEnabled:YES];
                [_pwmDitherSelect setEnabled:YES];
                break;
        }
    }
    
    [_defaultsButton setEnabled:YES];
    [_writeButton setEnabled:YES];
}
- (IBAction)defaultsButtonClicked:(id)sender {
    /* Based on https://raw.githubusercontent.com/bitdump/BLHeli/master/SiLabs/BLHeli.asm
     * see "TX programming defaults"
     */
    
    [_programmingByTX setState:NSOnState];
    [_throttleMin setIntegerValue:1148];
    [_throttleMax setIntegerValue:1832];
    [_centerThrottle setIntegerValue:1488];
    [_BECVoltage setSelected:YES forSegment:0];
    [_thermalProtection setState:NSOnState];
    [_lowRPMPowerProtection setState:NSOnState];
    [_pwmInput setState:NSOffState];

    [_rearmingEveryStart setState:NSOffState];
    
    switch (mode) {
        case MODE_MAIN: // Main
            [_pGain setDoubleValue:7.0];
            [_iGain setDoubleValue:7.0];
            [_governorMode setState:NSOnState];
            [_governorModeSelect setSelected:YES forSegment:0];
            [_governorRange setSelected:YES forSegment:0];
            [_lowVoltageLimit setState:NSOnState];
            [_lowVoltageLimitSelect setSelected:YES forSegment:2];
            [_PWMFrequency setSelected:YES forSegment:1];
            [_demagCompensation setState:NSOffState];
            [_demagCompensationSelect setSelectedSegment:-1];
            break;
        case MODE_TAIL: // Tail
            [_PWMFrequency setSelected:YES forSegment:0];
            [_pwmDitherSelect setSelected:YES forSegment:1];
            [_demagCompensation setState:NSOffState];
            [_demagCompensationSelect setSelectedSegment:-1];
            break;
        case MODE_MULTI: // Multi
            [_pGain setDoubleValue:9.0];
            [_iGain setDoubleValue:9.0];
            [_governorMode setState:NSOffState];
            [_governorModeSelect setSelectedSegment:-1];
            [_gain setDoubleValue:3.0];
            [_commutationTiming setSelected:YES forSegment:2];
            [_demagCompensation setState:NSOnState];
            [_demagCompensationSelect setSelected:YES forSegment:0];
            [_PWMFrequency setSelected:YES forSegment:0];
            [_motorDirection setSelected:YES forSegment:0];
            [_inputPWMPolarity setSelected:YES forSegment:0];
            [_beepStrength setIntegerValue:40];
            [_beaconStrength setIntegerValue:80];
            [_beaconDelay setState:NSOnState];
            [_beaconDelaySelect setSelected:YES forSegment:3];
            [_pwmDither setState:NSOnState];
            [_pwmDitherSelect setSelected:YES forSegment:1];
            break;
    }
}
- (IBAction)writeButtonClicked:(id)sender {
    NSString *response = @"";
    
    [self sendCommand:@"r"];
    response = [self readLine];
    
    [self sendCommand:@"i"];
    response = [self readLine];
    
    [self sendCommand:@"d"];
    response = [self readLine];
    
    // Erase flash page
    [self sendCommand:@"p0D"];
    response = [self readLine];
    
    NSString* stringValue;
    int intValue;
    
    // ########################
    // Eeprom Layout
    {
        stringValue = [NSString stringWithFormat:@"%02X", eepromLayout];
        [self writeStringToAdress:ADRESS_EEPROM_LAYOUT :SIZE_EEPROM_LAYOUT :stringValue];
    }
    
    // ########################
    // Version
    {
        stringValue = [_version stringValue];
        NSArray *components = [stringValue componentsSeparatedByString:@"."];
        stringValue = [NSString stringWithFormat:@"%02lX", (long)[[[components objectAtIndex:0] substringFromIndex:1] integerValue]];
        [self writeStringToAdress:ADRESS_MAIN_VERSION :SIZE_MAIN_VERSION :stringValue];
        stringValue = [NSString stringWithFormat:@"%02lX", (long)[[components objectAtIndex:1] integerValue]];
        [self writeStringToAdress:ADRESS_SUB_VERSION :SIZE_SUB_VERSION :stringValue];
    }
    
    // ########################
    // BESC
    {
        stringValue = [self stringToHexString:[_BESC stringValue]];
        [self writeStringToAdress:ADRESS_BESC :SIZE_BESC :stringValue];
    }
    
    // ########################
    // MCU
    {
        stringValue = [self stringToHexString:[_MCU stringValue]];
        [self writeStringToAdress:ADRESS_MCU :SIZE_MCU :stringValue];
    }
    
    // ########################
    // Name
    {
        stringValue = [_name stringValue];
        unsigned long length = [stringValue length];
        if (length > 16) {
            stringValue = [stringValue substringToIndex:15];
        } else if (length < 16) {
            for (int i = 0; i < 16 - length; i++) {
                stringValue = [stringValue stringByAppendingString:@" "];
            }
        }
        stringValue = [self stringToHexString:stringValue];
        [self writeStringToAdress:ADRESS_NAME :SIZE_NAME :stringValue];
    }
    
    // ########################
    // Mode
    {
        intValue = (int)[_mode selectedSegment];
        switch (mode) {
            case MODE_MAIN:
                stringValue = @"A55A";
                break;
            case MODE_TAIL:
                stringValue = @"5AA5";
                break;
            case MODE_MULTI:
                stringValue = @"55AA";
                break;
            default:
                stringValue = @"A55A";
                break;
        }
        [self writeStringToAdress:ADRESS_MODE :SIZE_MODE :stringValue];
    }
    
    // ########################
    // P-Gain
    {
        if ([_pGain isEnabled]) {
            intValue = (int)[_pGain doubleValue];
            [self writeIntegerToAdress:ADRESS_P_GAIN :SIZE_P_GAIN :intValue];
        }
    }
    
    // ########################
    // I-Gain
    {
        if ([_iGain isEnabled]) {
            intValue = (int)[_iGain doubleValue];
            [self writeIntegerToAdress:ADRESS_I_GAIN :SIZE_I_GAIN :intValue];
        }
    }
    
    // ########################
    // Governor mode / closed loop mode
    {
        if ([_governorMode isEnabled]) {
            if (mode == MODE_MAIN) {
                if ([_governorMode state] == NSOnState) {
                    intValue = (int)[_governorModeSelect selectedSegment] + 1;
                } else {
                    intValue = 1;
                }
            } else if (mode == MODE_MULTI) {
                if ([_governorMode state] == NSOnState) {
                    intValue = (int)[_governorModeSelect selectedSegment] + 1;
                } else {
                    intValue = 4;
                }
            } else {
                intValue = 0xFF;
            }
            [self writeIntegerToAdress:ADRESS_GOVERNOR_MODE :SIZE_GOVERNOR_MODE :intValue];
        }
    }
    
    // ########################
    // Low voltage limit
    {
        if ([_lowVoltageLimitSelect isEnabled]) {
            if (mode == MODE_MAIN) {
                if ([_lowVoltageLimit state] == NSOnState) {
                    intValue = (int)[_lowVoltageLimitSelect selectedSegment]+1;
                } else {
                    intValue = 1;
                }
                [self writeIntegerToAdress:ADRESS_LOW_VOLTAGE_LIMIT :SIZE_LOW_VOLTAGE_LIMT :intValue];
            }
        }
    }
    
    // ########################
    // Gain
    {
        if ([_gain isEnabled]) {
            switch (mode) {
                case MODE_MAIN:
                    intValue = 0xFF;
                    break;
                case MODE_TAIL:
                case MODE_MULTI:
                    intValue = (int)[_gain doubleValue];
                    break;
            }
            [self writeIntegerToAdress:ADRESS_GAIN :SIZE_GAIN :intValue];
        }
    }
    
    // ########################
    // Motor idle speed
    {
        NSLog(@"FIXME Write to: motor idle speed");
    }
    
    // ########################
    // Startup power
    {
        if ([_startupPower isEnabled]) {
            intValue = (int)[_startupPower doubleValue];
            [self writeIntegerToAdress:ADRESS_STARTUP_POWER :SIZE_STARTUP_POWER :intValue];
        }
    }
    
    // ########################
    // PWM Frequency
    {
        if ([_PWMFrequency isEnabled]) {
            intValue = (int)[_PWMFrequency selectedSegment] + 1;
            [self writeIntegerToAdress:ADRESS_PWM_FREQUENCY :SIZE_PWM_FREQUENCY :intValue];
        }
    }
    
    // ########################
    // Motor direction
    {
        if ([_motorDirection isEnabled]) {
            intValue = (int)[_motorDirection selectedSegment] + 1;
            [self writeIntegerToAdress:ADRESS_MOTOR_DIRECTION :SIZE_MOTOR_DIRECTION :intValue];
        }
    }
    
    // ########################
    // input PWM polarity
    {
        if ([_inputPWMPolarity isEnabled]) {
            intValue = (int)[_inputPWMPolarity selectedSegment] + 1;
            [self writeIntegerToAdress:ADRESS_INPUT_PWM_POLARITY  :SIZE_INPUT_PWM_POLARITY :intValue];
        }
    }
    
    // ########################
    // Programming by TX
    {
        if ([_programmingByTX isEnabled]) {
            if ([_programmingByTX state] == NSOnState) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_PROGRAMMING_BY_TX :SIZE_PROGRAMMING_BY_TX :intValue];
        }
    }
    
    // ########################
    // Rearm at start
    {
        if ([_rearmingEveryStart isEnabled]) {
            if ([_rearmingEveryStart state] == NSOnState) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_REARM_AT_START :SIZE_REARM_AT_START :intValue];
        }
    }
    
    // ########################
    // Governor setup target
    {
        NSLog(@"FIXME Write to:governor setup target");
    }
    
    // ########################
    // Startup RPM
    {
        NSLog(@"FIXME Write to: startup rpm");
    }
    
    // ########################
    // Startup Acceleration
    {
        NSLog(@"FIXME Write to: startup acceleration");
    }
    
    // ########################
    // Volt comp
    {
        NSLog(@"FIXME Write to: volt comp");
    }
    
    // ########################
    // Commutation timing
    {
        if ([_commutationTiming isEnabled]) {
            intValue = (int)[_commutationTiming selectedSegment] + 1;
            [self writeIntegerToAdress:ADRESS_COMMUTATION_TIMING :SIZE_COMMUTATION_TIMING :intValue];
        }
    }
    
    // ########################
    // Damping force
    {
        NSLog(@"FIXME Write to: damping force");
    }
    
    // ########################
    // Governor range
    {
        if ([_governorRange isEnabled]) {
            if (mode == MODE_MAIN) {
                intValue = (int)[_governorRange selectedSegment] - 1;
                [self writeIntegerToAdress:ADRESS_GOVERNOR_RANGE :SIZE_GOVERNOR_RANGE :intValue];
            }
        }
    }
    
    // ########################
    // Startup method
    {
        NSLog(@"FIXME Write to: startup method");
    }
    
    // ########################
    // min. throttle
    {
        if ([_throttleMin isEnabled]) {
            intValue = ((int)[_throttleMin integerValue]-1000)/4;
            [self writeIntegerToAdress:ADRESS_MIN_THROTTLE :SIZE_MIN_THROTTLE :intValue];
        }
    }
    
    // ########################
    // max. throttle
    {
        if ([_throttleMax isEnabled]) {
            intValue = ((int)[_throttleMax integerValue]-1000)/4;
            [self writeIntegerToAdress:ADRESS_MAX_THROTTLE :SIZE_MAX_THROTTLE :intValue];
        }
    }
    
    // ########################
    // beep strength
    {
        if ([_beepStrength isEnabled]) {
            intValue = (int)[_beepStrength integerValue];
            [self writeIntegerToAdress:ADRESS_BEEP_STRENGTH :SIZE_BEEP_STRENGTH :intValue];
        }
    }
    
    // ########################
    // beacon strength
    {
        if ([_beaconStrength isEnabled]) {
            intValue = (int)[_beaconStrength integerValue];
            [self writeIntegerToAdress:ADRESS_BEACON_STRENGTH :SIZE_BEACON_STRENGTH :intValue];
        }
    }
    
    // ########################
    // beacon delay
    {
        if ([_beaconDelay isEnabled]) {
            if ([_beaconDelay state] == NSOffState) {
                intValue = 5;
            } else {
                intValue = (int)[_beaconDelaySelect selectedSegment]+1;
            }
            [self writeIntegerToAdress:ADRESS_BEACON_DELAY :SIZE_BEACON_DELAY :intValue];
        }
    }
    
    // ########################
    // throttle rate
    {
        if ([_throttleRate isEnabled]) {
            intValue = (int)[_throttleRate doubleValue];
            [self writeIntegerToAdress:ADRESS_THROTTLE_RATE :SIZE_THROTTLE_RATE :intValue];
        }
    }
    
    // ########################
    // demag compensation
    {
        if ([_demagCompensation isEnabled]) {
            if ([_demagCompensation state] == NSOnState) {
                intValue = (int)[_demagCompensationSelect selectedSegment] + 2;
            } else {
                intValue = 1;
            }
            [self writeIntegerToAdress:ADRESS_DEMAG_COMPENSATION :SIZE_DEMAG_COMPENSATION :intValue];
        }
    }
    
    // ########################
    // BEC Voltage
    {
        if ([_BECVoltage isEnabled]) {
            if ([_BECVoltage selectedSegment] == 1) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_BEC_VOLTAGE :SIZE_BEC_VOLTAGE :intValue];
        }
    }
    
    // ########################
    // Center throttle
    {
        if ([_centerThrottle isEnabled]) {
            intValue = ((int)[_centerThrottle integerValue]-1000)/4;
            [self writeIntegerToAdress:ADRESS_CENTER_THROTTLE :SIZE_CENTER_THROTTLE :intValue];
        }
    }
    
    // ########################
    // Spoolup time
    {
        NSLog(@"FIXME Write to: Spoolup time");
    }
    
    // ########################
    // temperature protection
    {
        if ([_thermalProtection isEnabled]) {
            if ([_thermalProtection state] == NSOnState) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_TEMPERATURE_PROTECTION :SIZE_TEMPERATURE_PROTECTION :intValue];
        }
    }
    
    // ########################
    // low rpm power protection
    {
        if ([_lowRPMPowerProtection isEnabled]) {
            if ([_lowRPMPowerProtection state] == NSOnState) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_LOW_RPM_POWER_PROTECTION :SIZE_LOW_RPM_POWER_PROTECTION :intValue];
        }
    }

    // ########################
    // pwm input
    {
        if ([_pwmInput isEnabled]) {
            if ([_pwmInput state] == NSOnState) {
                intValue = 1;
            } else {
                intValue = 0;
            }
            [self writeIntegerToAdress:ADRESS_PWM_INPUT :SIZE_PWM_INPUT :intValue];
        }
    }

    // ########################
    // PWM Dither
    {
        if ([_pwmDither isEnabled]) {
            if ([_pwmDither state] == NSOnState) {
                intValue = (int)[_pwmDitherSelect selectedSegment] + 2;
            } else {
                intValue = 1;
            }
            [self writeIntegerToAdress:ADRESS_PWM_DITHER :SIZE_PWM_DITHER :intValue];
        }
    }
}
- (IBAction)selectButtonClicked:(id)sender {
    if (sender==_governorMode) {
        if ([_governorMode state]==NSOnState) {
            if (mode == MODE_MAIN) {
                [_governorModeSelect setSelected:YES forSegment:0];
            } else if (mode == MODE_MULTI) {
                [_governorModeSelect setSelectedSegment:-1];
            }
        } else {
            [_governorModeSelect setSelectedSegment:-1];
        }
    } else if (sender==_lowVoltageLimit) {
        if ([_lowVoltageLimit state]==NSOnState) {
            if (mode == MODE_MAIN) {
                [_lowVoltageLimitSelect setSelected:YES forSegment:2];
            }
        } else {
        }
    } else if (sender==_demagCompensation) {
        if ([_demagCompensation state]==NSOnState) {
            if (mode == MODE_MAIN || mode == MODE_TAIL) {
                [_demagCompensationSelect setSelectedSegment:-1];
            } else {
                [_demagCompensationSelect setSelected:YES forSegment:0];
            }
        } else {
        }
    } else if (sender==_pwmDither) {
        if ([_pwmDither state]==NSOnState) {
            if (mode == MODE_MAIN || mode == MODE_TAIL) {
                [_pwmDitherSelect setSelected:YES forSegment:1];
            } else {
                [_pwmDitherSelect setSelectedSegment:-1];
            }
        } else {
        }
    } else if (sender==_beaconDelay) {
        if ([_beaconDelay state]==NSOnState) {
            if (mode == MODE_MAIN) {
                [_beaconDelaySelect setSelected:YES forSegment:0];
            } else if (mode == MODE_MULTI) {
                [_beaconDelaySelect setSelectedSegment:-1];
            }
        } else {
        }
    }

}

- (NSString*)connect:(NSString*)toPath :(speed_t)withBaudRate {
    int success;
    
    // close the port if it is already open
    if (_serialFileDescriptor != -1) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
        
        // re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
        sleep(0.5);
    }
    
    // c-string path to serial-port file
    const char *bsdPath = [toPath cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Hold the original termios attributes we are setting
    struct termios options;
    
    // receive latency ( in microseconds )
    unsigned long mics = 3;
    
    // error message string
    NSString *errorMessage = nil;
    
    // open the port
    // O_NONBLOCK causes the port to open without any delay (we'll block with another call)
    _serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
    
    if (_serialFileDescriptor == -1) {
        // check if the port opened correctly
        errorMessage = @"Error: couldn't open serial port";
    } else {
        // TIOCEXCL causes blocking of non-root processes on this serial-port
        success = ioctl(_serialFileDescriptor, TIOCEXCL);
        if ( success == -1) {
            errorMessage = @"Error: couldn't obtain lock on serial port";
        } else {
            success = fcntl(_serialFileDescriptor, F_SETFL, 0);
            if ( success == -1) {
                // clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
                errorMessage = @"Error: couldn't obtain lock on serial port";
            } else {
                // Get the current options and save them so we can restore the default settings later.
                success = tcgetattr(_serialFileDescriptor, &_gOriginalTTYAttrs);
                if ( success == -1) {
                    errorMessage = @"Error: couldn't get serial attributes";
                } else {
                    // copy the old termios settings into the current
                    //   you want to do this so that you get all the control characters assigned
                    options = _gOriginalTTYAttrs;
                    
                    /*
                     cfmakeraw(&options) is equivilent to:
                     options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
                     options->c_oflag &= ~OPOST;
                     options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
                     options->c_cflag &= ~(CSIZE | PARENB);
                     options->c_cflag |= CS8;
                     */
                    cfmakeraw(&options);
                    
                    // set tty attributes (raw-mode in this case)
                    success = tcsetattr(_serialFileDescriptor, TCSANOW, &options);
                    if ( success == -1) {
                        errorMessage = @"Error: coudln't set serial attributes";
                    } else {
                        // Set baud rate (any arbitrary baud rate can be set this way)
                        success = ioctl(_serialFileDescriptor, IOSSIOSPEED, &withBaudRate);
                        if ( success == -1) {
                            errorMessage = @"Error: Baud Rate out of bounds";
                        } else {
                            // Set the receive latency (a.k.a. don't wait to buffer data)
                            success = ioctl(_serialFileDescriptor, IOSSDATALAT, &mics);
                            if ( success == -1) {
                                errorMessage = @"Error: coudln't set serial latency";
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // make sure the port is closed if a problem happens
    if ((_serialFileDescriptor != -1) && (errorMessage != nil)) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
    } else {
        // connection up an idle
    }
    
    return errorMessage;
}
- (void)disconnect {
    close(_serialFileDescriptor);
    _serialFileDescriptor = -1;
}
- (void)writeString:(NSString *)str {
    if(_serialFileDescriptor!=-1) {
        write(_serialFileDescriptor, [str cStringUsingEncoding:NSUTF8StringEncoding], [str length]);
    }
}
- (void)writeByte:(uint8_t *)val {
    if(_serialFileDescriptor!=-1) {
        write(_serialFileDescriptor, val, 1);
    }
}
- (void)sendCommand:(NSString*)command {
    [self writeString:command];
}
- (NSString*)readLine {
    const int BUFFER_SIZE = 1;
    char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
    ssize_t numBytes=0; // number of bytes read during read
    NSString *text; // incoming text from the serial port
    NSString *inputBuffer = @"";
    
    while (![text hasSuffix:@">"]) {
        // read() blocks until some data is available or the port is closed
        numBytes = read(_serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
        
        if(numBytes>0) {
            // create an NSString from the incoming bytes (the bytes aren't null terminated)
            text = [NSString stringWithCString:byte_buffer length:numBytes];
            inputBuffer = [inputBuffer stringByAppendingString:text];
        }
    }
    return [inputBuffer substringToIndex:[inputBuffer length]-2];
}
- (NSString*)readFromAdress:(long)adress :(int)size {
    return [self readValue:[NSString stringWithFormat:@"%02X%04lX", size, adress]];
}
- (NSString*)readValue:(NSString*)key {
    NSString *response = @"";
    
    [self sendCommand:[NSString stringWithFormat:@"br%@", key]];
    response = [self readLine];
    //NSLog(@"%@", response);
    if ([response length] > [key length]+2) {
        return [response substringFromIndex:[key length]+4];
    }
    
    return @"error";
}
- (NSString*)writeStringToAdress:(long)adress :(int)size :(NSString*)string {
/*
    NSString *read = [self readFromAdress:adress :size];
    if ([read isEqualToString:string]) {
        NSLog(@"OK      Read: >%@< Write: >%@<", read, string);
    } else {
        NSLog(@"FAILURE Read: >%@< Write: >%@< ####################", read, string);
    }
    return @"";
 */
    return [self writeValue:[NSString stringWithFormat:@"%02X%04lX", size, adress] :string];
}
- (NSString*)writeIntegerToAdress:(long)adress :(int)size :(int)integer {
    return [self writeStringToAdress:adress :size :[NSString stringWithFormat:@"%02X", integer]];
}
- (NSString*)writeValue:(NSString*)key :(NSString*)value {
    NSString *response = @"";
    
   [self sendCommand:[NSString stringWithFormat:@"bw%@%@", key, value]];
    
    response = [self readLine];
    
    return response;
}
- (unsigned int)intFromHexString:(NSString*)hexStr {
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
- (NSString*)stringFromHexString:(NSString*)hexStr {
    NSString* returnValue = @"";
    for (int i = 0; i < [hexStr length]/2; i++) {
        NSString* currentValue = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
        returnValue = [returnValue stringByAppendingString:[NSString stringWithFormat:@"%c", [self intFromHexString:currentValue]]];
    }
    return returnValue;
}
- (NSString*)stringToHexString:(NSString*)string {
    NSString* returnValue = @"";
    
    for (int i = 0; i < [string length]; i++) {
        int asciiCode = [[string substringWithRange:NSMakeRange(i, 1)] characterAtIndex:0];
        returnValue = [returnValue stringByAppendingString:[NSString stringWithFormat:@"%02X", asciiCode]];
    }
    
    return returnValue;
}

@end
