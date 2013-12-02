package service.command.friend
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetStrangersCommand extends AbstractCommand
	{
		public function GetStrangersCommand(callBack:Function)
		{
			onSuccess =callBack;
			super(Command.GETSTRANGERS,onResult);
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var strangers:Array = result.strangers;
				GameController.instance.localPlayer.addStrangers(strangers);
				onSuccess();
			}else{
				
			}
		}
	}
}


