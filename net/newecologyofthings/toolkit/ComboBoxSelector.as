﻿package net.newecologyofthings.toolkit {		import flash.system.Capabilities;	import flash.display.Sprite;	import flash.display.MovieClip;	import fl.controls.ComboBox; 	import fl.data.DataProvider;	import flash.events.*;		public class ComboBoxSelector extends MovieClip {  		private var _text:String;		private var box:ComboBox;		private var selections:Array;		private var widget:MovieClip;		private var selectionType:String;			  		public function ComboBoxSelector(box:ComboBox, selections:Array, widget:MovieClip, selectionType:String) {		//public function ComboBoxSelector(widget:MovieClip, selectionType:String) {									this.box = box;			this.selections = selections;			this.widget = widget;			this.selectionType = selectionType;			//text = "0";						//aCb.dropdownWidth = 210; 			//selectProperty.width = 75;  			//aCb.move(150, 50); 			//aCb.prompt = "San Francisco Area Universities"; 			box.dataProvider = new DataProvider(selections); 			//text = "height";			box.addEventListener(Event.CHANGE, changeSelection);		}				private function changeSelection(event:Event): void {			//trace("changeSelection");			text = String(ComboBox(event.target).selectedItem.data);			dispatchEvent(new Event(Event.CHANGE));		}				private function searchPropertiesArray(assocArray:Array, search:String): int {			for (var i:int = 0;i<assocArray.length;i++) {				if (assocArray[i]["data"] == search) return i;			}			return -1;		}				public function get text():String { return _text; }		public function set text(value:String):void {			//trace("setting text: " + value);			_text = value;			//if (box.selectedItem.data != value) 			box.selectedIndex = searchPropertiesArray(selections, value);			widget.handleComboBox(selectionType, box);		}	}}