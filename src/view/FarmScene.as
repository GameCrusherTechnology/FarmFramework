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
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.entity.CropEntity;
	import view.entity.GameEntity;
	import view.entity.MovableEntity;

	public class FarmScene extends Sprite
	{
		[Embed(source="/init/bgCell.png")]
		public static var bgClass:Class;
		
		private var entityLayer:Sprite;
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
				cropDic.push(crop);
			}
		}
		public function removeEntity(entity:CropEntity):void{
			var index:int = cropDic.indexOf(entity);
			if(index >=0){
				cropDic.splice(index,1);
				entityLayer.removeChild(entity);
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
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length == 1){
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
				mouseDownEntity = findEntity(mouseDownPos,TouchPhase.BEGAN);
				if(!mouseDownEntity){
					UiController.instance.hideUiTools();
				}
			}
			
			var touch:Touch = evt.getTouch(this, TouchPhase.ENDED);
			//click event
			if(touch){
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
		
		private var currentMoveEntity:MovableEntity;
		public function addMoveEntity(entity:GameEntity=null):void
		{
			removeMoveEntity();
			currentMoveEntity = new MovableEntity(entity);
			effectLayer.addChild(currentMoveEntity);
		}
		public function removeMoveEntity():void
		{
			if(currentMoveEntity){
				currentMoveEntity.cancel();
				if(currentMoveEntity.parent)
				{
					currentMoveEntity.parent.removeChild(currentMoveEntity);
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