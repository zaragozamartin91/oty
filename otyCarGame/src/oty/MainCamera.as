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
		private var _target:Sprite;
		private var _offset:* = {x: 0, y: 0};
		
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
		
		/**
		 * Agrega la camara al escenario de starling.
		 * @param	obj Sprite escenario.
		 * @return this
		 */
		public function addToWorld(obj:Sprite):MainCamera
		{
			obj.addChild(_camera);
			return this;
		}
		
		/**
		 * Cambia el objetivo original de la camara. La camara por defecto tiene un objetivo el cual debe moverse manualmente mediante funciones de esta misma clase (setCenterX y setCenterY).
		 * */
		public function setTarget(sprite:Sprite):MainCamera
		{
			_target = sprite;
			return this;
		}
		
		/**
		 * Establece una distancia entre el objetivo y la camara.
		 * @param	x Distancia horizontal en pixeles.
		 * @param	y Distancia vertical en pixeles.
		 * @return this
		 */
		public function setOffset(x:Number, y:Number):MainCamera
		{
			_offset.x = x;
			_offset.y = y;
			return this;
		}
		
		/**
		 * Actualiza el estado de la camara.
		 * @return this
		 */
		public function update():MainCamera
		{
			_cameraCenter.x = _target.x + _offset.x;
			_cameraCenter.y = _target.y + _offset.y;
			return this;
		}
	}

}