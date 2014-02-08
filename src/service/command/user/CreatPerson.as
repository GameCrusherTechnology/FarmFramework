package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class CreatPerson extends AbstractCommand
	{
		public function CreatPerson(name:String,sex:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREATPERSON,onResult,{name:name,sex:sex});
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



