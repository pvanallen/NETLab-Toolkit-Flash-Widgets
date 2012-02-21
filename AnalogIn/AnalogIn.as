﻿package { 	import flash.display.MovieClip;	import flash.events.*;	import flash.text.TextField;	import flash.geom.Rectangle;	import net.newecologyofthings.toolkit.*;		/**	 * @author Philip van Allen, vanallen@artcenter.edu, The New Ecology of Things Lab, Art Center College of Design	 * 	 * thanks to the component example by David Barlia david@barliesque.com	 * http://studio.barliesque.com/blog/2008/12/as3-component-custom-ui/	 * which was based on earlier work	 * http://flexion.wordpress.com/2007/06/27/building-flash-cs3-components/	 * 	 */	public class AnalogIn extends WidgetInput { 				// vars		public var theKnob:Knob;		// buttons		public var connectButton:ToggleButton;		public var smoothButton:ToggleButton;		public var easeButton:ToggleButton;		public var invertButton:ToggleButton;				// working variables 		private var knobRectangle:Rectangle;		public var knobRange:int = 100;				// instances of objects on the Flash stage		//		// fields		public var sInput:TextField;		public var sCeiling:TextField;		public var sFloor:TextField;		//public var gRawValueConstrained:TextField;		public var sMax:TextField;		public var sMin:TextField;		public var sOut:TextField;		public var sInstanceName:TextField;		public var sInputSource:TextField;		//public var gPort:TextField;				// buttons		public var connect:MovieClip;		public var smooth:MovieClip;		public var ease:MovieClip;		public var invert:MovieClip;				// objects		public var knob:MovieClip;		public var theLine:MovieClip;				// inherit constructor, so we don't need to create one		//public function AnalogInput(w:Number = NaN, h:Number = NaN) {			//super(w,h);		//} 						// functions				override public function setupAfterLoad( event:Event ): void {			super.setupAfterLoad(event);			// set up the buttons			connectButton = new ToggleButton(connect, this, "connect");			smoothButton = new ToggleButton(smooth, this, "smooth");			easeButton = new ToggleButton(ease, this, "ease");			invertButton = new ToggleButton(invert, this, "invert");									// PARAMETERS			//						// set up the defaults for this widget's parameters			paramsList.push(["connectButton", "off", "button"]);			paramsList.push(["smoothButton", "off", "button"]);			paramsList.push(["easeButton", "off", "button"]);			paramsList.push(["invertButton", "off", "button"]);			paramsList.push(["sMin", "0", "text"]);			paramsList.push(["sMax", "1023", "text"]);			paramsList.push(["sFloor", "0", "text"]);			paramsList.push(["sCeiling", "1023", "text"]);						// set the name used in the parameters XML			paramsXMLname = "AnalogInput_" + this.name;						// go			setupParams();						// set up knob			knobRectangle = new Rectangle(theLine.x,theLine.y,0,100);			theKnob = new Knob(knob, knobRectangle, this);						// put default values in text fields			//gRawValueConstrained.text = "0";			sInput.text = "0";			sOut.text = "0";						inputType = "analog";		}				override public function initControllerConnection() {			if (controller == "make") {				// connect				theConnection.sendData("/service/osc/reader-writer/nlhubconfig/connect " + controllerIP + ":" + controllerPort);				// make sure the input port is not set up as a digital in				theConnection.sendData("/service/osc/reader-writer/analogin/" + controllerInputNum + "/active 0");				theConnection.sendData("/service/osc/reader-writer/digitalin/" + controllerInputNum + "/active 0");				// set up the listen and polling -- /service/osc/reader-writer/nlhubconfig/listen [OSC pattern] [1 | 0] [samples per second]				theConnection.sendData("/service/osc/reader-writer/nlhubconfig/listen /analogin/" + controllerInputNum + "/value 1 " + String(sampleRate));			} else if (controller == "xbee") {				theConnection.sendData("/service/xbee/reader-writer/nlhubconfig/connect " + serialPort + " " + serialBaudXbee);				theConnection.sendData("/service/xbee/reader-writer/" + xbeeRemoteID + "/analogin/" + controllerInputNum + "/value");							} else if (controller == "arduino") {				theConnection.sendData("/service/arduino/reader-writer/nlhubconfig/connect " + serialPort + " " + serialBaudArduinoFirmata);				theConnection.sendData("/service/arduino/reader-writer/analogin/" + controllerInputNum + "/value");			} else super.initControllerConnection();		}				public function knobMove(position:Number): void {			var newRaw = Math.floor(position*(rawScale/knobRange));			//trace("knob: " + position + "," + newRaw);			processRawValue(newRaw, this);		}				override public function draw():void {			super.draw();			//trace("in draw");			if (controller == "inputSource") {				sInputSource.text = inputSource;			} else if (controller == "xbee") {				sInputSource.text = controller + " " + xbeeRemoteID + " " + controllerInputNum;			} else if (controller == "osc") {				sInputSource.text = controller + " " + oscString;			} else {				sInputSource.text = controller + " " + controllerInputNum;			}						sInstanceName.text = this.name;		}				//----------------------------------------------------------		// parameter getter setter functions				private var _easeAmount:Number = 10;				[Inspectable (name = "easeAmount", variable = "easeAmount", type = "Number", defaultValue = 10)]			public function get easeAmount():Number { return _easeAmount; }		public function set easeAmount(value:Number):void {			_easeAmount = value;			//draw();		}		}}