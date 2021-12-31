import java.nio.file.FileSystems;

public class Twinkle1 extends Thread{
	FilePlayer fp;
	String folderLocation = "";
	
	public Twinkle1() {
		fp = new FilePlayer();
		
		folderLocation = FileSystems.getDefault().getPath(new String()).toAbsolutePath() + "/src/Sounds/";
	}
	
	@Override
	public void run() {
		delay(200);
		fp.play(folderLocation + "do.wav"); // play do sound
		delay(400);
		fp.play(folderLocation + "do.wav"); // play do sound
		
		
		delay(600);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		delay(800);
		fp.play(folderLocation + "sol.wav"); // play sol sound

		
		delay(1400);
		fp.play(folderLocation + "sol.wav"); // play sol sound		

		
		delay(2200);
		fp.play(folderLocation + "mi.wav"); // play mi sound		
		delay(2400);
		fp.play(folderLocation + "mi.wav"); // play mi sound
		

		delay(3000);
		fp.play(folderLocation + "do.wav"); // play do sound
		
			
		delay(3400);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		delay(3600);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		
		
		delay(4200);
		fp.play(folderLocation + "mi.wav"); // play mi sound		
		delay(4400);
		fp.play(folderLocation + "mi.wav"); // play mi sound
		
		
		
		delay(5000);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		delay(5200);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		
		delay(5800);
		fp.play(folderLocation + "mi.wav"); // play mi sound		
		delay(6000);
		fp.play(folderLocation + "mi.wav"); // play mi sound
		
		
		delay(6600);
		fp.play(folderLocation + "do.wav"); // play do sound
		delay(6800);
		fp.play(folderLocation + "do.wav"); // play do sound
		
		delay(7000);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		delay(7200);
		fp.play(folderLocation + "sol.wav"); // play sol sound
		
		
		delay(7800);
		fp.play(folderLocation + "sol.wav"); // play sol sound

		
		delay(8600);
		fp.play(folderLocation + "mi.wav"); // play mi sound		
		delay(8800);
		fp.play(folderLocation + "mi.wav"); // play mi sound
		
		delay(9400);
		fp.play(folderLocation + "do.wav"); // play do sound

	
	
	}

	private void delay(int millis) {
		try {
			Thread1.sleep(millis);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
