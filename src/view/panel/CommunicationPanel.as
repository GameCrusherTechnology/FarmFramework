package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.SimplePlayer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	
	import view.render.InfoListRender;
	import view.render.MessageListRender;
	import view.render.OrderListRender;
	
	public class CommunicationPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var tabBar:TabBar;
		private var list:List;
		private var currentTabIndex:int;
		
		public function CommunicationPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.9);
			panelheight = Math.min(1500,Configrations.ViewPortHeight*0.9);
			var scale:Number = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
			
			tabBar = new TabBar();
			tabBar.dataProvider = new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("message")},
					{ label: LanguageController.getInstance().getString("order")},
					{ label: LanguageController.getInstance().getString("info") },
				]);
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				var buttxtures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSelectedSkin = new Scale9Image(buttxtures) ;
				buttxtures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSkin = new Scale9Image(buttxtures) ;
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.9;
			tabBar.height = panelheight*0.08;
			tabBar.x = panelSkin.x + panelwidth*0.05;
			tabBar.y = panelSkin.y + panelheight*0.02;
			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop = 20*scale;
			listLayout.gap = 10*scale;
			
			
			list = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			configList();
			list.width =  panelwidth*0.9;
			list.height =  panelheight *0.85;
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelSkin.x + panelwidth*0.05;
			list.y = panelSkin.y + panelheight*0.1;
			
			var leavebutton:Button = new Button();
			leavebutton.label = LanguageController.getInstance().getString("close");
			leavebutton.defaultSkin = new Image(Game.assets.getTexture("offButtonSkin"));
			leavebutton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			leavebutton.paddingLeft =leavebutton.paddingRight =  5;
			leavebutton.paddingTop =leavebutton.paddingBottom =  5;
			addChild(leavebutton);
			leavebutton.validate();
			leavebutton.x = Configrations.ViewPortWidth - leavebutton.width - 10*scale;
			leavebutton.y = Configrations.ViewPortHeight - leavebutton.height - 10*scale ;
			leavebutton.addEventListener(Event.TRIGGERED,onCloseTriggered);
			
		}
		private function onCloseTriggered(e:Event):void
		{
			close();
		}
		private function get mesArr():ListCollection
		{
			return new ListCollection([
				{ player:new SimplePlayer({gameuid:"12",sex:0,farmName:"dadw",mes:"sadawaeqweeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"2135",sex:1,farmName:"sad",mes:"sadawaeqweeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"456",sex:1,farmName:"sdaw",mes:"sadawaeqweeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"458",sex:1,farmName:"aewr",mes:"sadawaeqweeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"135",sex:0,farmName:"sdfw",mes:"sadawaeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"687",sex:0,farmName:"fscas",mes:"sadawaeqweeeeeeeeeeeeeeeeeeeeeeeeeeee"})},
				{ player:new SimplePlayer({gameuid:"978",sex:0,farmName:"xzdqww"})},
				{ player:new SimplePlayer({gameuid:"8648",sex:1,farmName:"gfewrwe"})},
				{ player:new SimplePlayer({gameuid:"5421",sex:0,farmName:"gfserq"})},
				{ player:new SimplePlayer({gameuid:"687",sex:0,farmName:"rewer"})}
			]);
		}
		private function get orderArr():ListCollection
		{
			return new ListCollection([
				{}
			]);
		}
		
		private function get infoArr():ListCollection
		{
			return new ListCollection([
				{ player:new SimplePlayer({gameuid:"12",sex:0,farmName:"dasfedw",type:1})},
				{ player:new SimplePlayer({gameuid:"687",sex:0,farmName:"rewfdgerer",type:2})}
			]);
		}
		private function tabBar_changeHandler(event:Event):void
		{
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				configList();
			}
		}
		private function configList():void
		{
			if(currentTabIndex == 0){
				list.dataProvider = mesArr;
				list.itemRendererFactory =function tileListItemRendererFactory():MessageListRender
				{
					var renderer:MessageListRender = new MessageListRender();
					renderer.width = panelwidth *0.7;
					renderer.height =panelheight*0.2;
					return renderer;
				}
			}else if(currentTabIndex == 1){
				list.dataProvider = orderArr;
				list.itemRendererFactory =function tileListItemRendererFactory():OrderListRender
				{
					var renderer:OrderListRender = new OrderListRender();
					renderer.width = panelwidth *0.7;
					renderer.height =panelheight*0.8;
					return renderer;
				}
			}else{
				list.dataProvider = infoArr;
				list.itemRendererFactory =function tileListItemRendererFactory():InfoListRender
				{
					var renderer:InfoListRender = new InfoListRender();
					renderer.width = panelwidth *0.7;
					renderer.height =panelheight*0.2;
					return renderer;
				}
			}
		}
		private function close():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}


