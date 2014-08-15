package com.magicbird.view.spriteview;

import com.eclecticdesignstudio.spritesheet.AnimatedSprite;
import com.eclecticdesignstudio.spritesheet.SpriteSheet;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

class SpriteLoqAnimationSequence extends Sprite, implements IAnimator {

	private var _animatedSprite:AnimatedSprite;

	private var _previousTime:Int;

	public function new(spriteSheet:SpriteSheet, defaultAnimation:String) {

		super();

		_animatedSprite = new AnimatedSprite(spriteSheet);
		_animatedSprite.showBehavior(defaultAnimation);
		_animatedSprite.update(0); 

		this.addChild(_animatedSprite);

		_previousTime = Lib.getTimer();

		this.addEventListener(Event.ENTER_FRAME, _update);
	}

	public function destroy():Void {

		this.removeChild(_animatedSprite);
		this.removeEventListener(Event.ENTER_FRAME, _update);
	}

	public function changeAnimation(animation:String):Void {

		_animatedSprite.showBehavior(animation);
	}

	private function _update(evt:Event):Void {

		var currentTime:Int = Lib.getTimer ();
		var deltaTime:Int = currentTime - _previousTime;

		_animatedSprite.update(deltaTime);

		_previousTime = currentTime;
	}
}