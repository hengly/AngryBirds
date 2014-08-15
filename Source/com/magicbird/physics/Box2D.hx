package com.magicbird.physics;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;

import com.magicbird.core.MagicEngine;
import com.magicbird.core.MagicObject;
import com.magicbird.physics.ContactListener;
import com.magicbird.view.ISpriteView;
import com.magicbird.view.spriteview.Box2DDebugArt;

import nme.display.Sprite;


class Box2D extends MagicObject, implements ISpriteView {

	public var world(getWorld, never):B2World;
	public var scale(getScale, never):Int;
	public var gravity(getGravity, setGravity):B2Vec2;

	public var x(getX, never):Float;
	public var y(getY, never):Float;
	public var parallax(getParallax, never):Float;
	public var rotation(getRotation, never):Float;
	public var group(getGroup, setGroup):Int;
	public var visible(getVisible, setVisible):Bool;
	public var view(getView, never):Dynamic;
	public var animation(getAnimation, never):String;
	public var inverted(getInverted, never):Bool;
	public var offsetX(getOffsetX, never):Float;
	public var offsetY(getOffsetY, never):Float;
	public var registration(getRegistration, never):String;

	private var _contactListener:ContactListener;

	var _world:B2World;
	var _scale:Int;
	var _gravity:B2Vec2;

	var _visible:Bool;
	var _group:Int;
	var _view:Dynamic;
	var _editMode : Bool;
	
	public function new(name:String, params:Dynamic = null) {

		_visible = false;
		_group = 1;
		_scale = 30;
		_gravity = new B2Vec2(0, 15);
		_view = Box2DDebugArt;

		super(name, params);

		_world = new B2World(_gravity, true);
		_contactListener = new ContactListener();

		_world.setContactListener(_contactListener);
	}

	override public function destroy():Void {

		super.destroy();
		_world = null;
	}

	override public function update(timeDelta:Float):Void {

		super.update(timeDelta);

		if(!_editMode)
		{
			_world.step(0.05, 8, 8);
			_world.clearForces();
		}
	}

	public function getWorld():B2World {
		return _world;
	}

		
	public function getScale():Int {
		return _scale;
	}

	public function getGravity():B2Vec2 {
		return _gravity;
	}

	public function setGravity(value:B2Vec2):B2Vec2 {
		return _gravity = value;
	}

	public function getX():Float {
		return 0;
	}

	public function getY():Float {
		return 0;
	}

	public function getParallax():Float {
		return 1;
	}

	public function getRotation():Float {
		return 0;
	}

	public function getGroup():Int {
		return _group;
	}

	public function setGroup(value:Int):Int {
		return _group = value;
	}

	public function getVisible():Bool {
		return _visible;
	}

	public function setVisible(value:Bool):Bool {
		return _visible = value;
	}

	public function getView():Dynamic {
		return _view;
	}

	public function getAnimation():String {
		return "";
	}

	public function getInverted():Bool {
		return false;
	}

	public function getOffsetX():Float {
		return 0;
	}

	public function getOffsetY():Float {
		return 0;
	}

	public function getRegistration():String {
		return "topLeft";
	}
	
	public override function setEditMode(v : Bool)
	{
		_editMode = v;
	}
}