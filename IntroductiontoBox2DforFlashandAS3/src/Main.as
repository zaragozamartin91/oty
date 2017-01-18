package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite
	{
		public var world:b2World;
		public var wheelBody:b2Body;
		public var groundBody:b2Body;
		public var stepTimer:Timer;
		public var timeStep:Number = 0.025;
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			getStarted();
		}
		
		private function getStarted():void
		{
			var gravity:b2Vec2 = new b2Vec2(0, 10);
			world = new b2World(gravity, true);
			
			/* A body definition, which is like a template for creating...
			   A body, which has a mass and a position, but doesn't have...
			   A shape, which could be as simple as a circle, that must be connected to a body using...
			   A fixture, which is created using...
			   A fixture definition which is another template, like the body definition*/
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			//By default, all Box2D bodies are static, meaning that they don't move
			//We need our wheel to be dynamic, so that it can move. Guess how we define this property of the body? Using the body definition.
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			wheelBody = world.CreateBody(wheelBodyDef);
			var circleShape:b2CircleShape = new b2CircleShape(5); // radius of the circle
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.shape = circleShape;
			var wheelFixture:b2Fixture = wheelBody.CreateFixture(wheelFixtureDef);
			
			// creamos un rectangulo como cuerpo estatico para el suelo
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0, stage.stageHeight);
			groundBody = world.CreateBody(groundBodyDef);
			var groundShape:b2PolygonShape = new b2PolygonShape();
			groundShape.SetAsBox(stage.stageWidth, 1);
			var groundFixtureDef:b2FixtureDef = new b2FixtureDef();
			groundFixtureDef.shape = groundShape;
			var groundFixture:b2Fixture = groundBody.CreateFixture(groundFixtureDef);
			
			var rightWallBodyDef:b2BodyDef = new b2BodyDef();
			rightWallBodyDef.position.Set(stage.stageWidth, 0);
			var rightWallBody:b2Body = world.CreateBody(rightWallBodyDef);
			var rightWallShape:b2PolygonShape = new b2PolygonShape();
			rightWallShape.SetAsBox(1, stage.stageHeight);
			var rightWallFixtureDef:b2FixtureDef = new b2FixtureDef();
			rightWallFixtureDef.shape = rightWallShape;
			var rightWallFixture:b2Fixture = rightWallBody.CreateFixture(rightWallFixtureDef);
			
			var leftWallBodyDef:b2BodyDef = new b2BodyDef();
			leftWallBodyDef.position.Set(0, 0);
			var leftWallBody:b2Body = world.CreateBody(leftWallBodyDef);
			var leftWallShape:b2PolygonShape = new b2PolygonShape();
			leftWallShape.SetAsBox(1, stage.stageHeight);
			var leftWallFixtureDef:b2FixtureDef = new b2FixtureDef();
			leftWallFixtureDef.shape = leftWallShape;
			var leftWallFixture:b2Fixture = leftWallBody.CreateFixture(leftWallFixtureDef);
			
			var ceilingBodyDef:b2BodyDef = new b2BodyDef();
			ceilingBodyDef.position.Set(0, 0);
			var ceilingBody:b2Body = world.CreateBody(ceilingBodyDef);
			var ceilingShape:b2PolygonShape = new b2PolygonShape();
			ceilingShape.SetAsBox(stage.stageWidth, 1);
			var ceilingFixtureDef:b2FixtureDef = new b2FixtureDef();
			ceilingFixtureDef.shape = ceilingShape;
			var ceilingFixture:b2Fixture = ceilingBody.CreateFixture(ceilingFixtureDef);
			
			//The GetPosition() method of a body returns a b2Vec2
			trace(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
			
			/*The first parameter we pass to Step() is the number of seconds to simulate passing in the Box2D world.
			 * The other two parameters specify how much accuracy Box2D should use in all the mathematical calculations
			 * it uses to simulate the passing of time*/
			world.Step(timeStep, 10, 10);
			trace(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
			
			// se establece una velocidad horizontal iniciala la rueda
			var startingVelocity:b2Vec2 = new b2Vec2(200, 0);
			wheelBody.SetLinearVelocity(startingVelocity);
			
			//I've given the timer a period of 0.025 seconds
			stepTimer = new Timer(timeStep * 1000);
			stepTimer.addEventListener(TimerEvent.TIMER, onTick);
			trace(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
			graphics.lineStyle(3, 0xff0000);
			stepTimer.start();
		}
		
		private function onTick(a_event:TimerEvent):void
		{
			// Se mueve el lienzo y se dibuja una linea por donde pasa la rueda
			// se limpia el lienzo
			graphics.clear();
			graphics.lineStyle(30, 0xff0000);
			world.Step(timeStep, 10, 10);
			// se dibuja un circulo donde se encuentra la rueda de box2d
			graphics.drawCircle(wheelBody.GetPosition().x, wheelBody.GetPosition().y, 5);
		}
	
	}

}