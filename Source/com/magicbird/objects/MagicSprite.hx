package com.magicbird.objects;

import com.magicbird.core.MagicEngine;
import com.magicbird.core.MagicObject;
import com.magicbird.view.ISpriteView;

import nme.events.MouseEvent;
import nme.display.MovieClip;
import com.eclecticdesignstudio.motion.Actuate;

class MagicSprite extends MagicObject,implements ISpriteView{

	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var width(getWidth, setWidth):Float;
	public var height(getHeight, setHeight):Float;
	public var rotation(getRotation, setRotation):Float;
	public var parallax(getParallax, setParallax):Float;
	public var group(getGroup, setGroup):Int;
	public var visible(getVisible, setVisible):Bool;
	public var view(getView, setView):Dynamic;
	public var animation(getAnimation, setAnimation):String;
	public var inverted(getInverted, setInverted):Bool;
	public var offsetX(getOffsetX, setOffsetX):Float;
	public var offsetY(getOffsetY, setOffsetY):Float;
	public var registration(getRegistration, setRegistration):String;

	var _ce:MagicEngine;

	var _x:Float;
	var _y:Float;
	var _rotation:Float;
	var _width:Float;
	var _height:Float;

	var _parallax:Float;
	var _group:Int;
	var _visible:Bool;
	var _offsetX:Float;
	var _offsetY:Float;

	var _inverted:Bool;
	var _animation:String;
	var _view:Dynamic;
	var _registration:String;
	
	var _params : Dynamic;
	
	var _editModeMgr : EditModeMgr;
	
	public function new(name:String, params:Dynamic = null) {

		_ce = MagicEngine.getInstance();
		
		_x = _y = _rotation = _offsetX = _offsetY = 0;
		_width = _height = 30;

		_group = 0;
		_parallax = 1;
		_visible = true;

		_animation = "";
		_inverted = false;
		_view = MovieClip;
		_registration = "topLeft";

		super(name, params);
		_params = params;
	}
	
	public function storeCurrentState()
	{
		_params = {x : getX(), y : getY(), rotation : getRotation()};
	}

	public function getX():Float {
		return _x;
	}

	public function setX(value:Float):Float {
		return _x = value;
	}

	public function getY():Float {
		return _y;
	}

	public function setY(value:Float):Float {
		return _y = value;
	}

	public function getWidth():Float {
		return _width;
	}

	public function setWidth(value:Float):Float {
		return _width = value;
	}

	public function getHeight():Float {
		return _height;
	}

	public function setHeight(value:Float):Float {
		return _height = value;
	}

	public function getRotation():Float {
		return _rotation;
	}

	public function setRotation(value:Float):Float {
		return _rotation = value;
	}

	public inline function getParallax():Float {
		return _parallax;
	}

	public inline function setParallax(value:Float):Float {
		return _parallax = value;
	}

	public inline function getGroup():Int {
		return _group;
	}

	public inline function setGroup(value:Int):Int {
		return _group = value;
	}

	public inline function getVisible():Bool {
		return _visible;
	}

	public inline function setVisible(value:Bool):Bool {
		return _visible = value;
	}

	public inline function getView():Dynamic {
		return _view;
	}

	public inline function setView(value:Dynamic):Dynamic {
		return _view = value;
	}

	public inline function getAnimation():String {
		return _animation;
	}

	public inline function setAnimation(value:String):String {
		return _animation = value;
	}

	public inline function getInverted():Bool {
		return _inverted;
	}

	public inline function setInverted(value:Bool):Bool {
		return _inverted = value;
	}

	public inline function getOffsetX():Float {
		return _offsetX;
	}

	public inline function setOffsetX(value:Float):Float {
		return _offsetX = value;
	}

	public inline function getOffsetY():Float {
		return _offsetY;
	}

	public inline function setOffsetY(value:Float):Float {
		return _offsetY = value;
	}

	public inline function getRegistration():String {
		return _registration;
	}

	public inline function setRegistration(value:String):String {
		return _registration = value;
	}
	
	override public function destroy():Void 
	{
		if (_editModeMgr != null)
		{
			_editModeMgr.dettach();
		}
		super.destroy();
		Actuate.stop(this, null, false, false);
		_params = null;
	}
	
	public override function setEditMode(v : Bool)
	{
		if (v)
		{
			Actuate.stop(this, null, false, false);
			_editModeMgr = EditModeMgr.attach(this);
			setParams(_params);
		}
		else if(_editModeMgr != null)
		{
			storeCurrentState();
			_editModeMgr.dettach();
			_editModeMgr = null;
		}
	}
}