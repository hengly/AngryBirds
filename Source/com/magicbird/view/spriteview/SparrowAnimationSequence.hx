package com.magicbird.view.spriteview;

import aze.display.TileClip;
import aze.display.TileLayer;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

class SparrowAnimationSequence extends Sprite, implements IAnimator {

	private var _tilerLayer:TileLayer;
	private var _fps:Int;

	private var _previousTime:Int;

	public function new(tilerLayer:TileLayer, defaultAnimation:String, fps:Int = 30) {

		super();

		_tilerLayer = tilerLayer;
		_fps = fps;

		_tilerLayer.addChild(new TileClip(defaultAnimation, _fps));
		
		this.addChild(_tilerLayer.view);

		_previousTime = Lib.getTimer();

		this.addEventListener(Event.ENTER_FRAME, _update);
	}

	public function destroy():Void {
		_tilerLayer.removeChildAt(0);
		removeChild(_tilerLayer.view);
		removeEventListener(Event.ENTER_FRAME, _update);
		_tilerLayer = null;
	}

	public function changeAnimation(animation:String):Void {

		_tilerLayer.addChild(new TileClip(animation, _fps));
		_tilerLayer.removeChildAt(0);
	}

	private function _update(evt:Event):Void {

		_tilerLayer.render();
	}
}