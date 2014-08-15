package com.magicbird.core;

import com.magicbird.core.MagicObject;
import com.magicbird.core.Console;
import com.magicbird.core.Input;
import com.magicbird.core.SoundManager;
import com.magicbird.core.State;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

	
class MagicEngine extends Sprite {

	static private var _instance:MagicEngine;

	public var state(getState, setState):State;
	public var playing(getPlaying, setPlaying):Bool;
	public var input(getInput, never):Input;
	public var sound(getSound, never):SoundManager;
	public var console(getConsole, never):Console;

	var _state:State;
	var _newState:State;
	var _stateDisplayIndex:Int;

	var _playing:Bool;

	var _input:Input;
	var _sound:SoundManager;
	var _console:Console;

	var _startTime:Float;
	var _gameTime:Float;
	
	
	public function new() {
		
		super();

		_instance = this;

		_stateDisplayIndex = 0;

		_playing = true;

		_startTime = Date.now().getTime();
		_gameTime = _startTime;

		
		_input = new Input();

		
		_sound = new SoundManager();

		
		_console = new Console();
		_console.addCommand("set", _handleConsoleSetCommand);
		this.addChild(_console);

		this.addEventListener(Event.ENTER_FRAME, _handleEnterFrame);
		this.addEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);
	}

	static public function getInstance():MagicEngine {

		return _instance;
	}

	
	private function _handleEnterFrame(evt:Event):Void {

		
		if (_newState != null) {

			if (_state != null)
			{	
				_state.destroy();
				
				if(contains(_state))
					removeChild(_state);
			}
			_state = _newState;
			_newState = null;

			this.addChildAt(_state, _stateDisplayIndex);

			_state.initialize();
		}

		
		if (_state != null && _playing) {
			
			var nowTime:Float = Date.now().getTime();
			var timeSinceLastFrame:Float = nowTime - _gameTime;
			var timeDelta:Float = timeSinceLastFrame * 0.001;
			_gameTime = nowTime;

			_state.update(timeDelta);
		}
	}

		
	public function getState():State {
		return (_newState != null) ? _newState : _state;
	}
	
		
	public function setState(value:State):State {
		return _newState = value;
	}
	
		
	public function getPlaying():Bool {
		return _playing;
	}

	public function setPlaying(value:Bool):Bool {

		_playing = value;

		if (_playing)
			_gameTime = Date.now().getTime();

		return _playing;
	}

			
	public function getInput():Input {
		return _input;
	}

	
	public function getSound():SoundManager {
		return _sound;
	}

	
	public function getConsole():Console {
		return _console;
	}

	
	private function _handleAddedToStage(evt:Event):Void {

	 	this.removeEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);

	 	Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.addEventListener(Event.DEACTIVATE, _handleStageDeactivated);

		_input.initialize();
	}

	private function _handleStageDeactivated(evt:Event):Void {

		if (_playing) {

	 		_playing = false;
	 		Lib.current.stage.addEventListener(Event.ACTIVATE, _handleStageActivated);
	 	}
	}

	private function _handleStageActivated(evt:Event):Void {

	 	_playing = true;
	 	Lib.current.stage.removeEventListener(Event.ACTIVATE, _handleStageActivated);
	}

	private function _handleConsoleSetCommand(objectName:String, paramName:String, paramValue:String):Void {
		trace('function set exec');
	 	var object:MagicObject = _state.getObjectByName(objectName);

		if (object == null) {

			trace("Warning: There is no object named " + objectName);
	 		return;
	 	}

	 	var value:Dynamic = paramValue;

	 	if (Reflect.hasField(object, paramName)) {
	 		Reflect.setField(object, paramName, value);
	 	} else {
	 		trace("Warning: " + objectName + " has no parameter named " + paramName + ".");
	 	}
	}
}