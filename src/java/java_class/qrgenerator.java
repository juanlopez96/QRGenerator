/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package java_class;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.Writer;
import com.google.zxing.WriterException;
import com.google.zxing.common.ByteMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 *
 * @author Juan
 */
public class qrgenerator {
    private final int width;
    private final int height;
    BufferedImage image;
    public qrgenerator(){
        width = 300;
        height = 300;
    }
    public BufferedImage createQR(String datos) throws WriterException{
        ByteMatrix matrix;
        Writer wr = new QRCodeWriter();
        matrix = wr.encode(datos, BarcodeFormat.QR_CODE, getWidth(), getHeight());
        image = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
        for(int y=0;y<getHeight();y++){
            for(int x=0;x<getWidth();x++){
                int gray = (matrix.get(x, y));
                image.setRGB(x, y, (gray==0 ? 0:0xFFFFFF));
            }
        }
        return image;
    }
    public String convertToBase64(BufferedImage image) throws IOException{
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", out);
        byte[] bytes = out.toByteArray();
        String toBase64 = Base64.encode(bytes);
        String src = "data:image/png;base64,"+toBase64;
        return src;
    }
    public int getWidth(){
        return width;
    }
    public int getHeight(){
        return height;
    }
}
