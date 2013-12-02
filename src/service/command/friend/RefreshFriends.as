package service.command.friend
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class RefreshFriends extends AbstractCommand
	{
		public function RefreshFriends(callBack:Function)
		{
			onSuccess =callBack;
			super(Command.REFRESH_FRIENDS,onResult);
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var friends:Array = result.friends;
				GameController.instance.localPlayer.addFriends(friends);
				onSuccess();
			}else{
				
			}
		}
	}
}


