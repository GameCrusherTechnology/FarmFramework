package view
{
	import flash.geom.Point;
	
	import controller.FieldController;
	
	import gameconfig.Configrations;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	
	import view.effect.RainEffect;

	public class TweenEffectLayer extends Sprite
	{
		public function TweenEffectLayer()
		{
			
		}
		
		public function showExpAddEffect(addExp:int,startPoint):void
		{
			var tween:Tween;
			var effectSp:Sprite =new Sprite;
			effectSp.touchable = false;
			var starIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			effectSp.addChild( starIcon);
			starIcon.width = starIcon.height = 30 *Configrations.ViewScale ;
			var scale:Number = starIcon.scaleX *2;
			var text:TextField = FieldController.createSingleLineDynamicField(100,16,"+"+addExp,0xffffff,15,true);
			text.hAlign = HAlign.LEFT;
			effectSp.addChild( text);
			text.x = starIcon.x + starIcon.width;
			text.y = starIcon.y + starIcon.height/2 - text.height/2;
			addChild(effectSp);
			effectSp.x = startPoint.x - effectSp.width/2;
			effectSp.y = startPoint.y - effectSp.height;
			
			tween = new Tween(effectSp,2,Transitions.LINEAR);
			tween.animate("y", effectSp.y - 30);
			tween.scaleTo(scale);
			Starling.juggler.add(tween);
			tween.onComplete = function(){
				if(effectSp&&effectSp.parent){
					removeChild(effectSp);
					effectSp = null;
				}
				
			};
		}
		
		public function addTweenFacItem(display:DisplayObject,startPoint:Point,delay:Number=0):void
		{
			var tween:Tween;
			var tween1:Tween;
			var itemIcon:DisplayObject = display;
			addChild( itemIcon);
			var leftDownPoint:Point = new Point(0,Configrations.ViewPortHeight );
			itemIcon.width = itemIcon.height = 30 *Configrations.ViewScale ;
			var scale:Number = itemIcon.scaleX *2;
			itemIcon.x = startPoint.x - itemIcon.width/2;
			itemIcon.y = startPoint.y - itemIcon.height;
			
			tween = new Tween(itemIcon,2,Transitions.EASE_IN_OUT_BACK);
			tween.delay = delay ;
			tween.animate("y", leftDownPoint.y);
			tween.animate("rotation", deg2rad(360));
			tween.scaleTo(scale);
			Starling.juggler.add(tween);
			tween.onComplete = function():void{
				if(itemIcon&&itemIcon.parent){
					removeChild(itemIcon);
					itemIcon = null;
				}
			};
			
			tween1 = new Tween(itemIcon,2,Transitions.LINEAR);
			tween1.delay = delay ;
			tween1.animate("x",leftDownPoint.x);
			Starling.juggler.add(tween);
			Starling.juggler.add(tween1);
		}
		
		private var starArr:Array =[];
		public function addTweenCrop(display:DisplayObject,startPoint:Point,delay:Number=0):void
		{
			var tween:Tween;
			var tween1:Tween;
			var cropIcon:DisplayObject = display;
			addChild( cropIcon);
			cropIcon.width = cropIcon.height = 30 *Configrations.ViewScale ;
			var scale:Number = cropIcon.scaleX *2;
			cropIcon.x = startPoint.x -cropIcon.width/2;
			cropIcon.y = startPoint.y - cropIcon.height;
			
			tween = new Tween(cropIcon,2,Transitions.EASE_IN_OUT_BACK);
			tween.delay = delay ;
			tween.animate("y", bagPoint.y);
			tween.animate("rotation", deg2rad(360));
			tween.scaleTo(scale);
			Starling.juggler.add(tween);
			tween.onComplete = function(){
				if(cropIcon&&cropIcon.parent){
					removeChild(cropIcon);
					cropIcon = null;
				}
				var starMc:MovieClip = new MovieClip(Game.assets.getTextures("starExplodeEffect"));
				starMc.touchable = false;
				addChild( starMc);
				starMc.x = bagPoint.x +Math.random()*30-15-starMc.width/2;
				starMc.y = bagPoint.y +Math.random()*30-15-starMc.height/2;
				starArr.push(starMc);
			};
			
			tween1 = new Tween(cropIcon,2,Transitions.LINEAR);
			tween1.delay = delay ;
			tween1.animate("x",bagPoint.x);
			Starling.juggler.add(tween);
			Starling.juggler.add(tween1);
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			var mc:MovieClip;
			for each(mc in starArr){
				if(mc.currentFrame<mc.numFrames-1){
					mc.currentFrame++;
				}else{
					if(mc.parent){
						mc.parent.removeChild(mc);
					}
					starArr.splice(mc,1);
					break;
				}
			}
		}
		
		
		public function addRainEffect(point:Point):void
		{
			var rainEffect:RainEffect = new RainEffect();
			addChild(rainEffect);
			rainEffect.x = point.x;
			rainEffect.y = point.y;
		}
		private var bagPoint:Point = new Point(50,Configrations.ViewPortHeight-50);
	}
}