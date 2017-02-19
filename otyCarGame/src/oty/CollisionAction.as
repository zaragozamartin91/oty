package oty
{
	import Box2D.Dynamics.b2Body;
	
	/**
	 * Chequeo y accion de colision entre cuerpos de box2d.
	 *
	 * @author martin
	 */
	public class CollisionAction
	{
		private var _check:Function;
		private var _action:Function;
		
		/**
		 *
		 * Crea una nueva accion de colision.
		 *
		 * @param	check Funcion de chequeo de colision. Firma: function(body1:b2Body, body2:b2Body):Boolean.
		 * @param	action Accion a ejecutar si la condicion de colision es verdadera. Firma: function(body1:b2Body, body2:b2Body):void.
		 */
		public function CollisionAction(check:Function, action:Function)
		{
			_check = check;
			_action = action;
		}
		
		public function collisionOk(body1:b2Body, body2:b2Body):Boolean
		{
			return _check(body1, body2);
		}
		
		public function perform(body1:b2Body, body2:b2Body):void
		{
			_action(body1, body2);
		}
		
		public function performIfCollisionOk(body1:b2Body, body2:b2Body):Boolean
		{
			var colOk:Boolean = this.collisionOk(body1, body2);
			if (colOk)
			{
				this.perform(body1, body2);
			}
			return colOk;
		}
	}

}