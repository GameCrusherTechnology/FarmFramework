package model.player
{
	public class SimplePlayer
	{
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
		
		public var helpCount:int = 0;
		
	}
}