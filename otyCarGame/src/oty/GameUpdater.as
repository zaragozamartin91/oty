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
		 * Actualiza todas las entidades actualizables registradas.
		 * @param	time Plazo de tiempo de actualizacion.
		 */
		public function update(time:Number = 0):void
		{
			var ud:UpdatableData = null;
			for (var name:String in _permUpdatables)
			{
				ud = _permUpdatables[name];
				ud.updatable.update(time);
			}
		}
	}
}

class UpdatableData
{
	public var name:String;
	public var updatable:oty.Updatable;
	public var updateCondition:Function;
	
	public function UpdatableData(n:String, up:oty.Updatable, uc:Function = null)
	{
		name = n;
		updatable = up;
		uc = updateCondition;
	}
}