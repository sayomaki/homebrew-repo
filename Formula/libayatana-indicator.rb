class LibayatanaIndicator < Formula
  desc "Ayatana Application Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-indicator"
  url "https://github.com/AyatanaIndicators/libayatana-indicator/archive/0.9.1.tar.gz"
  sha256 "15a8844265067652c06242736ece682622d73cedcccdf1c171ce27fba70ba689"
  license "GPL-3.0-only"
  head "https://github.com/AyatanaIndicators/libayatana-indicator.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "willi123yao/repo/ayatana-ido"

  patch do
    url "https://raw.githubusercontent.com/willi123yao/homebrew-repo/a51e8fdfcd1d8cc37390821bf78452195a7b9f98/libayatana-indicator.patch"
    sha256 "f9556df06de53385018e5b5b300d7ba1cf6939a5b4e0ed9366bf8ca6beb52580"
  end

  def install
    inreplace "src/CMakeLists.txt", "target_link_options", "# target_link_options" if OS.mac?
    mkdir "build" do
      system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      /*
        Test for libayatana-indicator

        Copyright 2009 Canonical Ltd.
        Copyright 2021 Robert Tari

        Authors:
            Ted Gould <ted@canonical.com>
            Robert Tari <robert@tari.in>

        This library is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License
        version 3.0 as published by the Free Software Foundation.

        This library is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License version 3.0 for more details.

        You should have received a copy of the GNU General Public
        License along with this library. If not, see
        <http://www.gnu.org/licenses/>.
        */


        #include <glib.h>
        #include <libayatana-indicator/indicator-service-manager.h>

        static GMainLoop * mainloop = NULL;
        static gboolean passed = FALSE;

        gboolean timeout (gpointer data)
        {
          passed = TRUE;
          g_debug("Timeout with no connection.");
          g_main_loop_quit(mainloop);
          return FALSE;
        }

        void connection (void)
        {
          g_debug("Connection");
          passed = FALSE;
          g_main_loop_quit(mainloop);
          return;
        }

        int main (int argc, char ** argv)
        {
            g_log_set_always_fatal(G_LOG_LEVEL_CRITICAL);

            IndicatorServiceManager * is = indicator_service_manager_new("my.test.name");
            g_signal_connect(G_OBJECT(is), INDICATOR_SERVICE_MANAGER_SIGNAL_CONNECTION_CHANGE, connection, NULL);

            g_timeout_add_seconds(1, timeout, NULL);

            mainloop = g_main_loop_new(NULL, FALSE);
            g_main_loop_run(mainloop);

            g_debug("Quiting");
            if (passed) {
                g_debug("Passed");
                return 0;
            }
            g_debug("Failed");
            return 1;
        }
    EOS

    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk+-3.0").strip.split
    flags << "-I#{include}/libayatana-indicator3-0.4"
    flags << "-L#{lib}"
    flags << "-layatana-indicator3"
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/ayatana-indicator3-0.4.pc")
  end
end