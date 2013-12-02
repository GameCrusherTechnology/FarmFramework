package service.command.shop
{
	import service.command.AbstractCommand;
	import service.command.Command;

	public class BuyItemCommand extends AbstractCommand
	{
		public function BuyItemCommand(id:String,c:int,m:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BUYITEM,onResult,{item_id:id,count:c,method:m});
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


