package controller
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.avatar.Map;
	import model.entity.CropItem;
	import model.entity.EntityItem;
	import model.player.GamePlayer;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.effect.ArrowEffect;
	import view.panel.TutorialMesPanel;
	
	public class TutorialController extends EventDispatcher
	{
		private static var _controller:TutorialController;
		private var curStep:int = 0;
		private var _arrowIcon : ArrowEffect;
		private var _tutorialPanel:TutorialMesPanel;
		private function get tutorialPanel():TutorialMesPanel
		{
			if(!_tutorialPanel){
				_tutorialPanel = new TutorialMesPanel();
			}
			return _tutorialPanel;
		}
		
		private function get arrowIcon():ArrowEffect
		{
			if(!_arrowIcon){
				_arrowIcon = new ArrowEffect();
			}
			return _arrowIcon;
		}
		private var _inTutorial:Boolean;
		public function get inTutorial():Boolean
		{
			return _inTutorial;
		}
		public static function get instance():TutorialController
		{
			if(!_controller){
				_controller = new TutorialController();
			}
			return _controller;
		}
		public function TutorialController()
		{
			
		}
		
		public function beginTutorial():void
		{
			_inTutorial = true;
			arrowIcon.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			configStep(curStep);
		}
		
		public function playStep(step:int):void
		{
			if(curStep == (step-1)){
				curStep = step;
				configStep(step);
			}else{
				trace("error");
			}
		}
		
		public function playNextStep():void
		{
			curStep++;
			configStep(curStep);
		}
		private function onTutorialTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(tutorialPanel,TouchPhase.BEGAN);
			if(touch){
			}
		}
		
		
		
		private function getHasFieldPos():Point
		{
			var point:Point ;
			var crops:Array = player.cropItems;
			for each(var item:CropItem in crops){
				if(item.canHarvest){
					point = Map.intance.iosToScene(item.positionx,item.positiony);
					break;
				}
			}
			if(point){
				point = new Point(point.x,point.y-arrowIcon.height);
				GameController.instance.currentFarm.foucesOn(point);
				point = GameController.instance.currentFarm.localToGlobal(point);
			}else{
				point = new Point(0,0);
				outTutorial();
			}
			return point;
		}
		
		private function getSeedFieldPos():Point
		{
			var point:Point ;
			var crops:Array = player.cropItems;
			for each(var item:CropItem in crops){
				if(!item.hasCrop){
					point = Map.intance.iosToScene(item.positionx,item.positiony);
					break;
				}
			}
			if(point){
				point = new Point(point.x,point.y-arrowIcon.height);
				GameController.instance.currentFarm.foucesOn(point);
				point = GameController.instance.currentFarm.localToGlobal(point);
			}else{
				point = new Point(0,0);
				outTutorial();
			}
			return point;
		}
		
		private function getSpeedFieldPos():Point
		{
			var point:Point ;
			var crops:Array = player.cropItems;
			for each(var item:CropItem in crops){
				if(item.canSpeed){
					point = Map.intance.iosToScene(item.positionx,item.positiony);
					break;
				}
			}
			if(point){
				point = new Point(point.x,point.y-arrowIcon.height);
				GameController.instance.currentFarm.foucesOn(point);
				point = GameController.instance.currentFarm.localToGlobal(point);
			}else{
				point = new Point(0,0);
				outTutorial();
			}
			return point;
		}
		private function getWeedPos():Point
		{
			var point:Point ;
			var crops:Array = player.decorationItems;
			var lastWild:EntityItem;
			for each(var item:EntityItem in crops){
				if(item.isWild && item.itemspec.coinPrice >0){
					if(!lastWild){
						lastWild = item;
					}else if(lastWild.itemspec.coinPrice > item.itemspec.coinPrice){
						lastWild = item;
					}
				}
			}
			if(lastWild){
				point = Map.intance.iosToScene(lastWild.positionx,lastWild.positiony);
			}
			if(point){
				point = new Point(point.x,point.y-arrowIcon.height);
				GameController.instance.currentFarm.foucesOn(point);
				point = GameController.instance.currentFarm.localToGlobal(point);
			}else{
				point = new Point(0,0);
				outTutorial();
			}
			return point;
		}
		private function configStep(stepInt:int):void
		{
			var stepData:Object = getStepDate(stepInt);
			if(!stepData){
				outTutorial();
			}else{
				var iconData:Object = stepData.icon;
				var speechData:String = stepData.speech;
				if(_inTutorial){
					if(iconData){
						UiController.instance.UILayer.addChild(arrowIcon);
						arrowIcon.x = iconData.p.x;
						arrowIcon.y = iconData.p.y;
						curPos = iconData.p;
						arrowIcon.setRot(iconData.r);
						if(iconData.r == 270){
							spx = 0;
							spy = 1;
						}else if(iconData.r == 180){
							spx = 1;
							spy = 0;
						}else if(iconData.r == 90){
							
						}else{
							
						}
					}else{
						if(arrowIcon.parent){
							arrowIcon.parent.removeChild(arrowIcon);
						}
					}
					
					if(speechData){
						tutorialPanel.talk(speechData);
						UiController.instance.UILayer.addChild(tutorialPanel);
						tutorialPanel.x = Configrations.ViewPortWidth*0.5 - tutorialPanel.width/2;
						tutorialPanel.y = 20*Configrations.ViewScale;
					}else{
						if(tutorialPanel.parent){
							tutorialPanel.parent.removeChild(tutorialPanel);
						}
					}
					
					
					if(stepInt == totalStep){
						setTimeout(outTutorial,5000);
					}
				}
			}
		}
		private var totalStep:int = 14;
		private var tin:int = 0;
		private var curPos:Point;
		private var spx:Number = 1;
		private var spy:Number = 1;
		private function enterFrameHandler(event:Event=null):void
		{
			arrowIcon.x -= spx;
			arrowIcon.y -= spy;
			if(tin >=20){
				tin = 0;
				spx = -spx;
				spy = -spy;
			}
			tin++;
			
		}
		
		private function outTutorial():void
		{
			if(arrowIcon&& arrowIcon.parent){
				arrowIcon.parent.removeChild(arrowIcon);
				arrowIcon.dispose();
			}
			
			if(tutorialPanel && tutorialPanel.parent){
				tutorialPanel.parent.removeChild(tutorialPanel);
				tutorialPanel.dispose();
			}
			_inTutorial = false;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		
		
		private function getStepDate(index:int = 0):Object
		{
			var obj:Object;
			switch(index)
			{
				//收获
				case 0:
				{
					obj = {icon:{p:getHasFieldPos(),r:270},speech:LanguageController.getInstance().getString("tutorTip01")};
					break;
				}
				case 1:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth/2, Configrations.ViewPortHeight -180*scale),r:270}};
					break;
				}
				case 2:
				{
					obj = {icon:{p:getHasFieldPos(),r:270}};
					break;
				}
				case 3:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth  - 80*scale - arrowIcon.width, Configrations.ViewPortHeight/2+arrowIcon.height/2),r:180}};
					break;
				}
				//播种
				case 4:
				{
					obj = {icon:{p:getSeedFieldPos(),r:270},speech:LanguageController.getInstance().getString("tutorTip02")};
					break;
				}
				case 5:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth/2, Configrations.ViewPortHeight -180*scale),r:270}};
					break;
				}
				case 6:
				{
					obj = {icon:{p:getSeedFieldPos(),r:270}};
					break;
				}
				case 7:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth  - 80*scale - arrowIcon.width, Configrations.ViewPortHeight/2+arrowIcon.height/2),r:180}};
					break;
				}
					
				//加速 
					//播种
				case 8:
				{
					obj = {icon:{p:getSpeedFieldPos(),r:270},speech:LanguageController.getInstance().getString("tutorTip03")};
					break;
				}
				case 9:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth/2, Configrations.ViewPortHeight -180*scale),r:270}};
					break;
				}
				case 10:
				{
					obj = {icon:{p:getSpeedFieldPos(),r:270}};
					break;
				}
				case 11:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth  - 80*scale - arrowIcon.width, Configrations.ViewPortHeight/2+arrowIcon.height/2),r:180}};
					break;
				}
					
				//引导 探索
				case 12:
				{
					obj = {icon:{p:getWeedPos(),r:270},speech:LanguageController.getInstance().getString("tutorTip04")};
					break;
				}
				case 13:
				{
					obj = {icon:{p:new Point(Configrations.ViewPortWidth/2, Configrations.ViewPortHeight -180*scale),r:270}};
					break;
				}
				//引导结束
				case 14:
				{
					obj = {speech:LanguageController.getInstance().getString("tutorTip05")};
					break;
				}
				default:
				{
					break;
				}
			}
			return obj;
		}
		
		private function get scale():Number
		{
			return Configrations.ViewScale;
		}
	}
}