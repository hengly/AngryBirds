package com.magicbird.view.spriteview;

import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import com.magicbird.core.MagicObject;
import nme.display.DisplayObject;
import nme.geom.Point;
import com.eclecticdesignstudio.motion.Actuate;
import com.magicbird.view.MagicView;
import com.magicbird.view.ISpriteView;
import com.magicbird.view.spriteview.SpriteArt;

import nme.display.Sprite;

class SpriteView extends MagicView {

	public var viewRoot(getViewRoot, never):Sprite;

	var _viewRoot:Sprite;

	public function new(root:Sprite) {
		super(root);

		_viewRoot = new Sprite();
		root.addChild(_viewRoot);
	}

	public function getViewRoot():Sprite {
		return _viewRoot;
	}
	
	public override function convertStagePointToViewPoint(point : Point) : Point
	{
		point = _viewRoot.parent.globalToLocal(point);
		return new Point(point.x + _viewRoot.x, point.y + _viewRoot.y);
	}
	
	override public function update():Void {

		super.update();

		if (cameraTarget != null) {

			var diffX:Float = (-cameraTarget.getX() + cameraOffset.x) - _viewRoot.x;
			var diffY:Float = (-cameraTarget.getY() + cameraOffset.y) - _viewRoot.y;
			var velocityX:Float = diffX * cameraEasing.x;
			var velocityY:Float = diffY * cameraEasing.y;
			_viewRoot.x += velocityX;
			_viewRoot.y += velocityY;
			
			if (cameraBounds != null) {
				
				if (-_viewRoot.x <= cameraBounds.left)
					_viewRoot.x = -cameraBounds.left;
				else if (-_viewRoot.x + cameraLensWidth >= cameraBounds.right)
					_viewRoot.x = cameraLensWidth - cameraBounds.right;
				
				if (-_viewRoot.y <= cameraBounds.top)
					_viewRoot.y = -cameraBounds.top;
				else if (-_viewRoot.y + cameraLensHeight >= cameraBounds.bottom)
					_viewRoot.y = -cameraBounds.bottom + cameraLensHeight;
			}
		}

		for (sprite in _viewObjects.iterator()) {

			var spriteArt = cast(sprite, SpriteArt);
			
			if (spriteArt.group != spriteArt.magicObject.group)
				_updateGroupForSprite(spriteArt);
				
			spriteArt.update();
		}
	}

	override private function createArt(mo:ISpriteView):DisplayObject {
		var art:SpriteArt = new SpriteArt(mo, this);
		art.update();
		
		_updateGroupForSprite(art);

		return art;
	}
	
	override public function destroy()
	{
		for (object in _viewObjects.keys()) {
			var viewobject = _viewObjects.get(object);
			cast(viewobject, SpriteArt).destroy();
		}
		
		if(_viewRoot.parent != null)
			_viewRoot.parent.removeChild(_viewRoot);
		
		Actuate.stop(_viewRoot, null, false, false);
			
		super.destroy();
	}
	
	override private function destroyArt(mo:ISpriteView):Void {
		var spriteArt = cast(_viewObjects.get(mo), SpriteArt);
		spriteArt.parent.removeChild(spriteArt);
	}

	public function createTileLayer(tileSheet:SparrowTilesheet, name:String, group:Int = 0):TileLayer {
		var tileLayer:TileLayer = new TileLayer(tileSheet);
		tileLayer.view.name = name;

		_updateGroupForTileLayer(tileLayer.view, group);

		return tileLayer;
	}

	private function _updateGroupForSprite(sprite:SpriteArt):Void {
		while (sprite.group >= _viewRoot.numChildren)
			_viewRoot.addChild(new Sprite());

		cast(_viewRoot.getChildAt(sprite.group), Sprite).addChild(sprite);
	}

	private function _updateGroupForTileLayer(sprite:Sprite, group:Int):Void {
		while (group >= _viewRoot.numChildren)
			_viewRoot.addChild(new Sprite());

		cast(_viewRoot.getChildAt(group), Sprite).addChild(sprite);
	}
}