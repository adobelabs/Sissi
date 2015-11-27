package sissi.components
{
	import flash.display.Bitmap;
	
	import sissi.interaction.CheckBoxInterAction;
	import sissi.managers.BMDCacheManager;
	import sissi.skin.SkinRadioButtonOverBMD;
	import sissi.skin.SkinRadioButtonSelectedOverBMD;
	import sissi.skin.SkinRadioButtonSelectedUpBMD;
	import sissi.skin.SkinRadioButtonUpBMD;

	public class CheckBox extends Button
	{
		public function CheckBox()
		{
			super();
			explicitWidth = explicitHeight = NaN;
			interAction = new CheckBoxInterAction(this);
			skin.upSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonUpBMD));
			skin.overSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonOverBMD));
			skin.downSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonUpBMD));
			skin.selectedUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedUpBMD));
			skin.selectedOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedOverBMD));
			skin.selectedDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedUpBMD));
		}
	}
}