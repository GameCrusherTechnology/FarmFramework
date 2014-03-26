package service.command.factory
{
	import controller.GameController;
	
	import model.OwnedItem;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class HarvestFacCommand extends AbstractCommand
	{
		public function HarvestFacCommand(callBack:Function)
		{
			onSuccess =callBack;
			super(Command.HARVEST_FORMULA,onResult);
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.formula){
					GameController.instance.localPlayer.user_factory = result.formula;
				}
				if(result.exp){
					GameController.instance.localPlayer.addExp(result.exp);
				}
				if(result.addItems){
					for each(var obj:Object in result.addItems){
						GameController.instance.localPlayer.addItem(new OwnedItem(obj.id,obj.count));
					}
				}
				onSuccess(result.addItems,result.exp);
			}else{
				
			}
		}
	}
}


