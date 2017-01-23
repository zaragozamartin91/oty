package oty
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	/**
	 * ...
	 * @author martin
	 */
	public class MainBox2dWorld
	{
		public static const PIXELS_TO_METER:int = 30;
		public static const WORLD_STEP:Number = 1 / 30;
		private static var _instance:MainBox2dWorld;
		private static var _allow:Boolean;
		
		private var box2dWorld:b2World;
		
		public function get world():b2World  { return box2dWorld; }
		
		public static function getInstance():MainBox2dWorld
		{
			if (!_instance)
			{
				_allow = true;
				_instance = new MainBox2dWorld();
				_allow = false;
			}
			return _instance;
		}
		
		public function MainBox2dWorld()
		{
			if (!_allow)
			{
				throw new Error("CLASE ES SINGLETON! USAR getInstance");
			}
			
			box2dWorld = new b2World(new b2Vec2(0, 10), true);
		}
		
		public function update():void
		{
			box2dWorld.Step(WORLD_STEP, 10, 10);
			box2dWorld.ClearForces();
			box2dWorld.DrawDebugData();
		}
		
		public static function metersToPixels(m:Number):Number
		{
			return m * PIXELS_TO_METER;
		}
		
		public static function pixelsToMeters(p:Number):Number
		{
			return p / PIXELS_TO_METER;
		}
	}
}