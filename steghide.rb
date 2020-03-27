class Steghide < Formula
  desc "Steghide is a steganography program that is able to hide data in various kinds of image- and audio-files."
  homepage "http://steghide.sourceforge.net"
  url "http://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1.tar.gz"
  sha256 "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b"

  depends_on "gettext" => :build
  depends_on "mcrypt"
  depends_on "mhash"

  patch :p0 do
    url "https://raw.githubusercontent.com/willi123yao/homebrew-repo/master/steghide-gcc.diff"
    sha256 "75fd41eeecdf5446d5d693fefc651ba3429c70e3133fbb2c0b0d78615ccbdaf0"
  end


  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    inreplace "src/Makefile", "SHELL = /bin/sh", "SHELL = /bin/bash"
    inreplace "src/Makefile", "LIBTOOL = $(SHELL) libtool", "LIBTOOL = $(SHELL) glibtool --tag CXX"
    system "make", "install"
  end

  test do
    system bin/"foobar", "--version"
  end
end
