package oty
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author martin
	 */
	public class DummyCar
	{
		public static const RAXLE_DEFAULT_OFFSET_X:Number = 60;
		public static const RAXLE_DEFAULT_OFFSET_Y:Number = 65;
		public static const FAXLE_DEFAULT_OFFSET_X:Number = 75;
		public static const FAXLE_DEFAULT_OFFSET_Y:Number = 65;
		
		private var _box2dWorld:b2World;
		private var _carBody:b2Body;
		private var _carBodyDef:b2BodyDef;
		private var _rearWheelRevoluteJoint:b2RevoluteJoint;
		private var _frontWheelRevoluteJoint:b2RevoluteJoint;
		private var _frontAxlePrismaticJoint:b2PrismaticJoint;
		private var _rearAxlePrismaticJoint:b2PrismaticJoint;
		private var _rearWheelBody:b2Body;
		private var _frontWheelBody:b2Body;
		private var _wheelShape:b2CircleShape;
		
		private var _frontWheelSprite:Sprite;
		private var _rearWheelSprite:Sprite;
		private var _carSprite:Sprite;
		
		/* SEPARACIONES DE LOS EJES GIRATORIOS DE LAS RUEDAS RESPECTO DEL CUERPO DEL AUTO */
		private var _raxleOffsetX:Number = RAXLE_DEFAULT_OFFSET_X;
		private var _raxleOffsetY:Number = RAXLE_DEFAULT_OFFSET_Y;
		private var _faxleOffsetX:Number = FAXLE_DEFAULT_OFFSET_X;
		private var _faxleOffsetY:Number = FAXLE_DEFAULT_OFFSET_Y;
		
		private var _carWidthPx:Number = 240;
		private var _carHeightPx:Number = 120;
		private var _carBaseHeightPx:Number = 40;
		private var _wheelRadiusPx:Number = 40;
		
		private var _motorSpeed:Number = 0;
		private var _left:Boolean;
		private var _right:Boolean;
		
		public function DummyCar(box2dWorld:b2World = null)
		{
			this._box2dWorld = box2dWorld ? box2dWorld : MainBox2dWorld.getInstance().world;
			
			buildBox2dBody();
			
			buildStarlingSprites();
		}
		
		public function addToWorld(starlingWorld:Sprite):void
		{
			starlingWorld.addChild(_frontWheelSprite);
			starlingWorld.addChild(_rearWheelSprite);
			starlingWorld.addChild(_carSprite);
		}
		
		public function goLeft():void
		{
			_left = true;
		}
		
		public function stopLeft():void
		{
			_left = false;
		}
		
		public function goRight():void
		{
			_right = true;
		}
		
		public function stopRight():void
		{
			_right = false;
		}
		
		public function update(time:Number):void
		{
			if (_left)
			{
				_motorSpeed += 0.15;
			}
			if (_right)
			{
				_motorSpeed -= 0.15;
			}
			_motorSpeed *= 0.99;
			if (_motorSpeed > 100)
			{
				_motorSpeed = 100;
			}
			
			_frontWheelSprite.x = metersToPixels(_frontWheelBody.GetPosition().x);
			_frontWheelSprite.y = metersToPixels(_frontWheelBody.GetPosition().y);
			_frontWheelSprite.rotation = _frontWheelBody.GetAngle();
			
			_rearWheelSprite.x = metersToPixels(_rearWheelBody.GetPosition().x);
			_rearWheelSprite.y = metersToPixels(_rearWheelBody.GetPosition().y);
			_rearWheelSprite.rotation = _rearWheelBody.GetAngle();
			
			/* debido a que "car" representa el cuerpo de la BASE del auto, la posicion del sprite del dibujo (que representa el cuerpo completo del auto) debe desplazarse teniendo en cuenta la rotacion de la base.
			 * El desplazamiento siempre es en base a la altura de la base del auto.*/
			_carSprite.x = metersToPixels(_carBody.GetPosition().x) + Math.sin(_carBody.GetAngle()) * _carBaseHeightPx;
			_carSprite.y = metersToPixels(_carBody.GetPosition().y) - Math.cos(_carBody.GetAngle()) * _carBaseHeightPx;
			_carSprite.rotation = _carBody.GetAngle();
			
			_rearWheelRevoluteJoint.SetMotorSpeed(_motorSpeed);
			_rearAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * _rearAxlePrismaticJoint.GetJointTranslation()));
			_rearAxlePrismaticJoint.SetMotorSpeed((_rearAxlePrismaticJoint.GetMotorSpeed() - 2 * _rearAxlePrismaticJoint.GetJointTranslation()));
			_frontWheelRevoluteJoint.SetMotorSpeed(_motorSpeed);
			_frontAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * _frontAxlePrismaticJoint.GetJointTranslation()));
			_frontAxlePrismaticJoint.SetMotorSpeed((_frontAxlePrismaticJoint.GetMotorSpeed() - 2 * _frontAxlePrismaticJoint.GetJointTranslation()));
		}
		
		public function get sprite():Sprite  { return _carSprite; }
		
		public function get body():b2Body  { return _carBody; }
		
		/**
		 *
		 * Establece la posicion del auto. Por defecto establece la rotacion del auto y su velocidad angular y lineal en 0.
		 * Los valores de posicion se deben indicar en pixeles.
		 *
		 * @param xpx Posicion x en pixeles.
		 * @param ypx Posicion y en pixeles.
		 *
		 * */
		public function setBodyPosition(xpx:Number, ypx:Number):void
		{
			var xms:Number = pixelsToMeters(xpx);
			var yms:Number = pixelsToMeters(ypx);
			_carBody.SetPosition(new b2Vec2(xms, yms));
			_carBody.SetLinearVelocity(new b2Vec2(0, 0));
			_carBody.SetAngle(0);
			_carBody.SetAngularVelocity(0);
			_frontWheelBody.SetPosition(new b2Vec2(calculateFrontWheelOffsetXMts(), calculateFrontWheelOffsetYMts()));
			_frontWheelBody.SetLinearVelocity(new b2Vec2(0, 0));
			_rearWheelBody.SetPosition(new b2Vec2(calculateRearWheelOffsetXMts(), calculateRearWheelOffsetYMts()));
			_rearWheelBody.SetLinearVelocity(new b2Vec2(0, 0));
		}
		
		/** Anima el auto hacia una posicion.
		 * @param xpx Posicion en x en pixeles.
		 * @param ypx Posicion en y en pixeles.
		 * @param time Tiempo que debe demorar la animacion.*/
		public function tweenToPosition(xpx:Number, ypx:Number, time:Number = 1):void
		{
			var carTween:Tween = new Tween(this._carSprite, time);
			
			carTween.moveTo(xpx, ypx);
			carTween.onUpdate = function():void
			{
				setBodyPosition(xpx, ypx);
			};
			
			Starling.juggler.add(carTween);
		}
		
		public function metersToPixels(m:Number):Number
		{
			return MainBox2dWorld.metersToPixels(m);
		}
		
		public function pixelsToMeters(p:Number):Number
		{
			return MainBox2dWorld.pixelsToMeters(p);
		}
		
		private function buildBox2dBody():void
		{
			// ************************ THE CAR ************************ //
			// shape
			var carShape:b2PolygonShape = new b2PolygonShape();
			carShape.SetAsBox(pixelsToMeters(_carWidthPx / 2), pixelsToMeters(_carBaseHeightPx / 2));
			// fixture
			var carFixtureDef:b2FixtureDef = new b2FixtureDef();
			carFixtureDef.density = 5;
			carFixtureDef.friction = 3;
			carFixtureDef.restitution = 0.3;
			carFixtureDef.filter.groupIndex = -1;
			carFixtureDef.shape = carShape;
			// body definition
			_carBodyDef = new b2BodyDef();
			_carBodyDef.type = b2Body.b2_dynamicBody;
			_carBodyDef.position.Set(pixelsToMeters(320), pixelsToMeters(100));
			
			// ************************ THE TRUNK ************************ //
			// shape
			var trunkShape:b2PolygonShape = new b2PolygonShape();
			// posicion central del baul
			var trunkCenter:b2Vec2 = new b2Vec2(pixelsToMeters(-80), pixelsToMeters(-60));
			trunkShape.SetAsOrientedBox(pixelsToMeters(40), pixelsToMeters(40), trunkCenter);
			// fixture
			var trunkFixtureDef:b2FixtureDef = new b2FixtureDef();
			trunkFixtureDef.density = 1;
			trunkFixtureDef.friction = 3;
			trunkFixtureDef.restitution = 0.3;
			trunkFixtureDef.filter.groupIndex = -1;
			trunkFixtureDef.shape = trunkShape;
			
			// ************************ THE HOOD ************************ //
			// shape
			var hoodShape:b2PolygonShape = new b2PolygonShape();
			var carVector:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			carVector[0] = new b2Vec2(pixelsToMeters(-40), pixelsToMeters(-20));
			carVector[1] = new b2Vec2(pixelsToMeters(-40), pixelsToMeters(-100));
			carVector[2] = new b2Vec2(pixelsToMeters(120), pixelsToMeters(-20));
			hoodShape.SetAsVector(carVector, 3);
			// fixture
			var hoodFixtureDef:b2FixtureDef = new b2FixtureDef();
			hoodFixtureDef.density = 1;
			hoodFixtureDef.friction = 3;
			hoodFixtureDef.restitution = 0.3;
			hoodFixtureDef.filter.groupIndex = -1;
			hoodFixtureDef.shape = hoodShape;
			
			// ************************ MERGING ALL TOGETHER ************************ //
			// the car itself
			_carBody = _box2dWorld.CreateBody(_carBodyDef);
			_carBody.CreateFixture(carFixtureDef);
			var trunkFixture:b2Fixture = _carBody.CreateFixture(trunkFixtureDef);
			var hoodFixture:b2Fixture = _carBody.CreateFixture(hoodFixtureDef);
			
			_carBody.SetUserData({name: NameLibrary.CAR_BODY_NAME});
			//trunkFixture.GetBody().SetUserData({name: NameLibrary.TRUNK_BODY_NAME});
			//hoodFixture.GetBody().SetUserData({name: NameLibrary.HOOD_BODY_NAME});
			
			trunkFixture.GetBody().SetUserData({name: NameLibrary.CAR_BODY_NAME});
			hoodFixture.GetBody().SetUserData({name: NameLibrary.CAR_BODY_NAME});
			
			// ************************ THE AXLES ************************ //
			// shape
			var axleShape:b2PolygonShape = new b2PolygonShape();
			axleShape.SetAsBox(pixelsToMeters(20), pixelsToMeters(20));
			// fixture
			var axleFixtureDef:b2FixtureDef = new b2FixtureDef();
			axleFixtureDef.density = 0.5;
			axleFixtureDef.friction = 3;
			axleFixtureDef.restitution = 0.3;
			axleFixtureDef.shape = axleShape;
			axleFixtureDef.filter.groupIndex = -1;
			// body definition
			var axleBodyDef:b2BodyDef = new b2BodyDef();
			axleBodyDef.type = b2Body.b2_dynamicBody;
			// the rear axle itself
			
			axleBodyDef.position.Set(_carBody.GetWorldCenter().x - pixelsToMeters(_raxleOffsetX), _carBody.GetWorldCenter().y + pixelsToMeters(_raxleOffsetY));
			var rearAxle:b2Body = _box2dWorld.CreateBody(axleBodyDef);
			rearAxle.CreateFixture(axleFixtureDef);
			// the front axle itself
			
			axleBodyDef.position.Set(_carBody.GetWorldCenter().x + pixelsToMeters(_faxleOffsetX), _carBody.GetWorldCenter().y + pixelsToMeters(_faxleOffsetY));
			var frontAxle:b2Body = _box2dWorld.CreateBody(axleBodyDef);
			frontAxle.CreateFixture(axleFixtureDef);
			
			// ************************ THE WHEELS ************************ //
			// shape
			_wheelShape = new b2CircleShape(pixelsToMeters(_wheelRadiusPx));
			trace("wheel radius: " + _wheelShape.GetRadius());
			// fixture
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.density = 1;
			wheelFixtureDef.friction = 3;
			wheelFixtureDef.restitution = 0.1;
			wheelFixtureDef.filter.groupIndex = -1;
			wheelFixtureDef.shape = _wheelShape;
			// body definition
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			// the real wheel itself
			// Body.getWorldCenter() is the center of gravity. Body.getPosition() is the center of the AABB
			wheelBodyDef.position.Set(calculateRearWheelOffsetXMts(), calculateRearWheelOffsetYMts());
			_rearWheelBody = _box2dWorld.CreateBody(wheelBodyDef);
			_rearWheelBody.CreateFixture(wheelFixtureDef);
			// the front wheel itself
			wheelBodyDef.position.Set(calculateFrontWheelOffsetXMts(), calculateFrontWheelOffsetYMts());
			_frontWheelBody = _box2dWorld.CreateBody(wheelBodyDef);
			_frontWheelBody.CreateFixture(wheelFixtureDef);
			
			_frontWheelBody.SetUserData({name: NameLibrary.FWHEEL_BODY_NAME});
			_rearWheelBody.SetUserData({name: NameLibrary.RWHEEL_BODY_NAME});
			
			// ************************ REVOLUTE JOINTS ************************ //
			// rear joint
			var rearWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rearWheelRevoluteJointDef.Initialize(_rearWheelBody, rearAxle, _rearWheelBody.GetWorldCenter());
			rearWheelRevoluteJointDef.enableMotor = true;
			rearWheelRevoluteJointDef.maxMotorTorque = 10000;
			_rearWheelRevoluteJoint = _box2dWorld.CreateJoint(rearWheelRevoluteJointDef) as b2RevoluteJoint;
			// front joint
			var frontWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			frontWheelRevoluteJointDef.Initialize(_frontWheelBody, frontAxle, _frontWheelBody.GetWorldCenter());
			frontWheelRevoluteJointDef.enableMotor = true;
			frontWheelRevoluteJointDef.maxMotorTorque = 10000;
			_frontWheelRevoluteJoint = _box2dWorld.CreateJoint(frontWheelRevoluteJointDef) as b2RevoluteJoint;
			
			// ************************ PRISMATIC JOINTS ************************ //
			//  definition
			var axlePrismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			axlePrismaticJointDef.lowerTranslation = pixelsToMeters(-20);
			axlePrismaticJointDef.upperTranslation = pixelsToMeters(5);
			axlePrismaticJointDef.enableLimit = true;
			axlePrismaticJointDef.enableMotor = true;
			// front axle
			axlePrismaticJointDef.Initialize(_carBody, frontAxle, frontAxle.GetWorldCenter(), new b2Vec2(0, 1));
			_frontAxlePrismaticJoint = _box2dWorld.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			// rear axle
			axlePrismaticJointDef.Initialize(_carBody, rearAxle, rearAxle.GetWorldCenter(), new b2Vec2(0, 1));
			_rearAxlePrismaticJoint = _box2dWorld.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
		
		}
		
		private function buildStarlingSprites():void
		{
			// ************************ SPRITES ************************ //
			var wheelTexture:Texture = TextureRepository.getInstance().wheelTexture;
			var frontWheelImg:Image = new Image(wheelTexture);
			_frontWheelSprite = new Sprite();
			_frontWheelSprite.addChild(frontWheelImg);
			_frontWheelSprite.alignPivot();
			_frontWheelSprite.width = metersToPixels(_wheelShape.GetRadius() * 2);
			_frontWheelSprite.height = metersToPixels(_wheelShape.GetRadius() * 2);
			
			var rearWheelImg:Image = new Image(wheelTexture);
			_rearWheelSprite = new Sprite();
			_rearWheelSprite.addChild(rearWheelImg);
			_rearWheelSprite.alignPivot();
			_rearWheelSprite.width = metersToPixels(_wheelShape.GetRadius() * 2);
			_rearWheelSprite.height = metersToPixels(_wheelShape.GetRadius() * 2);
			
			var carTexture:Texture = TextureRepository.getInstance().carTexture;
			var carImg:Image = new Image(carTexture);
			_carSprite = new Sprite();
			_carSprite.width = metersToPixels(_carWidthPx);
			_carSprite.height = metersToPixels(_carHeightPx);
			_carSprite.addChild(carImg);
			_carSprite.alignPivot();
		
		}
		
		private function calculateRearWheelOffsetXMts():Number
		{
			return _carBody.GetWorldCenter().x - pixelsToMeters(_raxleOffsetX);
		}
		
		private function calculateRearWheelOffsetYMts():Number
		{
			return _carBody.GetWorldCenter().y + pixelsToMeters(_raxleOffsetY);
		}
		
		private function calculateFrontWheelOffsetXMts():Number
		{
			return _carBody.GetWorldCenter().x + pixelsToMeters(_faxleOffsetX);
		}
		
		private function calculateFrontWheelOffsetYMts():Number
		{
			return _carBody.GetWorldCenter().y + pixelsToMeters(_faxleOffsetY);
		}
	}
}