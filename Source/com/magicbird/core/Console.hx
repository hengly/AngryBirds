package com.magicbird.core;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.FocusEvent;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.net.SharedObject;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormat;
import nme.ui.Keyboard;

class Console extends Sprite {
	public var enabled(getEnabled, setEnabled):Bool;
	private var _commandDelegates:Hash<Dynamic>;
	private var _inputField:TextField;
	private var _openKey:Int;
	private var _executeKey:Int;
	private var _showing:Bool;
	var _enabled:Bool;

	public function new() 
	{
		super();

		_commandDelegates = new Hash<Dynamic>();

		_inputField = cast(addChild(new TextField()), TextField);
		_inputField.type = TextFieldType.INPUT;
		_inputField.addEventListener(FocusEvent.FOCUS_OUT, _onConsoleFocusOut);
		_inputField.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF, false, false, false);

		_openKey = Keyboard.TAB;
		_executeKey = Keyboard.ENTER;

		this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);

		this.visible = _showing = _enabled = false;
	}

	public function addCommand(name:String, func:Dynamic):Void 
	{
		_commandDelegates.set(name, func);
	}

	public function hideConsole():Void 
	{
        if (_showing) {

            _showing = this.visible = false;

            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyPressInConsole);
        }
	}

	public function showConsole():Void 
	{   
	    if (!_showing) {
	            
            _showing =  this.visible = true;
           
            Lib.current.stage.focus = _inputField;

            Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyPressInConsole);
	    }
	}

	public function toggleConsole():Void
	{
		_showing ? hideConsole() : showConsole();
	}

	public function clearConsole():Void 
	{
		_inputField.text = "";
	}

	private function _onAddedToStage(evt:Event):Void 
	{

		this.graphics.beginFill(0x000000, 0.8);
		this.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, 30);
		this.graphics.endFill();

		_inputField.width = Lib.current.stage.stageWidth;
		_inputField.y = 4;
		_inputField.x = 4;

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onToggleKeyPress);
	}

	private function _onConsoleFocusOut(fEvt:FocusEvent):Void 
	{
	 	hideConsole();
	}

	private function _onToggleKeyPress(kEvt:KeyboardEvent):Void 
	{
		if (cast(kEvt.keyCode, Int) == _openKey)
			toggleConsole();
	}

	private function _onKeyPressInConsole(kEvt:KeyboardEvent):Void
	{
		if (cast(kEvt.keyCode, Int) == _executeKey) {

			if (_inputField.text == "" || _inputField.text == " ")
				return;

			var args:Array<String> = _inputField.text.split(" ");
			
			var func = _commandDelegates.get(args[0]);
			if (func)
			{
				Reflect.callMethod(null, func, args.slice(1));	
			}
			clearConsole();
			hideConsole();
		}
	}

	public function getEnabled():Bool
	{
		return _enabled;
	}

	public function setEnabled(value:Bool):Bool 
	{
		if (_enabled == value)
			return _enabled;

		_enabled = value;

		if (_enabled) {

			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onToggleKeyPress);

		} else {

			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onToggleKeyPress);
			hideConsole();
		}

		return _enabled;
	}

}