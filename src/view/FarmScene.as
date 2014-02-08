package view
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.net.SharedObject;
	
	import controller.DialogController;
	import controller.GameController;
	import controller.UiController;
	import controller.UpdateController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.MessageData;
	import model.SkillData;
	import model.UpdateData;
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.CropItem;
	import model.entity.EntityItem;
	import model.player.GamePlayer;
	
	import service.command.friend.HelpFriendCommand;
	import service.command.scene.CreatWeed;
	import service.command.user.UserSkillCommand;
	
	import starling.display.DisplayObject;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.entity.AnimalEntity;
	import view.entity.CropEntity;
	import view.entity.GameEntity;
	import view.entity.HouseEntity;
	import view.panel.ExtendFarmLandPanel;
	import view.panel.WarnnigTipPanel;

	public class FarmScene extends Sprite
	{
		[Embed(source="/init/bgCell.png")]
		public static var bgClass:Class;
		
		public var fieldLayer:Sprite;
		public var entityLayer:Sprite;
		private var scenew:Number;
		private var sceneh:Number;
		public var entityDic:Vector.<GameEntity>;
		
		public var effectLayer:Sprite;
		public function FarmScene()
		{
			
			var length:int = player.wholeSceneLength;
			scenew = Configrations.ViewPortWidth + (length-1)* Configrations.Tile_Width;
			sceneh = Configrations.ViewPortHeight +(length-1)* Configrations.Tile_Height;
			initBackground(scenew,sceneh,length);
			fieldLayer = new Sprite();
			addChild(fieldLayer);
			
			entityLayer = new Sprite();
			addChild(entityLayer);
			
			effectLayer = new Sprite();
			addChild(effectLayer);
			Map.intance.init(scenew/2,sceneh/2-length * Configrations.Tile_Height/2);
			
			initEntity();
			addEventListener(TouchEvent.TOUCH,onTouch);
			
			dragScreenTo(new Point(-(length-1)* Configrations.Tile_Width/2,-(length-1)* Configrations.Tile_Height/2));
			
			if(GameController.instance.isHomeModel){
				checkWeeds();
			}
		}
		
		private function initBackground(scenew:Number,sceneh:Number,length:int):void
		{
			var bitmap:Bitmap = new bgClass();
			var shape:Shape = new Shape();
			shape.graphics.beginTextureFill(Texture.fromBitmap(bitmap));
			shape.graphics.drawRect(0,0,scenew,sceneh);
			shape.graphics.endFill();
			shape.graphics.lineStyle(2,0xffff00,0.8);
			
			shape.graphics.moveTo(scenew/2,sceneh/2-length*Configrations.Tile_Height/2-5);
			shape.graphics.lineTo(scenew/2+length* Configrations.Tile_Width/2+5,sceneh/2);
			shape.graphics.lineTo(scenew/2,sceneh/2+length*Configrations.Tile_Height/2+5);
			shape.graphics.lineTo(scenew/2-length* Configrations.Tile_Width/2-5,sceneh/2);
			shape.graphics.lineTo(scenew/2,sceneh/2-length*Configrations.Tile_Height/2-5);
			shape.graphics.endFill();
			
			addChild(shape);
		}
		
		private function initEntity():void
		{
			entityDic = new Vector.<GameEntity>;
			
			var entity:GameEntity;
			var entityItem:EntityItem;
			for each(entityItem in player.decorationItems){
				if(entityItem.ishouse){
					entity = new HouseEntity(entityItem);
				}else{
					entity = new GameEntity(entityItem);
				}
				addEntityLayer(entity);
				entityDic.push(entity);
				maxDecId = Math.max(maxDecId,entityItem.data_id);
			}
			
			for each(entityItem in player.cropItems){
				entity = new CropEntity(entityItem as CropItem);
				maxFieldId = Math.max(maxFieldId,entityItem.data_id);
				addEntityLayer(entity);
				entityDic.push(entity);
			}
			
			sortEntityLayer();
		}
		private function addCropEntity(cropItem:CropItem):void
		{
			var crop:CropEntity = new CropEntity(cropItem);
			addEntityLayer(crop);
			entityDic.push(crop);
			player.addCropItem(cropItem);
			sortEntityLayer();
		}
		public function addEntity(item:EntityItem):void
		{
			var entity:GameEntity = new GameEntity(item);
			addEntityLayer(entity);
			entityDic.push(entity);
			maxDecId = Math.max(maxDecId,item.data_id);
			sortEntityLayer();
		}
		public function addAnimalEntity(entity:AnimalEntity):void
		{
			addEntityLayer(entity);
			entityDic.push(entity);
			sortEntityLayer();
		}
			
		public function removeEntity(entity:GameEntity):void{
				var index:int = entityDic.indexOf(entity);
				if(index >=0){
					entityDic.splice(index,1);
					if(entity is CropEntity && (entity as CropEntity).fieldSUR.parent){
						fieldLayer.removeChild((entity as CropEntity).fieldSUR);
					}
					if(entity.parent){
						entity.parent.removeChild(entity);
					}
				}
		}
		
		private var _hasDragged:Boolean;
		public function get hasDragged():Boolean{
			return _hasDragged
		}
		protected function get mouseStagePosition():Point{
			return new Point(stage.pivotX,stage.pivotY);
		}
		public var curBeginTouch:Touch;
		private var mouseDownPos:Point;
		private var mouseDownEntity:GameEntity;
		private var _currentDrag:GameEntity;
		private var lastEntity:GameEntity;
		public function onTouch(evt:TouchEvent):void{
			var scenePos:Point;
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length == 1){
				if(currentMoveEntity){
					scenePos = touches[0].getLocation(this);
					currentMoveEntity.moveEntity(scenePos);
				}else{
					if(GameController.instance.selectTool == UiController.TOOL_ADDFEILD){
						scenePos = touches[0].getLocation(this);
						addField(scenePos,2,2);
					}else{
						
						if(!_hasDragged){
							if (mouseStagePosition && mouseDownPos && mouseStagePosition.subtract(mouseDownPos).length >= Configrations.CLICK_EPSILON){
								_hasDragged = true;
							}
						}else if(GameController.instance.selectTool && mouseDownEntity){
							findEntity(new Point(touches[0].globalX, touches[0].globalY), TouchPhase.MOVED);
						}else{
							var delta:Point = touches[0].getMovement(this.parent);
							this.dragScreenTo(delta);
						}
					}
				}
			}else if (touches.length >= 2){
				if(curBeginTouch){
					curBeginTouch = null;
				}
				this.scaleScreen(touches[0],touches[1])
			}else{
				touches = evt.getTouches(this, TouchPhase.HOVER);
				if (touches.length >= 2){
					this.scaleScreen(touches[0],touches[1]);
				}else if(touches.length == 1 && GameController.instance.selectTool){
					findEntity(new Point(touches[0].globalX, touches[0].globalY), TouchPhase.HOVER);
				}
			}
			
			//touch begin
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				mouseDownPos = new Point(beginTouch.globalX, beginTouch.globalY);
				curBeginTouch = beginTouch;
				if(GameController.instance.selectTool == UiController.TOOL_ADDFEILD){
					scenePos = beginTouch.getLocation(this);
					addField(scenePos,2,2);
				}else{
					mouseDownEntity = findEntity(mouseDownPos,TouchPhase.BEGAN);
					if(!mouseDownEntity){
						mouseDownEntity = findEntityByTouch(mouseDownPos,TouchPhase.BEGAN);
						if(!mouseDownEntity){
							UiController.instance.hideUiTools();
						}
					}
				}
			}
			
			var touch:Touch = evt.getTouch(this, TouchPhase.ENDED);
			//click event
			if(touch){
				if(currentMoveEntity){
					currentMoveEntity.releaseEntity();
				}else{
					mouseDownEntity = null;
					if(lastEntity){
						lastEntity.doTouchEvent(TouchPhase.ENDED);
						lastEntity = null;
					}
					if(curBeginTouch){
						curBeginTouch = null;
					}
					if(!_hasDragged){
						if(_currentDrag){
						}else{
						}
					}else{
						if(_currentDrag){
							_currentDrag=null;
						}
						_hasDragged=false;
					}
				}
			}
		}
		
		private var lastCheckTile:Tile;
		private function addField(scenePos:Point,len_x:int,len_y:int):void
		{
			if(player.leftFarmLand >0){
				var tile:Tile = Map.intance.sceneToIso(scenePos);
				if(tile &&  tile != lastCheckTile){
					var tile1:Tile = Map.intance.getTileByIos(tile.x+len_x-1,tile.y+len_y-1);
					if(tile1){
						var valiable:Boolean = checkValiable(tile,len_x,len_y);
						if(valiable){
							maxFieldId++;
							var fieldObje:Object = {positionx:tile.x,positiony:tile.y,gameuid:player.gameuid,data_id:maxFieldId};
							UpdateController.instance.pushActionData(new UpdateData(player.gameuid,Configrations.ADD_FIELD,fieldObje));
							var item:CropItem = new CropItem(fieldObje);
							addCropEntity(item);
						}
					}
				}
				lastCheckTile = tile;
			}else{
				GameController.instance.resetTools();
				DialogController.instance.showPanel(new ExtendFarmLandPanel);
			}
		}
		private function checkValiable(toptile:Tile,len_x:int,len_y:int):Boolean
		{
			var index_x:int = toptile.x;
			var index_y:int;
			var tile:Tile;
			while(index_x<(toptile.x + len_x)){
				index_y = toptile.y;
				while(index_y <(toptile.y+len_y)){
					tile = Map.intance.getTileByIos(index_x,index_y);
					if(tile && !tile.owner){
						
					}else{
						return false;
					}
					index_y++;
				}
				index_x++;
			}
			return true;
		}
		private function sortEntityLayer():void
		{
			var depthArr:Array = [];
			var objA:DisplayObject;
			var entity:GameEntity;
			var max:uint = entityLayer.numChildren;
			var i:uint = 0;
			
			for (i=0; i < max; ++i)
			{
				objA = entityLayer.getChildAt(i);
				if(objA is GameEntity){
					depthArr.push({ index : (objA as GameEntity).sceneIndex, iso : objA });
				}
			}
			max = depthArr.length;
			depthArr.sortOn("index", Array.NUMERIC);
			for (i = 0; i < max; i++) {
				entity = depthArr[i]['iso'];
				entityLayer.setChildIndex(entity, i);
			}
		}
		
		private var currentMoveEntity:GameEntity;
		public function addMoveEntity(entity:GameEntity):void
		{
			removeMoveEntity();
			entity.intoMoveMode();
			if(entity is CropEntity){
				effectLayer.addChild((entity as CropEntity).fieldSUR);
			}
			effectLayer.addChild(entity);
			currentMoveEntity = entity;
		}
		public function putDownEntity(entity:GameEntity):void
		{
			if(currentMoveEntity != entity){
				removeMoveEntity();
			}
			addEntityLayer(currentMoveEntity);
			currentMoveEntity = null;
			sortEntityLayer();
		}
		public function removeMoveEntity():void
		{
			if(currentMoveEntity){
				currentMoveEntity.cancel();
				addEntityLayer(currentMoveEntity);
				currentMoveEntity = null;
			}
			
		}
		
		private function addEntityLayer(entity:GameEntity):void{
			if(entity.isFloor){
				fieldLayer.addChild(entity);
			}else{
				entityLayer.addChild(entity);
			}
			if(entity is CropEntity){
				fieldLayer.addChild((entity as CropEntity).fieldSUR);
			}
		}
		public function getCurrentFocusPos(lengthx:int,lengthy:int):Tile
		{
			var targetTile:Tile;
			var len:int = player.wholeSceneLength;
			var centerPoint:Point = globalToLocal(new Point(Configrations.ViewPortWidth/2,Configrations.ViewPortHeight/2));
			var centerIos:Tile = Map.intance.sceneToIso(centerPoint);
			if(centerIos){
				targetTile = Map.intance.getTileByIos(Math.min(centerIos.x,len - lengthx),Math.min(centerIos.y,len-lengthy));
			}else{
				targetTile = Map.intance.getTileByIos(Math.round(len/2),Math.round(len/2));
			}
			return targetTile;
		}
		private function findEntity(point:Point,type:String):GameEntity
		{
			var entity:GameEntity;
			var scenePos:Point = globalToLocal(point);
			var tile:Tile = Map.intance.sceneToIso(scenePos);
			if(tile &&tile.owner){
				tile.owner.doTouchEvent(type);
				entity =  tile.owner;
			}
			if(lastEntity && lastEntity!=entity){
				lastEntity.doTouchEvent(TouchPhase.ENDED);
			}
			lastEntity = entity;
			return entity;
		}
		private function findEntityByTouch(point:Point,type:String):GameEntity
		{
			var entity:GameEntity ;
			var localPos:Point;
			var index:int = entityDic.length-1;
			while(index>=0){
				entity = entityDic[index];
				localPos = entity.globalToLocal(point);
				if(entity.hitTest(localPos)){
					entity.doTouchEvent(type);
					if(lastEntity && lastEntity!=entity){
						lastEntity.doTouchEvent(TouchPhase.ENDED);
					}
					return entity;
				}
				index --;
			}
			return null;
		}
		
		private function scaleScreen(touchA:Touch,touchB:Touch):void{
			var currentPosA:Point  = touchA.getLocation(this);
			var previousPosA:Point = touchA.getPreviousLocation(this);
			var currentPosB:Point  = touchB.getLocation(this);
			var previousPosB:Point = touchB.getPreviousLocation(this);
			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
//			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
//			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
//			var deltaAngle:Number = currentAngle - previousAngle;
			
			var sizeDiff:Number = currentVector.length / previousVector.length;
			var scale:Number = Math.max(0.5,Math.min(2,scaleX*sizeDiff));
			if(scale != scaleX){
				var delx:Number = -(scenew*scale - scenew *scaleX)/2; 
				var dely:Number = -(sceneh*scale - sceneh *scaleX)/2; 
				this.setScale(scale);
				dragScreenTo(new Point(delx,dely));
			}
		}
		public function setScale(panScale:Number):void
		{
			if(scenew*scaleX*panScale > Configrations.ViewPortWidth && sceneh*scaleY*panScale > Configrations.ViewPortHeight){
				var scale:Number = Math.max(0.5,Math.min(2,scaleX*panScale));
				scaleX =scaleY= panScale;
			}
		}
		protected function dragScreenTo(delta:Point):void
		{
			if(x+delta.x >0){
				x = 0;
			}else if((x+delta.x)<(Configrations.ViewPortWidth - scenew*scaleX)){
				x = (Configrations.ViewPortWidth - scenew*scaleX);
			}else{
				x+=delta.x;
			}
			if(y+delta.y >0){
				y = 0;
			}else if((y+delta.y)<(Configrations.ViewPortHeight - sceneh*scaleY)){
				y = (Configrations.ViewPortHeight - sceneh*scaleY);
			}else{
				y+=delta.y;
			}
		}
		
		//技能
		public function playSkill():void
		{
			var entity:GameEntity;
			var skill :SkillData = player.skillData;
			var speedArr:Array = [];
			var harArr:Array = [];
			for each(entity in entityDic){
				if(entity is CropEntity){
					if(((entity as CropEntity).cropItem).hasCrop){
						if(((entity as CropEntity).cropItem).canSpeed){
							speedArr.push(entity);
						}
					}
				}
			}
			
			var speedC:int ;
			if(GameController.instance.isHomeModel)
			{
				speedC = skill.speedCount;
			}else{
				speedC = 5;
			}
			var speedR:Array = [];
			var crop:CropEntity;
			for (var i:int = 0; i<speedC; i++) {
				if (speedArr.length>0) {
					var arrIndex:Number = Math.floor(Math.random()*speedArr.length);
					crop = speedArr[arrIndex];
					speedR.push(crop.item.data_id);
					speedArr.splice(arrIndex, 1);
					
					if(GameController.instance.isHomeModel)
					{
						crop.showSkillSpeed();
					}else{
						crop.showHelpSpeed();
					}
				} else {
					break;
				}
			}
			
			if(speedR.length <=0 ){
				//提醒
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("skillTip03")));
			}else{
				if(GameController.instance.isHomeModel){
					new UserSkillCommand(speedR,onSkillCommandSuc);
					player.skill_time = SystemDate.systemTimeS;
				}else{
					new HelpFriendCommand(player.gameuid,speedR,player.cur_mes_dataid+1,onHelped);
					player.lastHelpedTime = SystemDate.systemTimeS;
				}
			}
		}
		//刷 野草
		public function checkWeeds():void
		{
			var shareo:SharedObject  = SharedObject.getLocal("WeedInfoTime","/");
			var lastTime:int;
			if(shareo && shareo.data && shareo.data.obj){
				lastTime = shareo.data.obj;
				if((lastTime - SystemDate.systemTimeS) < 3600){
					return;
				}
			}
			
			var tiles:Vector.<Tile> = Map.intance.tiles.concat();
			var newTiles:Array = [];
			while(tiles.length>0){
				newTiles.push(tiles.splice(Math.floor(Math.random()*tiles.length),1)[0]);
			}
			var i:int = 0;
			var bool:Boolean;
			var tile:Tile;
			for (i;i<newTiles.length;i++){
				tile = newTiles[i];
				bool = checkValiable(tile,2,2);
				if(bool){
					maxDecId++;
					new CreatWeed(tile,maxDecId,function():void{
						shareo.data.obj = SystemDate.systemTimeS;
						shareo.flush();
					});
					break;
				}
			}
			
		}
		
		private function onHelped():void
		{
			player.lastHelpedTime = SystemDate.systemTimeS;
			player.cur_mes_dataid++;
			player.addMessage(new MessageData({gameuid:player.gameuid,f_gameuid:GameController.instance.localPlayer.gameuid,
				message:"",type:Configrations.MESSTYPE_HELP,data_id:GameController.instance.currentPlayer.cur_mes_dataid,updatetime :SystemDate.systemTimeS}));
			var texture:Texture = Game.assets.getTexture("loveIcon");
			var stagePoint:Point  = new Point(Configrations.ViewPortWidth - 100*Configrations.ViewScale, Configrations.ViewPortHeight/2);
			GameController.instance.effectLayer.addTweenCrop(texture,stagePoint,0);
		}
		private function onSkillCommandSuc():void
		{
			player.skill_time = SystemDate.systemTimeS;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private var maxFieldId:int = 1000;
		public var maxDecId:int = 1000;
	}
}