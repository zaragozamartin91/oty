package oty
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	/**
	 * Manejador de colisiones de cuerpos de box2d.
	 *
	 * @author martin
	 */
	public class MainBox2dContactListener extends b2ContactListener
	{
		private static const UNIQUE_ID:Number = Math.random();
		private static var $instance:MainBox2dContactListener;
		
		private var _beginContactActions:Vector.<CollisionAction>;
		private var _endContactActions:Vector.<CollisionAction>;
		
		public static function getInstance():MainBox2dContactListener
		{
			$instance = $instance ? $instance : new MainBox2dContactListener(UNIQUE_ID);
			return $instance;
		}
		
		public function MainBox2dContactListener(uniqueId:Number)
		{
			if (UNIQUE_ID == uniqueId)
			{
				_beginContactActions = new Vector.<CollisionAction>();
				_endContactActions = new Vector.<CollisionAction>();
			}
			else
			{
				throw new Error("CLASE SINGLETON! USAR getInstance");
			}
		}
		
		public function addBeginContactAction(action:CollisionAction):MainBox2dContactListener
		{
			_beginContactActions.push(action);
			return this;
		}
		
		public function addEndContactAction(action:CollisionAction):MainBox2dContactListener
		{
			_endContactActions.push(action);
			return this;
		}
		
		/**
		 * Called when two fixtures begin to touch.
		 */
		override public function BeginContact(contact:b2Contact):void
		{
			_beginContactActions.forEach(function(action:CollisionAction, i, vec):void
			{
				var body1:b2Body = contact.GetFixtureA().GetBody();
				var body2:b2Body = contact.GetFixtureB().GetBody();
				//trace("CHECKING COLLISION BETWEEN " + body1.GetUserData().name + " AND " + body2.GetUserData().name);
				action.performIfCollisionOk(body1, body2);
			}, this);
		}
		
		/**
		 * Called when two fixtures cease to touch.
		 */
		override public function EndContact(contact:b2Contact):void
		{
			_endContactActions.forEach(function(action:CollisionAction, i, vec):void
			{
				var body1:b2Body = contact.GetFixtureA().GetBody();
				var body2:b2Body = contact.GetFixtureB().GetBody();
				action.performIfCollisionOk(body1, body2);
			}, this);
		}
		
		/**
		 * This is called after a contact is updated. This allows you to inspect a
		 * contact before it goes to the solver. If you are careful, you can modify the
		 * contact manifold (e.g. disable contact).
		 * A copy of the old manifold is provided so that you can detect changes.
		 * Note: this is called only for awake bodies.
		 * Note: this is called even when the number of contact points is zero.
		 * Note: this is not called for sensors.
		 * Note: if you set the number of contact points to zero, you will not
		 * get an EndContact callback. However, you may get a BeginContact callback
		 * the next step.
		 */
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
		
		}
		
		/**
		 * This lets you inspect a contact after the solver is finished. This is useful
		 * for inspecting impulses.
		 * Note: the contact manifold does not include time of impact impulses, which can be
		 * arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
		 * in a separate data structure.
		 * Note: this is only called for contacts that are touching, solid, and awake.
		 */
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
		
		}
	
	}

}