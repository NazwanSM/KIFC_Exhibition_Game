package id.kifc.review;

import com.android.uiautomator.core.Configurator;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

/** Test-only hierarchy capture without waiting for countdown animations to idle.
 * Runs in the shell UIAutomator process, never inside the game APK. */
@SuppressWarnings("deprecation")
public final class KifcDump extends UiAutomatorTestCase {
    public void testDump() {
        Configurator.getInstance().setWaitForIdleTimeout(0);
        java.io.File output = new java.io.File("/data/local/tmp/local/tmp/kifc-fast.xml");
        if (output.exists()) assertTrue(output.delete());
        getUiDevice().dumpWindowHierarchy("kifc-fast.xml");
        assertTrue("A fresh hierarchy is required", output.isFile());
    }
}
