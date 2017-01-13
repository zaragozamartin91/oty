package
{
	import starling.display.Quad;
	import starling.utils.Color;
	import starling.core.Starling;
	
	import flash.display.Sprite;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	
	public class Game extends starling.display.Sprite
	{
		private var world:b2World = new b2World(new b2Vec2(0, 10), true);
		private var worldScale:int = 30;
		private var car:b2Body;
		private var rearWheelRevoluteJoint:b2RevoluteJoint;
		private var frontWheelRevoluteJoint:b2RevoluteJoint;
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var motorSpeed:Number = 0;
		private var frontAxlePrismaticJoint:b2PrismaticJoint;
		private var rearAxlePrismaticJoint:b2PrismaticJoint;
		
		public function Game():void
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{	
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			debugDraw();
			
			// ************************ THE FLOOR ************************ //
			// shape
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(640 / worldScale, 10 / worldScale);
			// fixture
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density = 0;
			floorFixture.friction = 3;
			floorFixture.restitution = 0;
			floorFixture.shape = floorShape;
			// body definition
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(320 / worldScale, 480 / worldScale);
			// the floor itself
			var floor:b2Body = world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			
			// ************************ THE CAR ************************ //
			// shape
			var carShape:b2PolygonShape = new b2PolygonShape();
			carShape.SetAsBox(120 / worldScale, 20 / worldScale);
			// fixture
			var carFixture:b2FixtureDef = new b2FixtureDef();
			carFixture.density = 5;
			carFixture.friction = 3;
			carFixture.restitution = 0.3;
			carFixture.filter.groupIndex = -1;
			carFixture.shape = carShape;
			// body definition
			var carBodyDef:b2BodyDef = new b2BodyDef();
			carBodyDef.type = b2Body.b2_dynamicBody;
			carBodyDef.position.Set(320 / worldScale, 100 / worldScale);
			
			// ************************ THE TRUNK ************************ //
			// shape
			var trunkShape:b2PolygonShape = new b2PolygonShape();
			// posicion central del baul
			var trunkCenter:b2Vec2 = new b2Vec2(-80 / worldScale, -60 / worldScale);
			trunkShape.SetAsOrientedBox(40 / worldScale, 40 / worldScale, trunkCenter);
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
			carVector[0] = new b2Vec2(-40 / worldScale, -20 / worldScale);
			carVector[1] = new b2Vec2(-40 / worldScale, -100 / worldScale);
			carVector[2] = new b2Vec2(120 / worldScale, -20 / worldScale);
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
			car = world.CreateBody(carBodyDef);
			car.CreateFixture(carFixture);
			car.CreateFixture(trunkFixture);
			car.CreateFixture(hoodFixture);
			
			// ************************ THE AXLES ************************ //
			// shape
			var axleShape:b2PolygonShape = new b2PolygonShape();
			axleShape.SetAsBox(20 / worldScale, 20 / worldScale);
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
			axleBodyDef.position.Set(car.GetWorldCenter().x - (60 / worldScale), car.GetWorldCenter().y + (65 / worldScale));
			var rearAxle:b2Body = world.CreateBody(axleBodyDef);
			rearAxle.CreateFixture(axleFixture);
			// the front axle itself
			axleBodyDef.position.Set(car.GetWorldCenter().x + (75 / worldScale), car.GetWorldCenter().y + (65 / worldScale));
			var frontAxle:b2Body = world.CreateBody(axleBodyDef);
			frontAxle.CreateFixture(axleFixture);
			
			// ************************ THE WHEELS ************************ //
			// shape
			var wheelShape:b2CircleShape = new b2CircleShape(40 / worldScale);
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
			wheelBodyDef.position.Set(car.GetWorldCenter().x - (60 / worldScale), car.GetWorldCenter().y + (65 / worldScale));
			var rearWheel:b2Body = world.CreateBody(wheelBodyDef);
			rearWheel.CreateFixture(wheelFixture);
			// the front wheel itself
			wheelBodyDef.position.Set(car.GetWorldCenter().x + (75 / worldScale), car.GetWorldCenter().y + (65 / worldScale));
			var frontWheel:b2Body = world.CreateBody(wheelBodyDef);
			frontWheel.CreateFixture(wheelFixture);
			
			// ************************ REVOLUTE JOINTS ************************ //
			// rear joint
			var rearWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rearWheelRevoluteJointDef.Initialize(rearWheel, rearAxle, rearWheel.GetWorldCenter());
			rearWheelRevoluteJointDef.enableMotor = true;
			rearWheelRevoluteJointDef.maxMotorTorque = 10000;
			rearWheelRevoluteJoint = world.CreateJoint(rearWheelRevoluteJointDef) as b2RevoluteJoint;
			// front joint
			var frontWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			frontWheelRevoluteJointDef.Initialize(frontWheel, frontAxle, frontWheel.GetWorldCenter());
			frontWheelRevoluteJointDef.enableMotor = true;
			frontWheelRevoluteJointDef.maxMotorTorque = 10000;
			frontWheelRevoluteJoint = world.CreateJoint(frontWheelRevoluteJointDef) as b2RevoluteJoint;
			
			// ************************ PRISMATIC JOINTS ************************ //
			//  definition
			var axlePrismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			axlePrismaticJointDef.lowerTranslation = -20 / worldScale;
			axlePrismaticJointDef.upperTranslation = 5 / worldScale;
			axlePrismaticJointDef.enableLimit = true;
			axlePrismaticJointDef.enableMotor = true;
			// front axle
			axlePrismaticJointDef.Initialize(car, frontAxle, frontAxle.GetWorldCenter(), new b2Vec2(0, 1));
			frontAxlePrismaticJoint = world.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			// rear axle
			axlePrismaticJointDef.Initialize(car, rearAxle, rearAxle.GetWorldCenter(), new b2Vec2(0, 1));
			rearAxlePrismaticJoint = world.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		

		
		public function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Starling.current.nativeOverlay);
			debugDraw.SetDrawScale(30);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			world.SetDebugDraw(debugDraw);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			trace(e.keyCode);
			switch (e.keyCode)
			{
			case 37: 
				left = true;
				break;
			case 39: 
				right = true;
				break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				left = false;
				break;
			case 39: 
				right = false;
				break;
			}
		}
		
		private function updateWorld(e:Event):void
		{
			trace(e);
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
			rearWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			frontWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			frontAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * frontAxlePrismaticJoint.GetJointTranslation()));
			frontAxlePrismaticJoint.SetMotorSpeed((frontAxlePrismaticJoint.GetMotorSpeed() - 2 * frontAxlePrismaticJoint.GetJointTranslation()));
			rearAxlePrismaticJoint.SetMaxMotorForce(Math.abs(600 * rearAxlePrismaticJoint.GetJointTranslation()));
			rearAxlePrismaticJoint.SetMotorSpeed((rearAxlePrismaticJoint.GetMotorSpeed() - 2 * rearAxlePrismaticJoint.GetJointTranslation()));
			world.Step(1 / 30, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
		}
	}

}
