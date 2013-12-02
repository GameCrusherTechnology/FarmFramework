package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ChangeSexCommand extends AbstractCommand
	{
		public function ChangeSexCommand(sex:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CHANGESEX,onResult,{newsex:sex});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}else{
				
			}
		}
	}
}


