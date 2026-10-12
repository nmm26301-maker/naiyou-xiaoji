package cn.creamnote.app;
import android.content.*;import android.database.Cursor;import android.database.MatrixCursor;import android.net.Uri;import android.os.ParcelFileDescriptor;import android.provider.OpenableColumns;import java.io.*;
public class PhotoProvider extends ContentProvider {
 public boolean onCreate(){return true;}
 private File photo(Uri u)throws FileNotFoundException{String n=u.getLastPathSegment();if(n==null||!n.matches("[a-zA-Z0-9._-]+"))throw new FileNotFoundException();File f=new File(new File(getContext().getFilesDir(),"media"),n);if(!f.isFile())throw new FileNotFoundException();return f;}
 public ParcelFileDescriptor openFile(Uri u,String mode)throws FileNotFoundException{if(!"r".equals(mode))throw new FileNotFoundException();return ParcelFileDescriptor.open(photo(u),ParcelFileDescriptor.MODE_READ_ONLY);}
 public String getType(Uri u){String n=u.getLastPathSegment();String m=android.webkit.MimeTypeMap.getSingleton().getMimeTypeFromExtension(android.webkit.MimeTypeMap.getFileExtensionFromUrl(n));return m==null?"image/jpeg":m;}
 public Cursor query(Uri u,String[] projection,String s,String[] a,String o){try{File f=photo(u);String[] cols=projection==null?new String[]{OpenableColumns.DISPLAY_NAME,OpenableColumns.SIZE}:projection;MatrixCursor c=new MatrixCursor(cols);Object[] vals=new Object[cols.length];for(int i=0;i<cols.length;i++)vals[i]=cols[i].equals(OpenableColumns.DISPLAY_NAME)?f.getName():cols[i].equals(OpenableColumns.SIZE)?f.length():null;c.addRow(vals);return c;}catch(Exception e){return null;}}
 public Uri insert(Uri u,ContentValues v){throw new UnsupportedOperationException();}public int delete(Uri u,String s,String[]a){throw new UnsupportedOperationException();}public int update(Uri u,ContentValues v,String s,String[]a){throw new UnsupportedOperationException();}
}
