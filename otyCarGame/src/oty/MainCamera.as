package oty
{
	import flash.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.extensions.fluocode.Fluocam;
	
	/**
	 * Camara principal.
	 * @author martin
	 */
	public class MainCamera
	{
		private static var $instance:MainCamera;
		private static const UNIQUE_ID:Number = Math.random();
		
		private var _camera:Fluocam;
		private var _cameraCenter:Sprite;
		
		/**
		 * Construye una nueva camara. La misma reemplaza a la instancia previa de camara. Se debe acceder a la nueva camara mediante getInstance.
		 * @param spriteStage Stage de sprites donde la camara filmara.
		 * @param width Anchura de camara en pixeles.
		 * @param height Altura de camara en pixeles.
		 * */
		public static function buildNew(spriteStage:Sprite, width:Number, height:Number):void
		{
			$instance = new MainCamera(UNIQUE_ID, spriteStage, width, height);
		}
		
		/**
		 * Obtiene la instancia actual de la camara principal.
		 * @return instancia actual de la camara principal.
		 * */
		public static function getInstance():MainCamera
		{
			if (!$instance)
			{
				throw new Error("Invocar a buildNew antes!");
			}
			return $instance;
		}
		
		public function MainCamera(uniqueId:Number, spriteStage:Sprite, width:Number, height:Number)
		{
			if (uniqueId == UNIQUE_ID)
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
		
		public function addToWorld(obj:Sprite):MainCamera
		{
			obj.addChild(_camera);
			return this;
		}
		
		/**
		 * Cambia el objetivo original de la camara. La camara por defecto tiene un objetivo el cual debe moverse manualmente mediante funciones de esta misma clase (setCenterX y setCenterY).
		 * */
		public function changeTarget(sprite:Sprite):MainCamera
		{
			_camera.changeTarget(sprite);
			return this;
		}
		
		/**
		 * Reestablece la camara a su objetivo original.
		 * */
		public function resetTarget():MainCamera
		{
			_camera.changeTarget(_cameraCenter);
			return this;
		}
		
		/** 
		 * Establece la posicion en x del objetivo POR DEFECTO de la camara. Esta funcion no aplica si el objetivo de la camara fue modificado mediante changeTarget.
		 * @param x Nueva posicion en x del objetivo POR DEFECTO de la camara en pixeles.
		 * */
		public function setCenterX(x:Number):MainCamera
		{
			_cameraCenter.x = x;
			return this;
		}
		
		/** 
		 * Establece la posicion en y del objetivo POR DEFECTO de la camara. Esta funcion no aplica si el objetivo de la camara fue modificado mediante changeTarget.
		 * @param y Nueva posicion en y del objetivo POR DEFECTO de la camara en pixeles.
		 * */
		public function setCenterY(y:Number):MainCamera
		{
			_cameraCenter.y = y;
			return this;
		}
	}

}