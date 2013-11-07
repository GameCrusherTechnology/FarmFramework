package view
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.CropItem;
	import model.player.GamePlayer;
	
	import starling.display.DisplayObject;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.entity.CropEntity;
	import view.entity.GameEntity;

	public class FarmScene extends Sprite
	{
		[Embed(source="/init/bgCell.png")]
		public static var bgClass:Class;
		
		public var fieldLayer:Sprite;
		public var entityLayer:Sprite;
		private var scenew:Number;
		private var sceneh:Number;
		public var cropDic:Vector.<CropEntity>;
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
			
			x = -(length-1)* Configrations.Tile_Width/2;
			y = -(length-1)* Configrations.Tile_Height/2;
		}
		
		private function initBackground(scenew:Number,sceneh:Number,length:int):void
		{
			var bitmap:Bitmap = new bgClass();
			var shape:Shape = new Shape();
			shape.graphics.beginTextureFill(Texture.fromBitmap(bitmap));
			shape.graphics.drawRect(0,0,scenew,sceneh);
			shape.graphics.endFill();
			
			shape.graphics.lineStyle(2,0xffff00,1);
			shape.graphics.moveTo(scenew/2,sceneh/2-length*Configrations.Tile_Height/2);
			shape.graphics.lineTo(scenew/2+length* Configrations.Tile_Width/2,sceneh/2);
			shape.graphics.lineTo(scenew/2,sceneh/2+length*Configrations.Tile_Height/2);
			shape.graphics.lineTo(scenew/2-length* Configrations.Tile_Width/2,sceneh/2);
			shape.graphics.lineTo(scenew/2,sceneh/2-length*Configrations.Tile_Height/2);
			shape.graphics.endFill();
			
			addChild(shape);
		}
		
		private function initEntity():void
		{
			cropDic = new Vector.<CropEntity>;
			var crop:CropEntity ;
			for each(var cropItem:CropItem in player.cropItems){
				crop = new CropEntity(cropItem);
				entityLayer.addChild(crop);
				fieldLayer.addChild(crop.fieldSUR);
				cropDic.push(crop);
			}
			sortEntityLayer();
		}
		public function addFarmEntity(cropItem:CropItem):void
		{
			var crop:CropEntity = new CropEntity(cropItem);
			entityLayer.addChild(crop);
			fieldLayer.addChild(crop.fieldSUR);
			cropDic.push(crop);
			sortEntityLayer();
		}
			
		public function removeEntity(entity:GameEntity):void{
			if(entity is CropEntity){
				var index:int = cropDic.indexOf(entity as CropEntity);
				if(index >=0){
					cropDic.splice(index,1);
					fieldLayer.removeChild((entity as CropEntity).fieldSUR);
					entityLayer.removeChild(entity);
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
						UiController.instance.hideUiTools();
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
			var tile:Tile = Map.intance.sceneToIso(scenePos);
			if(tile &&  tile != lastCheckTile){
				var tile1:Tile = Map.intance.getTileByIos(tile.x+len_x-1,tile.y+len_y-1);
				if(tile1){
					var valiable:Boolean = checkValiable(tile,len_x,len_y);
					if(valiable){
						var item:CropItem = new CropItem({ios_x:tile.x,ios_y:tile.y});
						addFarmEntity(item);
					}
				}
			}
			lastCheckTile = tile;
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
			entityLayer.addChild(currentMoveEntity);
			if(entity is CropEntity){
				fieldLayer.addChild((entity as CropEntity).fieldSUR);
			}
			currentMoveEntity = null;
			sortEntityLayer();
		}
		public function removeMoveEntity():void
		{
			if(currentMoveEntity){
				currentMoveEntity.cancel();
				entityLayer.addChild(currentMoveEntity);
				if(currentMoveEntity is CropEntity){
					fieldLayer.addChild((currentMoveEntity as CropEntity).fieldSUR);
				}
				currentMoveEntity = null;
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
		
		private function scaleScreen(touchA:Touch,touchB:Touch):void{
			var currentPosA:Point  = touchA.getLocation(this.parent);
			var previousPosA:Point = touchA.getPreviousLocation(this.parent);
			var currentPosB:Point  = touchB.getLocation(this.parent);
			var previousPosB:Point = touchB.getPreviousLocation(this.parent);
			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number = currentAngle - previousAngle;
			
			var sizeDiff:Number = currentVector.length / previousVector.length;
			this.setScale(sizeDiff);
		}
		public function setScale(panScale:Number):void
		{
			if(scenew*scaleX*panScale > Configrations.ViewPortWidth && sceneh*scaleY*panScale > Configrations.ViewPortHeight){
				scaleX =scaleY= scaleX*panScale;
				dragScreenTo(new Point(0,0));
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
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}