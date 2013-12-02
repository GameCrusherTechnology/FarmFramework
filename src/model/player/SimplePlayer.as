package model.player
{
	public class SimplePlayer
	{
		public static const REQUEST_FRIEND:int=1;
		public static const HELP_FRIEND:int=2;
		public static const DO_NOTHING:int=0;
		public function SimplePlayer(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GamePlayer["+str+"]="+data[str]);
				}
			}
		}
		
		public var gameuid:String;
		public var sex:int=0;
		public var exp:int;
		public var love:int;
		public var name:String = "happyFarmc";
		
		public var title:String = "10001|1";
		
		public var type:int;
		
		public var mes:String = "...";
		
		public var creatTime:Number = 1382454068;
		
		public var helpCount:int = 0;
		
	}
}