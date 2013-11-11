package service.command
{
	import controller.GameController;
	
	import gameconfig.GameShareObject;

	public class LoginCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		private var errorLogin:Function;
		public function LoginCommand(callBack:Function,errorCall:Function)
		{
			onLoginSuccess =callBack;
			errorLogin = errorCall;
			super(Command.LOGIN,onLogin,{name:GameController.instance.userID})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				var data:Object = result['response']['data'];
				var localdata:Object = GameShareObject.getLocalPlayer();
				var bool :Boolean = false;
//				if(localdata && localdata['gameuid'] != 0 && localdata['gameuid'] ==data['gameuid'] && !GameController.instance().checkedLocal){
//					for(var o:String in localdata){
//						if(localdata[o] != data[o] && o != "powertime"){
//							bool = true;
//							break;
//						}
//					}
//				}
//				GameController.getInstance().checkedLocal = true;
//				if(bool){
//					new UpdateUserCommand(localdata,onLoginSuccess);
//				}else{
//					GameController.getInstance().localPlayer = new LocalPlayer(data);
//					onLoginSuccess();
//				}
			}else{
				errorLogin();
			}
		}
	}
}