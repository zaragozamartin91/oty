package oty
{
	
	/**
	 * Actualizador del estado del juego.
	 * @author martin
	 */
	public class GameUpdater implements Updatable
	{
		private static const UNIQUE_ID:Number = Math.random();
		private static var $instance:GameUpdater;
		
		private var _permUpdatables:Vector.<Updatable> = new Vector.<Updatable>();
		
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
		 * @param	up Entidad actualizable a manipular.
		 */
		public function addPermUpdatable(up:Updatable):void
		{
			_permUpdatables.push(up);
		}
		
		public function update(time:Number = 0):void
		{
			_permUpdatables.forEach(function(up:Updatable, index:int, vec:Vector.<Updatable>):void
			{
				up.update(time);
			});
		}
	}
}