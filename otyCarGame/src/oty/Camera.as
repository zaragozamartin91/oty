package oty
{
	import flash.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.extensions.fluocode.Fluocam;
	
	/**
	 * ...
	 * @author martin
	 */
	public class Camera
	{
		private static const $instance:Camera;
		private static const $uniqueId:Number = Math.random();
		
		private var _camera:Fluocam;
		private var _cameraCenter:Sprite;
		
		public static function getInstance():Camera
		{
			$instance = $instance ? $instance : new Camera($uniqueId);
			return $instance;
		}
		
		public function Camera(uniqueId:Number)
		{
			if (uniqueId == $uniqueId)
			{
				_camera = new Fluocam(STARLING_WORLD, stage.stageWidth, stage.stageHeight, false);
				_cameraCenter = new Sprite();
				_camera.changeTarget(_cameraCenter);
			}
			else
			{
				throw new Error("Clase singleton! usar getInstance()");
			}
		}
		
		public function addToWorld(obj:DisplayObjectContainer):Camera
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
		
		public function setCenterX(x:NUmber):Camera {
			_cameraCenter.x = x;
			return this;
		}
		
		public function setCenterY(y:NUmber):Camera {
			_cameraCenter.y = y;
			return this;
		}
	}

}