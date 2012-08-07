﻿package { 	import flash.display.MovieClip;	import flash.events.*;	import flash.text.TextField;	import fl.transitions.*;	import fl.transitions.easing.*;	import flash.utils.Timer;	import flash.utils.getTimer;	import flash.net.XMLSocket;	import flash.net.URLLoader;    import flash.net.URLRequest;	import net.newecologyofthings.toolkit.*;		/**	 * @author Philip van Allen, vanallen@artcenter.edu, The New Ecology of Things Lab, Art Center College of Design	 * 	 * thanks to the component example by David Barlia david@barliesque.com	 * http://studio.barliesque.com/blog/2008/12/as3-component-custom-ui/	 * which was based on earlier work	 * http://flexion.wordpress.com/2007/06/27/building-flash-cs3-components/	 * 	 */	public class Envelope extends Widget { 			// vars		private var _insertInput:Function = insertInputInternal;		private var _outputValue:Number = 0;				private var envelope:EnvelopeObj;				private var outputLevelMin:Number = 0;		private var outputLevelMax:Number = 1023;		private var levelRange:Number = outputLevelMax - outputLevelMin;		private var lastLevel:Number;				// instances of objects on the Flash stage		//		// input fields		public var sMinLevel:TextField;		public var sMaxLevel:TextField;		public var sFadeInStart:TextField;		public var sFadeInEnd:TextField;		public var sFadeOutStart:TextField;		public var sFadeOutEnd:TextField;		// output fields		public var sInputSource:TextField;		public var sInputValue:TextField;		public var sOut:TextField;						// buttons			// objects		// inherit constructor, so we don't need to create one		//public function AnalogInput(w:Number = NaN, h:Number = NaN) {			//super(w,h);		//} 						// functions				override public function setupAfterLoad( event:Event ): void {			super.setupAfterLoad(event);						// PARAMETERS			//						// set up the defaults for this widget's parameters			paramsList.push(["sMinLevel", "0", "text"]);			paramsList.push(["sMaxLevel", "1023", "text"]);			paramsList.push(["sFadeInStart", "1", "text"]);			paramsList.push(["sFadeInEnd", "400", "text"]);			paramsList.push(["sFadeOutStart", "800", "text"]);			paramsList.push(["sFadeOutEnd", "1023", "text"]);						// set the name used in the parameters XML			paramsXMLname = "Envelope_" + this.name;						// go			setupParams();									// init display text fields			sInputValue.text = "0";			sOut.text = "0";						// set up the listener for the input source, and draw a line to it			setUpInputSource();			}				override public function handleInputFeed( event:NetFeedEvent ):void {			//trace(this.name + ": " + event.netFeedValue + " " + event.widget.name);						var inputValue:Number = event.netFeedValue;			sInputValue.text = String(inputValue);			var newLevel = envelope.envelopeLevel(inputValue);			insertInput(Math.round(newLevel), this.name);		}				private function envelopeChanged (event:Event):void {			envelope.minLevel = Number(sMinLevel.text);			envelope.maxLevel = Number(sMaxLevel.text);			envelope.fadeInStart = Number(sFadeInStart.text);			envelope.fadeInEnd = Number(sFadeInEnd.text);			envelope.fadeOutStart = Number(sFadeOutStart.text);			envelope.fadeOutEnd = Number(sFadeOutEnd.text);		}				override public function parametersDone(): void {			// set up envelope and watch all the envelope fields			envelope = new EnvelopeObj(Number(sMinLevel.text), Number(sMaxLevel.text), Number(sFadeInStart.text), Number(sFadeInEnd.text), Number(sFadeOutStart.text), Number(sFadeOutEnd.text)); 			sMinLevel.addEventListener(Event.CHANGE, envelopeChanged);			sMaxLevel.addEventListener(Event.CHANGE, envelopeChanged);			sFadeInStart.addEventListener(Event.CHANGE, envelopeChanged);			sFadeInEnd.addEventListener(Event.CHANGE, envelopeChanged);			sFadeOutStart.addEventListener(Event.CHANGE, envelopeChanged);			sFadeOutEnd.addEventListener(Event.CHANGE, envelopeChanged);		}				public function insertInputInternal(inputValue:Number, id:String):void {						insertOutput(inputValue);		}				public function insertOutput(outputValue:Number) {			sOut.text = String(outputValue);			_outputValue = outputValue;			stage.dispatchEvent(new NetFeedEvent(this.name, 												 true,												 false,												 this,												 outputValue));		}				//				override public function draw():void {			super.draw();			sInputSource.text = inputSource;					}				// getter/setters for functions that can be replaced by user		public function set insertInput ( newFunction:Function){			_insertInput = newFunction;		}		public function get insertInput():Function {			return _insertInput;		}				public function set outputValue ( theValue:Number){			_outputValue = theValue;			insertOutput(_outputValue);		}		public function get outputValue():Number {			return _outputValue;		}				//----------------------------------------------------------		// parameter getter setter functions			}}