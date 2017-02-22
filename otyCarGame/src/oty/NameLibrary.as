package oty
{
	
	/**
	 * Conjunto de constantes de nombres.
	 *
	 * @author martin
	 */
	public class NameLibrary
	{
		public static const CAR_BODY_NAME:String = "car-body-car";
		public static const TRUNK_BODY_NAME:String = "car-body-trunk";
		public static const HOOD_BODY_NAME:String = "car-body-hood";
		public static const FWHEEL_BODY_NAME:String = "car-body-fwheel";
		public static const RWHEEL_BODY_NAME:String = "car-body-rwheel";
		
		public static const FLOOR_BODY_NAME:String = "floor";
		public static const RAMP_BODY_NAME:String = "ramp";
		
		public static const STAGE_BUILDER:String = "stage-builder";
		public static const BOX2D_WORLD:String = "box2d-world";
		public static const CAMERA:String = "camera";
		
		public static function buildName(template:String, index:int)
		{
			return template + "-" + index;
		}
	}

}