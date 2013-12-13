package service.command.friend
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class InviteFriend extends AbstractCommand
	{
		public function InviteFriend(friend_gameuid:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.INVITEFRIEND,onResult,{target:friend_gameuid});
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