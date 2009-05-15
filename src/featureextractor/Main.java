/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package featureextractor;
import java.io.*;
import java.awt.image.*;
import javax.imageio.*;
import net.semanticmetadata.lire.*;
import org.apache.lucene.index.*;
import org.apache.lucene.document.*;
import org.apache.lucene.analysis.*;
/**
 *
 * @author benoist
 */
public class Main {
    private static String testFilesPath = "dataset";
    private static String indexPath = "test-index";

    public static void testCreateIndex() throws IOException {
        // Create an appropriate DocumentBuilder
        DocumentBuilder builder = DocumentBuilderFactory.getFastDocumentBuilder();
        IndexWriter iw = new IndexWriter(indexPath, new SimpleAnalyzer(), true);
        File root = new File(testFilesPath);
        for (File dir : root.listFiles()) {
            if (dir.isDirectory()){
                int index = 0;
                for (File file : dir.listFiles()){
                    if (!file.isDirectory() && file.getName().endsWith("jpg")){
                        if (index > 29){
                            break;
                        }
                        index++;
                        // Build the Lucene Documents
                        Document doc = builder.createDocument(new FileInputStream(file), dir.getName() +"/"+file.getName());
                        iw.addDocument(doc);
                    }
                }
            }
        }
        iw.optimize();
        iw.close();
    }

    public static void testSearch(String filename) throws IOException {
		// Opening an IndexReader
        IndexReader reader = IndexReader.open(indexPath);
		// Creating an ImageSearcher
        ImageSearcher searcher = ImageSearcherFactory.createDefaultSearcher();
		// Reading the sample image, which is our "query"
        FileInputStream imageStream = new FileInputStream(filename);
        BufferedImage bimg = ImageIO.read(imageStream);
		// Search for similar images
        ImageSearchHits hits = null;
		hits = searcher.search(bimg, reader);
		// print out results
        for (int i = 0; i < 20; i++) {
            System.out.println(hits.doc(i).getField(DocumentBuilder.FIELD_NAME_IDENTIFIER).stringValue() + " " + hits.score(i));
        }
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            if (args.length > 0){
                testSearch(args[0]);
            } else {
                testCreateIndex();
            }

        } catch (IOException e)
        {
            e.printStackTrace();
        }
    }

}
