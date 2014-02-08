package model
{
	import controller.FriendInfoController;
	
	import model.player.SimplePlayer;
	import gameconfig.SystemDate;

	public class MessageData
	{
		public function MessageData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in Meeagedata: Meeagedata["+str+"]="+data[str]);
				}
			}
		}
		
		//
		public var gameuid:String ;
		public var f_gameuid:String; 
		public var data_id:int;
		public var message:String;
		public var type:int;
		public var updatetime:Number;
		
		public function get player():SimplePlayer{
			return FriendInfoController.instance.getUser(gameuid);
		}
		public function get senderplayer():SimplePlayer{
			return FriendInfoController.instance.getUser(f_gameuid);
		}
		
		public function get overOneDay():Boolean
		{
			return SystemDate.systemTimeS - updatetime >= 24*3600;
		}
	}
}