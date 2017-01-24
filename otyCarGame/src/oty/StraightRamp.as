package oty
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author martin
	 */
	public class StraightRamp
	{
		private var floorSprite:Sprite;
		private var floor:b2Body;
		private var box2dWorld:b2World;
		
		public function get sprite()  { return floorSprite; }
		
		public function StraightRamp(xPx:Number, yPx:Number, widthPx:Number, heightPx:Number, rotation:Number = 0, __box2dWorld:b2World = null)
		{
			this.box2dWorld = __box2dWorld ? __box2dWorld : MainBox2dWorld.getInstance().world;
			
			// shape
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(pixelsToMeters(widthPx) / 2, pixelsToMeters(heightPx) / 2);
			// fixture
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density = 0;
			floorFixture.friction = 3;
			floorFixture.restitution = 0;
			floorFixture.shape = floorShape;
			// body definition
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(pixelsToMeters(xPx), pixelsToMeters(yPx));
			// the floor itself
			floor = box2dWorld.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			floor.SetAngle(rotation);
			
			var floorTexture:Texture = TextureRepository.getInstance().woodTexture;
			floorSprite = new Sprite();
			floorSprite.addChild(new Image(floorTexture));
			floorSprite.alignPivot();
			floorSprite.width = widthPx;
			floorSprite.height = heightPx;
			floorSprite.x = metersToPixels(floor.GetPosition().x);
			floorSprite.y = metersToPixels(floor.GetPosition().y);
			floorSprite.rotation = rotation;
		}
		
		public function addToWorld(starlingWorld:Sprite):StraightRamp
		{
			starlingWorld.addChild(floorSprite);
			return this;
		}
		
		public function metersToPixels(m:Number):Number
		{
			return MainBox2dWorld.metersToPixels(m);
		}
		
		public function pixelsToMeters(p:Number):Number
		{
			return MainBox2dWorld.pixelsToMeters(p);
		}
	}
}