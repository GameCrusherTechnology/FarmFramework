package service.command.shop
{
	import controller.GameController;
	
	import model.entity.AnimalItem;
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.FarmScene;
	import view.entity.AnimalEntity;
	import view.entity.GameEntity;
	import view.entity.RanchEntity;
	
	public class BuyAnimalCommand extends AbstractCommand
	{
		public function BuyAnimalCommand(itemid:String,houseId:Number,m:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BUYANIMAL,onResult,{item_id:itemid,house_id:houseId,method:m});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
				if(GameController.instance.isHomeModel && result.animal){
					var player:GamePlayer = GameController.instance.localPlayer;
					var farm:FarmScene = GameController.instance.currentFarm;
					var animalItem:AnimalItem = new AnimalItem(result.animal);
					player.addAnimal(animalItem);
					var entity:GameEntity;
					for each(entity in farm.entityDic){
						if((entity is RanchEntity) && (entity.item.data_id == animalItem.house_id)){
							GameController.instance.currentFarm.addAnimalEntity(new AnimalEntity(animalItem,entity as RanchEntity));
							break;
						}
					}
					
				}
			}else{
				
			}
		}
	}
}


