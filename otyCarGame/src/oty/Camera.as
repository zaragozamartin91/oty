package oty
{
	import flash.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.extensions.fluocode.Fluocam;
	
	/**
	 * 
	 * @author martin
	 */
	public class Camera
	{
		private static var $instance:Camera;
		private static const $uniqueId:Number = Math.random();
		
		private var _camera:Fluocam;
		private var _cameraCenter:Sprite;
		
		public static function buildNew(spriteStage:Sprite, width:Number, height:Number):Camera
		{
			$instance = new Camera($uniqueId, spriteStage, width, height);
			return $instance;
		}
		
		public static function getInstance():Camera
		{
			if (!$instance)
			{
				throw new Error("Invocar a buildNew antes!");
			}
			return $instance;
		}
		
		public function Camera(uniqueId:Number, spriteStage:Sprite, width:Number, height:Number)
		{
			if (uniqueId == $uniqueId)
			{
				_camera = new Fluocam(spriteStage, width, height, false);
				_cameraCenter = new Sprite();
				_camera.changeTarget(_cameraCenter);
			}
			else
			{
				throw new Error("Clase singleton! usar getInstance()");
			}
		}
		
		public function addToWorld(obj:Sprite):Camera
		{
			obj.addChild(_camera);
			return this;
		}
		
		public function changeTarget(sprite:Sprite):Camera
		{
			_camera.changeTarget(sprite);
			return this;
		}
		
		public function resetTarget():Camera
		{
			_camera.changeTarget(_cameraCenter);
			return this;
		}
		
		public function setCenterX(x:Number):Camera
		{
			_cameraCenter.x = x;
			return this;
		}
		
		public function setCenterY(y:Number):Camera
		{
			_cameraCenter.y = y;
			return this;
		}
	}

}