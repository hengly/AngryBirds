package com.magicbird.demo;

import nme.ui.Keyboard;
import com.magicbird.core.State;
import com.magicbird.core.MagicEngine;

class DemoState extends State
{
	private static var _stateList : Array<DemoState> = new Array<DemoState>();
	
	
	private var _index : Int;
	
	public function new() 
	{
		super();
		_stateList.push(this);
		_index = _stateList.length - 1;
	}
	
	override public function update(timeDelta:Float):Void 
	{
		if (_input.justReleased(Keyboard.RIGHT))
		{
			if(_index < _stateList.length - 1)
			{
				MagicEngine.getInstance().state = _stateList[_index + 1];
			}
		}
		else if (_input.justPressed(Keyboard.LEFT) && _index > 0)
		{
			MagicEngine.getInstance().state = _stateList[_index - 1];
		}
		if (_input.justPressed(Keyboard.E))
		{
			MagicEngine.getInstance().state.editMode = !MagicEngine.getInstance().state.editMode;
		}
		super.update(timeDelta);
		
	}
}