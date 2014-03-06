package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.FriendInfoController;
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
	
	import model.player.GamePlayer;
	
	import starling.events.Event;
	
	import view.render.FindFriendRender;
	import view.render.FriendItemRender;
	import view.render.StrangerListRender;

	public class SocialPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var tabBar:TabBar;
		private var list:List;
		private var scale:Number;
		private var currentTabIndex:int;
		
		public function SocialPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			scale = Configrations.ViewScale;
			
			tabBar = new TabBar();
			tabBar.dataProvider = new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("friend")},
					{ label: LanguageController.getInstance().getString("stranger")},
					{ label: LanguageController.getInstance().getString("find")}
				]);
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				var buttxtures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSelectedSkin = new Scale9Image(buttxtures) ;
				buttxtures = new Scale9Textures(Game.assets.getTexture("PanelGlaySkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSkin = new Scale9Image(buttxtures) ;
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);;
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.8;
			tabBar.height =50*scale;
			tabBar.x = panelwidth*0.1;
			tabBar.y = panelheight*0.02;
			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop = 20*scale;
			listLayout.gap = 20*scale;
			
			findPanel = new FindFriendRender(panelwidth *0.8,panelheight*0.8);
			
			list = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			configList();
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.85;
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y = tabBar.y + 50*scale;
			list.addEventListener(Event.CHANGE,onRemovedRender);
			
		}
		
		private var findPanel:FindFriendRender;
		private function onRemovedRender(e:Event):void
		{
			configList();
		}
		private function get friendsArr():ListCollection
		{
			var listCollection:ListCollection = new ListCollection([1,2].concat(player.friends));
			return listCollection;
		}
		
		
		private function onGetStrangers():void
		{
			configList();
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
			if(currentTabIndex == 2){
				if(!findPanel.parent){
					this.addChild(findPanel);
				}
				findPanel.x = panelwidth*0.1;
				findPanel.y = tabBar.y + 50*scale;
				if(list.parent){
					list.parent.removeChild(list);
				}
			}else{
				if(findPanel.parent){
					findPanel.parent.removeChild(findPanel);
				}
				if(!list.parent){
					this.addChild(list);
				}
				list.x = panelwidth*0.1;
				list.y = tabBar.y + 50*scale;
				if(currentTabIndex == 0){
					list.dataProvider = friendsArr;
					list.itemRendererFactory =function tileListItemRendererFactory():FriendItemRender
					{
						var renderer:FriendItemRender = new FriendItemRender();
						renderer.width = panelwidth *0.7;
						renderer.height =panelheight*0.2;
						return renderer;
					}
				}else if(currentTabIndex == 1){
					list.dataProvider = FriendInfoController.instance.strangerArr;
					list.itemRendererFactory =function tileListItemRendererFactory():StrangerListRender
					{
						var renderer:StrangerListRender = new StrangerListRender();
						renderer.width = panelwidth *0.7;
						renderer.height =panelheight*0.2;
						return renderer;
					}
				}
			}
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}