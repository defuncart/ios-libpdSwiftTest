//
//  ViewController.swift
//  pdiOSSwiftTest
//
//  Created by DeFuncApps on 9/22/15.
//  Copyright © 2015 DeFunc Art. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let pd = PdAudioController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let pdInit = pd.configureAmbientWithSampleRate(44100, numberChannels: 2, mixingEnabled: true)
        if pdInit != PdAudioOK
        {
            print( "Error, could not instantiate pd audio engine" )
            return
        }
        
        PdBase.openFile("simpleOsc.pd", path: NSBundle.mainBundle().resourcePath)
        pd.active = true
    }

    // MARK: UI
    
    @IBAction func onOffSwitchToggled(sender: UISwitch)
    {
        PdBase.sendFloat( Float(sender.on), toReceiver: "onOff" )
    }
    
    @IBAction func crossFadeSliderMoved(sender: UISlider)
    {
        PdBase.sendFloat( /*Float(*/sender.value/*)*/, toReceiver: "xFade" )
    }
}

