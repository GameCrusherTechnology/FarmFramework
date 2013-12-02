package service.command
{
	import controller.GameController;
	
	import model.player.GamePlayer;

	public class LoginCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		public function LoginCommand(callBack:Function)
		{
			onLoginSuccess =callBack;
			super(Command.LOGIN,onLogin,{name:GameController.instance.userID})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.currentPlayer = GameController.instance.localPlayer = new GamePlayer(result['user_account']);
				onLoginSuccess();
			}
		}
	}
}