import com.magicbird.demo.Main;
import nme.Assets;
import nme.events.Event;


class ApplicationMain {
	
	static var mPreloader:NMEPreloader;

	public static function main () {
		
		var call_real = true;
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		if (loaded < total || true) /* Always wait for event */ {
			
			call_real = false;
			mPreloader = new NMEPreloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener (nme.events.Event.ENTER_FRAME, onEnter);
			
		}
		
		
		
		haxe.Log.trace = flashTrace;
		

		if (call_real)
			begin ();
	}

	private static function flashTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		var className = pos.className.substr(pos.className.lastIndexOf('.') + 1);
		var message = className+"::"+pos.methodName+":"+pos.lineNumber+": " + v;

        if (flash.external.ExternalInterface.available)
			flash.external.ExternalInterface.call("console.log", message);
		else untyped flash.Boot.__trace(v, pos);
    }
	
	private static function begin () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(com.magicbird.demo.Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (com.magicbird.demo.Main, Reflect.field (com.magicbird.demo.Main, "main"), []);
		}
		else
		{
			nme.Lib.current.addChild(cast (Type.createInstance(com.magicbird.demo.Main, []), nme.display.DisplayObject));	
		}
		
	}

	static function onEnter (_) {
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
			
		}
		
	}

	public static function getAsset (inName:String):Dynamic {
		
		
		if (inName=="assets/background.jpg")
			 
            return Assets.getBitmapData ("assets/background.jpg");
         
		
		if (inName=="assets/baddySparrow.png")
			 
            return Assets.getBitmapData ("assets/baddySparrow.png");
         
		
		if (inName=="assets/baddySparrow.xml")
			 
			 return Assets.getText ("assets/baddySparrow.xml");
         
		
		if (inName=="assets/baddySpriteLoq.png")
			 
            return Assets.getBitmapData ("assets/baddySpriteLoq.png");
         
		
		if (inName=="assets/baddySpriteLoq.xml")
			 
			 return Assets.getText ("assets/baddySpriteLoq.xml");
         
		
		if (inName=="assets/bird.png")
			 
            return Assets.getBitmapData ("assets/bird.png");
         
		
		if (inName=="assets/birdback.jpg")
			 
            return Assets.getBitmapData ("assets/birdback.jpg");
         
		
		if (inName=="assets/collect.wav")
			 
            return Assets.getSound ("assets/collect.wav");
         
		
		if (inName=="assets/crate.png")
			 
            return Assets.getBitmapData ("assets/crate.png");
         
		
		if (inName=="assets/heroSparrow.png")
			 
            return Assets.getBitmapData ("assets/heroSparrow.png");
         
		
		if (inName=="assets/heroSparrow.xml")
			 
			 return Assets.getText ("assets/heroSparrow.xml");
         
		
		if (inName=="assets/heroSpriteLoq.png")
			 
            return Assets.getBitmapData ("assets/heroSpriteLoq.png");
         
		
		if (inName=="assets/heroSpriteLoq.xml")
			 
			 return Assets.getText ("assets/heroSpriteLoq.xml");
         
		
		if (inName=="assets/jewel.png")
			 
            return Assets.getBitmapData ("assets/jewel.png");
         
		
		if (inName=="assets/pig.png")
			 
            return Assets.getBitmapData ("assets/pig.png");
         
		
		
		return null;
		
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		
		begin ();
		
	}
	
}


class NME_assets_background_jpg extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_baddysparrow_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_baddysparrow_xml extends nme.utils.ByteArray { }
class NME_assets_baddyspriteloq_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_baddyspriteloq_xml extends nme.utils.ByteArray { }
class NME_assets_bird_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_birdback_jpg extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_collect_wav extends nme.media.Sound { }
class NME_assets_crate_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_herosparrow_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_herosparrow_xml extends nme.utils.ByteArray { }
class NME_assets_herospriteloq_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_herospriteloq_xml extends nme.utils.ByteArray { }
class NME_assets_jewel_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_pig_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
