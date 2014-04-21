package service.command.action
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ActivateCommand extends AbstractCommand
	{
		public function ActivateCommand()
		{
			super(Command.ACTIVATE,onResult,{});
		}
		private function onResult(result:Object):void
		{
			
		}
	}
}

