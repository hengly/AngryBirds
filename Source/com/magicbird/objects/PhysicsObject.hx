package com.magicbird.objects;

import box2D.collision.B2Manifold;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2Shape;
import box2D.common.math.B2Mat22;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.contacts.B2Contact;

import com.magicbird.core.MagicEngine;
import com.magicbird.core.MagicObject;
import com.magicbird.physics.Box2D;

import nme.display.MovieClip;
import nme.Lib;

class PhysicsObject extends MagicSprite {
	
	public var radius(getRadius, setRadius):Float;
	public var body(getBody, never):B2Body;

	
	public var gravity:Float;

	var _box2D:Box2D;
	var _bodyDef:B2BodyDef;
	var _body:B2Body;
	var _shape:B2Shape;
	var _fixtureDef:B2FixtureDef;
	var _fixture:B2Fixture;
	var _radius : Float;
	
	public function new(name:String, params:Dynamic = null) {
		_ce = MagicEngine.getInstance();
		
		_box2D = cast(_ce.state.getFirstObjectByType(Box2D), Box2D);
		if (_box2D == null) {
			Lib.trace("Cannot create PhysicsObject when a Box2D object has not been added to the state.");
			return ;
		}
		
		var defaultParams = { width : 1, height : 1, radius : 0, gravity : 1.6,
			registration : "center" };
		
		if (params == null)
		{
			params = {};
		}
		for (param in Reflect.fields(defaultParams))
		{
			if (!Reflect.hasField(params, param))
			{
				Reflect.setProperty(params, param, Reflect.field(defaultParams, param));
			}
		}
		
		super(name, params);
		
		defineBody();
		createBody();
		createShape();
		defineFixture();
		createFixture();
		defineJoint();
		createJoint();
	}

	override public function destroy():Void {

		_body.DestroyFixture(_fixture);
		_box2D.world.destroyBody(_body);

		super.destroy();
	}

	public function handleBeginContact(contact:B2Contact):Void {

	}

	public function handleEndContact(contact:B2Contact):Void {
	}

	public function handleImpulse(contact : B2Contact, impluse : Float){	
	}
	
	
	private function defineBody():Void {

		_bodyDef = new B2BodyDef();
		_bodyDef.type = B2Body.b2_dynamicBody;
		_bodyDef.position.set(_x, _y);
		_bodyDef.angle = _rotation;
	}

		
	private function createBody():Void {

		_body = _box2D.world.createBody(_bodyDef);
		_body.setUserData(this);
		_body.setAngularDamping(0.5);
		_body.setLinearDamping(0.5);
	}

		
	private function createShape():Void {

		if (_radius != 0) {
			_shape = new B2CircleShape();
			_shape.m_radius = _radius / 2;
		} else {
			_shape = new B2PolygonShape();
			cast(_shape, B2PolygonShape).setAsBox(_width / 2, _height / 2);
		}
	}

	
	private function defineFixture():Void {

		_fixtureDef = new B2FixtureDef();
		_fixtureDef.shape = _shape;
		_fixtureDef.density = 1;
		_fixtureDef.friction = 0.6;
		_fixtureDef.restitution = 0.3;
	}

		
	private function createFixture():Void {

		_fixture = _body.createFixture(_fixtureDef);
	}

	
	private function defineJoint():Void {
	}

	
	private function createJoint():Void {
	}

	public override function getX():Float {
		
		if (_body != null)
			return _body.getPosition().x * _box2D.scale;
		else
			return _x * _box2D.scale;
	}

	public override function setX(value:Float):Float {

		_x = value / _box2D.scale;

		if(_body != null) {

			var pos:B2Vec2 = _body.getPosition();
			pos.x = _x;
			_body.setTransform(new B2Transform(pos, B2Mat22.fromAngle(_body.getAngle())));
		}

		return _x;
	}

	public override function getY():Float {
		
		if (_body != null)
			return _body.getPosition().y * _box2D.scale;
		else
			return _y * _box2D.scale;
	}

	public override function setY(value:Float):Float {

		_y = value / _box2D.scale;

		if(_body != null) {

			var pos:B2Vec2 = _body.getPosition();
			pos.y = _y;
			_body.setTransform(new B2Transform(pos, B2Mat22.fromAngle(_body.getAngle())));
		}

		return _y;
	}

	public override function getWidth():Float {
		return _width * _box2D.scale;
	}

	public override function setWidth(value:Float):Float {

		if (_initialized)
			Lib.trace("Warning: You cannot set width on object : " + name + 
			", type : " + this + ", after it has been created . Please set it in the constructor.");

		return _width = value / _box2D.scale;
	}

	public override function getHeight():Float {
		return _height * _box2D.scale;
	}

	public override function setHeight(value:Float):Float {

		if (_initialized)
			Lib.trace("Warning: You cannot set height on object : " + name + 
			", type : " + this + ", after it has been created . Please set it in the constructor.");

		return _height = value / _box2D.scale;
	}

	public function getRadius():Float {
		return _radius * _box2D.scale;
	}

	public function setRadius(value:Float):Float {

		if (_initialized)
			Lib.trace("Warning: You cannot set radius on object : " + name + 
			", type : " + this + ", after it has been created . Please set it in the constructor.");

		return _radius = value / _box2D.scale;
	}

	public override function getRotation():Float {
		
		if (_body != null)
			return _body.getAngle() * 180 / Math.PI;
		else
			return _rotation * 180 / Math.PI;
	}

	public override function setRotation(value:Float):Float {

		_rotation = value * Math.PI / 180;

		if (_body != null)
			_body.setTransform(new B2Transform(_body.getPosition(), B2Mat22.fromAngle(_rotation)));

		return _rotation;
	}

	public function getBody():B2Body {
		return _body;
	}
}