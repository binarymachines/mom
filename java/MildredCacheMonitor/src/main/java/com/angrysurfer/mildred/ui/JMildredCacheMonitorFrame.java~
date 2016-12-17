package com.angrysurfer.mildred.ui;

import com.angrysurfer.mildred.redis.DefaultMildredCacheMonitor;
import com.angrysurfer.mildred.redis.MildredCachePubSub;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class JMildredCacheMonitorFrame extends JFrame {

	private static int COLUMNS = 50;

	private static final String JEDIS_SERVER = "localhost";

	private JButton btnClose;
	private JTextField jtfOperator;
	private JTextField jtfOperation;
	private JTextField jtfTarget;

	public JMildredCacheMonitorFrame() throws HeadlessException {
		super("Mildred Cache Monitor");

		buildUI();

		try {
            startListening();
        }
        catch (Exception e) {
		    e.printStackTrace();
        }
	}

	private void buildUI() {
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

		final JFrame frm = this;

		JPanel pnlMain = new JPanel();
		pnlMain.setLayout(new BorderLayout());

		JPanel pnlLabels = new JPanel();
		pnlLabels.setLayout(new BoxLayout(pnlLabels, BoxLayout.Y_AXIS));

		JPanel pnlFields = new JPanel();
		pnlFields.setLayout(new BoxLayout(pnlFields, BoxLayout.Y_AXIS));

		JPanel pnl = new JPanel();
		pnl.add(new JLabel("Operator"));
		pnlLabels.add(pnl);

		JPanel pnlOperator = new JPanel();
		pnlOperator.add(jtfOperator = new JTextField(""));
		jtfOperator.setColumns(COLUMNS);
		jtfOperator.setEditable(false);
		jtfOperator.setBorder(BorderFactory.createLoweredSoftBevelBorder());
		pnlFields.add(pnlOperator, BorderLayout.NORTH);

		pnl = new JPanel();
		pnl.add(new JLabel("Operation"));
		pnlLabels.add(pnl);

		JPanel pnlOperation = new JPanel();
		pnlOperation.add(jtfOperation = new JTextField(""));
		jtfOperation.setColumns(COLUMNS);
		jtfOperation.setEditable(false);
		jtfOperation.setBorder(BorderFactory.createLoweredSoftBevelBorder());
		pnlFields.add(pnlOperation, BorderLayout.NORTH);

		pnl = new JPanel();
		pnl.add(new JLabel("Target"));
		pnlLabels.add(pnl);

		JPanel pnlTarget = new JPanel();
		pnlTarget.add(jtfTarget = new JTextField(""));
		jtfTarget.setColumns(COLUMNS);
		jtfTarget.setEditable(false);
		jtfTarget.setBorder(BorderFactory.createLoweredSoftBevelBorder());
		pnlFields.add(pnlTarget, BorderLayout.NORTH);


		JPanel pnlButtons = new JPanel();
		btnClose = new JButton("Close");
		btnClose.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {

				frm.setVisible(false);
				System.exit(0);
			}
		});
		pnlButtons.add(btnClose);

		pnlMain.add(pnlLabels, BorderLayout.WEST);
		pnlMain.add(pnlFields, BorderLayout.CENTER);
		pnlMain.add(pnlButtons, BorderLayout.SOUTH);

		setContentPane(pnlMain);
		pack();
		setResizable(false);
	}

	private void setText(JTextField field, String message) {
		int max = field.getColumns() + (int) (COLUMNS * 0.65);
		if (message.length() >= max) {
			int startpos = (message.length() - max) + 3;
			String shortmessage = "..." + message.substring(startpos);
			field.setText(shortmessage);

		}
		else {
			field.setText(message);
		}
	}

	private void startListening() throws Exception {

	    final JMildredCacheMonitorFrame frm = this;

		MildredCachePubSub pubSub = new MildredCachePubSub(new DefaultMildredCacheMonitor() {

            public void onMessage(String channel, String message) {

				if (channel.equals("operator")) {
					frm.setText(frm.jtfOperator, message);
				}
				if (channel.equals("operation")) {
					frm.setText(frm.jtfOperation, message);
				}
				if (channel.equals("target")) {
					frm.setText(frm.jtfTarget, message);					}
				}
    	    }
		);

		pubSub.addSubscription(JEDIS_SERVER, "operator");
		pubSub.addSubscription(JEDIS_SERVER, "operation");
		pubSub.addSubscription(JEDIS_SERVER, "target");
	}


	public static void main(String[] args) {

		new JMildredCacheMonitorFrame().setVisible(true);
	}

}
