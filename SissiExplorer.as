package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import sissi.components.Button;
	import sissi.components.CheckBox;
	import sissi.components.ComboBox;
	import sissi.components.DateChooser;
	import sissi.components.DefaultStringTextInput;
	import sissi.components.HGroup;
	import sissi.components.LeafPager;
	import sissi.components.List;
	import sissi.components.RadioButton;
	import sissi.components.ScrollBar;
	import sissi.components.SimplePager;
	import sissi.components.Slider;
	import sissi.components.TextArea;
	import sissi.components.TextInput;
	import sissi.components.TileList;
	import sissi.components.VGroup;
	import sissi.core.Application;
	import sissi.core.SissiManager;
	import sissi.core.UITextField;
	import sissi.layouts.HorizontalAlign;
	import sissi.layouts.LayoutDirection;
	import sissi.layouts.VerticalLayout;
	
	public class SissiExplorer extends Sprite
	{
		public function SissiExplorer()
		{
			super();
			
			stage.frameRate = 30;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			constructed();
		}
		
		
		private var application:Application;
		private function constructed():void
		{
			SissiManager.sissiManager = this;
			
			addEventListener(MouseEvent.CLICK, handleMouseClick);
			
			SissiManager.sissiManager = this;
			application = new Application();
			application.setSize(1400, 800);
			super.addChild(application);
			//VGroup
			var vg:VGroup = new VGroup();
			//			vg.background = true;
			//			vg.width = 500;
			//			vg.height = 200;
			//			vg.horizontalScrollEnable = true;
			//			vg.verticalScrollEnable = true;
			(vg.layout as VerticalLayout).align = HorizontalAlign.LEFT;
			addChild(vg);
			
			var hg1:HGroup = new HGroup();
			vg.addChild(hg1);
			//Button
			var btn:Button = new Button();
			btn.width = 80;
			btn.height = 21;
			//			btn.enabled = false;
			btn.toolTip = "Button";
			btn.autoRepeat = true;
			btn.label = "It's Button";
			btn.skin.labelTextFormat = new TextFormat(null, 12);
			btn.skin.disabledLabelTextFormat = new TextFormat(null, 12, 0xFF0000);
			hg1.addChild(btn);
			//CheckBox
			var checkBox:CheckBox = new CheckBox();
			checkBox.label = "CheckBox";
			hg1.addChild(checkBox);
			//RadioButton
			var rdBtn1:RadioButton = new RadioButton();
			rdBtn1.label = "RadioButton One";
			rdBtn1.groupName = "sissi2";
			hg1.addChild(rdBtn1);
			var rdBtn2:RadioButton = new RadioButton();
			rdBtn2.label = "RadioButton Two";
			rdBtn2.groupName = "sissi2";
			hg1.addChild(rdBtn2);
			var rdBtn3:RadioButton = new RadioButton();
			rdBtn3.label = "RadioButton Three";
			rdBtn3.groupName = "sissi2";
			hg1.addChild(rdBtn3);
			
			var hg2:HGroup = new HGroup();
			vg.addChild(hg2);
			//UITextField
			var defalutTF:TextFormat = new TextFormat(null, 12, 0xFF0000, true);
			var newTF:TextFormat = new TextFormat("simsun", 12, 0x0000FF, false);
			var utf:UITextField = new UITextField();
			hg2.addChild(utf);
			utf.htmlText = "<b>Lorem ipsum dolor sit amet.</b>";
			utf.defaultTextFormat = defalutTF;
			utf.defaultTextFormat = newTF;
			utf.truncateToFit = true;
			utf.text = "It's UITextField!";
			//			utf.width = 50;
			utf.color = 0x00FF00;
			utf.textAlign = "center"
			utf.thickness = 20;
			utf.toolTip = "toolTip";
			//TextInput
			var ti:TextInput = new TextInput();
			ti.width = 80;
			ti.text = "It's  TextInput";
			hg2.addChild(ti);
			//TextArea
			var ta:TextArea = new TextArea();
			ta.x = ta.y = 100;
			ta.text = "It's  TextArea";
			hg2.addChild(ta);
			//DefaultStringTextInput
			var dsTI:DefaultStringTextInput = new DefaultStringTextInput();
			dsTI.defaultText = "It's  DefaultStringTextInput";
			dsTI.defaultTextDefaultTextFormat = new TextFormat(null, 12, 0xFFFF00, false);
			hg2.addChild(dsTI);
			
			var hg3:HGroup = new HGroup();
			vg.addChild(hg3);
			//Slider
			var hSlider:Slider = new Slider(LayoutDirection.HORIZONTAL);//LayoutDirection.HORIZONTAL
			hSlider.snapInterval  = 1;//.5, 1, 2
			hSlider.minValue = -5;
			hSlider.maxValue = 5;
			hg3.addChild(hSlider);
			var vSlider:Slider = new Slider(LayoutDirection.VERTICAL);//LayoutDirection.HORIZONTAL
			vSlider.snapInterval  = 1;//.5, 1, 2
			vSlider.minValue = -5;
			vSlider.maxValue = 5;
			hg3.addChild(vSlider);
			//ScrollBar
			var hScrollBar:ScrollBar = new ScrollBar(LayoutDirection.HORIZONTAL);
			//			hScrollBar.snapInterval = 2;
			hScrollBar.maxScrollPosition = 5;
			hScrollBar.minScrollPosition = -5;
			hg3.addChild(hScrollBar);
			var vScrollBar:ScrollBar = new ScrollBar(LayoutDirection.VERTICAL);
			//			vScrollBar.snapInterval = 2;
			vScrollBar.maxScrollPosition = 5;
			vScrollBar.minScrollPosition = -5;
			hg3.addChild(vScrollBar);
			
			var hg4:HGroup = new HGroup();
			vg.addChild(hg4);
			//DateChooser
			var dc:DateChooser = new DateChooser();
			hg4.addChild(dc);
			
			var hg5:HGroup = new HGroup();
			vg.addChild(hg5);
			//LeafPager
			var leafPager:LeafPager = new LeafPager();
			leafPager.count = 5;
			leafPager.background = true;
			hg5.addChild(leafPager);
			//SimplePager
			var simplePager:SimplePager = new SimplePager();
			simplePager.count = 5;
			simplePager.background = true;
			hg5.addChild(simplePager);
			
			var hg6:HGroup = new HGroup();
			vg.addChild(hg6);
			//List not virtual
			var nvLst:List = new List(LayoutDirection.VERTICAL, false);
			var dp:Array = [];
			var i:int;
			while(i < 20)
			{
				dp.push(i++);
			}
			//			nvLst.background = true;
			nvLst.dataProvider = dp;
			nvLst.verticalScrollEnable = true;
			nvLst.horizontalScrollEnable = true;
			nvLst.enableMouseWheel = true;
			var rollOverSkin:Shape = new Shape();
			var g:Graphics = rollOverSkin.graphics;
			g.clear();
			g.beginFill(0x00FF00, .5);
			g.drawRect(0, 0, 250, 22);
			g.endFill();
			
			var listBgSkin:Shape = new Shape();
			g = listBgSkin.graphics;
			g.clear();
			g.beginFill(0x00FFFF, .5);
			g.drawRect(0, 0, 250, 50);
			g.endFill();
			nvLst.backgroundDisplayObject = listBgSkin;
			nvLst.rollOverSkin = rollOverSkin;
			nvLst.width = 300;
			nvLst.showCount = 3;
			hg6.addChild(nvLst);
			
			//TileList not virtual
			var tileList:TileList = new TileList(3, false);
			var tileListDp:Array = [];
			var t:int;
			while(t < 20)
			{
				tileListDp.push(t++);
			}
			//			nvLst.background = true;
			tileList.dataProvider = dp;
			tileList.verticalScrollEnable = true;
			//			tileList.horizontalScrollEnable = true;
			tileList.enableMouseWheel = true;
			var tileListRollOverSkin:Shape = new Shape();
			var tileListG:Graphics = tileListRollOverSkin.graphics;
			tileListG.clear();
			tileListG.beginFill(0x00FF00, .5);
			tileListG.drawRect(0, 0, 250, 22);
			tileListG.endFill();
			tileList.rollOverSkin = tileListRollOverSkin;
			tileList.width = 770;
			tileList.showCount = 9;
			hg6.addChild(tileList);
			
			//ComboBox
			var cmb:ComboBox = new ComboBox();
			cmb.dataProvider = tileListDp;
			hg6.addChild(cmb);
		}
		
		protected function handleChange(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("handleChange");
		}
		
		protected function handleMouseClick(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			trace(target, target.x, target.y, target.width, target.height);
			//			if(target is UITextField)
			//			{
			//				(target as UITextField).color = 0x0000FF;
			//			}
			//			if(target is TextField)
			//			{
			//				(target as TextField).text = "It's UITextField!=.=";
			//			}
			
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(application)
				return application.addChild(child);
			return null;
		}
	}
}