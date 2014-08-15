package com.magicbird.core;

import com.magicbird.core.MagicEngine;
import com.magicbird.core.MagicObject;
import com.magicbird.core.Input;
import com.magicbird.view.MagicView;
import com.magicbird.view.ISpriteView;
import com.magicbird.view.spriteview.SpriteView;
import com.eclecticdesignstudio.motion.Actuate;
import nme.display.Sprite;


class State extends Sprite {

	public var view(getView, never):MagicView;
	public var editMode(getEditMode, setEditMode) : Bool;
	
	var _ce:MagicEngine;

	private var _objects:Array<MagicObject>;
	private var _view:MagicView;
	private var _input:Input;
	private var _editMode:Bool;
	
	public function new() {

		super();

		_ce = cast MagicEngine.getInstance();

		_objects = new Array<MagicObject>();
	}

	
	public function destroy():Void {

		var n:Int = _objects.length;
		while (n-- > 0) {

			var object:MagicObject = _objects[n];
			object.destroy();
		}

		_objects = [];
		_view.destroy();
		_view = null;
		
		_input = null;
	}
	
	public function getEditMode()
	{
		return _editMode;
	}
	
	public function setEditMode(v : Bool)
	{
		if (_editMode == v)
		{
			return _editMode;
		}
		_editMode = v;
		
		var n:Int = _objects.length;
		while (n-- > 0) {

			var object:MagicObject = _objects[n];
			object.setEditMode(v);
		}
		return _editMode;
	}
	
	public function getView():MagicView {
		return _view;
	}

	
	public function initialize():Void {
		
		_view = createView();
		_input = _ce.input;
	}

		
	public function update(timeDelta:Float):Void {

		var garbage:Array<MagicObject> = [];
		var n:Int = _objects.length;

		for (i in 0...n) {

			var object:MagicObject = _objects[i];
			if (object.kill == true)
				garbage.push(object);
			else
				object.update(timeDelta);
		}

		
		n = garbage.length;

		for (i in 0...n) {

			var garbageObject:MagicObject = garbage[i];
			_objects.splice(Lambda.indexOf(_objects, garbageObject), 1);
			garbageObject.destroy();
			
			if(Std.is(garbageObject, ISpriteView))
			{
				_view.removeArt(cast(garbageObject, ISpriteView));
			}
		}

		
		_input.update();

		
		_view.update();
	}

		
	public function add(object:MagicObject):MagicObject {

		_objects.push(object);
		if (Std.is(object, ISpriteView))
		{
			_view.addArt(cast(object, ISpriteView));	
		}
		if(editMode)
			object.setEditMode(true);
		return object;
	}

	
	public function remove(object:MagicObject):Void {

		object.kill = true;
	}

	
	public function getObjectByName(name:String):MagicObject {

		for (object in _objects) {
			if (object.name == name)
				return object;
		}

		return null;
	}

	
	public function getFirstObjectByType(type:Class<Dynamic>):MagicObject {

		for (object in _objects) {
			if (Std.is(object, type))
				return object;
		}

		return null;
	}

	
	public function getObjectsByType(type:Class<Dynamic>):Array<MagicObject> {

		var objects:Array<MagicObject> = new Array<MagicObject>();
		for (object in _objects) {
			if (Std.is(object, type))
				objects.push(object);
		}

		return objects;
	}

			
	private function createView():MagicView {
		return new SpriteView(this);
	}
}
