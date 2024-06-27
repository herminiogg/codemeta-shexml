@Grab('org.apache.jena:jena-base:4.10.0')
@Grab('org.apache.jena:jena-core:4.10.0')
@Grab('org.apache.jena:jena-arq:4.10.0')
import org.apache.jena.rdf.model.Model
import org.apache.jena.rdf.model.ModelFactory
import org.apache.jena.riot.RDFDataMgr
import org.apache.jena.riot.RDFFormat
import org.apache.jena.riot.RDFWriter
import org.apache.jena.riot.Lang
import org.apache.jena.riot.JsonLDWriteContext
import com.github.jsonldjava.core.JsonLdOptions
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.PrintWriter

Model model = ModelFactory.createDefaultModel() ;
model.read(args[0], "JSONLD10") ;

// Establishes the frame so the different entities are nested
def ctx = new JsonLDWriteContext();
def frame = new File(args[1]).text
ctx.setFrame(frame)

// Puts the option to omit the @graph in the output
JsonLdOptions options = new JsonLdOptions();
options.setOmitGraph(true);
ctx.setOptions(options);

def outputStream = new ByteArrayOutputStream()
def writer = RDFWriter.create()
                .format(RDFFormat.JSONLD_FRAME_PRETTY)
                .source(model)
                .context(ctx)
                .build()
writer.output(outputStream)

def pw = new PrintWriter(new File(args[2]))
pw.print(outputStream)
pw.close()