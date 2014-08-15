package com.magicbird.objects;

import com.magicbird.core.MagicObject;
import com.magicbird.core.MagicEngine;
import nme.display.DisplayObject;
import nme.geom.Point;

import nme.events.MouseEvent;
import nme.display.Sprite;

class EditModeMgr 
{
	private static var prevSelected : Sprite;
	private static inline var MAX_PRIORITY = 0x80;
	private var art : Sprite;
	private var mo : MagicSprite;
	private var offset : Point;
	private static var currentSelected : EditModeMgr;
	
	public function new(art : Sprite, mo : MagicSprite)
	{
		this.art = art;
		this.mo = mo;
		art.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, MAX_PRIORITY);
	}
	
	private function onMouseDown(e : MouseEvent)
	{
		if (prevSelected != null)
		{
			clearEditMode(prevSelected);
		}
		prevSelected = art;
		enterEditMode(prevSelected);
		
		MagicEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove,
			false, MAX_PRIORITY);
		MagicEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, 
			false, MAX_PRIORITY);
			
		e.stopImmediatePropagation();
		
		currentSelected = this;
		
		var view = MagicEngine.getInstance().state.view;
		var pos = view.convertStagePointToViewPoint(new Point(e.stageX, e.stageY));
		offset = pos.subtract(new Point(mo.x, mo.y));
	}
	
	private function onMouseUp(e : MouseEvent)
	{
		MagicEngine.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		MagicEngine.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		e.stopImmediatePropagation();
	}
	
	private function onMouseMove(e : MouseEvent)
	{
		var view = MagicEngine.getInstance().state.view;
		var pos = view.convertStagePointToViewPoint(new Point(e.stageX, e.stageY));
		mo.x = pos.x - offset.x;
		mo.y = pos.y - offset.y;
		e.stopImmediatePropagation();
	}
	
	private function clearEditMode(sprite : Sprite)
	{
		sprite.graphics.clear();
	}
	
	private function enterEditMode(sprite : Sprite)
	{
		sprite.graphics.clear();
		sprite.graphics.lineStyle(1, 0x0ff0000);
		sprite.graphics.beginFill(0, 0);
		if (mo.registration == "topLeft")
		{
			sprite.graphics.drawRect( -1, -1, mo.width + 2, mo.height + 2);
		}
		else if(mo.registration == "center")
		{
			sprite.graphics.drawRect(-(mo.width / 2) -1, -(mo.height / 2) - 1, mo.width + 2, mo.height + 2);
		}
		sprite.graphics.endFill();
	}
	
	public static function attach(mo : MagicSprite)
	{
		var view = MagicEngine.getInstance().state.view;
		var art = view.getArt(mo);
		if (art == null || !Std.is(art, Sprite))
		{
			return null;
		}
		return new EditModeMgr(cast(art, Sprite), mo);
	}
	
	public function dettach()
	{
		art.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		MagicEngine.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		MagicEngine.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		if (currentSelected == this)
		{
			currentSelected.clearEditMode(art);
			currentSelected = null;
		}
		art = null;
		mo = null;
	}
}