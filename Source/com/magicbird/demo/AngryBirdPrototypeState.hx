package com.magicbird.demo;

import com.magicbird.objects.MagicSprite;
import com.magicbird.objects.PhysicsObject;
import com.magicbird.core.MagicEngine;
import com.magicbird.physics.Box2D;
import com.magicbird.view.spriteview.SpriteArt;
import com.magicbird.view.spriteview.SpriteView;

import nme.geom.Point;
import nme.Lib;
import nme.events.MouseEvent;
import nme.display.Sprite;

import box2D.common.math.B2Vec2;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;

import com.bit101.components.PushButton;
import com.bit101.components.CheckBox;
import com.bit101.components.Label;
import com.bit101.components.InputText;
import com.bit101.components.Style;
import com.eclecticdesignstudio.motion.Actuate;


class Wall extends PhysicsObject
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
		_fixtureDef.friction = 1;
	}
}


class Bird extends PhysicsObject
{
	public var anchor(getAnchor, setAnchor) : Point;
	public var range(getRange, setRange) : Float;
	
	private var _range : Float;
	private var _anchor : Point;
	private var _offset : Point;
	
	override private function defineFixture()
	{
		super.defineFixture();
		_fixtureDef.friction = 1;
		_fixtureDef.density = 2;
		_fixtureDef.restitution = 0.5;
	}
	
	override public function storeCurrentState() 
	{
		super.storeCurrentState();
		_body.setActive(false);
		Lib.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, false);
	}
	
	public function setAnchor(p : Point) 
	{
		_anchor = p; 
		return _anchor;
	}
	
	public function getAnchor()
	{
		return _anchor;
	}
	
	public function setRange(p : Float) 
	{
		_range = p; 
		return _range;
	}
	
	public function getRange()
	{
		return _range;
	}
	
	public function new(name : String, params : Dynamic)
	{
		super(name, params);
		_body.setActive(false);
		_body.setBullet(true);
		Lib.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, false);
	}
	
	private function onMouseDown(e : MouseEvent)
	{
		var view = MagicEngine.getInstance().getState().getView();
		var viewPoint = view.convertStagePointToViewPoint(new Point(e.stageX, e.stageY));
		
		_offset = new Point(x, y).subtract(viewPoint);
		
		if (_offset.length < radius)
		{
			Lib.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, false);
			Lib.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, false);
		}
	}
	
	override public function destroy()
	{
		super.destroy();
		Lib.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	private function onMouseMove(e : MouseEvent)
	{
		var view = MagicEngine.getInstance().getState().getView();
		var viewPoint = view.convertStagePointToViewPoint(new Point(e.stageX, e.stageY));
		viewPoint = viewPoint.subtract(_offset);
		var diff = viewPoint.subtract(_anchor);
		if (diff.length > range)
		{
			diff.normalize(range);
		}
		viewPoint = _anchor.add(diff);
		x = viewPoint.x;
		y = viewPoint.y;
	}
	
	override public function update(timeDelta:Float):Void 
	{
		super.update(timeDelta);
		if(_offset != null)
		{
			var view = MagicEngine.getInstance().getState().getView();
			if (view == null)
			{
				return;
			}
			var art = cast(view.getArt(this), SpriteArt);
		
			art.graphics.clear();
			art.graphics.lineStyle(5, 0x0ff0000);
			art.graphics.moveTo(0, 0);
			art.graphics.lineTo(_anchor.x - x, _anchor.y - y);
		}
	}
	
	private function onMouseUp(e : MouseEvent)
	{
		Lib.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Lib.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		Lib.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		body.setActive(true);
		var view = cast(MagicEngine.getInstance().getState().getView(), SpriteView);
		var art = cast(view.getArt(this), SpriteArt);
		art.graphics.clear();
		var diff = _anchor.subtract(new Point(x, y));
		body.applyImpulse(new B2Vec2(diff.x, diff.y), body.getPosition());
		_offset = null;
	}
}

class Pig extends PhysicsObject
{
	private var destroying : Bool;
	public function new(name : String, params : Dynamic)
	{
		super(name, params);
		_body.setBullet(true);
	}
	
	public override function handleImpulse(contact : B2Contact, impluse : Float)
	{
		if(impluse > 20 && destroying == false)
		{
			var view = cast(MagicEngine.getInstance().getState().getView(), SpriteView);
			var art = cast(view.getArt(this), SpriteArt);
			destroying = true;
			Actuate.tween(art, 1, { scaleX : 1.3, scaleY : 1.3, alpha : 0} ).onComplete(remove);
		}
	}
	
