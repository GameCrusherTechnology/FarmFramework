package service.command.friend
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class AcceptFriend extends AbstractCommand
	{
		public function AcceptFriend(friend_gameuid:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.ACCEPTFRIEND,onResult,{target:friend_gameuid});
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


