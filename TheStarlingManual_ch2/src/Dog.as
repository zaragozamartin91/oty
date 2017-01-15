package
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author martin
	 */
	public class Dog extends Sprite
	{
		public static const BARK:String = "bark";
		private var _name:String = "";
		
		public function Dog(name:String)
		{
			_name = name;
			addEventListener(Event.ADDED_TO_STAGE, function():void
			{
				trace(_name + " added to stage!");
			});
			addEventListener(BARK, function():void {
				trace(_name + " just barked!");
			});
		}
		
		public function bark():void
		{
			var event:Event = new Event(BARK, true);
			dispatchEvent(event);
			dispatchEventWith(BARK, true);
		}
	}
}