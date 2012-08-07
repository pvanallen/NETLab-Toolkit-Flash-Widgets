﻿package net.newecologyofthings.toolkit { 	import adobe.utils.MMExecute;	import flash.display.MovieClip;	import flash.events.*;	import flash.text.TextField;	import flash.display.Sprite;	import flash.geom.Rectangle;	import flash.geom.Point;	import net.newecologyofthings.toolkit.*;		/**	 * @author Philip van Allen, vanallen@artcenter.edu, The New Ecology of Things Lab, Art Center College of Design	 * 	 * thanks to the component example by David Barlia david@barliesque.com	 * http://studio.barliesque.com/blog/2008/12/as3-component-custom-ui/	 * which was based on earlier work	 * http://flexion.wordpress.com/2007/06/27/building-flash-cs3-components/	 * 	 */	public class WidgetBase extends MovieClip	{ 						// vars		private var _width:Number;		private var _height:Number;		public var originalWidth:Number;		public var controlClip:Object;		public var thisWidget:MovieClip;		// params vars		public var paramsList:Array = new Array();		public var paramsXMLname:String;		public var filePath:FilePath;		public var hubPort:int = 51000;		public var deviceType:String = "computer";		public var mobileSetupComplete:Boolean = false;		public var hubDeviceName:String = "";				public function WidgetBase(w:Number = NaN, h:Number = NaN) {			// Store our dimensions in our own variables			// so that when we reset the scale, we still			// know the correct size to draw.  If this instance			// is being dropped onto the stage in the authoring			// environment, then w and h will be NaN, and we'll			// use the default dimensions--defined by the "avatar"			// that's already on-stage.						_width = isNaN(w) ? super.width : w;			_height = isNaN(h) ? super.height : h;						originalWidth = this.width;			//trace(this.name + " " + originalWidth);			//scaleX = scaleY = 1;			//setSize(_width, _height);			//originalWidth = _width;									// set up a key_down listener for the instant widget hide function			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);			// set up to do most of the init tasks on the first enter frame			// because component parameters don't have real values until then			this.addEventListener(Event.ENTER_FRAME,setupAfterLoad); 			return;		} 						// functions				public function setupAfterLoad( event:Event ): void {			this.removeEventListener(Event.ENTER_FRAME, setupAfterLoad);			// set up the current path for the parameters file			thisWidget = this;			filePath = new FilePath(this);						// determine if running on a computer or mobile device			if (filePath.currentOS == "IPHONE" || filePath.currentOS == "IOS"  || filePath.filePrefix == "app:/") deviceType = "mobile";			//trace("deviceType: " + deviceType);			//deviceType = "mobile";			// set up listener so we init the params after the first widget checks the params file and sets up the global			stage.addEventListener(SocketConnectionParams.PARAMSCOMPLETE, initParams);						// set up to listen to a movieClip that can hide all widgets			controlClip = parseNameSpace("mobileControl", parent);			if (controlClip != null && this.name != "mobileControl") {				controlClip.mainButton.addEventListener(MouseEvent.CLICK, handleControlClip);				//controlClip.mainButton.buttonMode = true;				deviceType = "mobile";				mobileSetupComplete = false;			} else {				mobileSetupComplete = true;			}						draw();			// hide ourselves if parameter set			if (invisible) showHideWidget("hide");		} 				public function setupParams(): void {			if (mobileSetupComplete || deviceType != "mobile") {				if (Globals.vars.fileConnection == undefined) { // we must be the first widget starting					// so set up the params socket connection					// set up socket connection and define file location					// initParams() will be run once the file process is completed and a params files is found & loaded, or not found					//trace(name + ": setting up params");					//trace("setting up params" + " " + filePath.filePrefix + " " + filePath.currentOS);					if (deviceType == "mobile") {						// use the remotehubIP since the hub isn't running on the iDevice						trace("connecting to remotehubIP Hub for storing/retrieveing parameters...");						Globals.vars.fileConnection = new SocketConnectionParams(this, filePath.currentDir, filePath.currentFilename, remotehubIP);					} else {						// use the local version of Hub to keep the parameters on our own machine						trace("connecting to localhost Hub for storing/retrieveing parameters...");						Globals.vars.fileConnection = new SocketConnectionParams(this, filePath.currentDir, filePath.currentFilename, "localhost");					}										Globals.vars.fileConnection.openConnection();				} else { // another widget has set up the connection, so just init our params when we get the event					//trace(name + ": params are already set up");					//if (deviceType == "mobile") mobileSetupComplete = false;				}			}		}				public function initParams(event:Event): void {			if (Globals.vars.xmlParams[paramsXMLname].length() == 0) { // an XML node for this widget does not exist, create it and set defaults				defaultParams();			}			//trace(name + ": loading params into widget: " + Globals.vars.xmlParams[this.name].@theValue.toXMLString());						restoreParames();		}				private function defaultParams(): void {			for ( var i:int = 0; i < paramsList.length; i++) {				//trace("in default params: " + i);				// cycle through the paramsList array and use the [name][defaultvalue] pairs to set the defaults				Globals.vars.xmlParams[paramsXMLname].@[paramsList[i][0]] = paramsList[i][1];			}		}				private function restoreParames(): void {			for ( var i:int = 0; i < paramsList.length; i++) {				//trace("in restore params: " + i);				// get the current values from the global XML variable for parameters				this[paramsList[i][0]].text = Globals.vars.xmlParams[paramsXMLname].@[paramsList[i][0]];				// set up all the params objects so they cause the params to be saved anytime they change				this[paramsList[i][0]].addEventListener(Event.CHANGE, getSaveParams);			}						// call routine when done to let widget know parameter values are valid			parametersDone();			if (deviceType == "mobile") mobileSetupComplete = true;		}				private function getSaveParams(event:Event): void {			for ( var i:int = 0; i < paramsList.length; i++) {				// load the values of all the params objects into the global XML variable				Globals.vars.xmlParams[paramsXMLname].@[paramsList[i][0]] = this[paramsList[i][0]].text;			}			// save the XML out to a file			saveParams();		}				private function saveParams(): void {			XML.prettyPrinting = false;			Globals.vars.fileConnection.sendData(Globals.vars.xmlParams.toXMLString());		}				public function parametersDone(): void {			// stub		}				public function parseNameSpace (objectName:String, theParent:Object): Object {				var theObject:Object;			var objectArray:Array;			//return if parsing not necessary			if ( objectName.indexOf('.') == -1 ) {				try {					return theParent[objectName];				} catch (e) {					return(null);				}			}						//make array for looping through			objectArray = objectName.split('.');						//run though members / methods			for (var i:int = 0;i < objectArray.length; i++) {				//trace(objectArray[i]);				try {					theParent = theParent[objectArray[i]];				} catch (e) {					return(null);				}			}						//return object if it is valid			return theParent ;		}				// instant hide handler		// listener funtion		private function keyHandler (event:KeyboardEvent):void {			//trace("keyHandlerfunction: " + event.keyCode);			if (event.keyCode == 220) {				showHideWidget();			}		}				public function handleControlClip (e:MouseEvent):void{			//trace("controlclip was clicked!");						if (mobileSetupComplete) {				showHideWidget();			} else {				//trace(this.name + " setting up params");				remotehubIP = controlClip.ip.text;				//controlClip.mainButton.buttonText.text = "Connected";				mobileSetupComplete = true;				setupParams();			}		}				public function showHideWidget(newState:String = "toggle"):void {						switch (newState) {				case "toggle":					if (this.visible == true) {						this.visible = false;						if (controlClip != null) controlClip.setShow("defaultHide");					} else {						this.visible = true;						if (controlClip != null) controlClip.setShow("full");					}					break;									case "show":					this.visible = true;					break;								case "hide":					this.visible = false;					break;			}		}		public function localToLocal(fr:MovieClip, to:MovieClip):Point {			return to.globalToLocal(fr.localToGlobal(new Point()));		};				public function trim( inputStr : String, extraWhiteSpace : Boolean = true ) : String {			// from http://www.designscripting.com/2008/11/string-utils-in-as3/			var temp : String = inputStr;			var obj : RegExp = /^(\s*)([\W\w]*)(\b\s*$)/;			if ( obj.test(temp) ) 			temp = temp.replace(obj, '$2'); 			if( extraWhiteSpace )			{			   var obj1 : RegExp = / +/g;			   temp = temp.replace( obj1, " " );			   if ( temp == " " ) 			   temp = ""; 			 }		   return temp;		}						//----------------------------------------------------------		// component functions				/**		 * This method is called automatically by the authoring		 * tool whenever the components dimensions are changed.		 */		public function setSize(w:Number, h:Number):void {			_width = w;			_height = h;			draw();		} 				public function draw():void {			// 		}				//----------------------------------------------------------		// parameter getter setter functions				private var _invisible:Boolean = false;		[Inspectable (name = "invisible", variable = "invisible", type = "Boolean", defaultValue = false)]		public function get invisible():Boolean { return _invisible; }		public function set invisible(value:Boolean):void {			_invisible = value;			//draw();		}				private var _remotehubIP:String = "127.0.0.1";		[Inspectable (name = "remotehubIP", variable = "remotehubIP", type = "String", defaultValue = "127.0.0.1")]		public function get remotehubIP():String { return _remotehubIP; }		public function set remotehubIP(value:String):void {			_remotehubIP = value;			//draw();		}			}}