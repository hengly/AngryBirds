package com.magicbird.view.spriteview;

import com.magicbird.core.MagicObject;
import com.magicbird.view.ISpriteView;
import com.magicbird.view.spriteview.Box2DDebugArt;
import com.magicbird.view.spriteview.SparrowAnimationSequence;
import com.magicbird.view.spriteview.SpriteLoqAnimationSequence;
import com.magicbird.view.spriteview.SpriteView;

import com.eclecticdesignstudio.motion.Actuate;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.Sprite;


class SpriteArt extends Sprite {

	public var magicObject(getMagicObject, never):ISpriteView;
	public var view(getView, setView):Dynamic;
	public var animation(getAnimation, setAnimation):String;
	public var registration(getRegistration, setRegistration):String;
	public var group(getGroup, setGroup):Int;

	public var content:DisplayObject;
	public var stateView:SpriteView;

	var _MagicObject:ISpriteView;
	var _view:Dynamic;
	var _animator:IAnimator;
	var _animation:String;
	var _registration:String;
	var _group:Int;

	public function new(object:ISpriteView, rootView:SpriteView) {

		super();

		_MagicObject = object;
		stateView = rootView;

		this.name = cast(_MagicObject, MagicObject).name;
	}

	public function update():Void {
		
		this.scaleX = _MagicObject.inverted ? - 1 : 1;
		
		this.x =  _MagicObject.x + (-stateView.viewRoot.x * (1 - _MagicObject.parallax)) + _MagicObject.offsetX * this.scaleX;
		this.y = _MagicObject.y + (-stateView.viewRoot.y * (1 - _MagicObject.parallax)) + _MagicObject.offsetY * this.scaleY;
		this.rotation = _MagicObject.rotation;
		this.visible = _MagicObject.visible;
		registration = _MagicObject.registration;
		view = _MagicObject.view;
		animation = _MagicObject.animation;
		group = _MagicObject.group;
	}

	public function getMagicObject():ISpriteView {
		return _MagicObject;
	}

	public function getView():Dynamic {
		return _view;
	}

	public function setView(value:Dynamic):Dynamic {

		if (_view == value) {
			return _view;
		}
		if (_view != null)
		{
			var destroyMethod = Reflect.field(_view, "destroy");
			if (destroyMethod != null)
			{
				Reflect.callMethod(_view, destroyMethod, []);
			}
		}
		_view = value;
		
		_animator = Std.is(_view, IAnimator) ? cast(_view, IAnimator) : null;
		if (_view != null) {

			if (Std.is(_view, String)) {

				
				var classString:String = _view;
				var suffix:String = classString.substr(classString.length - 4).toLowerCase();
				if (suffix == ".png" || suffix == ".jpg") {

					content = new Bitmap(Assets.getBitmapData(_view));
					this.addChild(content);
				}

			} else if (Std.is(_view, Class)) {
				
				content = Type.createInstance(_MagicObject.view, []);
				this.addChild(content);

			} else if (Std.is(_view, DisplayObject)) {
				
				content = _view;
				addChild(content);

			} else {
				trace("SpriteArt doesn't know how to create a graphic object from the provided MagicObject " + MagicObject);
			}
		}

		return _view;
	}

	public function getAnimation():String {
		return _animation;
	}

	public function setAnimation(value:String):String {

		if (_animation == value)
			return _animation;

		_animation = value;

		if (_animation != "" && _animator != null) {
			
			_animator.changeAnimation(_animation);
		}
		return _animation;
	}

	public function getRegistration():String {
		return _registration;
	}

	public function setRegistration(value:String):String {

		if (_registration == value || content == null)
			return _registration;

		_registration = value;

		if (_registration == "topLeft") {

			content.x = 0;
			content.y = 0;

		} else if (_registration == "center") {

			content.x = -content.width / 2;
			content.y = -content.height / 2;
		}

		return _registration;
	}
	
	public function destroy()
	{
		if (content.parent != null)
		{
			content.parent.removeChild(content);
		}
		if (_view != null)
		{
			var destroyMethod = Reflect.field(_view, "destroy");
			if (destroyMethod != null)
			{
				Reflect.callMethod(_view, destroyMethod, []);
			}
		}
		Actuate.stop(this, null, false, false);
	}
	
	public function getGroup():Int {
		return _group;
	}

	public function setGroup(value:Int):Int {
		return _group = value;
	}
}