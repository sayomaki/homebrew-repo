class Steghide < Formula
  desc "Steganography program able to hide data in image and audio files"
  homepage "https://steghide.sourceforge.io"
  url "https://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1.tar.gz"
  sha256 "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b"
  license "GPL-1.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/steghide-0.5.1_1"
    sha256 big_sur:      "9a5b7c6e81c3055b7ae8015a29414b345ea63b18f365f2c23fbf9ab06fa46b81"
    sha256 catalina:     "fbd4a185b6508cd879f2f8b18792f77ded851e15d168d5416767b29405fa5b51"
    sha256 x86_64_linux: "4f40af64d5230f3e1bc3bf8da6fb73a4f4ed960eefd7535a94d1f79ed903f7d3"
  end

  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "mcrypt"
  depends_on "mhash"

  patch do
    url "https://raw.githubusercontent.com/willi123yao/homebrew-repo/a51e8fdfcd1d8cc37390821bf78452195a7b9f98/steghide-gcc.diff"
    sha256 "75fd41eeecdf5446d5d693fefc651ba3429c70e3133fbb2c0b0d78615ccbdaf0"
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    inreplace "src/Makefile", "SHELL = /bin/sh", "SHELL = /bin/bash" if OS.mac?
    inreplace "src/Makefile", "LIBTOOL = $(SHELL) libtool", "LIBTOOL = $(SHELL) glibtool --tag CXX" if OS.mac?
    inreplace "src/Makefile", "LIBTOOL = $(SHELL) libtool", "LIBTOOL = $(SHELL) libtool --tag CXX" if OS.linux?
    system "make", "install"
  end

  test do
    system bin/"steghide", "--version"
  end
end
