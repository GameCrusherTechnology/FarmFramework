package service.command.payment
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.LanguageController;
	
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
				onBack();
				var player:GamePlayer = GameController.instance.localPlayer;
				var addGem:int = result.gem - player.gem;
				player.changeGem(addGem);
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				onError();
			}
		}
	}
}

