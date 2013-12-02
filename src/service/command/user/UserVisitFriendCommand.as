package service.command.user
{
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
				GameController.instance.currentPlayer = new GamePlayer(result['friend_account']);
				onLoginSuccess();
			}else{
			}
		}
	}
}

