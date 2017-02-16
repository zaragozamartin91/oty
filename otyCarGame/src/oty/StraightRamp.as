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
	 * Rampas rectas.
	 * @author martin
	 */
	public class StraightRamp
	{
		private var _rampSprite:Sprite;
		private var _rampBody:b2Body;
		private var _box2dWorld:b2World;
		
		public function get sprite():Sprite  { return _rampSprite; }
		
		public function get body():b2Body  { return _rampBody; }
		
		/**
		 * Construye una rampa nueva.
		 * @param xPx 		posicion x en pixeles.
		 * @param yPx 		posicion y en pixeles.
		 * @param widthPx 	Anchura en pixeles.
		 * @param heightPx	Altura en pixeles.
		 * @param rotation	Rotacion de la rampa en radianes. La rotacion se da desde el centro de masa de la misma en sentido horario.
		 * */
		public function StraightRamp(xPx:Number, yPx:Number, widthPx:Number, heightPx:Number, rotation:Number = 0, box2dWorld:b2World = null)
		{
			_box2dWorld = box2dWorld ? box2dWorld : MainBox2dWorld.getInstance().world;
			
			// shape
			var rampShape:b2PolygonShape = new b2PolygonShape();
			rampShape.SetAsBox(pixelsToMeters(widthPx) / 2, pixelsToMeters(heightPx) / 2);
			// fixture
			var rampFixture:b2FixtureDef = new b2FixtureDef();
			rampFixture.density = 0;
			rampFixture.friction = 3;
			rampFixture.restitution = 0;
			rampFixture.shape = rampShape;
			// body definition
			var rampBodyDef:b2BodyDef = new b2BodyDef();
			rampBodyDef.position.Set(pixelsToMeters(xPx), pixelsToMeters(yPx));
			// the floor itself
			_rampBody = _box2dWorld.CreateBody(rampBodyDef);
			_rampBody.CreateFixture(rampFixture);
			_rampBody.SetAngle(rotation);
			
			var rampTexture:Texture = TextureRepository.getInstance().woodTexture;
			_rampSprite = new Sprite();
			_rampSprite.addChild(new Image(rampTexture));
			_rampSprite.alignPivot();
			_rampSprite.width = widthPx;
			_rampSprite.height = heightPx;
			_rampSprite.x = metersToPixels(_rampBody.GetPosition().x);
			_rampSprite.y = metersToPixels(_rampBody.GetPosition().y);
			_rampSprite.rotation = rotation;
		}
		
		/**
		 * Agrega la rampa al mundo.
		 * */
		public function addToWorld(starlingWorld:Sprite):StraightRamp
		{
			starlingWorld.addChild(_rampSprite);
			return this;
		}
		
		/**
		 * Elimina el objeto rampa liberando memoria.
		 */
		public function dispose():void {
			if (_rampSprite && _rampSprite.parent) {
				/* Le pido al contenedor del sprite que lo remueva y lo elimine */
				_rampSprite.parent.removeChild(sprite, true);
				_rampSprite = null;
			}
			if (_rampBody) {
				/* le pido a Box2d que elimine el cuerpo */
				_box2dWorld.DestroyBody(body);
				_rampBody = null;
			}
		}
		
		private function metersToPixels(m:Number):Number
		{
			return MainBox2dWorld.metersToPixels(m);
		}
		
		private function pixelsToMeters(p:Number):Number
		{
			return MainBox2dWorld.pixelsToMeters(p);
		}
	}
}