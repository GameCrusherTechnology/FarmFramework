package service.command
{
	import logic.GameController;
	import logic.rules.player.LocalPlayer;
	
	import util.Config;
	import util.GameShareObject;

	public class LoginCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		private var errorLogin:Function;
		public function LoginCommand(callBack:Function,errorCall:Function)
		{
			onLoginSuccess =callBack;
			errorLogin = errorCall;
			super(Command.LOGIN,onLogin,{name:Config.userName})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				var data:Object = result['response']['data'];
				var localdata:Object = GameShareObject.getLocalPlayer();
				var bool :Boolean = false;
				if(localdata && localdata['gameuid'] != 0 && localdata['gameuid'] ==data['gameuid'] && !GameController.getInstance().checkedLocal){
					for(var o:String in localdata){
						if(localdata[o] != data[o] && o != "powertime"){
							bool = true;
							break;
						}
					}
				}
				GameController.getInstance().checkedLocal = true;
				if(bool){
					new UpdateUserCommand(localdata,onLoginSuccess);
				}else{
					GameController.getInstance().localPlayer = new LocalPlayer(data);
					onLoginSuccess();
				}
			}else{
				errorLogin();
			}
		}
	}
}