package settings;


import java.awt.LayoutManager;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BoxLayout;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;


public class Settings extends JFrame implements ActionListener {

    public JComboBox objectSettings, lightSettings, textureSettings, mappingSettings;
    public JCheckBox wireframeDisplay, testureDisplay;
    
    private int lightS, objectS, textureS, mappingS;
    private boolean wireframeS, textureEnabledS;
    
    public Settings() {
        createSettings();
        lightS = 0;
    }
    
    private void createSettings() {
        setTitle("Settings");
        setSize(300, 300);
        
        LayoutManager m = new BoxLayout(getContentPane(), BoxLayout.Y_AXIS);
        setLayout(m);
	setAlwaysOnTop(true);
                
        addSettings();
        
        pack();
        setVisible(true);
    }
    
    private void addSettings() {
        String[] objects = { "Grid", "Cone", "Torus", "Trumpet", "Sphere", "Elephant Head", "Space Station", "Cylin", "Goblet", "Juicer", "Tent"  };
        
        JPanel objectPanel = new JPanel();
		objectSettings = new JComboBox(objects);
		objectSettings.setSize(100, 20);
                objectSettings.addActionListener(this);
		objectPanel.add(new JLabel("Objects: "));
		objectPanel.add(objectSettings);
                
        add(objectPanel);
        
        String[] textures = { "Bricks", "Earth" };
               
        JPanel texturePanel = new JPanel();
		textureSettings = new JComboBox(textures);
		textureSettings.setSize(100, 20);
                textureSettings.addActionListener(this);
		texturePanel.add(new JLabel("Texture: "));
		texturePanel.add(textureSettings);
                
        add(texturePanel);
        
        String[] mappings = { "Disabled mapping", "Normal mapping", "Paralax mapping" };
        
        JPanel mappingPanel = new JPanel();
		mappingSettings = new JComboBox(mappings);
		mappingSettings.setSize(100, 20);
                mappingSettings.addActionListener(this);
		mappingPanel.add(new JLabel("Mapping settings: "));
		mappingPanel.add(mappingSettings);
                
        add(mappingPanel);
        
        String[] lights = { "None", "Blinn-Phong (per vertex)", "Blinn-Phong (per pixel)" };
        
        JPanel lightPanel = new JPanel();
		lightSettings = new JComboBox(lights);
		lightSettings.setSize(100, 20);
                lightSettings.addActionListener(this);
		lightPanel.add(new JLabel("Light: "));
		lightPanel.add(lightSettings);
                
        add(lightPanel);
        
        wireframeDisplay = new JCheckBox("Display in Wireframe: ");
		wireframeDisplay.setSelected(false);
                wireframeDisplay.addActionListener(this);
        add(wireframeDisplay);
        
        testureDisplay = new JCheckBox("Display texture: ");
		testureDisplay.setSelected(false);
                testureDisplay.addActionListener(this);
        add(testureDisplay);
    }
    
    @Override
    public void actionPerformed(ActionEvent ae) {
        setLightS(lightSettings.getSelectedIndex());
        setObjectS(objectSettings.getSelectedIndex());
        setTextureS(textureSettings.getSelectedIndex());
        setMappingS(mappingSettings.getSelectedIndex());
        
        setWireframeS(wireframeDisplay.isSelected());
        setTextureEnabledS(testureDisplay.isSelected());
    }
    
    public int getLightS() {
        return lightS;
    }

    public void setLightS(int lightS) {
        this.lightS = lightS;
    }
    
    public int getObjectS() {
        return objectS;
    }

    public void setObjectS(int objectS) {
        this.objectS = objectS;
    }

    public boolean isWireframeS() {
        return wireframeS;
    }

    public void setWireframeS(boolean wireframeS) {
        this.wireframeS = wireframeS;
    }

    public int getTextureS() {
        return textureS;
    }
    
    public void setTextureS(int textureS) {
        this.textureS = textureS;
    }
    
    public int getMappingS() {
        return mappingS;
    }

    public void setMappingS(int mappingS) {
        this.mappingS = mappingS;
    }
    
    public boolean isTextureEnabledS() {
        return textureEnabledS;
    }

    public void setTextureEnabledS(boolean textureEnabledS) {
        this.textureEnabledS = textureEnabledS;
    }
    
}
