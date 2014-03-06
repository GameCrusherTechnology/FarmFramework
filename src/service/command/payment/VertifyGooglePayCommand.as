package service.command.payment
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.panel.WarnnigTipPanel;
	
	public class VertifyGooglePayCommand extends AbstractCommand
	{
		private var onBack:Function;
		private var onError:Function;
		public function VertifyGooglePayCommand(param:Object,callBack:Function,onerror:Function)
		{
			onBack =callBack;
			onError = onerror;
			super(Command.GOOGLEPAY,onResult,param)
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.gem){
					onBack();
					var player:GamePlayer = GameController.instance.localPlayer;
					var addGem:int = result.gem - player.gem;
					player.changeGem(addGem);
					
					if(result.item){
						player.addItem(new OwnedItem(result.item.id,result.item.count));
					}
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				onError();
			}
		}
	}
}

