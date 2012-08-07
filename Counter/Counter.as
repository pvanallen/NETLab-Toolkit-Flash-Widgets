﻿package { 	import flash.display.MovieClip;	import flash.events.*;	import flash.text.TextField;	import net.newecologyofthings.toolkit.*;		/**	 * @author Philip van Allen, vanallen@artcenter.edu, The New Ecology of Things Lab, Art Center College of Design	 * 	 * thanks to the component example by David Barlia david@barliesque.com	 * http://studio.barliesque.com/blog/2008/12/as3-component-custom-ui/	 * which was based on earlier work	 * http://flexion.wordpress.com/2007/06/27/building-flash-cs3-components/	 * 	 */	public class Counter extends Widget { 			// parameters in alphabetized order							// vars		private var lastToggleValue:Number = 0;		private var lastToggleValueDecrement:Number = 0;		private var currentValue:Number = 0;		// buttons						// working variables				// instances of objects on the Flash stage		//		// fields		public var sInputSource:TextField;		public var sInput:TextField;		public var sOut:TextField;		public var sToggleThreshold:TextField;		public var sToggleInc:TextField;		public var sToggleMin:TextField;		public var sToggleMax:TextField;						// buttons				// objects		// inherit constructor, so we don't need to create one		//public function AnalogInput(w:Number = NaN, h:Number = NaN) {			//super(w,h);		//} 						// functions				override public function setupAfterLoad( event:Event ): void {			super.setupAfterLoad(event);						// set up the defaults for this widget's parameters			paramsList.push(["sToggleThreshold", "500", "text"]);			paramsList.push(["sToggleInc", "1", "text"]);			paramsList.push(["sToggleMin", "0", "text"]);			paramsList.push(["sToggleMax", "1", "text"]);						// set the name used in the parameters XML			paramsXMLname = "SoundControl_" + this.name;						// go			setupParams();						// init display text fields			sInput.text = "0";			sOut.text = String(currentValue);						// set up the listener for the input source, and draw a line to it			setUpInputSource();			// set up listener for optional decrement input source			if (inputDecrement != "none") setUpInputSourceOther(inputDecrement,handleInputFeed);			}				override public function handleInputFeed( event:NetFeedEvent ):void {			//trace(this.name + ": " + event.netFeedValue + " " + event.widget.name);						var inputValue:Number = event.netFeedValue;			var threshold = Number(sToggleThreshold.text);			var min = Number(sToggleMin.text);			var max = Number(sToggleMax.text);			var inc = Number(sToggleInc.text);			var lastInputValue:Number;						if (event.widget.name == inputDecrement) {				inputValue *= -1;				lastInputValue = lastToggleValueDecrement;			} else {				lastInputValue = lastToggleValue;			}						sInput.text = String(inputValue);						//trace("newC: " + sensorValue + ", " + counter.gToggleThreshold + ", " + gLastToggleValue);						if (inputValue >= threshold && lastInputValue < threshold) {				currentValue += inc;				//trace("gValue: " + gValue);				if (currentValue > max) {					currentValue = min;				}				if (currentValue<min) {					currentValue = max;				}				sOut.text = String(currentValue);								stage.dispatchEvent(new NetFeedEvent(this.name, 												 true,												 false,												 this,												 currentValue));							} else if ((inputValue * -1) >= threshold && (lastInputValue * -1) < threshold) {				currentValue -= inc;				//trace("gValue: " + gValue);				if (currentValue > max) {					currentValue = min;				}				if (currentValue<min) {					currentValue = max;				}				sOut.text = String(currentValue);								stage.dispatchEvent(new NetFeedEvent(this.name, 												 true,												 false,												 this,												 currentValue));			}									if (event.widget.name == inputDecrement) lastToggleValueDecrement = inputValue;			else lastToggleValue = inputValue;					}				public function setCount(newCount:Number):void {			// restrict values to the min and max			newCount = Math.min(newCount, Number(sToggleMax.text));			newCount = Math.max(newCount, Number(sToggleMin.text));			currentValue = newCount;			sOut.text = String(currentValue);							stage.dispatchEvent(new NetFeedEvent(this.name, 												 true,												 false,												 this,												 currentValue));		}						override public function draw():void {			super.draw();			sInputSource.text = inputSource;					}				//----------------------------------------------------------		// parameter getter setter functions		private var _inputDecrement:String = "none";		[Inspectable (name = "inputDecrement", variable = "inputDecrement", type = "String", defaultValue = "none")]		public function get inputDecrement():String { return _inputDecrement; }		public function set inputDecrement(value:String):void {			_inputDecrement = value;			draw();		}				}}