	private function remove()
	{
		var view = cast(MagicEngine.getInstance().getState().getView(), SpriteView);
		var art = cast(view.getArt(this), SpriteArt);		
		
		Actuate.stop(art, null, false, false);
		if (view != null)
		{
			this.destroy();	
			MagicEngine.getInstance().getState().remove(this);	
		}
	}
}

class AngryBirdPrototypeState extends DemoState
{
	var uiLayer : Sprite;
	var createPig : PushButton ;
	var newPlatform : PushButton;
	var horisontalPlatform : CheckBox;
	var yInput:InputText;
	var xInput:InputText;
	
	var pigIndex : Int;
	var platFormIndex : Int;
	
	public function new() 
	{
		super();
		uiLayer = new Sprite();
		Lib.stage.addChild(uiLayer);
		
		initializeUI();
	}
	
	override public function setEditMode(v:Bool):Dynamic 
	{
		super.setEditMode(v);
		uiLayer.visible = v;
	}
	
	private function initializeUI()
	{
		Style.fontSize = 12;
		Style.embedFonts = false;
		Style.fontName = 'Microsoft YaHei';
		
		createPig = new PushButton(uiLayer, 220, 30, "new pig", 
			onCreatePig);

		newPlatform = new PushButton(uiLayer, 110, 30, "new platform", 
			onNewPlatform);

		horisontalPlatform = new CheckBox(uiLayer, 20, 35, "horizontal");
		horisontalPlatform.selected = false;

		yInput = new InputText(uiLayer, 460, 30, "300");

	    xInput = new InputText(uiLayer, 340, 30, "300");

		var xlabel:Label = new Label(uiLayer, 330, 30, "x");

		var ylabel:Label = new Label(uiLayer, 450, 30, "y");
	}
	
	private function onCreatePig(e : MouseEvent):Void
	{
		add(new Pig("pigqueen" + (platFormIndex++), 
			{ x : 300, y : 174, width : 80, height : 80, view : "assets/pig.png" } ));
	}
	
	private function onNewPlatform(e : MouseEvent):Void
	{
		var stuffView = new Sprite();
		stuffView.graphics.clear();
		stuffView.graphics.beginFill(0x0808080);
		stuffView.graphics.drawRect(0, 0, Std.parseInt(xInput.text), Std.parseInt(yInput.text));
		stuffView.graphics.endFill();
		add(new PhysicsObject("stuff" + (pigIndex++), { x : 300, y : 300, 
			width : stuffView.width, 
			height : stuffView.height, view : stuffView } ));	
	}
	
	private function uninitializeUI()
	{
		createPig.removeEventListener(MouseEvent.CLICK, onCreatePig);
		newPlatform.removeEventListener(MouseEvent.CLICK, onNewPlatform);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		uninitializeUI();
		Lib.stage.removeChild(uiLayer);
	}
	
	override public function initialize():Void 
	{
		super.initialize();
		var box2d = new Box2D("box2d");
		add(box2d);
		
		add(new Wall("bottom", { x : Lib.stage.stageWidth / 2, y : 396, height : 20, 
			width : Lib.stage.stageWidth } ));
		
		add(new Wall("top", { x : Lib.stage.stageWidth / 2, y : 10, height : 20, 
			width : Lib.stage.stageWidth } ));
		
		add(new Wall("left", { x : 10, y : Lib.stage.stageHeight / 2, height : Lib.stage.stageHeight, 
			width : 20 } ));
		
		add(new Wall("right", { x : Lib.stage.stageWidth - 10, 
			y : Lib.stage.stageHeight / 2, 
			height : Lib.stage.stageHeight, 
			width : 20 } ));
		
		add(new MagicSprite("background", { x : 0, y : 0, view : "assets/birdback.jpg" } ));
		
		var anchorPoint = new Point(165, 258);
		
		add(new Bird("Reo", { x : anchorPoint.x, y : anchorPoint.y, 
			radius : 32, view : "assets/bird.png", width : 32, height : 32,
			anchor : anchorPoint, range : 50 } ));
		
		var stuffView = new Sprite();
		stuffView.graphics.clear();
		stuffView.graphics.beginFill(0x0808080);
		stuffView.graphics.drawRect(0, 0, 30, 172);
		stuffView.graphics.endFill();
		add(new PhysicsObject("stuff", { x : 300, y : 300, width : stuffView.width, 
			height : stuffView.height, view : stuffView } ));	
		
		add(new Pig("pigqueen", { x : 300, y : 174, width : 80, height : 80, view : "assets/pig.png" } ));
		
		editMode = true;
	}
}