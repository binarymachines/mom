package net.bitmachines.util;

import java.awt.Color;
import java.awt.GraphicsEnvironment;
import java.util.Enumeration;

import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.plaf.FontUIResource;

public class UIUtil {

	public static final String DEFAULT = UIManager
			.getCrossPlatformLookAndFeelClassName();

	public static final String NAPKIN = "net.sourceforge.napkinlaf.NapkinLookAndFeel";

	public static final String LIQUID = "com.birosoft.liquid.LiquidLookAndFeel";

	public static final String AQUA = "apple.laf.AquaLookAndFeel";

	public static final String INFONODE = "net.infonode.gui.laf.InfoNodeLookAndFeel";

	public static final String TONIC = "com.digitprop.tonic.TonicLookAndFeel";

	@SuppressWarnings("unchecked")
	public static void setUIFont(javax.swing.plaf.FontUIResource f) {

		Enumeration keys = UIManager.getDefaults().keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();
			Object value = UIManager.get(key);
			if (value instanceof javax.swing.plaf.FontUIResource)
				UIManager.put(key, f);
		}
	}

	public static String[] getFontNames() {

		GraphicsEnvironment ge = GraphicsEnvironment
				.getLocalGraphicsEnvironment();
		String[] names = ge.getAvailableFontFamilyNames();

		return names;
	}

	public static void setDefaultFont(String fontName, int style, int size) {

		// "dialog.plain"
		FontUIResource defaultFont = new FontUIResource(fontName, style, size);
		// Toolkit.setDefaultFont(defaultFont);
	}

	public static String getPLAF() {

		String result = UIManager.getLookAndFeel().getClass().getName();

		return result;
	}

	public static boolean setPLAF(String plafClassName) {

		boolean result = false;

		try {
			UIManager.setLookAndFeel(plafClassName);
			result = true;
		} catch (UnsupportedLookAndFeelException e) {
			try {
				UIManager.setLookAndFeel(DEFAULT);
				result = true;
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		} catch (ClassNotFoundException e) {
			// handle exception
		} catch (InstantiationException e) {
			// handle exception
		} catch (IllegalAccessException e) {
			// handle exception
		}

		return result;
	}

	public static Color color_washedOutGreen = new Color(195, 255, 195);

	public static Color color_coolBlue = new Color(150, 205, 235);

	public static Color getColorForRow(int row) {

		int x = row % 2;
		if (x == 1) {
			if (getPLAF().equals(UIUtil.LIQUID))
				return Color.WHITE;

			else if (getPLAF().equals(UIUtil.NAPKIN))
				return Color.YELLOW;

			else
				return Color.LIGHT_GRAY;
		} else {

			if (getPLAF().equals(UIUtil.LIQUID))
				return Color.WHITE;

			else if (getPLAF().equals(UIUtil.NAPKIN))
				return color_washedOutGreen;

			else
				return color_coolBlue;
		}

	}
}
