class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/0.10.1.tar.gz"
  sha256 "26187915a6f3402195e2c78d9e8a54549112a3cd05bb2fbe2059d3e78fc0e071"
  license "LGPL-2.1-or-later"
  head "https://github.com/AyatanaIndicators/ayatana-ido.git", branch: "main"

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/ayatana-ido-0.9.2"
    rebuild 1
    sha256 cellar: :any,                 monterey:     "c72e07931ba69e57b9c2ad9cf002d98c5987b2d2a678aa30cde740eaf95e5560"
    sha256 cellar: :any,                 big_sur:      "7992c58ba3377921c0ab2ec1e1758f6db2d55f496f3b56181d03d0fa5f360ed7"
    sha256 cellar: :any,                 catalina:     "c470bfa40e793edb2fb5a5edb64aa4edeba033d6198cc85bbf8e09f7cc6a37dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd3821c5757b65af98c4b63978ca1018d50257be81a541cccafd7e38c8a12a90"
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
