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
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author martin
	 */
	public class DummyCar
	{
		private var box2dWorld:b2World;
		private var car:b2Body;
		private var carBodyDef:b2BodyDef;
		private var rearWheelRevoluteJoint:b2RevoluteJoint;
		private var frontWheelRevoluteJoint:b2RevoluteJoint;
		private var frontAxlePrismaticJoint:b2PrismaticJoint;
		private var rearAxlePrismaticJoint:b2PrismaticJoint;
		private var rearWheel:b2Body;
		private var frontWheel:b2Body;
		
		private var frontWheelSprite:Sprite;
		private var rearWheelSprite:Sprite;
		private var carSprite:Sprite;
		
		
		private var carWidthPx:Number = 240;
		private var carHeightPx:Number = 120;
		private var carBaseHeightPx:Number = 40;
		
		private var motorSpeed:Number = 0;
		private var left:Boolean;
		private var right:Boolean;
		
		public function DummyCar()
		{
			this.box2dWorld = MainBox2dWorld.getInstance().world;			
		}
		
		public function addToWorld(starlingWorld:Sprite):void
		{
						// ************************ THE CAR ************************ //
			// shape
			var carShape:b2PolygonShape = new b2PolygonShape();
			carShape.SetAsBox(pixelsToMeters(carWidthPx / 2), pixelsToMeters(carBaseHeightPx / 2));
			// fixture
			var carFixture:b2FixtureDef = new b2FixtureDef();
			carFixture.density = 5;
			carFixture.friction = 3;
			carFixture.restitution = 0.3;
			carFixture.filter.groupIndex = -1;
			carFixture.shape = carShape;
			// body definition
			carBodyDef = new b2BodyDef();
			carBodyDef.type = b2Body.b2_dynamicBody;
			carBodyDef.position.Set(pixelsToMeters(320), pixelsToMeters(100));
			
			// ************************ THE TRUNK ************************ //
			// shape
			var trunkShape:b2PolygonShape = new b2PolygonShape();
			// posicion central del baul
			var trunkCenter:b2Vec2 = new b2Vec2(pixelsToMeters(-80), pixelsToMeters(-60));
			trunkShape.SetAsOrientedBox(pixelsToMeters(40), pixelsToMeters(40), trunkCenter);
			// fixture
			var trunkFixture:b2FixtureDef = new b2FixtureDef();
			trunkFixture.density = 1;
			trunkFixture.friction = 3;
			trunkFixture.restitution = 0.3;
			trunkFixture.filter.groupIndex = -1;
			trunkFixture.shape = trunkShape;
			
			// ************************ THE HOOD ************************ //
			// shape
			var hoodShape:b2PolygonShape = new b2PolygonShape();
			var carVector:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			carVector[0] = new b2Vec2(pixelsToMeters(-40), pixelsToMeters(-20));
			carVector[1] = new b2Vec2(pixelsToMeters(-40), pixelsToMeters(-100));
			carVector[2] = new b2Vec2(pixelsToMeters(120), pixelsToMeters(-20));
			hoodShape.SetAsVector(carVector, 3);
			// fixture
			var hoodFixture:b2FixtureDef = new b2FixtureDef();
			hoodFixture.density = 1;
			hoodFixture.friction = 3;
			hoodFixture.restitution = 0.3;
			hoodFixture.filter.groupIndex = -1;
			hoodFixture.shape = hoodShape;
			
			// ************************ MERGING ALL TOGETHER ************************ //
			// the car itself
			car = box2dWorld.CreateBody(carBodyDef);
			car.CreateFixture(carFixture);
			car.CreateFixture(trunkFixture);
			car.CreateFixture(hoodFixture);
			
			// ************************ THE AXLES ************************ //
			// shape
			var axleShape:b2PolygonShape = new b2PolygonShape();
			axleShape.SetAsBox(pixelsToMeters(20), pixelsToMeters(20));
			// fixture
			var axleFixture:b2FixtureDef = new b2FixtureDef();
			axleFixture.density = 0.5;
			axleFixture.friction = 3;
			axleFixture.restitution = 0.3;
			axleFixture.shape = axleShape;
			axleFixture.filter.groupIndex = -1;
			// body definition
			var axleBodyDef:b2BodyDef = new b2BodyDef();
			axleBodyDef.type = b2Body.b2_dynamicBody;
			// the rear axle itself
			axleBodyDef.position.Set(car.GetWorldCenter().x - pixelsToMeters(60), car.GetWorldCenter().y + pixelsToMeters(65));
			var rearAxle:b2Body = box2dWorld.CreateBody(axleBodyDef);
			rearAxle.CreateFixture(axleFixture);
			// the front axle itself
			axleBodyDef.position.Set(car.GetWorldCenter().x + pixelsToMeters(75), car.GetWorldCenter().y + pixelsToMeters(65));
			var frontAxle:b2Body = box2dWorld.CreateBody(axleBodyDef);
			frontAxle.CreateFixture(axleFixture);
			
			// ************************ THE WHEELS ************************ //
			// shape
			var wheelShape:b2CircleShape = new b2CircleShape(pixelsToMeters(40));
			trace("wheel radius: " + wheelShape.GetRadius());
			// fixture
			var wheelFixture:b2FixtureDef = new b2FixtureDef();
			wheelFixture.density = 1;
			wheelFixture.friction = 3;
			wheelFixture.restitution = 0.1;
			wheelFixture.filter.groupIndex = -1;
			wheelFixture.shape = wheelShape;
			// body definition
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			// the real wheel itself
			wheelBodyDef.position.Set(car.GetWorldCenter().x - pixelsToMeters(60), car.GetWorldCenter().y + pixelsToMeters(65));
			rearWheel = box2dWorld.CreateBody(wheelBodyDef);
			rearWheel.CreateFixture(wheelFixture);
			// the front wheel itself
			wheelBodyDef.position.Set(car.GetWorldCenter().x + pixelsToMeters(75), car.GetWorldCenter().y + pixelsToMeters(65));
			frontWheel = box2dWorld.CreateBody(wheelBodyDef);
			frontWheel.CreateFixture(wheelFixture);
			
			// ************************ REVOLUTE JOINTS ************************ //
			// rear joint
			var rearWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rearWheelRevoluteJointDef.Initialize(rearWheel, rearAxle, rearWheel.GetWorldCenter());
			rearWheelRevoluteJointDef.enableMotor = true;
			rearWheelRevoluteJointDef.maxMotorTorque = 10000;
			rearWheelRevoluteJoint = box2dWorld.CreateJoint(rearWheelRevoluteJointDef) as b2RevoluteJoint;
			// front joint
			var frontWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			frontWheelRevoluteJointDef.Initialize(frontWheel, frontAxle, frontWheel.GetWorldCenter());
			frontWheelRevoluteJointDef.enableMotor = true;
			frontWheelRevoluteJointDef.maxMotorTorque = 10000;
			frontWheelRevoluteJoint = box2dWorld.CreateJoint(frontWheelRevoluteJointDef) as b2RevoluteJoint;
			
			// ************************ PRISMATIC JOINTS ************************ //
			//  definition
			var axlePrismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			axlePrismaticJointDef.lowerTranslation = pixelsToMeters(-20);
			axlePrismaticJointDef.upperTranslation = pixelsToMeters(5);
			axlePrismaticJointDef.enableLimit = true;
			axlePrismaticJointDef.enableMotor = true;
			// front axle
			axlePrismaticJointDef.Initialize(car, frontAxle, frontAxle.GetWorldCenter(), new b2Vec2(0, 1));
			frontAxlePrismaticJoint = box2dWorld.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			// rear axle
			axlePrismaticJointDef.Initialize(car, rearAxle, rearAxle.GetWorldCenter(), new b2Vec2(0, 1));
			rearAxlePrismaticJoint = box2dWorld.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			
			// ************************ SPRITES ************************ //
			var wheelTexture:Texture = TextureRepository.getInstance().wheelTexture;
			var frontWheelImg:Image = new Image(wheelTexture);
			frontWheelSprite = new Sprite();
			frontWheelSprite.addChild(frontWheelImg);
			frontWheelSprite.alignPivot();
			frontWheelSprite.width = metersToPixels(wheelShape.GetRadius() * 2);
			frontWheelSprite.height = metersToPixels(wheelShape.GetRadius() * 2);
			
			var rearWheelImg:Image = new Image(wheelTexture);
			rearWheelSprite = new Sprite();
			rearWheelSprite.addChild(rearWheelImg);
			rearWheelSprite.alignPivot();
			rearWheelSprite.width = metersToPixels(wheelShape.GetRadius() * 2);
			rearWheelSprite.height = metersToPixels(wheelShape.GetRadius() * 2);
			
			var carTexture:Texture = TextureRepository.getInstance().carTexture;
			var carImg:Image = new Image(carTexture);
			carSprite = new Sprite();
			carSprite.width = metersToPixels(carWidthPx);
			carSprite.height = metersToPixels(carHeightPx);
			carSprite.addChild(carImg);
			carSprite.alignPivot();

			
			starlingWorld.addChild(frontWheelSprite);
			starlingWorld.addChild(rearWheelSprite);
			starlingWorld.addChild(carSprite);
		}
		
		public function goLeft():void
		{
			left = true;
		}
		
		public function stopLeft():void
		{
			left = false;
		}
		
		public function goRight():void
		{
			right = true;
		}
		
		public function stopRight():void
		{
			right = false;
		}
		
		public function update(time:Number):void
		{
			if (left)
			{
				motorSpeed += 0.1;
			}
			if (right)
			{
				motorSpeed -= 0.1;
			}
			motorSpeed *= 0.99;
			if (motorSpeed > 100)
			{
				motorSpeed = 100;
			}
			
			frontWheelSprite.x = metersToPixels(frontWheel.GetPosition().x);
			frontWheelSprite.y = metersToPixels(frontWheel.GetPosition().y);
			frontWheelSprite.rotation = frontWheel.GetAngle();
			
			rearWheelSprite.x = metersToPixels(rearWheel.GetPosition().x);
			rearWheelSprite.y = metersToPixels(rearWheel.GetPosition().y);
			rearWheelSprite.rotation = rearWheel.GetAngle();
			
			/* debido a que "car" representa el cuerpo de la BASE del auto, la posicion del sprite del dibujo (que representa el cuerpo completo del auto) debe desplazarse teniendo en cuenta la rotacion de la base.
			 * El desplazamiento siempre es en base a la altura de la base del auto.*/
			carSprite.x = metersToPixels(car.GetPosition().x) + Math.sin(car.GetAngle()) * carBaseHeightPx;
			carSprite.y = metersToPixels(car.GetPosition().y) - Math.cos(car.GetAngle()) * carBaseHeightPx;
			carSprite.rotation = car.GetAngle();
			
			rearWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			frontWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			frontAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * frontAxlePrismaticJoint.GetJointTranslation()));
			frontAxlePrismaticJoint.SetMotorSpeed((frontAxlePrismaticJoint.GetMotorSpeed() - 2 * frontAxlePrismaticJoint.GetJointTranslation()));
			rearAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * rearAxlePrismaticJoint.GetJointTranslation()));
			rearAxlePrismaticJoint.SetMotorSpeed((rearAxlePrismaticJoint.GetMotorSpeed() - 2 * rearAxlePrismaticJoint.GetJointTranslation()));
		}
		
		public function get sprite():Sprite  { return carSprite; }
		public function get box2dBody():b2Body { return car; }
		
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