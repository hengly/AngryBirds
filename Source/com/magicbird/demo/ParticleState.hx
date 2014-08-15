package com.magicbird.demo;
import com.magicbird.objects.MagicSprite;
import nme.geom.Rectangle;
import org.flintparticles.twod.emitters.Emitter2D;
import org.flintparticles.common.actions.Age;
import org.flintparticles.common.actions.ColorChange;
import org.flintparticles.common.actions.Fade;
import org.flintparticles.common.actions.ScaleImage;
import org.flintparticles.common.counters.Steady;
import org.flintparticles.common.displayObjects.RadialDot;
import org.flintparticles.common.initializers.Lifetime;
import org.flintparticles.common.initializers.SharedImage;
import org.flintparticles.twod.actions.Accelerate;
import org.flintparticles.twod.actions.LinearDrag;
import org.flintparticles.twod.actions.Move;
import org.flintparticles.twod.actions.RandomDrift;
import org.flintparticles.twod.actions.RotateToDirection;
import org.flintparticles.twod.initializers.Position;
import org.flintparticles.twod.initializers.Velocity;
import org.flintparticles.twod.renderers.BitmapRenderer;
import org.flintparticles.twod.zones.DiscSectorZone;
import org.flintparticles.twod.zones.DiscZone;
import nme.geom.Point;
import nme.display.Sprite;

class ParticleState extends DemoState
{
	public function new() 
	{
		super();
	}
	
	var fire  : Emitter2D;
	var particlerender : BitmapRenderer;
	override public function initialize()
	{
		super.initialize();
		
		fire = new Emitter2D();
		fire.counter = new Steady( 60 );
		fire.addInitializer( new Lifetime( 2, 3 ) );
		fire.addInitializer( new Velocity( new DiscSectorZone( new Point( 0, 0 ), 20, 10, -Math.PI, 0 ) ) );
		fire.addInitializer( new Position( new DiscZone( new Point( 0, 0 ), 3 ) ) );
		var FireBlob:Sprite = new Sprite();
		FireBlob.graphics.beginFill(0xcccccc);
		FireBlob.graphics.drawEllipse(0, 0, 30, 10);
		fire.addInitializer( new SharedImage( FireBlob ) );

		fire.addAction( new Age( ) );
		fire.addAction( new Move( ) );
		fire.addAction( new LinearDrag( 1 ) );
		fire.addAction( new Accelerate( 0, -40 ) );
		fire.addAction( new ColorChange( 0xFFFFCC00, 0x00CC0000 ) );
		fire.addAction( new ScaleImage( 1, 1.5 ) );
		fire.addAction( new RotateToDirection() );
		
		fire.start();
		
		particlerender = new BitmapRenderer(new Rectangle(-200, -200, 400, 400));
		particlerender.addEmitter(fire);
		
		var sprite = new MagicSprite("smoke", { x : 300, y : 300, view : particlerender } );
		add(sprite);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		fire = null;
		particlerender = null;
	}
}