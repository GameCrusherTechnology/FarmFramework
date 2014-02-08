package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class SellItemCommand extends AbstractCommand
	{
		public function SellItemCommand(item_id:String,count:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.SELLITEM,onResult,{item_id:item_id,count:count});
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


