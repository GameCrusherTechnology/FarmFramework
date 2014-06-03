package view.entity
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.AnimalItem;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.BuyRanchPanel;

	public class StandAnimalEntity extends GameEntity
	{
		
		private var creatLevel:int;
		public function StandAnimalEntity(item:AnimalItem,level:int)
		{
			creatLevel = level;
			super(item);
		}
		override protected function creatSurface():void
		{
			var s:String = Math.random()>0.5?"Eat":"Stand";
			playAnimation(s);
		}
		override public function configPosition():void
		{
			var bottomPoint :Point = Map.intance.getBottomPoint();
			var rightPoint:Point = Map.intance.iosToScene(12,0);
			x = rightPoint.x;
			y = bottomPoint.y;
			
		}
		
		override public function get sceneIndex():Number
		{
			var tile :Tile =  Map.intance.sceneToNearIso(new Point(x,y));
			return (tile.x+1/2+tile.y+1/2)* 1000 + tile.x+1/2;
			
		}
		
		private function playAnimation(_motion:String):void
		{
			surface = new MovieClip(Game.assets.getTextures(animalItem.name+"/"+animalItem.name+_motion));
			addChild(surface);
			surface.x = - surface.width/2;
			surface.y = - surface.height;
			Starling.juggler.add(surface);
			
		}
		
		override public function doTouchEvent(type:String):void
		{
			switch(type){
				case TouchPhase.BEGAN:
					if(player.level >= creatLevel){
//						DialogController.instance.showPanel(new CreatRanchPanel(item.itemspec),true);
						DialogController.instance.showPanel(new BuyRanchPanel(item.itemspec),true);
					}else{
						showWarnning(creatLevel);
					}
					break;
			}
		}
		private var warnningTip:Sprite;
		private function showWarnning(creatL:int):void
		{
			if(!warnningTip){
				warnningTip = new Sprite;
				var texture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30));
				var skin:Scale9Image = new Scale9Image(texture);
				warnningTip.addChild(skin);
				skin.alpha = 0.8;
				var mesText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth*0.8,Configrations.ViewPortHeight*0.3,
					LanguageController.getInstance().getString("warnTip01")+creatL ,0xff0000,30,true);
				mesText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				warnningTip.addChild(mesText);
				mesText.touchable = false;
				skin.width = mesText.width + 20*Configrations.ViewScale;
				skin.height = mesText.height + 10*Configrations.ViewScale;
				mesText.x = skin.x + 10*Configrations.ViewScale;
				mesText.y = skin.y + 5*Configrations.ViewScale;
			}else{
				warnningTip.alpha = 1;
			}
			addChild(warnningTip);
			warnningTip.x = -warnningTip.width/2;
			warnningTip.y = surface.y - warnningTip.height;
			
			var tween:Tween = new Tween(warnningTip,5);
			tween.animate("alpha",0);
			tween.onComplete = function():void {
				if(warnningTip.parent){
					warnningTip.parent.removeChild(warnningTip);
					
				}
				Starling.juggler.removeTweens(warnningTip);
			};
			Starling.juggler.add(tween);
		}
		
		public function get animalItem():AnimalItem
		{
			return item as AnimalItem;
		}
		
	}
}