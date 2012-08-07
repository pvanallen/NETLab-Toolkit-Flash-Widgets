﻿package { 	import flash.display.MovieClip;	import flash.events.*;	import flash.errors.IOError; 	import flash.text.TextField;    import flash.net.URLRequest;	import flash.utils.getDefinitionByName;	import flash.utils.Timer;	import flash.geom.Rectangle;	import net.newecologyofthings.toolkit.*;		/**	 * @author Philip van Allen, vanallen@artcenter.edu, The New Ecology of Things Lab, Art Center College of Design	 * 	 * thanks to the component example by David Barlia david@barliesque.com	 * http://studio.barliesque.com/blog/2008/12/as3-component-custom-ui/	 * which was based on earlier work	 * http://flexion.wordpress.com/2007/06/27/building-flash-cs3-components/	 * 	 */	public class MidiOutCtrl extends WidgetOutput { 		// vars				// buttons		public var connectButton:ToggleButton;		public var sendMessageButton:ToggleButton;				// working variables 		private var timerButtonOff:Timer;				// instances of objects on the Flash stage		//		// input fields		public var sMidiChannel:TextField;		public var sMidiCtrl:TextField;		// output fields		public var sInputSource:TextField;		public var sInput:TextField;		public var sOut:TextField;				// buttons		public var connect:MovieClip;		public var sendMessage:MovieClip;				// objects				// inherit constructor, so we don't need to create one		//public function AnalogInput(w:Number = NaN, h:Number = NaN) {			//super(w,h);		//} 						// functions				override public function setupAfterLoad( event:Event ): void {			super.setupAfterLoad(event);						// set up the buttons			connectButton = new ToggleButton(connect, this, "connect");			sendMessageButton = new ToggleButton(sendMessage, this, "sendMessage");			// PARAMETERS			//						// set up the defaults for this widget's parameters			paramsList.push(["connectButton", "off", "button"]);			paramsList.push(["sMidiChannel", "1", "text"]);			paramsList.push(["sMidiCtrl", "7", "text"]);						// set the name used in the parameters XML			paramsXMLname = "MidiOutputCtrl_" + this.name;						// go			setupParams();						// init vars			timerButtonOff = new Timer(100, 1);			timerButtonOff.addEventListener(TimerEvent.TIMER, sendMessageOff);									setUpInputSource();		}						public function initControllerConnection() {			theConnection.sendData("/service/osc/reader-writer/connect " + mediaControlPort + " " + mediaControlIP);			//theConnection.sendData("/service/osc/reader-writer/nlhubconfig/connect " + mediaControlIP + ":" + mediaControlPort + " " + String(mediaControlPort + 1));		}				override public function handleButton(buttonType:String, buttonState:String) {			if (buttonType == "sendMessage") {				if (buttonState == "on") {					sendMidiCtrl(127);				} 			} else super.handleButton(buttonType, buttonState);		}				function sendMessageOff(e:TimerEvent):void{			sendMessageButton.text = "off";		}		override public function handleInputFeed( event:NetFeedEvent ):void {			//trace(this.name + ": " + event.netFeedValue + " " + event.widget.name);						var inputValue = event.netFeedValue;			sendMidiCtrl(inputValue);		}				public function sendMidiCtrl(controllerValue:Number, controllerNum:Number = -1, midiChannel:Number = -1):void {			controllerValue = Math.round(controllerValue);			sInput.text = String(controllerValue);						controllerValue = Math.min(127, controllerValue);			controllerValue = Math.max(0, controllerValue);				if (controllerNum >= 0) sMidiCtrl.text = String(controllerNum);			if (midiChannel >= 0) sMidiChannel.text = String(midiChannel);			sOut.text = String(controllerValue);			sendMessageButton.setState("on");			timerButtonOff.start();						if (connectButton.text == "on" && connectionComplete) { // send midi if we are connected to OSC device				theConnection.sendData("/service/osc/reader-writer/" + mediaControlIP + ":" + mediaControlPort + "/mediacontrol/midiout/ctrl/data " + String(controllerValue) + " " + sMidiCtrl.text + " " + sMidiChannel.text);			}		}				public function connectWidget():void {			tryConnect();			connectButton.setState("on");		}				public function disconnectWidget():void {			disConnect();			connectButton.setState("off");		}				override public function draw():void {			super.draw();			sInputSource.text = inputSource;		}								//----------------------------------------------------------		// parameter getter setter functions				private var _mediaControlIP:String = "127.0.0.1";		[Inspectable (name = "mediaControlIP", variable = "mediaControlIP", type = "String", defaultValue = "127.0.0.1")]		public function get mediaControlIP():String { return _mediaControlIP; }		public function set mediaControlIP(value:String):void {			_mediaControlIP = value;			//draw();		}				private var _mediaControlPort:Number = 51010;		[Inspectable (name = "mediaControlPort", variable = "mediaControlPort", type = "Number", defaultValue = 51010)]		public function get mediaControlPort():Number { return _mediaControlPort; }		public function set mediaControlPort(value:Number):void {			_mediaControlPort = value;			//draw();		}	}}