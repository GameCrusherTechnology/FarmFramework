package gameconfig
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	public class Devices
	{
		public function Devices()
		{
			
		}
		//first check to see if we're on the device or in the debugger//
		public static const isDebugger:Boolean = Capabilities.isDebugger;
		//set a few variables that'll help us deal with the debugger//
		public static const isLandscape:Boolean = true;// most of my games are in landscape
		public static var debuggerDevice:String = "others";//iPhone3 = iPhone4,4s, etc.iPad2 others
		
		//we create an object here that'll keep a detailed abount of the current environment.
		public static const DeviceDetails:Object = getDeviceDetails();
		
		public static const GameWidth:int  = DeviceDetails.width;// set an Easy reference for Height & Width
		public static const GameHeight:int = DeviceDetails.height; 
		
		public static const CenterX:int = DeviceDetails.x;// Calculate the CenterX & Y for the screen
		public static const CenterY:int = DeviceDetails.y;
		
		//I find that having a rect that accurately represents the screen size is useful, so I make one here for both main orientations.
		public static const GameScreenLandscape:Rectangle = new Rectangle(CenterX, CenterY, GameWidth, GameHeight);
		public static const GameScreenPortrait:Rectangle = new Rectangle(CenterY, CenterX, GameHeight, GameWidth); 
		
		
		private static var _deviceDetails:Object;
		public static function getDeviceDetails():Object {
			if(_deviceDetails) return _deviceDetails;
			var retObj:Object = {};
			var devStr:String = Capabilities.os;
			var devStrArr:Array = devStr.split(" ");
			devStr = devStrArr.pop();
			devStr = (devStr.indexOf(",") > -1)?devStr.split(",").shift():debuggerDevice;
			
			
			retObj.width = Capabilities.screenResolutionX>Capabilities.screenResolutionY?Capabilities.screenResolutionX:Capabilities.screenResolutionY;
			retObj.height = Capabilities.screenResolutionX<Capabilities.screenResolutionY?Capabilities.screenResolutionX:Capabilities.screenResolutionY;
			retObj.width = 1024;
			retObj.height = 768;
			retObj.x = Capabilities.screenResolutionX/2;
			retObj.y = Capabilities.screenResolutionY/2;
			retObj.device = devStr;
			retObj.scale =1;
			retObj.frameRate = "60";
			return _deviceDetails = retObj;
		}
		
	}

}