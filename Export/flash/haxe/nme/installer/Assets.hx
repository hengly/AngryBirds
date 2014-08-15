package nme.installer;


import nme.display.BitmapData;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.ByteArray;
import ApplicationMain;


/**
 * ...
 * @author Joshua Granick
 */

class Assets {

	
	public static var cachedBitmapData:Hash<BitmapData> = new Hash<BitmapData>();
	
	private static var initialized:Bool = false;
	private static var resourceClasses:Hash <Dynamic> = new Hash <Dynamic> ();
	private static var resourceTypes:Hash <String> = new Hash <String> ();
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			resourceClasses.set ("assets/background.jpg", NME_assets_background_jpg);
			resourceTypes.set ("assets/background.jpg", "image");
			resourceClasses.set ("assets/baddySparrow.png", NME_assets_baddysparrow_png);
			resourceTypes.set ("assets/baddySparrow.png", "image");
			resourceClasses.set ("assets/baddySparrow.xml", NME_assets_baddysparrow_xml);
			resourceTypes.set ("assets/baddySparrow.xml", "text");
			resourceClasses.set ("assets/baddySpriteLoq.png", NME_assets_baddyspriteloq_png);
			resourceTypes.set ("assets/baddySpriteLoq.png", "image");
			resourceClasses.set ("assets/baddySpriteLoq.xml", NME_assets_baddyspriteloq_xml);
			resourceTypes.set ("assets/baddySpriteLoq.xml", "text");
			resourceClasses.set ("assets/bird.png", NME_assets_bird_png);
			resourceTypes.set ("assets/bird.png", "image");
			resourceClasses.set ("assets/birdback.jpg", NME_assets_birdback_jpg);
			resourceTypes.set ("assets/birdback.jpg", "image");
			resourceClasses.set ("assets/collect.wav", NME_assets_collect_wav);
			resourceTypes.set ("assets/collect.wav", "sound");
			resourceClasses.set ("assets/crate.png", NME_assets_crate_png);
			resourceTypes.set ("assets/crate.png", "image");
			resourceClasses.set ("assets/heroSparrow.png", NME_assets_herosparrow_png);
			resourceTypes.set ("assets/heroSparrow.png", "image");
			resourceClasses.set ("assets/heroSparrow.xml", NME_assets_herosparrow_xml);
			resourceTypes.set ("assets/heroSparrow.xml", "text");
			resourceClasses.set ("assets/heroSpriteLoq.png", NME_assets_herospriteloq_png);
			resourceTypes.set ("assets/heroSpriteLoq.png", "image");
			resourceClasses.set ("assets/heroSpriteLoq.xml", NME_assets_herospriteloq_xml);
			resourceTypes.set ("assets/heroSpriteLoq.xml", "text");
			resourceClasses.set ("assets/jewel.png", NME_assets_jewel_png);
			resourceTypes.set ("assets/jewel.png", "image");
			resourceClasses.set ("assets/pig.png", NME_assets_pig_png);
			resourceTypes.set ("assets/pig.png", "image");
			
			initialized = true;
			
		}
		
	}
	
	
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id) == "image") {
			
			if (useCache && cachedBitmapData.exists (id)) {
				
				return cachedBitmapData.get (id);
				
			} else {
				
				var data = cast (Type.createInstance (resourceClasses.get (id), []), BitmapData);
				
				if (useCache) {
					
					cachedBitmapData.set (id, data);
					
				}
				
				return data;
				
			}
			
		} else {
			
			trace ("[nme.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getBytes (id:String):ByteArray {
		
		initialize ();
		
		if (resourceClasses.exists (id)) {
			
			return Type.createInstance (resourceClasses.get (id), []);
			
		} else {
			
			trace ("[nme.Assets] There is no ByteArray asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getFont (id:String):Font {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id) == "font") {
			
			return cast (Type.createInstance (resourceClasses.get (id), []), Font);
			
		} else {
			
			trace ("[nme.Assets] There is no Font asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getSound (id:String):Sound {
		
		initialize ();
		
		if (resourceTypes.exists (id)) {
			
			if (resourceTypes.get (id) == "sound" || resourceTypes.get (id) == "music") {
				
				return cast (Type.createInstance (resourceClasses.get (id), []), Sound);
				
			}
			
		}
		
		trace ("[nme.Assets] There is no Sound asset with an ID of \"" + id + "\"");
		
		return null;
		
	}
	
	
	public static function getText (id:String):String {
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
}