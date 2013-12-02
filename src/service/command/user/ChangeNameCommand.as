package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ChangeNameCommand extends AbstractCommand
	{
		public function ChangeNameCommand(name:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CHANGENAME,onResult,{newname:name});
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


