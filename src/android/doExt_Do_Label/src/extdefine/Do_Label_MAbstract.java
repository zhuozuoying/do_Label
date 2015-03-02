package extdefine;

import core.object.DoUIModule;
import core.object.DoProperty;
import core.object.DoProperty.PropertyDataType;


public abstract class Do_Label_MAbstract extends DoUIModule{

	protected Do_Label_MAbstract() throws Exception {
		super();
	}
	
	/**
	 * 初始化
	 */
	@Override
	public void onInit() throws Exception{
        super.onInit();
        //注册属性
		this.registProperty(new DoProperty("fontColor", PropertyDataType.String, "000000", false));
		this.registProperty(new DoProperty("fontSize", PropertyDataType.Number, "9", false));
		this.registProperty(new DoProperty("fontStyle", PropertyDataType.String, "normal", false));
		this.registProperty(new DoProperty("maxHeight", PropertyDataType.Number, "100", true));
		this.registProperty(new DoProperty("maxLines", PropertyDataType.Number, "3", true));
		this.registProperty(new DoProperty("maxWidth", PropertyDataType.Number, "100", true));
		this.registProperty(new DoProperty("text", PropertyDataType.String, "", false));
		this.registProperty(new DoProperty("textAlign", PropertyDataType.String, "left", true));
	}
}