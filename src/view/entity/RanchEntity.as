package view.entity
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.UiController;
	import controller.UpdateController;
	import controller.VoiceController;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.UpdateData;
	import model.avatar.Map;
	import model.entity.AnimalItem;
	import model.entity.EntityItem;
	import model.gameSpec.AnimalItemSpec;
	import model.gameSpec.RanchSpec;
	
	import service.command.scene.CreatRanchCommand;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class RanchEntity extends GameEntity
	{
		public function RanchEntity(entityItem:EntityItem) 
		{
			super(entityItem);
		}
		
		public var animals:Array = [];
		public function addAnimal(animalEntity:AnimalEntity):void
		{
			animals.push(animalEntity)
		}
		override public function intoMoveMode():void
		{
			super.intoMoveMode();
			
			if(item.isRanch){
				var entity:GameEntity;
				for each(entity in scene.entityDic){
					if(entity is AnimalEntity && item.data_id == (entity as AnimalEntity).animalItem.house_id){
						(entity as AnimalEntity).intoMove();
					}
				}
			}
		}
		public var animalPosArr:Vector.<Point>;
		override public function configPosition():void
		{
			animalPosArr = new Vector.<Point>;
			var topPoint:Point = Map.intance.iosToScene(item.positionx +item.bound_x,item.positiony+item.bound_y);
			x = topPoint.x;
			y = topPoint.y;
			
			var tx:int = item.positionx+2;
			var ty:int
			while(tx <= item.positionx + item.bound_x-1){
				ty = item.positiony+2;
				while(ty <= item.positiony + item.bound_y-1){
					animalPosArr.push(new Point(tx,ty));
					ty++;
				}
				tx++;
			}
			
		}
		override protected function putDown():void
		{
			if(!item.data_id){
				scene.maxDecId ++;
				scene.maxAnimalId++;
				var animalData:Object = {data_id:scene.maxAnimalId,item_id:item.itemspec.boundId,house_id:scene.maxDecId};
				new CreatRanchCommand({data_id:scene.maxDecId,item_id:item.item_id,positionx:currentMoveTile.x,positiony:currentMoveTile.y},animalData,function():void{
					scene.removeStandAnimal();
					item.data_id = scene.maxDecId;
				});
			
				clearTile();
				moveToIso(currentMoveTile);
				scene.putDownEntity(this);
				scene.entityDic.push(this);
				setTile();
				destroyMoveMc();
				
				
				var animal:AnimalEntity = new AnimalEntity(new AnimalItem(animalData),this);
				scene.addAnimalEntity(animal);
				player.addRanch(item);
				player.addAnimal(animal.animalItem);
				
				UiController.instance.hideUiTools();
			}else{
				 super.putDown();
			}
		}
		override protected function destroyMoveMc():void
		{
			super.destroyMoveMc();
			if(item.isRanch){
				var entity:GameEntity;
				for each(entity in scene.entityDic){
					if(entity is AnimalEntity && item.data_id == (entity as AnimalEntity).animalItem.house_id){
						(entity as AnimalEntity).outMove();
					}
				}
			}
			scene.sortEntityLayer();
		}
		
		override public function doTouchEvent(type:String):void
		{
			var tool:String = GameController.instance.selectTool;
			if(type == TouchPhase.BEGAN ){
				if(GameController.instance.isHomeModel){
					if(tool == UiController.TOOL_MOVE){
						scene.addMoveEntity(this);
					}else{
						checkTool();
//						DialogController.instance.showPanel(new AnimalRanchPanel(this));
					}
				}else{
					
				}
			}else if(type== TouchPhase.MOVED){
				if(tool == UiController.TOOL_HARVEST_ANIMAL || tool == UiController.TOOL_FEED_ANIMAL){
					checkTool(false);
				}
			}
		}
		
		private function checkTool(isSelected:Boolean = true):void
		{
			var animal:AnimalEntity;
			var doThing:Boolean = false;
			for each(animal in animals){
				if(animal.animalItem.canHarvest){
					UpdateController.instance.pushActionData(new UpdateData(item.gameuid,Configrations.HARVESTANIMAL,{data_id:animal.animalItem.data_id,gameuid:item.gameuid}));
					animal.harvest();
					VoiceController.instance.playSound(VoiceController.SOUND_HARVEST);
					if(GameController.instance.selectTool != UiController.TOOL_HARVEST_ANIMAL){
						GameController.instance.selectTool = UiController.TOOL_HARVEST_ANIMAL;
						UiController.instance.showToolStateButton(UiController.TOOL_HARVEST_ANIMAL,Game.assets.getTexture("HarvestAnimalIcon"));
					}
					doThing = true;
					break;
				}
			}
			if(!doThing){
				for each(animal in animals){
					if(animal.animalItem.canFeed){
						if(getFeedEnough(animal.animalItem)){
							UpdateController.instance.pushActionData(new UpdateData(item.gameuid,Configrations.FEEDANIMAL,{data_id:animal.animalItem.data_id,gameuid:item.gameuid}));
							animal.feed();
							VoiceController.instance.playSound(VoiceController.SOUND_HARVEST);
							if(GameController.instance.selectTool != UiController.TOOL_FEED_ANIMAL){
								GameController.instance.selectTool = UiController.TOOL_FEED_ANIMAL;
								UiController.instance.showToolStateButton(UiController.TOOL_FEED_ANIMAL,Game.assets.getTexture("FeedIcon"));
							}
						}else if(isSelected){
							DialogController.instance.showFacPanel((animal.animalItem.itemspec as AnimalItemSpec).feedId);
						}
						doThing = true;
						break;
					}
				}
			}
			if(!doThing && isSelected ){
				if(canGetMore()){
					UiController.instance.showUiTools(UiController.TOOL_RANCH_INFO,this);
				}
				
				var minTime:Number= 9999999;
				for each(animal in animals){
					minTime = Math.min(animal.animalItem.getLeftTime(),minTime);
				}
				if(minTime>0){
					showLeftTime(minTime);
				}
			}
		}
		
		
		private var tipContainer:Scale9Image;
		private var tipText:TextField;
		private function showLeftTime(minTime:Number):void
		{
			if(!tipContainer){
				
				var scaleTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(5,5,40,40));
				tipContainer = new Scale9Image(scaleTexture);
				
				tipText = FieldController.createSingleLineDynamicField(100,50," ",0x000000,25,true);
				tipText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				tipContainer.addChild(tipText);
				tipText.x = 10;
				tipText.y = 5;
			}
			tipContainer.alpha = 1;
			Starling.juggler.removeTweens(tipContainer);
			tipText.text = SystemDate.getTimeLeftString(minTime);
			tipContainer.width = tipText.width+20;
			tipContainer.height = tipText.height + 10;
			
			scene.effectLayer.addChild(tipContainer);
			tipContainer.x = 	x-tipContainer.width/2;
			tipContainer.y = 	y- tipContainer.height - 5;
			
			var tween:Tween = new Tween(tipContainer,2,Transitions.LINEAR);
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			tween.onComplete = function():void{
				if(tipContainer&&tipContainer.parent){
					tipContainer.parent.removeChild(tipContainer);
				}
			}
				
			
		}
		
		public function getLittleTimeLeft():Number
		{
			var animal:AnimalEntity;
			var lTime:Number=100000000;
			for each(animal in animals){
				lTime = Math.min(lTime,animal.animalItem.getLeftTime());
			}
			return lTime;
		}
		public function canGetMore():Boolean
		{
			var maxCount:int = (item.itemspec as RanchSpec).maxNumber;
			if(animals.length < maxCount){
				return true;
			}else{
				return false;
			}
		}
		private function getFeedEnough(animalItem:AnimalItem):Boolean
		{
			var ownedItem:OwnedItem = player.getOwnedItem((animalItem.itemspec as AnimalItemSpec).feedId);
			if(ownedItem.count >=1 ){
				return true;
			}else{
				return false;
			}
		}

	}
}