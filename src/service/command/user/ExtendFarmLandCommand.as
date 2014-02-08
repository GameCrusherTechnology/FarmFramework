package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ExtendFarmLandCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function ExtendFarmLandCommand(method:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.EXTENDFARMLAND,onResult,{method:method});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}else{
				
			}
		}
	}
}


