package view.entity
{
	import flash.geom.Point;
	
	import controller.DialogController;
	import controller.GameController;
	import controller.TutorialController;
	import controller.UiController;
	import controller.UpdateController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.UpdateData;
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.EntityItem;
	import model.player.GamePlayer;
	
	import service.command.scene.SearchingCommand;
	
	import starling.core.RenderSupport;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.TouchPhase;
	
	import view.FarmScene;
	import view.TweenEffectLayer;
	import view.panel.ConfirmPanel;
	import view.panel.TreasurePanel;
	import view.panel.WarnnigTipPanel;

	public class GameEntity extends Sprite
	{
		public var surface:MovieClip;
		protected var effctSur:MovieClip;
		public var item:EntityItem;
		public function GameEntity(entityItem:EntityItem) 
		{
			item = entityItem;
			creatSurface();
			setTile();
			configPosition();
		}
		protected function creatSurface():void
		{
			surface = new MovieClip(Game.assets.getTextures(item.name));
			addChild(surface);
			surface.x = - surface.width/2;
			surface.y = - surface.height;
		}
		private function setTile():void
		{
			var i:int;
			var j:int;
			var tile:Tile;
			while(i < item.bound_x){
				j=0;
				while(j<item.bound_y){
					tile = Map.intance.getTileByIos(item.positionx+i,item.positiony+j);
					if(tile){
						tile.owner  = this;
					}
					j++;
				}
				i++;
			}
		}
		private var currentMoveTile:Tile ;
		private var movableMc:MovieClip;
		public function intoMoveMode():void
		{
			currentMoveTile = getTopTile();
			movableMc = new MovieClip(Game.assets.getTextures("movableSkin"));
			movableMc.width = (length_x+length_y)/2*Configrations.Tile_Width+5;
			movableMc.height = (length_x+length_y)/2*Configrations.Tile_Height+4;
			addChild(movableMc);
			movableMc.x = -movableMc.width/2;
			movableMc.y = -movableMc.height+2;
			
			dragmoveToTile(currentMoveTile);
		}
		protected function dragmoveToTile(tile:Tile):void
		{
			trace("tile" + tile.x);
			var topPoint:Point = Map.intance.iosToScene(tile.x +length_x,tile.y+length_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		
		public function moveEntity(scenePos:Point):void
		{
			var tile:Tile = Map.intance.sceneToNearIso(scenePos,item.bound_x,item.bound_y);
			if(tile &&  tile != currentMoveTile){
				var valiable:Boolean = checkValiable(tile);
				if(valiable){
					movableMc.currentFrame = 0;
				}else{
					movableMc.currentFrame = 1;
				}
				dragmoveToTile(tile);
				currentMoveTile = tile;
			}

		}
		public function releaseEntity():void
		{
			var valiable:Boolean = checkValiable(currentMoveTile);
			if(valiable){
				putDown();
			}
		}
		public function get sceneIndex():Number
		{
			return item.sceneIndex;
		}
		private function putDown():void
		{
			UpdateController.instance.pushActionData(new UpdateData(item.gameuid,Configrations.MOVE,{data_id:item.data_id,positionx:currentMoveTile.x,positiony:currentMoveTile.y,type:item.itemType}));
			
			clearTile();
			moveToIso(currentMoveTile);
			scene.putDownEntity(this);
			setTile();
			destroyMoveMc();
		}
		protected function clearTile():void
		{
			var i:int;
			var j:int;
			var tile:Tile;
			while(i < item.bound_x){
				j=0;
				while(j<item.bound_y){
					tile = Map.intance.getTileByIos(item.positionx+i,item.positiony+j);
					if(tile){
						tile.owner  = null;
					}
					j++;
				}
				i++;
			}
		}
		public function cancel():void
		{
			moveToIso(getTopTile());
			destroyMoveMc();
		}
		private function destroyMoveMc():void
		{
			if(movableMc && movableMc.parent){
				movableMc.parent.removeChild(movableMc);
			}
		}
		
		private function checkValiable(toptile:Tile):Boolean
		{
			var index_x:int = toptile.x;
			var index_y:int;
			var tile:Tile;
			while(index_x<(toptile.x + length_x)){
				index_y = toptile.y;
				while(index_y <(toptile.y+length_y)){
					tile = Map.intance.getTileByIos(index_x,index_y);
					if(tile && (!tile.owner ||tile.owner == this)){
						
					}else{
						return false;
					}
					index_y++;
				}
				index_x++;
			}
			return true;
		}
		protected function configPosition():void
		{
			var topPoint:Point = Map.intance.iosToScene(item.positionx +item.bound_x,item.positiony+item.bound_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		public function getTopTile():Tile
		{
			return Map.intance.getTileByIos(item.positionx,item.positiony);
		}
		public function get length_x():int
		{
			return item.bound_x;
		}
		public function get length_y():int
		{
			return item.bound_y;
		}
		
		public function moveToIso(tile:Tile):void
		{
			clearTile();
			item.positionx = tile.x;
			item.positiony = tile.y;
			configPosition();
			setTile();
		}
		protected function refresh():void
		{
			
		}
		
		public function doTouchEvent(type:String):void
		{
			switch(type){
				case TouchPhase.BEGAN:
					checkCurrentTool();
					break;
			}
			
		}
		private function checkCurrentTool():void
		{
			var tool:String = GameController.instance.selectTool;
			if(GameController.instance.isHomeModel){
				if(tool == UiController.TOOL_SCOOP){
					sell();
				}else if(tool == UiController.TOOL_MOVE){
					if(item.itemspec.type == "wild" ){
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnintTip02")));
					}else{
						scene.addMoveEntity(this);
					}
				}else{
					if(item.itemspec.type == "wild" ){
						UiController.instance.showUiTools(UiController.TOOL_EXCAVATE,this);
						if(TutorialController.instance.inTutorial){
							TutorialController.instance.playStep(13);
						}
					}
				}
			}else{
				
			}
		}
		
		private var isCommanding:Boolean;
		public function searching():void
		{
			if(!isCommanding && item.serchingCost){
				var type:String = item.serchingCost.type;
				if(type == "gem"){
					if(player.gem < item.serchingCost.price){
						DialogController.instance.showPanel(new TreasurePanel);
					}else{
						new SearchingCommand(this,onSearching);
						isCommanding = true;
					}
				}else{
					if(player.coin < item.serchingCost.price){
						DialogController.instance.showPanel(new TreasurePanel);
					}else{
						new SearchingCommand(this,onSearching);
						isCommanding = true;
					}
				}
			}
		}
		private function onSearching():void
		{
			player.removeEntityItem(item);
			dispose();
			isCommanding  = false;
		}
		protected function sell():void
		{
			var str:String = LanguageController.getInstance().getString("sellTip01") + item.cname +" ?";
			var confirmPanel:ConfirmPanel = new ConfirmPanel(str,function():void{
				UpdateController.instance.pushActionData(new UpdateData(item.gameuid,Configrations.SELL,{data_id:item.data_id,gameuid:item.gameuid,type:item.itemType}));
				VoiceController.instance.playSound(VoiceController.SOUND_PLOW);
				player.removeEntityItem(item);
				dispose();
			},function():void{});
			DialogController.instance.showPanel(confirmPanel);
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void{
			super.render(support,parentAlpha);
			update()
		}
		protected function get sceneEffectLayer():Sprite
		{
			return GameController.instance.currentFarm.effectLayer;
		}
		
		protected function get stageEffectLayer():TweenEffectLayer
		{
			return GameController.instance.effectLayer;
		}
		protected function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
		override public function dispose():void
		{
			clearTile();
			scene.removeEntity(this);
			super.dispose();
		}
		protected function update():void
		{
			if(item.update()){
				refresh();
			}
		}
		
		public function get isFloor():Boolean
		{
			return item.itemspec &&  item.itemspec.type =="floor";
		}
		public function get isWild():Boolean
		{
			return item.isWild;
		}
		
		protected function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
			
	}
}