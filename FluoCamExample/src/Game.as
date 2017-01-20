package  {

	import flash.display.Bitmap;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import starling.extensions.fluocode.*;
	import starling.animation.Juggler;
	
	import starling.display.Button;
	import starling.events.Event;
	
	public class Game extends Sprite{
		
		[Embed(source="bg.jpg")]
        private static var BG:Class
		
		[Embed(source="starling.png")]
        private static var Bird:Class
		
		
		[Embed(source="btn.png")]
        private static var Btn:Class

		private var tw:Tween;
		private var cam:Fluocam;
		
		public function Game() {
			//Create "world" the main container
			var world:Sprite=new Sprite();
			addChild(world);
			
			//Defining the Bird texture
			var background:Bitmap = new BG();
			var bgTexture:Texture = Texture.fromBitmap(background);
			var bgImage:Image = new Image(bgTexture);
			world.addChild(bgImage);
			
			var bird:Bitmap = new Bird();
			var birdTexture:Texture = Texture.fromBitmap(bird);
			
			//Creating the statig bird
			var birdIma:Image = new Image(birdTexture);
			var birdStatic:Sprite = new Sprite();
			world.addChild(birdStatic);
			birdStatic.x=600;
			birdStatic.y=300;
			birdStatic.scaleX=birdStatic.scaleY=0.5;
			birdStatic.addChild(birdIma);
			
			//Creating the flyer bird
			var birdImaMove:Image = new Image(birdTexture);
			var birdMove:Sprite = new Sprite();
			birdMove.x=600;
			birdMove.y=300;
			birdMove.addChild(birdImaMove);
			birdMove.alignPivot();
			birdMove.scaleX=birdMove.scaleY=0.5;
			world.addChild(birdMove);
			moveBird(birdMove, world);
			
			
			var cam:Fluocam=new Fluocam(world, 500, 400, false);
			addChild(cam);
			cam.changeTarget(birdMove);
			
					
			
			/////// BUTTONS
			
			//Defining the Bird texture
			var btnBM:Bitmap = new Btn();
			var btnT:Texture = Texture.fromBitmap(btnBM);

			
			
			var buttonA:Button = new Button(btnT);
			buttonA.text="Go to Static Bird";
			buttonA.fontColor = 0x0FFFFFF;
			buttonA.fontSize = 14;
			this.addChild( buttonA );
			buttonA.addEventListener(Event.TRIGGERED, function(){cam.changeTarget(birdStatic)});
			
			var buttonB:Button = new Button(btnT);
			buttonB.x=355;
			buttonB.text = "Go to Flying Bird";
			buttonB.fontColor = 0x0FFFFFF;
			buttonB.fontSize = 14;
			this.addChild( buttonB );
			buttonB.addEventListener(Event.TRIGGERED, function(){cam.changeTarget(birdMove)});
			
			var buttonC:Button = new Button(btnT);
			buttonC.y=365;
			buttonC.text = "Go to Static Bird Smoothly";
			buttonC.fontColor = 0x0FFFFFF;
			buttonC.fontSize = 14;
			this.addChild( buttonC );
			buttonC.addEventListener(Event.TRIGGERED, function(){cam.goToTarget(birdStatic)});
			
			var buttonD:Button = new Button(btnT);
			buttonD.x=355;
			buttonD.y=365;
			buttonD.text = "Go to Flying Bird Smoothly";
			buttonD.fontColor = 0x0FFFFFF;
			buttonD.fontSize = 14;
			this.addChild( buttonD );
			buttonD.addEventListener(Event.TRIGGERED, function(){cam.goToTarget(birdMove)});

		}
		
		
		private function moveBird(birdImaMove:Sprite, world:Sprite):void{
			// We stop the tween by removing it from the juggler
			if (tw!=null)
			Starling.juggler.remove(tw);
			
			tw=new Tween(birdImaMove, 2);
			tw.moveTo(250+Math.random()*(world.width-550),200+Math.random()*(world.height-400));
			tw.onComplete=moveBird;
			tw.onCompleteArgs=new Array(birdImaMove,world);
			// We add the tween to a juggler
			Starling.juggler.add(tw);	
		}

		
		

	}
	
}
