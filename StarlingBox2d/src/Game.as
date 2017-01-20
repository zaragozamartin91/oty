package
{
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.core.Starling;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	
	public class Game extends starling.display.Sprite
	{
		[Embed(source = "forward-button.png")]
		public static const ForwardButtonBmp:Class;
		
		[Embed(source = "wheel.png")]
		public static const WheelBmp:Class;
		
		[Embed(source = "car.png")]
		public static const CarBmp:Class;
		
		[Embed(source = "oty.png")]
		public static const OtyBmp:Class;
		
		public static const PIXELS_TO_METER:int = 30;
		public static const WORLD_STEP:Number = 1 / 30;
		
		private var world:b2World = new b2World(new b2Vec2(0, 10), true);
		
		private var car:b2Body;
		private var carBodyDef:b2BodyDef;
		private var rearWheelRevoluteJoint:b2RevoluteJoint;
		private var frontWheelRevoluteJoint:b2RevoluteJoint;
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var motorSpeed:Number = 0;
		private var frontAxlePrismaticJoint:b2PrismaticJoint;
		private var rearAxlePrismaticJoint:b2PrismaticJoint;
		private var rearWheel:b2Body;
		private var frontWheel:b2Body;
		
		private var frontWheelSprite:Sprite;
		private var rearWheelSprite:Sprite;
		private var carSprite:Sprite;
		private var moveButtonTexture:Texture;
		
		private var carWidthPx:Number = 240;
		private var carHeightPx:Number = 120;
		private var carBaseHeightPx:Number = 40;
		
		public function Game():void
		{
		}
		
		public function start():void
		{
			trace("INIT!");
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			debugDraw();
			
			// ************************ THE FLOOR ************************ //
			// shape
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(pixelsToMeters(stage.stageWidth) / 2, pixelsToMeters(10));
			// fixture
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density = 0;
			floorFixture.friction = 3;
			floorFixture.restitution = 0;
			floorFixture.shape = floorShape;
			// body definition
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(pixelsToMeters(stage.stageWidth) / 2, pixelsToMeters(stage.stageHeight));
			// the floor itself
			var floor:b2Body = world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			
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
			car = world.CreateBody(carBodyDef);
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
			var rearAxle:b2Body = world.CreateBody(axleBodyDef);
			rearAxle.CreateFixture(axleFixture);
			// the front axle itself
			axleBodyDef.position.Set(car.GetWorldCenter().x + pixelsToMeters(75), car.GetWorldCenter().y + pixelsToMeters(65));
			var frontAxle:b2Body = world.CreateBody(axleBodyDef);
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
			rearWheel = world.CreateBody(wheelBodyDef);
			rearWheel.CreateFixture(wheelFixture);
			// the front wheel itself
			wheelBodyDef.position.Set(car.GetWorldCenter().x + pixelsToMeters(75), car.GetWorldCenter().y + pixelsToMeters(65));
			frontWheel = world.CreateBody(wheelBodyDef);
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
			axlePrismaticJointDef.lowerTranslation = pixelsToMeters(-20);
			axlePrismaticJointDef.upperTranslation = pixelsToMeters(5);
			axlePrismaticJointDef.enableLimit = true;
			axlePrismaticJointDef.enableMotor = true;
			// front axle
			axlePrismaticJointDef.Initialize(car, frontAxle, frontAxle.GetWorldCenter(), new b2Vec2(0, 1));
			frontAxlePrismaticJoint = world.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			// rear axle
			axlePrismaticJointDef.Initialize(car, rearAxle, rearAxle.GetWorldCenter(), new b2Vec2(0, 1));
			rearAxlePrismaticJoint = world.CreateJoint(axlePrismaticJointDef) as b2PrismaticJoint;
			
			/* SPRITES ----------------------------------------------------------------------------------------------------- */
			
			moveButtonTexture = Texture.fromEmbeddedAsset(ForwardButtonBmp);
			addForwardButton();
			addBackButton();
			
			var wheelTexture:Texture = Texture.fromEmbeddedAsset(WheelBmp);
			var frontWheelImg:Image = new Image(wheelTexture);
			frontWheelSprite = new Sprite();
			frontWheelSprite.addChild(frontWheelImg);
			frontWheelSprite.alignPivot();
			frontWheelSprite.width = metersToPixels(wheelShape.GetRadius() * 2);
			frontWheelSprite.height = metersToPixels(wheelShape.GetRadius() * 2);
			addChild(frontWheelSprite);
			
			var rearWheelImg:Image = new Image(wheelTexture);
			rearWheelSprite = new Sprite();
			rearWheelSprite.addChild(rearWheelImg);
			rearWheelSprite.alignPivot();
			rearWheelSprite.width = metersToPixels(wheelShape.GetRadius() * 2);
			rearWheelSprite.height = metersToPixels(wheelShape.GetRadius() * 2);
			addChild(rearWheelSprite);
			
			var carTexture:Texture = Texture.fromEmbeddedAsset(CarBmp);
			var carImg:Image = new Image(carTexture);
			carSprite = new Sprite();
			carSprite.width = metersToPixels(carWidthPx);
			carSprite.height = metersToPixels(carHeightPx);
			carSprite.addChild(carImg);
			carSprite.alignPivot();
			addChild(carSprite);
			
			var otyTexture:Texture = Texture.fromEmbeddedAsset(OtyBmp);
			var otySprite:Sprite = new Sprite();
			otySprite.addChild(new Image(otyTexture));
			otySprite.scale = 0.2;
			otySprite.alignPivot();
			otySprite.x = stage.stageWidth / 2;
			otySprite.y = stage.stageHeight * 0.25;
			addChild(otySprite);
			var otyTween:Tween = new Tween(otySprite, 2);
			otyTween.animate("scale", 0.5);
			otyTween.animate("alpha", 0.5);
			otyTween.animate("rotation", Math.PI * 2);
			Starling.juggler.add(otyTween);
			
			/* LISTENERS ----------------------------------------------------------------------------------------------------- */
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		private function addForwardButton():void
		{
			var buttonImg:Image = new Image(moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			buttonSprite.alignPivot();
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			buttonSprite.x = stage.stageWidth - buttonSprite.width / 2;
			buttonSprite.y = buttonSprite.height / 2;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onForwardButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function addBackButton():void
		{
			var buttonImg:Image = new Image(moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			buttonSprite.alignPivot();
			buttonSprite.rotation = Math.PI;
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			buttonSprite.x = stage.stageWidth - buttonSprite.width * 1.25;
			buttonSprite.y = buttonSprite.height / 2;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onBackButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function onForwardButtonTouch(event:TouchEvent):void
		{
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var localPos:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + localPos);
				right = true;
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var localPos:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + localPos);
				right = false;
			}
		}
		
		private function onBackButtonTouch(event:TouchEvent):void
		{
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var touchPosStart:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + touchPosStart);
				left = true;
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var touchPosEnd:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + touchPosEnd);
				left = false;
			}
		}
		
		public function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Starling.current.nativeOverlay);
			debugDraw.SetDrawScale(PIXELS_TO_METER);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			//debugDraw.SetDrawScale(50);
			world.SetDebugDraw(debugDraw);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				trace("LEFT");
				left = true;
				break;
			case 39: 
				trace("RIGHT");
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
		
		// este metodo sera invocado en cada frame
		private function updateWorld(e:Event):void
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
			world.Step(WORLD_STEP, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
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
