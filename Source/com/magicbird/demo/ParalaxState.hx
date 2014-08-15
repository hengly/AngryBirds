package com.magicbird.demo;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.magicbird.objects.MagicSprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.magicbird.view.spriteview.SpriteView;
import com.eclecticdesignstudio.motion.easing.Linear;

class ParalaxState extends DemoState
{
	public function new() 
	{
		super();
	}
		
	override public function initialize()
	{
		super.initialize();
		
		var crates = new Array<MagicSprite>();
		for (i in 0...10)
		{
			var crate = new MagicSprite("crate" + i, { x : i * 100, y : 30, view : "assets/crate.png",
				group : 1, parallax : i / 10.0 } );
				
			add(crate);
		}
		
		
		var background = new MagicSprite("background", { x : 0, y : 0, view : "assets/background.jpg", group : 0 } );
		add(background);
		
		var viewroot = cast(view, SpriteView).viewRoot;
		var tween = Actuate.tween(viewroot, 4, { x : -200 } );
		tween.ease(Linear.easeNone);
		tween.onComplete(reverse);
	}
	
	
	private function reverse()
	{
		Actuate.reset();
		if (view == null)
		{
			return;
		}
		var viewroot = cast(view, SpriteView).viewRoot;
		var dest = viewroot.x == 0 ? -200 : 0;
		var tween = Actuate.tween(viewroot, 4, { x : dest } );
		tween.ease(Linear.easeNone);
		tween.onComplete(reverse);
	}
}