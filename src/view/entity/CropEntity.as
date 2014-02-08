package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	import controller.UpdateController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.UpdateData;
	import model.avatar.Tile;
	import model.entity.CropItem;
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.effect.RainEffect;

	public class CropEntity extends GameEntity
	{
		public var fieldSUR:Image;
		public function CropEntity(cropItem:CropItem)
		{
			fieldSUR = new Image(Game.assets.getTexture("FieldLand"));
			fieldSUR.width = Configrations.Tile_Width*2;
			fieldSUR.height = Configrations.Tile_Height*2;
			fieldSUR.x = - fieldSUR.width/2;
			fieldSUR.y = - fieldSUR.height;
			
			super(cropItem);
			
		}
		
		override protected function creatSurface():void
		{
			if(cropItem.hasCrop){
				surface = new MovieClip(Game.assets.getTextures(cropItem.name+"Static"));
				addChild(surface);
				surface.currentFrame =   Math.min(surface.numFrames-1,cropItem.growStep);
				surface.x = - surface.width/2;
				if(cropItem.isTree){
					fieldSUR.texture = Game.assets.getTexture("TreeLand");
					surface.y = - surface.height - Configrations.Tile_Height/2;
				}else{
					surface.y = - surface.height;
				}
				
				var vec:Vector.<Texture> = Game.assets.getTextures(cropItem.name+"MC");
				if(vec && vec.length>0){
					effctSur = new MovieClip(vec);
					checkEffectLayer();
				}
			}
		}
		override protected function dragmoveToTile(tile:Tile):void
		{
			super.dragmoveToTile(tile);
			fieldSUR.x = x - fieldSUR.width/2;
			fieldSUR.y = y - fieldSUR.height;
		}
		override protected function configPosition():void
		{
			super.configPosition();
			fieldSUR.x = x - fieldSUR.width/2;
			fieldSUR.y = y - fieldSUR.height;

		}
		override protected function refresh():void
		{
			if(cropItem.hasCrop){
				if(!surface){
					creatSurface();
				}
				surface.currentFrame =  Math.min(surface.numFrames-1,cropItem.growStep);
				surface.x = - surface.width/2;
				if(cropItem.isTree){
					surface.y = - surface.height - Configrations.Tile_Height/2;
				}else{
					surface.y = - surface.height;
				}
				checkEffectLayer();
			}else{
				if(effctSur && effctSur.parent){
					effctSur.parent.removeChild(effctSur);
					effctSur = null;
				}
				
				if(surface && surface.parent){
					surface.parent.removeChild(surface);
					surface = null;
				}
				
			}
		}
		override public function doTouchEvent(type:String):void
		{
			switch(type){
				case TouchPhase.BEGAN:
					checkCurrentTool();
					break;
				case TouchPhase.MOVED:
					onToolMoved();
					break;
				case TouchPhase.HOVER:
					onToolMoved();
					break;
				case TouchPhase.ENDED:
					hasSpeed = false;
					break;
			}
			
		}
		private var hasSpeed:Boolean;
		private function checkCurrentTool():void
		{
			var tool:String = GameController.instance.selectTool;
			if(GameController.instance.isHomeModel){
				if(tool == UiController.TOOL_SCOOP){
					sell();
				}else if(tool == UiController.TOOL_MOVE){
					scene.addMoveEntity(this);
				}else{
					if(cropItem.hasCrop){
						if(cropItem.canHarvest){
							if(tool !=UiController.TOOL_HARVEST){
								//show harvest
								UiController.instance.showUiTools(UiController.TOOL_HARVEST,this);
							}else{
								harvest();
							}
						}else if(tool !=UiController.TOOL_SPEED){
							//show time
							
							var remainTime:Number = cropItem.remainTime;
							UiController.instance.showUiTools(UiController.TOOL_SPEED,this);
						}else{
							speedCrop();
						}
					}else if(tool !=UiController.TOOL_SEED){
						// show plant
						UiController.instance.showUiTools(UiController.TOOL_SEED,this);
					}else{
						plant();
					}
				}
			}else{
				
			}
		}
		
		private function onToolHoved():void
		{
			var tool:String = GameController.instance.selectTool;
			switch(tool){
				case UiController.TOOL_HARVEST:
					if(cropItem.hasCrop && cropItem.canHarvest){
						harvest();
					}
					break;
			}
		}
		private function onToolMoved():void
		{
			var tool:String = GameController.instance.selectTool;
			switch(tool){
				case UiController.TOOL_HARVEST:
					if(cropItem.hasCrop && cropItem.canHarvest){
						harvest();
					}
					break;
				case UiController.TOOL_SPEED:
					if(cropItem.canSpeed){
						speedCrop();
					}
					break;
				case UiController.TOOL_SEED:
					if(!cropItem.hasCrop){
						plant();
					}
					break;
			}
		}
		
		private function plant():void
		{
			if(GameController.instance.selectSeed){
				if(player.hasItem(GameController.instance.selectSeed)){
					UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.PLANT,{data_id:cropItem.data_id,gameuid:cropItem.gameuid,item_id:GameController.instance.selectSeed,plant_time:SystemDate.systemTimeS}));
					cropItem.plant(GameController.instance.selectSeed);
					VoiceController.instance.playSound(VoiceController.SOUND_SEED);
				}else{
					GameController.instance.resetTools();
				}
			}
		}
		
		private function speedCrop():void
		{
			if(!hasSpeed){
				if(player.hasItem(Configrations.SPEED_ITEMID))
				{
					UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.SPEED,{data_id:cropItem.data_id,gameuid:cropItem.gameuid}));
					player.deleteItem(new OwnedItem(Configrations.SPEED_ITEMID,1));
					cropItem.speed();
					showSpeedAnimation();
				}else{
					GameController.instance.resetTools();
				}
				hasSpeed = true;
			}
		}
		
		public function showHelpSpeed():void
		{
			cropItem.speed();
			showSpeedAnimation();
		}
		
		public function showSkillSpeed():void
		{
			cropItem.speed(player.skillData.speedTime);
			showSpeedAnimation();
		}
		private function harvest():void
		{
			UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.HARVEST,{data_id:cropItem.data_id,gameuid:cropItem.gameuid}));
			player.addExp(cropItem.exp);
			GameController.instance.localPlayer.addItem(new OwnedItem(Configrations.getAchieveId(cropItem.item_id,"harvestCrop"),1));
			showHarvestAnimation();
			cropItem.harvest();
			VoiceController.instance.playSound(VoiceController.SOUND_HARVEST);
			refresh();
		}
		private function showHarvestAnimation():void
		{
			var texture:Texture;
			var count:int;
			if(cropItem.isTree){
				var spec:ItemSpec = SpecController.instance.getItemSpec(String(int(cropItem.item_id) + 10000));
				texture = Game.assets.getTexture(spec.name+"Icon");
				count = 10;
			}else{
				texture = Game.assets.getTexture(cropItem.name+"Icon");
				count = 2;
			}
			var index:int = 0;
			var stagePoint:Point ;
			while(index <count){
				stagePoint = scene.localToGlobal(new Point(x + Math.random()*50-25,y + Math.random()*50-25));
				stageEffectLayer.addTweenCrop(texture,stagePoint,0.1*index);
				
				index++;
			}
			stageEffectLayer.showExpAddEffect(cropItem.exp,stagePoint);
			UiController.instance.showToolStateEffect();
		}
		private function showSpeedAnimation():void
		{
			var rainEffect:RainEffect = new RainEffect();
			sceneEffectLayer.addChild(rainEffect);
			rainEffect.x = x;
			rainEffect.y = y;
			
			VoiceController.instance.playSound(VoiceController.SOUND_WATER);
		}
		
		public function get cropItem():CropItem
		{
			return item as CropItem;
		}
		
		private function checkEffectLayer():void
		{
			if(effctSur){
				var index:int = cropItem.growStep - (cropItem.totalStep -effctSur.numFrames);
				if(index>=0){
					if(!effctSur.parent){
						addChild(effctSur);
					}
					effctSur.currentFrame = Math.min(effctSur.numFrames-1,index);
					effctSur.x = - effctSur.width/2;
					effctSur.y =  surface.y;
				}else{
					if(effctSur.parent){
						effctSur.parent.removeChild(effctSur);
					}
				}
				
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
	}
}