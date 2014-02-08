package service.command.friend
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class AcceptFriend extends AbstractCommand
	{
		public function AcceptFriend(friend_gameuid:String,data_id:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.ACCEPTFRIEND,onResult,{target:friend_gameuid,data_id:data_id});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}else{
				
			}
		}
	}
}


