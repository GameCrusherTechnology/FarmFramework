package model.player
{
	import gameconfig.Configrations;

	public class SimplePlayer
	{
		public function SimplePlayer(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in SimplePlayer: SimplePlayer["+str+"]="+data[str]);
				}
			}
		}
		public var gameuid:String;
		public var sex:int=0;
		public var exp:int;
		public var achieve:String;
		private var _name:String = "Sunny Farmer";
		public function get name():String{
			if(gameuid == "1"){
				return "Alice";
			}else if(gameuid == "2"){
				return "Tony";
			}else{
				return _name;
			}
		}
		public function set name(n:String):void
		{
			_name = n;
		}
		
		public var title:String = "10001|1";
		
		public var helpCount:int = 0;
		
		public function get headIconName():String
		{
			if(gameuid == "1"){
				return "femaleHeadIcon";
			}else if(gameuid == "2"){
				return "maleHeadIcon";
			}else if(sex == Configrations.CHARACTER_BOY){
				return "boyIcon";
			}else{
				return "girlIcon";
			}
		}
	}
}