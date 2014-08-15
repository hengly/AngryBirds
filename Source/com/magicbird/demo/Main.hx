package com.magicbird.demo;

#if(flash)
import com.sociodox.theminer.TheMiner;
#end

import com.magicbird.core.MagicEngine;
import nme.display.FPS;
import nme.Lib;

class Main extends MagicEngine
{
	public function new()
	{
		super();
		
		state = new AngryBirdPrototypeState();
			new KnifeLightState();
			new ParticleState(); 
			new PhysicsState(); 
			new ViewControlState();
			new SpriteAnimationState();
			new ParalaxState();
			
		addChild(new FPS());
		
		#if(flash)
			addChild(new TheMiner());
		#end
	}
	
	public static function main() 
	{
		Lib.current.addChild(new Main());
	}
}