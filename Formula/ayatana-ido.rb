class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/0.9.2.tar.gz"
  sha256 "b166e7a160458e4a71f6086d2e4e97e18cf1ac584231a4b9f1f338914203884c"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/AyatanaIndicators/ayatana-ido.git", branch: "main"

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/ayatana-ido-0.9.2_1"
    sha256 cellar: :any,                 big_sur:      "8f8003583e67ed11ecdafbb06aadf7b0ce519408075603cab753b60fafbd02e3"
    sha256 cellar: :any,                 catalina:     "8e20551c3a6cb7a3004680ede03d09ada386481ec5aefe93b97f740966172439"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "377803fce51047384e4046804d16e0c59e1eb4208dbf1585487d7635f9475afd"
  end

  depends_on "cmake" => :build
  depends_on "glib-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"

  patch do
    url "https://raw.githubusercontent.com/willi123yao/homebrew-repo/1c50976446551667f9a72430dba6b3f1ffe73711/ayatana-ido.patch"
    sha256 "833a0c80c9331193de3d52d9495943bd3e536c5f0a91ea289a8aab5a6a6c0afd"
  end

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtk/gtk.h>
      #include <libayatana-ido/idocalendarmenuitem.h>
      #include <libayatana-ido/idoentrymenuitem.h>
      #include <libayatana-ido/idoscalemenuitem.h>

      int main(int argc, char *argv[]) {
        gtk_init(&argc, &argv);
        GtkWidget * cal = ido_calendar_menu_item_new();
        GtkWidget * entry = ido_entry_menu_item_new();
        GtkWidget * big_scale = ido_scale_menu_item_new("Label", IDO_RANGE_STYLE_DEFAULT, gtk_adjustment_new(0.5, 0.0, 1.0, 0.01, 0.1, 0.1));
        GtkWidget * small_scale = ido_scale_menu_item_new("Label", IDO_RANGE_STYLE_SMALL, gtk_adjustment_new(0.5, 0.0, 1.0, 0.01, 0.1, 0.1));
        return 0;
      }
    EOS

    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk+-3.0").strip.split
    flags << "-I#{include}/libayatana-ido3-0.4"
    flags << "-L#{lib}"
    flags << "-layatana-ido3-0.4"
    system ENV.cc, "test.cpp", "-o", "test", *flags
    assert_predicate testpath/"test", :exist?

    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/libayatana-ido3-0.4.pc").strip
  end
end
