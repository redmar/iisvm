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
    private static String[] testFiles = new String[]{"p7.jpg", "p24.jpg","p27.jpg","p51.jpg", "p57.jpg","p67.jpg"};
    private static String testFilesPath = "/Users/benoist/Pictures/";
    private static String indexPath = "test-index";

    public static void testCreateIndex() throws IOException {
        // Create an appropriate DocumentBuilder
        DocumentBuilder builder = DocumentBuilderFactory.getExtensiveDocumentBuilder();
        IndexWriter iw = new IndexWriter(indexPath, new SimpleAnalyzer(), true);
        for (String identifier : testFiles) {
            // Build the Lucene Documents
            Document doc = builder.createDocument(new FileInputStream(testFilesPath +
				identifier), identifier);
            // Add the Documents to the index
            iw.addDocument(doc);
        }
        iw.optimize();
        iw.close();
    }

    public static void testSearch() throws IOException {
		// Opening an IndexReader
        IndexReader reader = IndexReader.open(indexPath);
		// Creating an ImageSearcher
        ImageSearcher searcher = ImageSearcherFactory.createDefaultSearcher();
		// Reading the sample image, which is our "query"
        FileInputStream imageStream = new FileInputStream(testFilesPath + testFiles[0]);
        BufferedImage bimg = ImageIO.read(imageStream);
		// Search for similar images
        ImageSearchHits hits = null;
		hits = searcher.search(bimg, reader);
		// print out results
        for (int i = 0; i < 6; i++) {
            System.out.println(hits.score(i) + ": " +
				hits.doc(i).getField(DocumentBuilder.FIELD_NAME_IDENTIFIER).stringValue());
        }

		// Get a document from the results
        Document document = hits.doc(0);
		// Search for similar Documents based on the image features
		hits = searcher.search(document, reader);
        for (int i = 0; i < 6; i++) {
            System.out.println(hits.score(i) + ": " +
				hits.doc(i).getField(DocumentBuilder.FIELD_NAME_IDENTIFIER).stringValue());
        }
    }


    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            testCreateIndex();
            testSearch();
        } catch (IOException e)
        {
            e.printStackTrace();
        }
    }

}
