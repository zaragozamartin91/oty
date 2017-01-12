package {
   
   import flash.display.Sprite;
   import flash.events.Event;

   import Box2D.Dynamics.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Joints.*;
   
   public class TruckGame extends Sprite {
      
      public const ITERATIONS      : int       = 30;
      public const TIME_STEP       : Number    = 1.0/60.0;
      public const SCREEN_WIDTH    : int       = 800;
      public const SCREEN_HEIGHT   : int      = 500;
      public const DRAW_SCALE      : Number   = 50;
      
      private var world    : b2World;
      private var cart    : b2Body;
      private var wheel1    : b2Body;
      private var wheel2    : b2Body;
      private var axle1   : b2Body;
      private var axle2   : b2Body;
      private var motor1   : b2RevoluteJoint;
      private var motor2   : b2RevoluteJoint;
      private var spring1   : b2PrismaticJoint;
      private var spring2   : b2PrismaticJoint;
      
      private var screen   : Sprite;
      private var input   : Input;

      
      public function TruckGame() : void {
         
         // create the drawing screen //
         screen = new Sprite();
         screen.scaleY = -1;
         screen.y = SCREEN_HEIGHT;
         addChild(screen);
         
         // initialize input object //
         input = new Input(this);
         
         // add main loop event listener //
         addEventListener(Event.ENTER_FRAME, update, false, 0, true);
         
         init();
         
      }
      
      private function init() : void {

         // create world //
         var worldAABB:b2AABB = new b2AABB();
         
         worldAABB.lowerBound.Set(-200, -100);
         worldAABB.upperBound.Set(200, 200);
         
         world = new b2World(worldAABB, new b2Vec2(0, -10.0), true);
         
         
         // allow debug drawing //
         var debugDraw : b2DebugDraw = new b2DebugDraw();
         debugDraw.m_sprite          = screen;
         debugDraw.m_drawScale       = DRAW_SCALE;
         debugDraw.m_fillAlpha       = 0.1;
         debugDraw.m_lineThickness    = 2.0;
         debugDraw.m_drawFlags       = 1;
         
         world.SetDebugDraw(debugDraw);
         
         
         // temporary variables for adding new bodies //
         var i               : int;
         var body             : b2Body;
         var bodyDef          : b2BodyDef;
         var boxDef             : b2PolygonDef;
         var circleDef          : b2CircleDef;
         var revoluteJointDef   : b2RevoluteJointDef;
         var prismaticJointDef   : b2PrismaticJointDef;
         
         
         // add the ground //
         bodyDef = new b2BodyDef();
         bodyDef.position.Set(0, 0.5);
         
         boxDef = new b2PolygonDef();
         boxDef.SetAsBox(50, 0.5);
         boxDef.friction = 1;
         boxDef.density = 0; 
         
         body = world.CreateBody(bodyDef);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(1, 2, new b2Vec2(-50, 0.5), 0);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(1, 2, new b2Vec2(50, 0.5), 0);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(5, 1.5), Math.PI/4);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(3.5, 1), Math.PI/8);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(9, 1.5), -Math.PI/4);
         body.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(10.5, 1), -Math.PI/8);
         body.CreateShape(boxDef);
         
         body.SetMassFromShapes();
         
         
         // add random shit //
         circleDef = new b2CircleDef();
         circleDef.density = 0.01;
         circleDef.friction = 0.1;
         circleDef.restitution = 0.5;
         
         for (i = 0; i < 30; i++) {
            circleDef.radius = Math.random()/20+0.02;
            
            bodyDef = new b2BodyDef();
            bodyDef.position.Set(Math.random()*35+15, 1);
            bodyDef.allowSleep = true;
            bodyDef.linearDamping = 0.1;
            bodyDef.angularDamping = 0.1;
            
            body = world.CreateBody(bodyDef);
            
            body.CreateShape(circleDef);
            body.SetMassFromShapes();
         }
         
         
         // add cart //
         bodyDef = new b2BodyDef();
         bodyDef.position.Set(0, 3.5);

         cart = world.CreateBody(bodyDef);
         
         boxDef = new b2PolygonDef();
         boxDef.density = 2;
         boxDef.friction = 0.5;
         boxDef.restitution = 0.2;
         boxDef.filter.groupIndex = -1;
         
         boxDef.SetAsBox(1.5, 0.3);
         cart.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(-1, -0.3), Math.PI/3);
         cart.CreateShape(boxDef);
         
         boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(1, -0.3), -Math.PI/3);
         cart.CreateShape(boxDef);
         
         cart.SetMassFromShapes();
         
         boxDef.density = 1;
         
         
         // add the axles //
         axle1 = world.CreateBody(bodyDef);
         
         boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI/3), -0.3 - 0.6*Math.sin(Math.PI/3)), Math.PI/3);
         axle1.CreateShape(boxDef);
         axle1.SetMassFromShapes();
         
         prismaticJointDef = new b2PrismaticJointDef();
         prismaticJointDef.Initialize(cart, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
         prismaticJointDef.lowerTranslation = -0.3;
         prismaticJointDef.upperTranslation = 0.5;
         prismaticJointDef.enableLimit = true;
         prismaticJointDef.enableMotor = true;
         
         spring1 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
         
         
         axle2 = world.CreateBody(bodyDef);
         
         boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6*Math.cos(-Math.PI/3), -0.3 + 0.6*Math.sin(-Math.PI/3)), -Math.PI/3);
         axle2.CreateShape(boxDef);
         axle2.SetMassFromShapes();
         
         prismaticJointDef.Initialize(cart, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
         
         spring2 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
         
         
         // add wheels //
         circleDef.radius = 0.7;
         circleDef.density = 0.1;
         circleDef.friction = 5;
         circleDef.restitution = 0.2;
         circleDef.filter.groupIndex = -1;
         
         for (i = 0; i < 2; i++) {
            
            bodyDef = new b2BodyDef();
            if (i == 0) bodyDef.position.Set(axle1.GetWorldCenter().x - 0.3*Math.cos(Math.PI/3), axle1.GetWorldCenter().y - 0.3*Math.sin(Math.PI/3));
            else bodyDef.position.Set(axle2.GetWorldCenter().x + 0.3*Math.cos(-Math.PI/3), axle2.GetWorldCenter().y + 0.3*Math.sin(-Math.PI/3));
            bodyDef.allowSleep = false;
            
            if (i == 0) wheel1 = world.CreateBody(bodyDef);
            else wheel2 = world.CreateBody(bodyDef);
            
            (i == 0 ? wheel1 : wheel2).CreateShape(circleDef);
            (i == 0 ? wheel1 : wheel2).SetMassFromShapes();
            
         }
         
         
         // add joints //
         revoluteJointDef = new b2RevoluteJointDef();
         revoluteJointDef.enableMotor = true;
         
         revoluteJointDef.Initialize(axle1, wheel1, wheel1.GetWorldCenter());
         motor1 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
         
         revoluteJointDef.Initialize(axle2, wheel2, wheel2.GetWorldCenter());
         motor2 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
         
      }
      
      
      public function update(e : Event) : void {
         
         if (input.isPressed(32)) {
            world = null;
            init();
            return;
         }

         motor1.SetMotorSpeed(15*Math.PI * (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
         motor1.SetMaxMotorTorque(input.isPressed(40) || input.isPressed(38) ? 17 : 0.5);
         
         motor2.SetMotorSpeed(15*Math.PI * (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
         motor2.SetMaxMotorTorque(input.isPressed(40) || input.isPressed(38) ? 12 : 0.5);
         
         spring1.SetMaxMotorForce(30+Math.abs(800*Math.pow(spring1.GetJointTranslation(), 2)));
         //spring1.SetMotorSpeed(-4*Math.pow(spring1.GetJointTranslation(), 1));
         spring1.SetMotorSpeed((spring1.GetMotorSpeed() - 10*spring1.GetJointTranslation())*0.4);         
         
         spring2.SetMaxMotorForce(20+Math.abs(800*Math.pow(spring2.GetJointTranslation(), 2)));
         spring2.SetMotorSpeed(-4*Math.pow(spring2.GetJointTranslation(), 1));
         
         cart.ApplyTorque(30*(input.isPressed(37) ? 1: input.isPressed(39) ? -1 : 0));
         
         screen.x -= (screen.x - (-DRAW_SCALE*cart.GetWorldCenter().x + SCREEN_WIDTH/2 - cart.GetLinearVelocity().x*10))/3;
         screen.y -= (screen.y - (DRAW_SCALE*cart.GetWorldCenter().y + 2*SCREEN_HEIGHT/3 + cart.GetLinearVelocity().y*6))/3;

         world.Step(TIME_STEP, ITERATIONS);
         
         FRateLimiter.limitFrame(60);
         
      }
      
   }
   
}