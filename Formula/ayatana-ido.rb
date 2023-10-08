class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/0.10.1.tar.gz"
  sha256 "26187915a6f3402195e2c78d9e8a54549112a3cd05bb2fbe2059d3e78fc0e071"
  license "LGPL-2.1-or-later"
  head "https://github.com/AyatanaIndicators/ayatana-ido.git", branch: "main"

  bottle do
    root_url "https://github.com/sayomaki/homebrew-repo/releases/download/ayatana-ido-0.10.1"
    sha256 cellar: :any,                 ventura:      "ea95621d3b73e38a13cf8f744c2879a8b01546afdfa2b722df1094d8174044ad"
    sha256 cellar: :any,                 monterey:     "375b83ef69bce422380357c412a7b3fd15bfa7f191eefd0cd1f2835e2909cf74"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5896efec43cbc41c63855724a66b4b66ae49ec8c2b1610bc5eb1b3d1e2e0ae46"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "vala" => :build
  depends_on "pkg-config" => :test
  depends_on "glib"
  depends_on "gtk+3"

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

    pkgconfig = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk+-3.0").strip.split
    pkgconfig << "-I#{include}/libayatana-ido3-0.4"
    pkgconfig << "-L#{lib}"
    pkgconfig << "-layatana-ido3-0.4"

    flags = %w[-v]
    if OS.linux?
      flags += %W[
        -Wl,--rpath=#{Formula["glibc"].opt_lib}
        -L#{Formula["glibc"].opt_lib}
      ]
    end
    flags += pkgconfig

    system ENV.cc, "test.cpp", "-o", "test", *flags
    assert_predicate testpath/"test", :exist?

    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/libayatana-ido3-0.4.pc").strip
  end
end
