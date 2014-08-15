package com.magicbird.core;


class MagicObject {

	public var name:String;
	public var kill:Bool;

	private var _initialized:Bool;
		
	public function new(name:String, params:Dynamic = null) {

		kill = false;
		_initialized = false;

		this.name = name;

		if (params != null)
			setParams(params);
		else
			_initialized = true;
	}
	
	public function setEditMode(v : Bool)
	{
		
	}
		
	public function destroy():Void {

	}

		
	public function update(timeDelta):Void {

	}

		
	private function setParams(object:Dynamic):Void {

		for (param in Reflect.fields(object)) {

			try {
				Reflect.setProperty(this, param, Reflect.field(object, param));
			} catch (e:Dynamic) {

				trace("Warning: The parameter " + param + " does not exist on object : " + name + ", with type : " + this);
			}
		}

		_initialized = true;
	}
}