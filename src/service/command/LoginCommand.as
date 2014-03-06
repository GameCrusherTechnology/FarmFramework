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
				if(GameController.instance.localPlayer){
					var player:GamePlayer = new GamePlayer(result['user_account']);
					player.strangers = GameController.instance.localPlayer.strangers;
					GameController.instance._curPlayer = GameController.instance.localPlayer = player;
				}else{
					GameController.instance._curPlayer = GameController.instance.localPlayer = new GamePlayer(result['user_account']);
				}
				GameController.instance.isNewer = result['is_new'];
				onLoginSuccess();
			}
		}
	}
}