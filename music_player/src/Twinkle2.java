import java.nio.file.FileSystems;

public class Twinkle2 extends Thread{
	FilePlayer fp;
	String folderLocation = "";
	
	public Twinkle2() {
		fp = new FilePlayer();
		
		folderLocation = FileSystems.getDefault().getPath(new String()).toAbsolutePath() + "/src/Sounds/";
	}
	
	@Override
	public void run() {

		delay(1000);
		fp.play(folderLocation + "la.wav"); // play la sound
		delay(1200);
		fp.play(folderLocation + "la.wav"); // play la sound
			
		
		delay(1800);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		delay(2000);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		
		
		delay(2600);
		fp.play(folderLocation + "re.wav"); // play re sound
		delay(2800);
		fp.play(folderLocation + "re.wav"); // play re sound
		

		delay(3800);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		delay(4000);
		fp.play(folderLocation + "fa.wav"); // play fa sound		
			
		delay(4600);
		fp.play(folderLocation + "re.wav"); // play re sound
		
		
		delay(5400);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		delay(5600);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		
		delay(6200);
		fp.play(folderLocation + "re.wav"); // play re sound
		
		
		delay(7400);
		fp.play(folderLocation + "la.wav"); // play la sound
		delay(7600);
		fp.play(folderLocation + "la.wav"); // play la sound	
		
		delay(8200);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		delay(8400);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		
		delay(9000);
		fp.play(folderLocation + "re.wav"); // play re sound
		delay(9200);
		fp.play(folderLocation + "re.wav"); // play re sound		
	
	
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

