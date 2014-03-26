package service.command.factory
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ExtendFacTileCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function ExtendFacTileCommand(method:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.EXPAND_FACTORY_TILE,onResult,{method:method});
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

