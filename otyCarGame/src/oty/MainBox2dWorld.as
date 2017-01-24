package oty
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author martin
	 */
	public class MainBox2dWorld
	{
		public static const PIXELS_TO_METER:int = 30;
		public static const WORLD_STEP:Number = 1 / 30;
		private static const UNIQUE_ID:Number = Math.random();
		
		private static var $instance:MainBox2dWorld;
		
		private var _box2dWorld:b2World;
		private var _debugDrawOn:Boolean = false;
		
		public static function getInstance():MainBox2dWorld
		{
			$instance = $instance ? $instance : new MainBox2dWorld(UNIQUE_ID);
			return $instance;
		}
		
		public function MainBox2dWorld(uniqueId:Number)
		{
			if (UNIQUE_ID == uniqueId)
			{
				_box2dWorld = new b2World(new b2Vec2(0, 10), true);
			}
			else
			{
				throw new Error("CLASE ES SINGLETON! USAR getInstance");
			}
		}
		
		public function get world():b2World  { return _box2dWorld; }
		
		public function update():void
		{
			_box2dWorld.Step(WORLD_STEP, 10, 10);
			_box2dWorld.ClearForces();
			if (_debugDrawOn)
			{
				_box2dWorld.DrawDebugData();
			}
		}
		
		public function debugDraw():void
		{
			_debugDrawOn = true;
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Starling.current.nativeOverlay);
			debugDraw.SetDrawScale(PIXELS_TO_METER);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			//debugDraw.SetDrawScale(50);
			_box2dWorld.SetDebugDraw(debugDraw);
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