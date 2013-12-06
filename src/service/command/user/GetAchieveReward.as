package service.command.user
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetAchieveReward extends AbstractCommand
	{
		public function GetAchieveReward(achieveid:String,callBack:Function)
		{
			onSuccess =callBack;
			var step:int = GameController.instance.localPlayer.getAchieveLevel(achieveid)+1;
			super(Command.GETACHIEVE,onResult,{id:achieveid,step:step});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.localPlayer.changeGem(result.gem);
				GameController.instance.localPlayer.achieve = result.achieve;
				onSuccess();
			}else{
				
			}
		}
	}
}


