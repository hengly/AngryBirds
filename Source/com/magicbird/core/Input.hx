package com.magicbird.core;

import nme.events.KeyboardEvent;
import nme.events.TouchEvent;
import nme.Lib;

#if (!js)
import nme.ui.Acceleration;
import nme.ui.Accelerometer;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
#end

class Input 
{
	static inline public var JUST_PRESSED:Int = 0;
	static inline public var DOWN:Int = 1;
	static inline public var JUST_RELEASED:Int = 2;
	static inline public var UP:Int = 3;

	public var enabled(getEnabled, setEnabled):Bool;
	public var jumpTouch(getJumpTouch, null):Bool;
	public var accelerometerXDirection(getAccelerometerXDirection, null):String;

	private var _keys:IntHash<Int>;
	private var _keysReleased:Array<Int>;
	private var _initialized:Bool;

	#if mobile
		private var _acceleration:Acceleration;
	#end

	private var _firstJumpTouch:Bool;

	var _enabled:Bool;
	var _jumpTouch:Bool;
	var _accelerometerXDirection:String;

	public function new() {
#if(!js)
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
#end
		_keys = new IntHash<Int>();
		_keysReleased = new Array<Int>();

		_initialized = false;
		_enabled = true;

		_jumpTouch = _firstJumpTouch = false;
	}

	
	public function initialize():Void {

		if (_initialized)
			return;

		_initialized = true;

		#if (flash || desktop)
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);

		#elseif mobile
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, _touchBegin);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, _touchEnd);

		#end
	}

	
	public function update():Void {

		if (!_enabled)
			return;

		#if mobile

			_acceleration =  Accelerometer.get();

			if (_acceleration != null) {

				#if landscape

					if (_acceleration.y > 0.3)
						_accelerometerXDirection = "right";
					else if (_acceleration.y < -0.3)
						_accelerometerXDirection = "left";
					else
						_accelerometerXDirection = "immobile";

				#elseif portrait 

					if (_acceleration.x > 0.3)
						_accelerometerXDirection = "right";
					else if (_acceleration.x < -0.3)
						_accelerometerXDirection = "left";
					else
						_accelerometerXDirection = "immobile";

				#end
			}

		#elseif (flash || desktop)

			for (key in _keys.keys()) {

				if (_keys.get(key) == JUST_PRESSED) {
					_keys.set(key, DOWN);
				}
			}

			_keysReleased = [];

		#end
	}

	
	public function isDown(keyCode:Int):Bool {
		return _keys.get(keyCode) == DOWN;
	}

	
	 public function justPressed(keyCode:Int):Bool {
	 	return _keys.get(keyCode) == JUST_PRESSED;
	 }

	 
	 public function justReleased(keyCode:Int):Bool {
	 	return Lambda.indexOf(_keysReleased, keyCode) != -1;
	 }

	 
	 public function justJumpTouched():Bool {

		if (_jumpTouch && _firstJumpTouch) {

			_firstJumpTouch = false;
			return true;
		}

		return false;
	}

	
	public function getJumpTouch():Bool {
		return _jumpTouch;
	}

	
	public function getAccelerometerXDirection():String {
		return _accelerometerXDirection;
	}

	private function _onKeyDown(kEvt:KeyboardEvent):Void {

		if (_keys.get(kEvt.keyCode) == null) {
			_keys.set(kEvt.keyCode, JUST_PRESSED);
		}
			
	}

	private function _onKeyUp(kEvt:KeyboardEvent):Void {

		_keys.remove(kEvt.keyCode);
		Lib.trace("key released");
		_keysReleased.push(kEvt.keyCode);
	}

	private function _touchBegin(tEvt:TouchEvent):Void {
		_firstJumpTouch = _jumpTouch = true;
	}

	private function _touchEnd(tEvt:TouchEvent):Void {
		_firstJumpTouch = _jumpTouch = false;
	}

	
	public function getEnabled():Bool {
		return _enabled;
	}

	public function setEnabled(value:Bool):Bool {

		if (_enabled == value)
			return _enabled;

		_enabled = value;

		if (_enabled) {

			#if (flash || desktop)
				Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);

			#elseif mobile
				Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, _touchBegin);
				Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, _touchEnd);
				
			#end

		} else {

			#if (flash || desktop)
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);

			#elseif mobile
				Lib.current.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, _touchBegin);
				Lib.current.stage.removeEventListener(TouchEvent.TOUCH_END, _touchEnd);
				
			#end
		}

		return _enabled;
	}
}