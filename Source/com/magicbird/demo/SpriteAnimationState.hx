package com.magicbird.demo;
import aze.display.SparrowTilesheet;
import com.magicbird.objects.MagicSprite;
import nme.Assets;
import nme.Lib;
import nme.events.MouseEvent;
import com.magicbird.view.spriteview.SpriteView;
import com.magicbird.view.spriteview.SparrowAnimationSequence;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import nme.display.DisplayObject;

class SpriteAnimationState extends DemoState
{
	public function new() 
	{
		super();
	}	
	
	private var tween : IGenericActuator;
	var sprite : MagicSprite;
	
	var animList : Array<String>;
	var i = 0;
	
	private function onClick(e) { 
		i += 1;
		i %= animList.length;
		sprite.animation = animList[i];
	} 
	
	override public function initialize()
	{
		super.initialize();
		
		var spriteSheet = new SparrowTilesheet(Assets.getBitmapData("assets/heroSparrow.png"),
			Assets.getText("assets/heroSparrow.xml"));
		
		var tilelayer = cast(view, SpriteView).createTileLayer(spriteSheet, "hero");
		var animator = new SparrowAnimationSequence(tilelayer, "idle");
		
		sprite = new MagicSprite("hero", { x : 100, y : 100, view : animator } );
		animList = ["idle", "walk"];
		Lib.stage.addEventListener(MouseEvent.CLICK, onClick);
		
		add(sprite);
		
		tween = Actuate.tween(sprite, 1, { rotation : 360 } ).repeat();
	}
	
	
	override public function destroy()
	{
		super.destroy();
		Lib.stage.removeEventListener(MouseEvent.CLICK, onClick);
		sprite = null;
		tween = null;
	}
}