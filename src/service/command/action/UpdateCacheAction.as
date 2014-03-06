package service.command.action
{
	import flash.system.Capabilities;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UpdateCacheAction extends AbstractCommand
	{
		public function UpdateCacheAction(actionId:int)
		{
			super(Command.UPDATEACTIONS,onResult,{actionId:actionId,version:Capabilities.version});
		}
		private function onResult(result:Object):void
		{
		}
	}
}

