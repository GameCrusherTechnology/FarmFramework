package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
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
	
	import model.MessageData;
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
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
			var tabList:ListCollection = GameController.instance.isHomeModel?new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("message")},
					{ label: LanguageController.getInstance().getString("order")},
					{ label: LanguageController.getInstance().getString("info") }
				]):new ListCollection(
					[
						{ label: LanguageController.getInstance().getString("message")},
						{ label: LanguageController.getInstance().getString("order")},
					]);
			tabBar.dataProvider = tabList;
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
			
			
			player.addEventListener(PlayerChangeEvents.MESSAGE_CHANGE,onmessagechange);
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, onCloseTriggered);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = Configrations.ViewPortHeight*0.05;
			cancelButton.x = Configrations.ViewPortWidth *0.95 -cancelButton.width -5;
			cancelButton.y = panelSkin.y + panelheight*0.02;
			
		}
		
		private function onmessagechange(e:Event):void
		{
			configList();
		}
		private function onCloseTriggered(e:Event):void
		{
			close();
		}
		private function get mesArr():ListCollection
		{
			var list:ListCollection;
			var arr:Array = [];
			var data:MessageData;
			for each(data in player.user_mes_vec){
				if(data.type == Configrations.MESSTYPE_MES){
					arr.push(data);
				}
			}
			arr.sortOn("updatetime",Array.DESCENDING);
			arr = [new MessageData({})].concat(arr);
			list = new ListCollection(arr);
			return list;
		}
		private function get orderArr():ListCollection
		{
			return new ListCollection([
				{}
			]);
		}
		
		private function get infoArr():ListCollection
		{
			var list:ListCollection = new ListCollection;
			var data:MessageData;
			for each(data in player.user_mes_vec){
				if(data.type != Configrations.MESSTYPE_MES){
					list.push(data);
				}
			}
			return list;
			
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
					renderer.width = panelwidth *0.85;
					renderer.height =panelheight*0.15;
					return renderer;
				}
			}else if(currentTabIndex == 1){
				list.dataProvider = orderArr;
				list.itemRendererFactory =function tileListItemRendererFactory():OrderListRender
				{
					var renderer:OrderListRender = new OrderListRender();
					renderer.width = panelwidth *0.85;
					renderer.height =panelheight*0.8;
					return renderer;
				}
			}else{
				list.dataProvider = infoArr;
				list.itemRendererFactory =function tileListItemRendererFactory():InfoListRender
				{
					var renderer:InfoListRender = new InfoListRender();
					renderer.width = panelwidth *0.85;
					renderer.height =panelheight*0.2;
					return renderer;
				}
			}
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private function close():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}


