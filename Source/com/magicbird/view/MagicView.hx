package com.magicbird.view;

import com.magicbird.core.MagicEngine;
import com.magicbird.math.MathVector;
import com.magicbird.view.ISpriteView;
import nme.display.DisplayObject;
import nme.errors.Error;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.ObjectHash;


class MagicView 
{	
	public var cameraTarget:Dynamic;
	public var cameraOffset:MathVector;
	public var cameraEasing:MathVector;
	public var cameraBounds:Rectangle;
	public var cameraLensWidth:Float;
	public var cameraLensHeight:Float;

	private var _viewObjects:ObjectHash<ISpriteView, DisplayObject>;
	private var _root:Dynamic;
	
	public function new(root:Dynamic)
	{
		_root = root;

		_viewObjects = new ObjectHash<ISpriteView, DisplayObject>();

		var ce:MagicEngine = MagicEngine.getInstance();

		cameraLensWidth = ce.stage.stageWidth;
		cameraLensHeight = ce.stage.stageHeight;

		cameraOffset = new MathVector();
		cameraEasing = new MathVector(0.25, 0.05);
	}

	public function destroy():Void 
	{
		_viewObjects = null;
		cameraTarget = null;
	}
	
	public function update():Void 
	{
	}
	
	public function addArt(mo:ISpriteView):Void
	{
		var art:Dynamic = createArt(mo);

		if (art != null) {
			_viewObjects.set(mo, art);
		}
	}
	
	public function convertStagePointToViewPoint(point : Point) : Point
	{
		throw new Error("not implemented");
		return null;
	}
	
	public function removeArt(mo:ISpriteView):Void 
	{
		destroyArt(mo);
		_viewObjects.remove(mo);
	}

	public function getArt(mo:ISpriteView):DisplayObject 
	{
		return _viewObjects.get(mo);
	}

	public function getObjectFromArt(art:DisplayObject):ISpriteView 
	{
		for (object in _viewObjects.keys()) {

			if (_viewObjects.get(object) == art)
				return object;
		}
		return null;
	}

	public function setupCamera(target:Dynamic, offset:MathVector, bounds:Rectangle, easing:MathVector):Void 
	{
		cameraTarget = target;
		cameraOffset = offset;
		cameraBounds = bounds;
		cameraEasing = easing;
	}

	
	private function createArt(mo:ISpriteView):DisplayObject
	{
		return null;
	}
	
	private function destroyArt(mo:ISpriteView):Void 
	{
	}
}