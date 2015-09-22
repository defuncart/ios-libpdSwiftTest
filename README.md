# ios-libpdSwiftTest

<p><b>Requirements</b><br>OSX running 10.10.5 or later and Xcode 7<br>Basic Pure Data and Swift knowledge<br></p><p><b>Step 1</b></p><p>Clone the <a href="https://github.com/libpd/pd-for-ios">git hub repository</a> as per Rafael’s detailed instructions <a href="https://www.youtube.com/watch?v=jK5ZaObMvnI&amp;list=PLn3ODBv0ka5jDXKS374IhS95GeXp4sTGt&amp;index=2">here</a>. It actually doesn’t matter where you clone this library to but we will need to know the full path for Step 4.</p><p><b>Step 2</b></p><p>In Xcode 7, create a new single view application using Swift as the default language. Copy <b>pd-for-ios/libpd/libpd.xcodeproj </b>into your project.&nbsp;</p><p>Now go to Build Phases of your project and select <b>libpd-ios</b> as a target dependency and <b>AudioToolbox</b>, <b>AVFoundation</b> and <b>libpd-ios</b> as a linked library.</p><figure data-orig-width="759" data-orig-height="463" class="tmblr-full"><img src="https://41.media.tumblr.com/efb82fce2003f274d96ec205546fc5ae/tumblr_inline_nv2vmcYQZ11raxrd9_540.png" alt="image" data-orig-width="759" data-orig-height="463"></figure><p>Note that, unlike in Xcode 6, <b>libpd-ios.a</b> isn’t highlighted in red (as per <a href="https://www.youtube.com/watch?v=l5GQqCDmBZY&amp;list=PLn3ODBv0ka5jDXKS374IhS95GeXp4sTGt&amp;index=3">Rafael’s video</a>) but nevertheless there is a non-displayed issue that the Objective-c pd headers cannot be located. We’ll solve this in step 4.</p><p>One thing you’ll notice is that there are loads (over 180) warnings from the libpd project. To suppress these warnings, go to build settings of the libpd project and under other warning flags of custom compiler flags, simply add&nbsp;“-w”</p><figure data-orig-width="758" data-orig-height="104" class="tmblr-full"><img src="https://41.media.tumblr.com/c0027b94a1c2af6e512828203aeccbd8/tumblr_inline_nv31hscR4s1raxrd9_540.png" alt="image" data-orig-width="758" data-orig-height="104"></figure><p>Now in the errors and warnings panel, you should be just let with a recommendation from Xcode to update libpd’s project settings (which again is optional).</p><p><b>Step 3</b></p><p>Now lets create a very basic pure data patch. This will be a sine wave oscillator of 440Hz which we can switch on and off, and which can be spatialized from left to right.</p><figure data-orig-width="176" data-orig-height="229"><img src="https://40.media.tumblr.com/2a07b0905e5015576590fba7582cd7f0/tumblr_inline_nv31nxAQcz1raxrd9_540.png" alt="image" data-orig-width="176" data-orig-height="229"></figure><p><b>Step 4</b><br></p><p>Because the pd-for-ios library is wrapped in Objective-C and we wish to write our app using Swift, we need to create a bridge header so that we can access these Objective-C classes in Swift.&nbsp;</p><p>Create a header file named <b>[MyProjectName]-Bridging-Header.h</b></p>
<p><pre><code>#import "PdAudioController.h"
#import "PdBase.h"</code></pre></p>
<p>and&nbsp;go to the build settings of your project and make sure the <i>Objective-C Bridging Header</i> build setting under <i>Swift Compiler - Code Generation</i> has a path to the header (full info in the <a href="https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html">apple docs</a>). Now we can add all our imports to this header.</p><figure data-orig-width="756" data-orig-height="187" class="tmblr-full"><img src="https://41.media.tumblr.com/433629a9f373f0c642e21cff5648d68e/tumblr_inline_nv30uqy6nm1raxrd9_540.png" alt="image" data-orig-width="756" data-orig-height="187"></figure><p>As eluded to in Step 2, the project will still fail to compile cause Xcode cannot find these header files. There are two ways of solving this. Firstly you could update the&nbsp;<b>[MyProjectName]-Bridging-Header.h </b>file to include the actual full path to the headers</p><pre><code>#import "[Path to pd-for-ios]/libpd/objc/PdAudioController.h"</code></pre><p>and so forth, or you can go to build settings of the iOS project and supply a user header search path. This is the full path to pd-for-ios (within quotation marks) and the option recursive selected, or a relative path (as below) from the Xcode project to the pd-for-ios folder.</p><figure data-orig-width="962" data-orig-height="126" class="tmblr-full"><img src="https://41.media.tumblr.com/fb3c6c150238efe75d178024f8856b35/tumblr_inline_nv33ocLarN1raxrd9_540.png" alt="image" data-orig-width="962" data-orig-height="126"></figure><p><b>Step 5</b></p><p>Next thing we want to do is to create our user interface. This consists of a <b>UISwitch</b> to turn the sine wave on and off, and a <b>UISlider</b> to spatialize from left to right. By default, this UISlider returns a float value from 0.0 to 1.0, while UISwitch returns a true/false value.</p><figure data-orig-width="389" data-orig-height="700" class="tmblr-full"><img src="https://41.media.tumblr.com/18cc727018e152b16379a8c7ef9cc16a/tumblr_inline_nv321wPlkQ1raxrd9_540.png" alt="image" data-orig-width="389" data-orig-height="700"></figure><p><b>Step 6</b></p><p>Now we need to use the pd audio engine inside our app, load our pd patch and connect the UI events to our pd patch. In ViewController we define a <b>PdAudioController</b> and initialize this. Once the engine has sucessfully been inialitized, we load our pd file and turn the dsp engine on.</p>
<p><pre><code>class ViewController: UIViewController
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
}</code></pre></p
<p>>Now we can create methods to handle user interaction and send messages back to our pd patch.Add the following methods to ViewController and link them to the ui objects in storyboard.</p><pre><code>@IBAction func onOffSwitchToggled(sender: UISwitch)
{
  PdBase.sendFloat( Float(sender.on), toReceiver: "onOff" )
}
    
@IBAction func crossFadeSliderMoved(sender: UISlider)
{
  PdBase.sendFloat( sender.value, toReceiver: "xFade" )
}
</code></pre><p><b>Step 7</b></p><p>Now lets run the application and see it in all it’s glory! (if you want to run the application on your own device, you need an Apple developers account).
