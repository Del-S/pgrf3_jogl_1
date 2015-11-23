package renderer;

import com.jogamp.opengl.GL2;
import com.jogamp.opengl.GLAutoDrawable;
import com.jogamp.opengl.GLEventListener;

import geom.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import settings.Settings;
import transforms.Camera;
import transforms.Mat4;
import transforms.Mat4PerspRH;
import transforms.Vec3D;
import utils.OGLBuffers;
import utils.OGLTexture;
import utils.ShaderUtils;
import utils.ToFloatArray;

public class Renderer implements GLEventListener, MouseListener,
		MouseMotionListener, KeyListener {

	int width, height, ox, oy;
	int shaderProgram, objectS, textureS, locMat, settingsLight, lightPos, eyePos, ambient, mapping, attenuation;

	Camera cam = new Camera();
        Vec3D lightPosVec = new Vec3D(5, 5, 2.5);
        Vec3D attenuationVec = new Vec3D(0.5, 0.5, 0.5);
        GeomGenerator gen;
        OGLBuffers grid;
	Mat4 proj;
        
        Settings s;
        
        OGLTexture textureB, textureE, textureB_H, textureB_N, textureE_H, textureE_N;

        public Renderer(Settings s) {
            this.s = s;
        }
        
        // TODO: reflektor blin-phong 
        // TODO: blinn-phong per pixel opravit.. (přesvěcuje)
        // TODO: normal mapping + paralax mapping - nefunguje dobře (opravit)
        
	public void init(GLAutoDrawable glDrawable) {
		GL2 gl = glDrawable.getGL().getGL2();
		
                gen = new GeomGeneratorGrid(gl);
                grid = gen.generate(30, 30);
                
		System.out.println("Init GL is " + gl.getClass().getName());
		System.out.println("OpenGL version " + gl.glGetString(GL2.GL_VERSION));
		System.out.println("OpenGL vendor " + gl.glGetString(GL2.GL_VENDOR));
		System.out
				.println("OpenGL renderer " + gl.glGetString(GL2.GL_RENDERER));
		System.out.println("OpenGL extensions "
				+ gl.glGetString(GL2.GL_EXTENSIONS));

                shaderProgram = ShaderUtils.loadProgram(gl, "./shader/project/objects");
                
                locMat = gl.glGetUniformLocation(shaderProgram, "mat");
                
                /* Object settings */
                objectS = gl.glGetUniformLocation(shaderProgram, "objectS");
                
                /* Light settings */
                settingsLight = gl.glGetUniformLocation(shaderProgram, "settingsLight");
                lightPos = gl.glGetUniformLocation(shaderProgram, "lightPos");
		eyePos = gl.glGetUniformLocation(shaderProgram,"eyePos");
                ambient = gl.glGetUniformLocation(shaderProgram, "ambient");
                attenuation = gl.glGetUniformLocation(shaderProgram, "attenuation");
                
                /* Textures */
                textureS = gl.glGetUniformLocation(shaderProgram,"textureS");
                textureB = new OGLTexture(gl, "textures/bricks.png");
                textureE = new OGLTexture(gl, "textures/earth.png");
                /* Texture for paralax */
                textureB_H = new OGLTexture(gl, "textures/bricksh.png");
                textureB_N = new OGLTexture(gl, "textures/bricksn.png");
                textureE_H = new OGLTexture(gl, "textures/earthh.png");
                textureE_N = new OGLTexture(gl, "textures/earthn.png");
                
                /* Normal mapping or parallax */
                mapping = gl.glGetUniformLocation(shaderProgram, "mapping");
                	
		cam.setPosition(new Vec3D(5, 5, 2.5));
		cam.setAzimuth(Math.PI * 1.25);
		cam.setZenith(Math.PI * -0.125);

		gl.glEnable(GL2.GL_DEPTH_TEST);
	}
	
	public void display(GLAutoDrawable glDrawable) {
		GL2 gl = glDrawable.getGL().getGL2();
                
		gl.glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
		gl.glClear(GL2.GL_COLOR_BUFFER_BIT | GL2.GL_DEPTH_BUFFER_BIT);
                
                gl.glUseProgram(shaderProgram); 
                
                gl.glUniformMatrix4fv(locMat, 1, false, ToFloatArray.convert(cam.getViewMatrix().mul(proj)), 0);             
                
                /* Object settings */
                gl.glUniform1i(objectS, s.getObjectS());                 
                 
                /* Texture settings */
                if(s.isTextureEnabledS()) {
                    gl.glUniform1i(textureS, 1);
                    
                    switch (s.getTextureS()) {
                        case 0: 
                            /* Bricks texture */
                            textureB.bind(shaderProgram, "texture", 1);
                            textureB_H.bind(shaderProgram, "texture_h", 2);
                            textureB_N.bind(shaderProgram, "texture_n", 3);
                        break;
                        case 1: 
                            /* Earth texture */
                            textureE.bind(shaderProgram, "texture", 4);
                            textureE_H.bind(shaderProgram, "texture_h", 5);
                            textureE_N.bind(shaderProgram, "texture_n", 6);
                        break;
                        default:
                            /* Bricks is default texture when enabled */
                            textureB.bind(shaderProgram, "texture", 1);
                            textureB_H.bind(shaderProgram, "texture_h", 2);
                            textureB_N.bind(shaderProgram, "texture_n", 3);
                        break;
                    }      
                } else {
                    gl.glUniform1i(textureS, 0);
                }
                
                /* Light settings */
                gl.glUniform1i(settingsLight, s.getLightS()); 
                gl.glUniform3fv(lightPos, 1, ToFloatArray.convert(lightPosVec), 0);
		gl.glUniform3fv(eyePos, 1, ToFloatArray.convert(cam.getEye()), 0);
                gl.glUniform1f(ambient, (float) 0.2);
                
                /* Use wireframe or not? */
                if(s.isWireframeS()) {
                    gl.glPolygonMode(GL2.GL_FRONT_AND_BACK, GL2.GL_LINE);
                } else {
                    gl.glPolygonMode(GL2.GL_FRONT_AND_BACK, GL2.GL_FILL);
                }
                
                gl.glUniform3fv(attenuation, 1, ToFloatArray.convert(attenuationVec), 0);
                
                /* Normal or paralax mapping */
                gl.glUniform1i(mapping, s.getMappingS()); 
                 
                grid.draw(GL2.GL_TRIANGLES, shaderProgram);
                
	}

	public void reshape(GLAutoDrawable drawable, int x, int y, int width,
			int height) {
		this.width = width;
		this.height = height;
		proj = new Mat4PerspRH(Math.PI / 4, height / (double) width, 0.01, 1000.0);
	}

	public void displayChanged(GLAutoDrawable drawable, boolean modeChanged,
			boolean deviceChanged) {
	}

	public void mouseClicked(MouseEvent e) {
	}

	public void mouseEntered(MouseEvent e) {
	}

	public void mouseExited(MouseEvent e) {
	}

	public void mousePressed(MouseEvent e) {
		ox = e.getX();
		oy = e.getY();
	}

	public void mouseReleased(MouseEvent e) {
	}

	public void mouseDragged(MouseEvent e) {
		cam.addAzimuth((double) Math.PI * (ox - e.getX())
				/ width);
		cam.addZenith((double) Math.PI * (e.getY() - oy)
				/ width);
		ox = e.getX();
		oy = e.getY();
	}

	public void mouseMoved(MouseEvent e) {
	}

	public void keyPressed(KeyEvent e) {
		switch (e.getKeyCode()) {
		case KeyEvent.VK_W:
			cam.forward(1);
			break;
		case KeyEvent.VK_D:
			cam.right(1);
			break;
		case KeyEvent.VK_S:
			cam.backward(1);
			break;
		case KeyEvent.VK_A:
			cam.left(1);
			break;
		case KeyEvent.VK_SHIFT:
			cam.down(1);
			break;
		case KeyEvent.VK_CONTROL:
			cam.up(1);
			break;
		case KeyEvent.VK_SPACE:
			cam.setFirstPerson(!cam.getFirstPerson());
			break;
		case KeyEvent.VK_R:
			cam.mulRadius(0.9f);
			break;
		case KeyEvent.VK_F:
			cam.mulRadius(1.1f);
			break;
		}
	}

	public void keyReleased(KeyEvent e) {
	}

	public void keyTyped(KeyEvent e) {
	}

	public void dispose(GLAutoDrawable arg0) {
	}
}