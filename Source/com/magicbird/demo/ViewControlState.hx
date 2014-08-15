package com.magicbird.demo;

import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.magicbird.math.MathVector;
import com.magicbird.objects.MagicSprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.magicbird.view.spriteview.SpriteView;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.Lib;
import nme.geom.Rectangle;

class ViewControlState extends DemoState
{
	public function new() 
	{
		super();
	}
	
	override public function initialize() 
	{
		super.initialize();
		
		var bkground = new MagicSprite("background", { x : 0, y : 0, view : "assets/background.jpg" } );
		add(bkground);
		
		var crate = new MagicSprite("crate", { x : 100, y : 100, view : "assets/crate.png" , group : 1} );
		add(crate);
		
		demoViewRootControl();
	}
	
	private function demoViewRootControl()
	{
		var viewroot = cast(view, SpriteView).viewRoot;
		viewroot.x = -100;
		viewroot.y = -100;
		var tween = Actuate.tween (viewroot, 1, { x : 0, y : 0 } );
		tween.ease(Quad.easeOut);
		tween.onComplete(demoViewTarget);
	}
	
	private function demoViewTarget()
	{
		if (view != null)
		{
			var crate = getObjectByName("crate");
			view.setupCamera(crate, new MathVector(100, 100), 
				new Rectangle(0, 0, Lib.stage.stageWidth + 100, Lib.stage.stageHeight + 100),
				new MathVector(0.5, 0.5));
			
			var tween = Actuate.tween(crate, 10, 
				{ x : Lib.stage.stageWidth - 100, y : Lib.stage.stageHeight - 100 } );
		}
	}
}