class Steghide < Formula
  desc "Steganography program able to hide data in image and audio files"
  homepage "https://steghide.sourceforge.io"
  url "https://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1.tar.gz"
  sha256 "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b"
  license "GPL-1.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/steghide-0.5.1"
    sha256 big_sur:      "b73db063978bf7889415fac5ce21c151ee5ac756e052cbc3bb13720af5694125"
    sha256 x86_64_linux: "5cb1433496720a1a0c7de43f5726867cda2770126960ec33234efc5780cf6057"
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
