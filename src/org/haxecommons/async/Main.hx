package org.haxecommons.async;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
 * @author SlavaRa
 */
class Main extends Sprite {
	
	public static function main() {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	var _inited:Bool;
	
	function onAddedToStage(?_) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onStageResize);
		#if ios
		haxe.Timer.delay(initialize, 100); // iOS 6
		#else
		initialize();
		#end
	}
	
	function onStageResize(?_) if (!_inited) initialize();
	
	function initialize() {
		if (_inited) {
			return;
		}
	}
}