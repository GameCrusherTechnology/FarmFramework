package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TutorialPanel extends PanelScreen
	{
		private var guideSpeechContainer:Sprite;
		private var speechW:Number;
		private var speechH:Number;
		private var mClipQuad : Quad;
		
		public function TutorialPanel()
		{
			speechW = Configrations.ViewPortWidth *0.6;
			speechH = Configrations.ViewPortHeight *0.1;
			
//			var bgSkin:Shape = new Shape;
//			bgSkin.graphics.beginFill(0x000000,0);
//			bgSkin.graphics.drawCircle(500,300,60);
//			bgSkin.graphics.beginFill(0x000000,1);
//			bgSkin.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
//			bgSkin.graphics.endFill();
//			addChild(bgSkin);
			
//			var scissorRect:Rectangle = new Rectangle(0, 0, 150, 150); 
//			this.clipRect = scissorRect;
//			
//			mClipQuad = new Quad(scissorRect.width, scissorRect.height, 0xff0000);
//			mClipQuad.x = 500;
//			mClipQuad.y = 300;
//			mClipQuad.alpha = 1;
//			mClipQuad.touchable = false;
//			addChild(mClipQuad);
			
			guideSpeechContainer = new Sprite;
			addChild(guideSpeechContainer);
			
		}
		private var curStep:int = 0;
		public function addSpeechStep():void
		{
			var h:Number = guideSpeechContainer.height + 20;
			var obj:Object = tutorialSteps[curStep];
			if(obj){
				var isLeft:Boolean = obj.isleft;
				var speechMC:Sprite = creatSpeech(obj.iconName,obj.text,isLeft);
				guideSpeechContainer.addChild(speechMC);
				if(isLeft){
					speechMC.x= Configrations.ViewPortWidth *0.1;
				}else{
					speechMC.x= Configrations.ViewPortWidth *0.3;
				}
				speechMC.y = h;
				moveContainer(true);
				curStep++;
			}
		}
		private function creatSpeech(iconName:String,text:String,isLeft:Boolean =false):Sprite
		{
			var container:Sprite = new Sprite;
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("talkSkin"),new Rectangle(10,10,100,50));
			var skin :Scale9Image = new Scale9Image(skinTexture);
			skin.width = speechW;
			skin.height = speechH;
			container.addChild(skin);
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			icon.height = speechH*1.5;
			if(isLeft){
				icon.scaleX = icon.scaleY;
				icon.x = -icon.width/2;
			}else{
				icon.scaleX = -icon.scaleY;
				icon.x = speechW + icon.width/2;
			}
			container.addChild(icon);
			icon.y = speechH - icon.height;
			
			var speechText:TextField = FieldController.createSingleLineDynamicField( speechW-icon.width,speechH*0.8,text,0x000000,30,true);
			speechText.vAlign = VAlign.CENTER;
			if(isLeft){
				speechText.hAlign = HAlign.LEFT;
				speechText.x = icon.width;
			}else{
				speechText.hAlign = HAlign.RIGHT;
				speechText.x = 0;
			}
			
			container.addChild(speechText);
			return container;
		}
		
		private function moveContainer(isTween:Boolean=false):void
		{
			if(isTween){
				var tween:Tween = new Tween(guideSpeechContainer,0.5);
				tween.animate("y",Configrations.ViewPortHeight/2 - (guideSpeechContainer.height - speechH/2));
				Starling.juggler.add(tween);
			}else{
				guideSpeechContainer.y = Configrations.ViewPortHeight/2 - (guideSpeechContainer.height - speechH/2);
			}
		}
		
		private function clearContainer():void
		{
			var displayObj:DisplayObject;
			while(guideSpeechContainer.numChildren>0){
				displayObj = guideSpeechContainer.getChildAt(0);
				guideSpeechContainer.removeChild(displayObj);
			}
		}
		
		private const tutorialSteps:Array =[{iconName:"femaleIcon",text:"hello",isleft:true},
											{iconName:"maleIcon",text:"hello1",isleft:false},
											{iconName:"femaleIcon",text:"hello2",isleft:true},
											{iconName:"maleIcon",text:"hello3",isleft:false},
											{iconName:"femaleIcon",text:"hello4",isleft:true},
											{iconName:"maleIcon",text:"hello5",isleft:false},
											{iconName:"femaleIcon",text:"hello6",isleft:true},
											{iconName:"maleIcon",text:"hello7",isleft:false},
											{iconName:"femaleIcon",text:"hello8",isleft:true},
											{iconName:"maleIcon",text:"hello9",isleft:false},
											{iconName:"femaleIcon",text:"hello10",isleft:true},
											{iconName:"maleIcon",text:"hello11",isleft:false},
											{iconName:"femaleIcon",text:"hello12",isleft:true}];
	}
}