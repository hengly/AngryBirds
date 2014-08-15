package com.magicbird.demo;
import com.magicbird.core.Input;
import com.magicbird.core.MagicEngine;
import nme.geom.Point;
import nme.ui.Mouse;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.counters.Counter;
import org.flintparticles.twod.emitters.Emitter2D;
import org.flintparticles.common.emitters.Emitter;
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
import org.flintparticles.twod.particles.Particle2D;
import org.flintparticles.common.particles.Particle;
import nme.events.MouseEvent;
import nme.Lib;
import nme.display.Sprite;
import nme.geom.Rectangle;
import com.magicbird.objects.MagicSprite;

class MousePosition implements Counter, extends InitializerBase 
{
	private var prevPos : Point;
	private var newPos : Point;
	private var _running : Bool;
	private var step : Float;
	public function new( step : Float )
	{
		super();
		this.step = step;
		_running = false;
		Lib.stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0);
		Lib.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0);
	}
	
	public function completeGetter():Bool
	{
		return false;
	}
	
	public function runningGetter():Bool
	{
		return _running;
	}
	
	public function stop():Void
	{
		_running = false;
		Lib.stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		Lib.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}

	public function resume():Void
	{
		_running = true;
	}
	
	private function _onMouseDown(e : MouseEvent)
	{
		prevPos = new Point(e.stageX, e.stageY);
		Lib.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0);
		processed = true;
	}
	
	private function _onMouseMove(e : MouseEvent)
	{
		if (processed)
		{
			processed = false;
			if (newPos != null)
			{
				prevPos = newPos;
			}
		}
		newPos = new Point(e.stageX, e.stageY);
	}
	
	private function _onMouseUp(e : MouseEvent)
	{
		newPos = null;
		prevPos = null;
		Lib.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
	}
	
	private var pos : Array<Point>;
	private var index : Int;
	private var processed : Bool;
	
	public function updateEmitter( emitter:Emitter, time:Float ):Int
	{
		pos = new Array<Point>();
		index = 0;
		if (prevPos != null)
		{
			pos.push(prevPos);
			if (newPos != null)
			{
				var diff = newPos.subtract(prevPos);
				var n : Int = Std.int((diff.length + (step - 0.01)) / step);
				
				for ( i in 1...n)
				{
					pos.push(new Point(prevPos.x + ((diff.x * i) / n), prevPos.y + ((diff.y * i) / n)));
				}
			}
		}
		processed = true;
		return pos.length;
	}
	
	public function startEmitter( emitter:Emitter ):Int
	{
		return 0;
	}
	
	override public function initialize( emitter : Emitter, particle : Particle ) : Void
	{
		var p:Particle2D = cast( particle, Particle2D );
		p.x = pos[index].x;
		p.y = pos[index].y;
		index++;
	}
}

class KnifeLightState extends DemoState
{
	public function new() 
	{
		super();
	}
	
	private var fire : Emitter2D;
	private var particlerender : BitmapRenderer;
	private var mousepos : MousePosition;
	override public function initialize()
	{
		super.initialize();
		
		mousepos = new MousePosition(1);
		fire = new Emitter2D();
		fire.counter = mousepos;
		fire.addInitializer( new Lifetime( 0.3, 0.3 ) );
		fire.addInitializer( mousepos );
		var FireBlob:Sprite = new Sprite();
		FireBlob.graphics.beginFill(0x0a5cbd1);
		FireBlob.graphics.drawEllipse(0, 0, 10, 10);
		fire.addInitializer( new SharedImage( FireBlob ) );

		fire.addAction( new Age( ) );
		fire.addAction( new ColorChange( 0xFFFFFFFF, 0x00 ) );
		fire.addAction( new ScaleImage( 1, 0 ) );
		fire.start();
		
		particlerender = new BitmapRenderer(new Rectangle(0, 0, 600, 400));
		particlerender.addEmitter(fire);
		
		var sprite = new MagicSprite("smoke", { x : 0, y : 0, view : particlerender } );
		add(sprite);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		fire = null;
		particlerender = null;
	}
}