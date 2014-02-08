package service.command.user
{
	import controller.FriendInfoController;
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UserVisitFriendCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		public function UserVisitFriendCommand(tgameuid:String,callBack:Function)
		{
			onLoginSuccess =callBack;
			super(Command.VISITFRIEND,onLogin,{friend_gameuid:tgameuid})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				var player:GamePlayer = new GamePlayer(result['friend_account']);
				player.lastHelpedTime = result["lastHelp"];
				GameController.instance._curPlayer = player;
				FriendInfoController.instance.updateFriend(player);
				onLoginSuccess();
			}else{
			}
		}
	}
}

