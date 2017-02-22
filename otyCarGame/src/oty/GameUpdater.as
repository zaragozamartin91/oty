package oty
{
	
	/**
	 * Actualizador de entidades actualizables en el tiempo.
	 * @author martin
	 */
	public class GameUpdater implements Updatable
	{
		private static const UNIQUE_ID:Number = Math.random();
		private static var $instance:GameUpdater;
		
		private var _permUpdatables:* = {};
		private var _tempUpdatables:* = {};
		
		public static function getInstance():GameUpdater
		{
			$instance = $instance || new GameUpdater(UNIQUE_ID);
			return $instance;
		}
		
		public function GameUpdater(uniqueId:Number)
		{
			if (UNIQUE_ID != uniqueId)
			{
				throw new Error("Usar getInstance!");
			}
		}
		
		/**
		 * Agrega una entidad actualizable PERMANENTE que el actualizador del juego debe manipular en cada llamada "update".
		 * @param	name	Nombre/Id de la entidad actualizable.
		 * @param	up 		Entidad actualizable a manipular.
		 */
		public function addPermUpdatable(name:String, up:Updatable):void
		{
			_permUpdatables[name] = new UpdatableData(name, up);
		}
		
		/**
		 * Remueve una entidad actualizable.
		 * @param	name Nombre/Id de la entidad actualizable a remover.
		 */
		public function removePermUpdatable(name:String):void
		{
			if (_permUpdatables[name])
			{
				delete _permUpdatables[name];
			}
		}
		
		/**
		 * Remueve una entidad actualizable TEMPORAL.
		 * @param	name Nombre/Id de la entidad actualizable TEMPORAL a remover.
		 */
		public function removeTempUpdatable(name:String):void
		{
			if (_tempUpdatables[name])
			{
				delete _tempUpdatables[name];
			}
		}
		
		/**
		 * Agrega una entidad actualizable temporal que sera removida cuando la funcion de chequeo sea falsa.
		 * @param	name			Nombre de la entidad actualizable.
		 * @param	up				Entidad actualizable.
		 * @param	updateCheck		Funcion de chequeo: mientras devuelva true la entidad seguira siendo actualizada.
		 */
		public function addTempUpdatable(name:String, up:Updatable, updateCheck:Function = null):void
		{
			updateCheck = updateCheck || function():Boolean
			{
				return false;
			}
			_tempUpdatables[name] = new UpdatableData(name, up, updateCheck);
		}
		
		private var _updatablesToRemove:Vector.<UpdatableData> = new Vector.<UpdatableData>();
		/* VARIABLES CON PREFIJO _ui SERAN USADAS PARA ITERACIONES DEL METODO update. ESTO SE HACE PARA
		 * AHORRAR MEMORIA EN LA DECLARACION DE VARIABLES NUEVAS POR CADA LLAMADA A UPDATE.*/
		private var _uiname:String;
		private var _uipu:UpdatableData = null;
		private var _uitu:UpdatableData = null;
		private var _uiutr:UpdatableData = null;
		
		/**
		 * Actualiza todas las entidades actualizables registradas.
		 * @param	time Plazo de tiempo de actualizacion.
		 */
		public function update(time:Number = 0):void
		{
			for (_uiname in _permUpdatables)
			{
				_uipu = _permUpdatables[_uiname];
				_uipu.updatable.update(time);
			}
			
			for (_uiname in _tempUpdatables)
			{
				_uitu = _tempUpdatables[_uiname];
				if (_uitu.updateCheck())
				{
					_uitu.updatable.update();
				}
				else
				{
					_updatablesToRemove.push(_uitu);
				}
			}
			
			while (true)
			{
				_uiutr = _updatablesToRemove.pop();
				if (_uiutr)
				{
					removeTempUpdatable(_uiutr.name);
				}
				else
				{
					break;
				}
			}
		}
	}
}

class UpdatableData
{
	public var name:String;
	public var updatable:oty.Updatable;
	public var updateCheck:Function;
	
	public function UpdatableData(n:String, up:oty.Updatable, uc:Function = null)
	{
		name = n;
		updatable = up;
		uc = updateCheck;
	}
}