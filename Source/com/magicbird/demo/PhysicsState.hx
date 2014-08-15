package com.magicbird.demo;
import box2D.common.math.B2Vec2;
import box2D.dynamics.contacts.B2Contact;
import com.magicbird.physics.Box2D;
import nme.Lib;
import nme.events.MouseEvent;
import nme.ui.Keyboard;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import com.magicbird.objects.PhysicsObject;

class Platform extends PhysicsObject
{
	public function new(name:String, params:Dynamic = null) {
		super(name, params);
	}
	
	override private function defineBody(){
		_bodyDef = new B2BodyDef();
		_bodyDef.type = B2Body.b2_staticBody;
		_bodyDef.position.set(_x, _y);
		_bodyDef.angle = _rotation;
	}
	
	override private function defineFixture()
	{
		super.defineFixture();
		_fixtureDef.restitution = 0.8;
		_fixtureDef.friction = 0;
	}
}

class Ball extends PhysicsObject
{
	public function new(name:String, params:Dynamic = null) {
		super(name, params);
	}
	
	
	override private function defineFixture()
	{
		super.defineFixture();
		_fixtureDef.restitution = 0.5;
		_fixtureDef.density = 1.2;
	}
	
	override private function createShape()
	{
		super.createShape();
	}
	
	override public function handleBeginContact(contact:B2Contact)
	{
		var other = cast(contact.getFixtureA().getBody().getUserData(), PhysicsObject);
		if (other == this)
		{
			other = cast(contact.getFixtureB().getBody().getUserData(), PhysicsObject);
		}
		if (Std.is(other, Platform))
		{
			Lib.trace("contact width platform");
		}
	}
}

class PhysicsState extends DemoState
{
	public function new() 
	{
		super();
	}
	
	private var ball : Ball;
	
	override public function initialize()
	{
		super.initialize();
		
		var box2d = new Box2D("box2d");
		add(box2d);
		box2d.setVisible(true);
		
		add(new Platform("bottom", { x : Lib.stage.stageWidth / 2, y : Lib.stage.stageHeight - 10, height : 20, 
			width : Lib.stage.stageWidth } ));
		
		add(new Platform("top", { x : Lib.stage.stageWidth / 2, y : 10, height : 20, 
			width : Lib.stage.stageWidth } ));
		
		add(new Platform("left", { x : 10, y : Lib.stage.stageHeight / 2, height : Lib.stage.stageHeight, 
			width : 20 } ));
		
		add(new Platform("right", { x : Lib.stage.stageWidth - 10, 
			y : Lib.stage.stageHeight / 2, 
			height : Lib.stage.stageHeight, 
			width : 20 } ));
			
		ball = new Ball("ball", { x : 200, y : 200, width : 100, height : 100, radius : 50 } );
		add(ball);
		
	}
	
	override public function update(timeDelta:Float)
	{
		if (_input.justPressed(Keyboard.SPACE))
		{
			var position = ball.body.getPosition();
			ball.body.applyImpulse(new B2Vec2(0, -100), position);	
		}
		super.update(timeDelta);
	}
	
	override public function destroy()
	{
		super.destroy();
		ball = null;
	}
}