package controller
{
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import model.player.SimplePlayer;
	
	import service.command.user.GetFriendsInfo;

	public class FriendInfoController
	{
		private var DATA_NAME :String = "UserFriendInfo";
		private static var _controller:FriendInfoController;
		public static function get instance():FriendInfoController
		{
			if(!_controller){
				_controller = new FriendInfoController();
				_controller.initFriendsMes();
			}
			return _controller;
		}
		public function FriendInfoController()
		{
		}
		
		private var users_vec:Vector.<SimplePlayer>;
		public function initFriendsMes():void
		{
			users_vec = new Vector.<SimplePlayer>;
			var shareo:SharedObject = SharedObject.getLocal(DATA_NAME,"/");
			if(shareo.data.obj){
				var obj:Object;
				for each(obj in shareo.data.obj)
				{
					users_vec.push(new SimplePlayer(obj));
				}
			}
		}
		public function getUser(id:String):SimplePlayer
		{
			var player:SimplePlayer = checkUser(id);
			if(player){
				return player;
			}else{
				return new SimplePlayer({gameuid:id});
			}
		}
		public function checkUser(id:String):SimplePlayer
		{
			var player:SimplePlayer;
			var targePlayer:SimplePlayer;
			for each(player in users_vec){
				if(player.gameuid == id){
					targePlayer = player;
				}
			}
			if(!targePlayer){
				pushActionData(id);
			}
			return targePlayer;
		}
		
		private function pushNewer(id:String):void
		{
			
		}
		private var listData:Array = [];
		public function pushActionData(id:String):void
		{
			listData.push(id);
			setTimeout(laterSend,500);
		}
		
		private function laterSend():void
		{
			sendUpdateList();
		}
		
		private function sendUpdateList():void{
			if(listData.length>0){
				new GetFriendsInfo(listData);
			}
			listData = [];
		}
		
		public function addNewFriendsInfo(infoArr:Array):void
		{
			var obj:Object;
			for each(obj in infoArr){
				users_vec.push(new SimplePlayer(obj));
			}
			saveFriendInfo();
		}
		
		public function saveFriendInfo():void
		{
			var shareo:SharedObject = SharedObject.getLocal(DATA_NAME,"/");
			shareo.data.obj = users_vec;
			shareo.flush();
		}
	}
}